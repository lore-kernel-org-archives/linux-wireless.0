Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36794 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2K0RXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:23:13 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4598422wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:23:12 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] mac80211: Reject setting masked mac addresses
Date: Tue, 27 Nov 2012 18:23:06 +0100
Message-Id: <1354036986-30027-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_182316_717312_CE4A2797)
In-Reply-To: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
References: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a driver registers an address mask we should ensure that no interface
gets an address assigned that isn't covered by the registered address
mask.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Changes since v1:
* Don't match against perm address, just verify if all virtual interface
  addresses fit within registered mask.

 net/mac80211/iface.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bc3e3e1..6b116a0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -188,6 +188,41 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u64 new, mask, tmp;
+	u8 *m;
+
+	if (!is_zero_ether_addr(local->hw.wiphy->addr_mask)) {
+		m = addr;
+		new =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		m = local->hw.wiphy->addr_mask;
+		mask =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+				continue;
+
+			m = sdata->vif.addr;
+			tmp =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+				((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+				((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+			if ((new & ~mask) != (tmp & ~mask))
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -197,6 +232,10 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
+	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+	if (ret)
+		return ret;
+
 	ret = eth_mac_addr(dev, sa);
 
 	if (ret == 0)
-- 
1.7.7

