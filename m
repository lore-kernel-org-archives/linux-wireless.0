Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46735 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab0I3Ulz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 16:41:55 -0400
Received: by qyk36 with SMTP id 36so2191635qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 13:41:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 16:41:52 -0400
Message-ID: <AANLkTimrRJavN0B+nYGJwFeNM9KYa1XuQ2VrSCREb5kN@mail.gmail.com>
Subject: [PATCH] fix for WDS in ath9k (and mac80211, and nl80211)
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to submit this before, but I believe that version was lost to
the ether. Apologies
if this is a repeat.

I'm trying to use WDS with ath9k, and I ran into some problems. In addition to
enabling WDS interfaces in ath9k, I also had to patch mac80211 to
allow xmits and
recvs to pass through on WDS interfaces. The rate table was also never being
initialized for WDS interfaces.

I have also patched nl80211 so I have a mechanism to set the WDS peer bssid.

With these patches, I'm able to interoperate over WDS between
linux-wireless and MadWifi.
I'm running wireless-testing plus OpenWRT patches on a Cambria board with
an AR9160 radio.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 ++
 include/linux/nl80211.h               |    3 ++
 net/mac80211/iface.c                  |    3 ++
 net/mac80211/main.c                   |    3 ++
 net/mac80211/rx.c                     |    1 +
 net/mac80211/tx.c                     |    3 ++
 net/wireless/nl80211.c                |   49 +++++++++++++++++++++++++++++++++
 8 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c
b/drivers/net/wireless/ath/ath9k/init.c
index de33938..c2792c9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -639,6 +639,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc,
struct ieee80211_hw *hw)

 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_WDS) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index a133878..d67067f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1384,6 +1384,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
+	case NL80211_IFTYPE_WDS:
+		ic_opmode = NL80211_IFTYPE_WDS;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..35a9681 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -387,6 +387,8 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a
WDS interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -489,6 +491,7 @@ enum nl80211_commands {
 	NL80211_CMD_NOTIFY_CQM,

 	NL80211_CMD_SET_CHANNEL,
+	NL80211_CMD_SET_WDS_PEER,

 	/* add new commands above here */

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6678573..1e91984 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -24,6 +24,7 @@
 #include "led.h"
 #include "driver-ops.h"
 #include "wme.h"
+#include "rate.h"

 /**
  * DOC: Interface list locking
@@ -301,6 +302,8 @@ static int ieee80211_do_open(struct net_device
*dev, bool coming_up)
 			/* STA has been freed */
 			goto err_del_interface;
 		}
+
+		rate_control_rate_init(sta);
 	}

 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e24fa5b..4ea88dd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -201,6 +201,8 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
+	else if (sdata->vif.type == NL80211_IFTYPE_WDS)
+		sdata->vif.bss_conf.bssid = NULL;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sdata->vif.bss_conf.bssid = zero;
 	} else {
@@ -211,6 +213,7 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MESH_POINT:
 		break;
 	default:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0b0e83e..b3e161f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -819,6 +819,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	if (unlikely((ieee80211_is_data(hdr->frame_control) ||
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
 		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
 		if ((!ieee80211_has_fromds(hdr->frame_control) &&
 		     !ieee80211_has_tods(hdr->frame_control) &&
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e1733dc..258fbdb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -273,6 +273,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 */
 		return TX_DROP;

+	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
+		return TX_CONTINUE;
+
 	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 		return TX_CONTINUE;

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c84825..c401349 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -603,6 +603,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	CMD(set_wds_peer, SET_WDS_PEER);

 #undef CMD

@@ -831,6 +832,48 @@ static int nl80211_set_channel(struct sk_buff
*skb, struct genl_info *info)
 	return result;
 }

+static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	u8 *bssid;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_wds_peer) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (wdev->iftype != NL80211_IFTYPE_WDS) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	err = rdev->ops->set_wds_peer(wdev->wiphy, dev, bssid);
+
+out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+
 static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
@@ -5462,6 +5505,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_WDS_PEER,
+		.doit = nl80211_set_wds_peer,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };

 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.2.3
