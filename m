Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52458 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0ACVQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2010 16:16:25 -0500
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 8B46DEB6BC
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:38 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 7349727D8B
	for <linux-wireless@vger.kernel.org>; Sun,  3 Jan 2010 23:07:37 +0200 (EET)
Subject: [PATCH 2/9] mac80211: use PS Poll and Nullfunc templates when sending
	such frames
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 03 Jan 2010 23:07:37 +0200
Message-ID: <20100103210737.29287.86904.stgit@tikku>
In-Reply-To: <20100103210552.29287.20384.stgit@tikku>
References: <20100103210552.29287.20384.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

To avoid duplicate code, use ieee80211_[pspoll|nullfunc]_get() to get
templates for PS Poll and Nullfunc frames in mlme.c.

Compile-tested only.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/mlme.c |   48 +++++++++---------------------------------------
 1 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 72920ee..7f771c0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -249,30 +249,15 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_pspoll *pspoll;
 	struct sk_buff *skb;
-	u16 fc;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for "
-		       "pspoll frame\n", sdata->name);
+	skb = ieee80211_pspoll_get(&local->hw, &sdata->vif);
+	if (!skb)
 		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	pspoll = (struct ieee80211_pspoll *) skb_put(skb, sizeof(*pspoll));
-	memset(pspoll, 0, sizeof(*pspoll));
-	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL | IEEE80211_FCTL_PM;
-	pspoll->frame_control = cpu_to_le16(fc);
-	pspoll->aid = cpu_to_le16(ifmgd->aid);
 
-	/* aid in PS-Poll has its two MSBs each set to 1 */
-	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
-
-	memcpy(pspoll->bssid, ifmgd->bssid, ETH_ALEN);
-	memcpy(pspoll->ta, sdata->vif.addr, ETH_ALEN);
+	pspoll = (struct ieee80211_pspoll *) skb->data;
+	pspoll->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
@@ -283,30 +268,15 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     int powersave)
 {
 	struct sk_buff *skb;
-	struct ieee80211_hdr *nullfunc;
-	__le16 fc;
+	struct ieee80211_hdr_3addr *nullfunc;
 
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
+	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
+	if (!skb)
 		return;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 24);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for nullfunc "
-		       "frame\n", sdata->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
-	memset(nullfunc, 0, 24);
-	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-			 IEEE80211_FCTL_TODS);
+	nullfunc = (struct ieee80211_hdr_3addr *) skb->data;
 	if (powersave)
-		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
-	nullfunc->frame_control = fc;
-	memcpy(nullfunc->addr1, sdata->u.mgd.bssid, ETH_ALEN);
-	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
-	memcpy(nullfunc->addr3, sdata->u.mgd.bssid, ETH_ALEN);
+		nullfunc->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);

