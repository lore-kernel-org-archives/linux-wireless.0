Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:44294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYBDVYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:35 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1548589rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:35 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:34:20 -0800
Subject: [PATCH 10/13] o11s: mesh discovery and peer link establishment support
Message-ID: <47a78292.22528c0a.1300.1aef@mx.google.com> (sfid-20080204_212438_516087_6199B5A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file implements mesh discovery and peer link establishment support using
the mesh peer link table provided in mesh_plinktbl.c.

Secure peer links have not been implemented yet.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_plinkfsm.c |  742 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 742 insertions(+), 0 deletions(-)
 create mode 100644 net/mac80211/mesh_plinkfsm.c

diff --git a/net/mac80211/mesh_plinkfsm.c b/net/mac80211/mesh_plinkfsm.c
new file mode 100644
index 0000000..e657edd
--- /dev/null
+++ b/net/mac80211/mesh_plinkfsm.c
@@ -0,0 +1,742 @@
+/*
+ * Copyright (c) 2008 open80211s Ltd.
+ * Author:     Luis Carlos Cobo <luisca@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+#include "mesh.h"
+#include <linux/random.h>
+
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+#define mpl_dbg(fmt, args...)	printk(KERN_DEBUG fmt, ##args)
+#else
+#define mpl_dbg(fmt, args...)	do { (void)(0); } while (0)
+#endif
+
+#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
+#define PLINK_GET_FRAME_SUBTYPE(p) (p)
+#define PLINK_GET_LLID(p) (p + 1)
+#define PLINK_GET_PLID(p) (p + 3)
+
+#define mod_plink_timer(m, t) (mod_timer(&m->timer, jiffies + HZ * t / 1000))
+
+/* Peer link cancel reasons, all subject to ANA approval */
+#define MESH_LINK_CANCELLED                     2
+#define MESH_MAX_NEIGHBORS                      3
+#define MESH_CAPABILITY_POLICY_VIOLATION        4
+#define MESH_CLOSE_RCVD                         5
+#define MESH_MAX_RETRIES                        6
+#define MESH_CONFIRM_TIMEOUT                    7
+#define MESH_SECURITY_ROLE_NEGOTIATION_DIFFERS  8
+#define MESH_SECURITY_AUTHENTICATION_IMPOSSIBLE 9
+#define MESH_SECURITY_FAILED_VERIFICATION       10
+
+#define dot11MeshMaxRetries(s)	(s->u.sta.mshcfg.dot11MeshMaxRetries)
+#define dot11MeshRetryTimeout(s) (s->u.sta.mshcfg.dot11MeshRetryTimeout)
+#define dot11MeshConfirmTimeout(s) (s->u.sta.mshcfg.dot11MeshConfirmTimeout)
+#define dot11MeshHoldingTimeout(s) (s->u.sta.mshcfg.dot11MeshHoldingTimeout)
+#define dot11MeshMaxPeerLinks(s) (s->u.sta.mshcfg.dot11MeshMaxPeerLinks)
+
+enum plink_frame_type {
+	PLINK_OPEN = 0,
+	PLINK_CONFIRM,
+	PLINK_CLOSE
+};
+
+enum plink_event {
+	PLINK_UNDEFINED,
+	OPN_ACPT,
+	OPN_RJCT,
+	OPN_IGNR,
+	CNF_ACPT,
+	CNF_RJCT,
+	CNF_IGNR,
+	CLS_ACPT,
+	CLS_IGNR
+};
+
+int mesh_plink_open(u8 *hw_addr, struct net_device *dev);
+
+static int mesh_send_plink_frame(struct net_device *dev,
+		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
+		__le16 reason) {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct ieee80211_mgmt *mgmt;
+	bool include_plid = false;
+	u8 *pos;
+	int ie_len;
+
+	if (!skb)
+		return -1;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	/* 25 is the size of the common mgmt part (24) plus the size of the
+	 * common action part (1)
+	 */
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 25 + sizeof(mgmt->u.action.u.plink_action));
+	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.plink_action));
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_ACTION);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	/* BSSID is left zeroed, wildcard value */
+	mgmt->u.action.category = PLINK_CATEGORY;
+	mgmt->u.action.u.plink_action.action_code = action;
+
+	if (action == PLINK_CLOSE)
+		mgmt->u.action.u.plink_action.aux = reason;
+	else {
+		mgmt->u.action.u.plink_action.aux = cpu_to_le16(0x0);
+		if (action == PLINK_CONFIRM) {
+			pos = skb_put(skb, 4);
+			/* two-byte status code followed by two-byte AID */
+			memset(pos, 0, 4);
+		}
+		mesh_add_mgmt_ies(skb, dev);
+	}
+
+	/* Add Peer Link Management element */
+	switch (action) {
+	case PLINK_OPEN:
+		ie_len = 3;
+		break;
+	case PLINK_CONFIRM:
+		ie_len = 5;
+		include_plid = true;
+		break;
+	case PLINK_CLOSE:
+	default:
+		if (!plid)
+			ie_len = 5;
+		else {
+			ie_len = 7;
+			include_plid = true;
+		}
+		break;
+	}
+
+	pos = skb_put(skb, 2 + ie_len);
+	*pos++ = WLAN_EID_PEER_LINK;
+	*pos++ = ie_len;
+	*pos++ = action;
+	memcpy(pos, &llid, 2);
+	if (include_plid) {
+		pos += 2;
+		memcpy(pos, &plid, 2);
+	}
+	if (action == PLINK_CLOSE) {
+		pos += 2;
+		memcpy(pos, &reason, 2);
+	}
+
+	ieee80211_sta_tx(dev, skb, 0);
+	return 0;
+}
+
+void update_mesh_neighbour(u8 *hw_addr, struct net_device *dev, bool add)
+{
+	struct mesh_plink *mpl;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(hw_addr, dev);
+	if (mpl) {
+		mpl->last_active = jiffies;
+		rcu_read_unlock();
+	} else if (add && plink_capacity(sdata)) {
+		rcu_read_unlock();
+		add_mesh_neighbour(hw_addr, dev);
+	} else
+		rcu_read_unlock();
+}
+
+
+
+int add_mesh_neighbour(u8 *hw_addr, struct net_device *dev)
+{
+	int err;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	err = add_mesh_plink(hw_addr, dev);
+	if (err)
+		return err;
+
+	if (sdata->u.sta.mshcfg.auto_open_plinks)
+		return mesh_plink_open(hw_addr, dev);
+
+	return err;
+}
+
+bool is_estab_plink(u8 *hw_addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	bool ret;
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(hw_addr, dev);
+	if (!mpl) {
+		ret = false;
+		goto endestab;
+	}
+
+	mpl->last_active = jiffies;
+	ret = mpl->state == ESTAB;
+
+endestab:
+	rcu_read_unlock();
+	return ret;
+}
+
+static void plink_timer(unsigned long data)
+{
+	struct mesh_plink *mpl;
+	__le16 llid, plid, reason;
+	bool del_mpl = false;
+	struct net_device *dev = NULL;
+	struct ieee80211_sub_if_data *sdata;
+	u8 ha[ETH_ALEN];
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	DECLARE_MAC_BUF(mac);
+#endif
+
+	rcu_read_lock();
+	mpl = (struct mesh_plink *) data;
+	mpl = rcu_dereference(mpl);
+	if (!mpl) {
+		mpl_dbg("Mesh plink: timer's mpl vanished\n");
+		goto endpltimer;
+	}
+	spin_lock_bh(&mpl->state_lock);
+	if (mpl->ignore_timer) {
+		mpl->ignore_timer = false;
+		spin_unlock_bh(&mpl->state_lock);
+		goto endpltimer;
+	}
+	mpl_dbg("Mesh plink timer for %s fired on state %d\n",
+			print_mac(mac, mpl->ha), mpl->state);
+	reason = 0;
+	llid = mpl->llid;
+	plid = mpl->plid;
+	dev = mpl->dev;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	switch (mpl->state) {
+	case OPN_RCVD:
+	case OPN_SNT:
+		/* retry timer */
+		if (mpl->retries < dot11MeshMaxRetries(sdata)) {
+			u32 rand;
+			mpl_dbg("Mesh plink for %s (retry, timeout): %d %d\n",
+					print_mac(mac, mpl->ha),
+					mpl->retries, mpl->timeout);
+			get_random_bytes(&rand, sizeof(u32));
+			mpl->timeout = mpl->timeout + rand % mpl->timeout;
+			++mpl->retries;
+			mod_plink_timer(mpl, mpl->timeout);
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_OPEN,
+					mpl->ha, llid, 0, 0);
+			break;
+		}
+		reason = cpu_to_le16(MESH_MAX_RETRIES);
+		/* fall through on else */
+	case CNF_RCVD:
+		/* confirm timer */
+		if (!reason)
+			reason = cpu_to_le16(MESH_CONFIRM_TIMEOUT);
+		mpl->state = HOLDING;
+		mod_plink_timer(mpl, dot11MeshHoldingTimeout(sdata));
+		spin_unlock_bh(&mpl->state_lock);
+		mesh_send_plink_frame(dev, PLINK_CLOSE,
+				mpl->ha, llid, plid, reason);
+		break;
+	case HOLDING:
+		/* holding timer */
+		del_timer(&mpl->timer);
+		spin_unlock_bh(&mpl->state_lock);
+		del_mpl = true;
+		memcpy(ha, mpl->ha, ETH_ALEN);
+		break;
+	default:
+		spin_unlock_bh(&mpl->state_lock);
+		break;
+	}
+
+endpltimer:
+	rcu_read_unlock();
+	if (del_mpl)
+		del_mesh_plink(ha, dev);
+}
+
+
+static void set_plink_timer(struct mesh_plink *mpl, int timeout)
+{
+	mpl->timer.expires = jiffies + (HZ * timeout / 1000);
+	mpl->timer.data = (unsigned long) mpl;
+	mpl->timer.function = plink_timer;
+	mpl->timeout = timeout;
+	add_timer(&mpl->timer);
+}
+
+int mesh_plink_open(u8 *hw_addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	__le16 llid;
+	int err;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	DECLARE_MAC_BUF(mac);
+#endif
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(hw_addr, dev);
+	if (!mpl) {
+		err = -ENXIO;
+		goto endopen;
+	}
+
+	spin_lock_bh(&mpl->state_lock);
+	get_random_bytes(&llid, 2);
+	mpl->llid = llid;
+	if (mpl->state != LISTEN) {
+		err = -EBUSY;
+		spin_unlock_bh(&mpl->state_lock);
+		goto endopen;
+	}
+	mpl->state = OPN_SNT;
+	set_plink_timer(mpl, dot11MeshRetryTimeout(sdata));
+	spin_unlock_bh(&mpl->state_lock);
+	mpl_dbg("Mesh plink: starting establishment with %s\n",
+		print_mac(mac, mpl->ha));
+
+	err = mesh_send_plink_frame(dev, PLINK_OPEN, hw_addr, llid, 0, 0);
+
+endopen:
+	rcu_read_unlock();
+	return err;
+}
+
+int mesh_plink_block(u8 *hw_addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	int err = 0;
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	DECLARE_MAC_BUF(mac);
+#endif
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(hw_addr, dev);
+	if (!mpl) {
+		rcu_read_unlock();
+		add_mesh_plink(hw_addr, dev);
+		rcu_read_lock();
+		mpl = mesh_plink_lookup(hw_addr, dev);
+	}
+
+	if (!mpl) {
+		err = -ENXIO;
+		goto endblock;
+	}
+
+	spin_lock_bh(&mpl->state_lock);
+	deactivate_plink(mpl);
+	mpl->state = BLOCKED;
+	spin_unlock_bh(&mpl->state_lock);
+
+endblock:
+	rcu_read_unlock();
+	return err;
+}
+
+int mesh_plink_close(u8 *hw_addr, struct net_device *dev)
+{
+	struct mesh_plink *mpl;
+	int err = 0;
+	int llid, plid, reason;
+	bool del_mpl = false;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	DECLARE_MAC_BUF(mac);
+#endif
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(hw_addr, dev);
+	if (!mpl) {
+		err = -ENXIO;
+		goto endclose;
+	}
+
+	mpl_dbg("Mesh plink: closing link with %s\n", print_mac(mac, mpl->ha));
+	spin_lock_bh(&mpl->state_lock);
+	mpl->reason = cpu_to_le16(MESH_LINK_CANCELLED);
+	reason = mpl->reason;
+	if (mpl->state == LISTEN || mpl->state == BLOCKED)
+		del_mpl = true;
+	else if (mpl->state == ESTAB) {
+		deactivate_plink(mpl);
+		mod_plink_timer(mpl, dot11MeshHoldingTimeout(sdata));
+	} else if (!mod_plink_timer(mpl, dot11MeshHoldingTimeout(sdata)))
+		mpl->ignore_timer = true;
+	mpl->state = HOLDING;
+	llid = mpl->llid;
+	plid = mpl->plid;
+	spin_unlock_bh(&mpl->state_lock);
+	if (!del_mpl)
+		mesh_send_plink_frame(dev, PLINK_CLOSE,
+				mpl->ha, llid, plid, reason);
+endclose:
+	rcu_read_unlock();
+	if (del_mpl)
+		del_mesh_plink(hw_addr, dev);
+	return err;
+}
+
+void mesh_rx_plink_frame(struct net_device *dev,
+			 struct ieee80211_mgmt *mgmt,
+			 size_t len)
+{
+	struct ieee802_11_elems elems;
+	struct mesh_plink *mpl;
+	enum plink_event event;
+	enum plink_frame_type ftype;
+	size_t baselen;
+	bool del_mpl = false;
+	u8 ie_len;
+	u8 *baseaddr;
+	__le16 plid, llid, reason;
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	DECLARE_MAC_BUF(mac);
+#endif
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (is_multicast_ether_addr(mgmt->da)) {
+		mpl_dbg("Mesh plink: ignore frame from multicast address");
+		return;
+	}
+
+	baseaddr = mgmt->u.action.u.plink_action.variable;
+	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
+	if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
+		baseaddr += 4;
+		baselen -= 4;
+	}
+	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
+	if (!elems.peer_link) {
+		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
+		return;
+	}
+
+	ftype = *((u8 *)PLINK_GET_FRAME_SUBTYPE(elems.peer_link));
+	ie_len = elems.peer_link_len;
+	if ((ftype == PLINK_OPEN && ie_len != 3) ||
+	    (ftype == PLINK_CONFIRM && ie_len != 5) ||
+	    (ftype == PLINK_CLOSE && ie_len != 5 && ie_len != 7)) {
+		mpl_dbg("Mesh plink: incorrect plink ie length\n");
+		return;
+	}
+
+	if (ftype != PLINK_CLOSE && (!elems.mesh_id || !elems.mesh_config)) {
+		mpl_dbg("Mesh plink: missing necessary ie\n");
+		return;
+	}
+	/* Note the lines below are correct, the llid in the frame is the plid
+	 * from the point of view of this host.
+	 */
+	memcpy(&plid, PLINK_GET_LLID(elems.peer_link), 2);
+	if (ftype == PLINK_CONFIRM || (ftype == PLINK_CLOSE && ie_len == 7))
+		memcpy(&llid, PLINK_GET_PLID(elems.peer_link), 2);
+
+	rcu_read_lock();
+	mpl = mesh_plink_lookup(mgmt->sa, dev);
+	if (mpl)
+		mpl->last_active = jiffies;
+	if (!mpl && ftype != PLINK_OPEN) {
+		mpl_dbg("Mesh plink: cls or cnf from unknown peer\n");
+		rcu_read_unlock();
+		return;
+	}
+
+	if (mpl && mpl->state == BLOCKED) {
+		rcu_read_unlock();
+		return;
+	}
+
+	/* Now we will figure out the appropriate event... */
+	event = PLINK_UNDEFINED;
+	if (ftype != PLINK_CLOSE && (!same_mesh(mgmt, &elems, dev))) {
+		switch (ftype) {
+		case PLINK_OPEN:
+			event = OPN_RJCT;
+			break;
+		case PLINK_CONFIRM:
+			event = CNF_RJCT;
+			break;
+		case PLINK_CLOSE:
+			/* avoid warning */
+			break;
+		}
+		spin_lock_bh(&mpl->state_lock);
+	} else if (!mpl) {
+		/* ftype == PLINK_OPEN */
+		if (!plink_capacity(sdata)) {
+			mpl_dbg("Mesh plink error: no more free plinks\n");
+			return;
+		}
+		rcu_read_unlock();
+		add_mesh_neighbour(mgmt->sa, dev);
+		rcu_read_lock();
+		mpl = mesh_plink_lookup(mgmt->sa, dev);
+		if (!mpl) {
+			mpl_dbg("Mesh plink error: plink table full\n");
+			rcu_read_unlock();
+			return;
+		}
+		event = OPN_ACPT;
+		spin_lock_bh(&mpl->state_lock);
+	} else {
+		spin_lock_bh(&mpl->state_lock);
+		switch (ftype) {
+		case PLINK_OPEN:
+			if (!plink_capacity(sdata) ||
+					(mpl->plid && mpl->plid != plid))
+				event = OPN_IGNR;
+			else
+				event = OPN_ACPT;
+			break;
+		case PLINK_CONFIRM:
+			if (!plink_capacity(sdata) ||
+				(mpl->llid != llid || mpl->plid != plid))
+				event = CNF_IGNR;
+			else
+				event = CNF_ACPT;
+			break;
+		case PLINK_CLOSE:
+			if (mpl->state == ESTAB)
+				/* This does not follow the standard, but it is
+				 * necessary to avoid a livelock when node sees
+				 * the link as ESTAB and the other does not,
+				 * without having to support multiple plinks
+				 * per peer
+				 */
+				event = CLS_ACPT;
+			else if (mpl->plid != plid)
+				event = CLS_IGNR;
+			else if (ie_len == 7 && mpl->llid != llid)
+				event = CLS_IGNR;
+			else
+				event = CLS_ACPT;
+			break;
+		default:
+			mpl_dbg("Mesh plink: unknown frame subtype\n");
+			spin_unlock_bh(&mpl->state_lock);
+			rcu_read_unlock();
+			return;
+		}
+	}
+
+	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %s %d %d %d %d\n",
+			print_mac(mac, mgmt->sa), mpl->state,
+			__le16_to_cpu(mpl->llid), __le16_to_cpu(mpl->plid),
+			event);
+	reason = 0;
+	switch (mpl->state) {
+		/* spin_unlock as soon as state is updated at each case */
+	case LISTEN:
+		switch (event) {
+		case CLS_ACPT:
+			mpl->state = BLOCKED;
+			spin_unlock_bh(&mpl->state_lock);
+			del_mpl = true;
+			break;
+		case OPN_ACPT:
+			mpl->state = OPN_RCVD;
+			mpl->plid = plid;
+			get_random_bytes(&llid, 2);
+			mpl->llid = llid;
+			set_plink_timer(mpl, dot11MeshRetryTimeout(sdata));
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_OPEN,
+					mpl->ha, llid, 0, 0);
+			mesh_send_plink_frame(dev, PLINK_CONFIRM,
+					mpl->ha, llid, plid, 0);
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		}
+		break;
+
+	case OPN_SNT:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		case CLS_ACPT:
+			if (!reason)
+				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+			mpl->reason = reason;
+			mpl->state = HOLDING;
+			if (!mod_plink_timer(mpl,
+					     dot11MeshHoldingTimeout(sdata)))
+				mpl->ignore_timer = true;
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CLOSE,
+					mpl->ha, llid, plid, reason);
+			break;
+		case OPN_ACPT:
+			/* retry timer is left untouched */
+			mpl->state = OPN_RCVD;
+			mpl->plid = plid;
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CONFIRM,
+					mpl->ha, llid, plid, 0);
+			break;
+		case CNF_ACPT:
+			mpl->state = CNF_RCVD;
+			if (!mod_plink_timer(mpl,
+					     dot11MeshConfirmTimeout(sdata)))
+				mpl->ignore_timer = true;
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		}
+		break;
+
+	case OPN_RCVD:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		case CLS_ACPT:
+			if (!reason)
+				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+			mpl->reason = reason;
+			mpl->state = HOLDING;
+			if (!mod_plink_timer(mpl,
+					     dot11MeshHoldingTimeout(sdata)))
+				mpl->ignore_timer = true;
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CLOSE,
+					mpl->ha, llid, plid, reason);
+			break;
+		case OPN_ACPT:
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CONFIRM,
+					mpl->ha, llid, plid, 0);
+			break;
+		case CNF_ACPT:
+			del_timer(&mpl->timer);
+			mpl->state = ESTAB;
+			plink_inc(sdata);
+			spin_unlock_bh(&mpl->state_lock);
+			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
+					print_mac(mac, mpl->ha));
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		}
+		break;
+
+	case CNF_RCVD:
+		switch (event) {
+		case OPN_RJCT:
+		case CNF_RJCT:
+			reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+		case CLS_ACPT:
+			if (!reason)
+				reason = cpu_to_le16(MESH_CLOSE_RCVD);
+			mpl->reason = reason;
+			mpl->state = HOLDING;
+			if (!mod_plink_timer(mpl,
+					     dot11MeshHoldingTimeout(sdata)))
+				mpl->ignore_timer = 1;
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CLOSE,
+					mpl->ha, llid, plid, reason);
+		case OPN_ACPT:
+			del_timer(&mpl->timer);
+			mpl->state = ESTAB;
+			plink_inc(sdata);
+			spin_unlock_bh(&mpl->state_lock);
+			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
+					print_mac(mac, mpl->ha));
+			mesh_send_plink_frame(dev, PLINK_CONFIRM,
+					mpl->ha, llid, plid, 0);
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		}
+		break;
+
+	case ESTAB:
+		switch (event) {
+		case CLS_ACPT:
+			reason = cpu_to_le16(MESH_CLOSE_RCVD);
+			mpl->reason = reason;
+			deactivate_plink(mpl);
+			mpl->state = HOLDING;
+			llid = mpl->llid;
+			mod_plink_timer(mpl, dot11MeshHoldingTimeout(sdata));
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CLOSE,
+					mpl->ha, llid, plid, reason);
+			break;
+		case OPN_ACPT:
+			llid = mpl->llid;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CONFIRM,
+					mpl->ha, llid, plid, 0);
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		}
+		break;
+	case HOLDING:
+		switch (event) {
+		case CLS_ACPT:
+			if (!del_timer(&mpl->timer))
+				mpl->ignore_timer = 1;
+			del_mpl = true;
+			spin_unlock_bh(&mpl->state_lock);
+			break;
+		case OPN_ACPT:
+		case CNF_ACPT:
+		case OPN_RJCT:
+		case CNF_RJCT:
+			llid = mpl->llid;
+			reason = mpl->reason;
+			spin_unlock_bh(&mpl->state_lock);
+			mesh_send_plink_frame(dev, PLINK_CLOSE,
+					mpl->ha, llid, plid, reason);
+			break;
+		default:
+			spin_unlock_bh(&mpl->state_lock);
+		}
+		break;
+	default:
+		/* should not get here, BLOCKED is dealt with at the beggining
+		 * of the function
+		 */
+		spin_unlock_bh(&mpl->state_lock);
+		break;
+	}
+	rcu_read_unlock();
+
+	if (del_mpl)
+		del_mesh_plink(mgmt->sa, dev);
+}
-- 
1.5.2.5



