Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33540 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2K0PoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 10:44:05 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4020350wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:44:03 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Reject setting masked mac addresses
Date: Tue, 27 Nov 2012 16:43:49 +0100
Message-Id: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_164409_817537_2D23C23F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a driver registers an address mask we should ensure that no interface
gets an address assigned that isn't covered by the registered address
mask.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

As far as I could see addr_mask is not used by any driver yetbut we're
going to use it in rt2x00 in a follow-up patch.
Helmut

 net/mac80211/iface.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bc3e3e1..1f84dd1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -191,12 +191,35 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct sockaddr *sa = addr;
 	int ret;
+	u64 perm, new, mask;
+	u8 *m;
 
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
+	if (!is_zero_ether_addr(local->hw.wiphy->addr_mask)) {
+		m = local->hw.wiphy->perm_addr;
+		perm =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		m = local->hw.wiphy->addr_mask;
+		mask =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		m = sa->sa_data;
+		new =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		if ((new & ~mask) != (perm & ~mask))
+			return -EINVAL;
+	}
+
 	ret = eth_mac_addr(dev, sa);
 
 	if (ret == 0)
-- 
1.7.7

