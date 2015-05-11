Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:34350 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbbEKNFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:05:22 -0400
Received: by laat2 with SMTP id t2so92606063laa.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:05:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix AP_VLAN crypto tailroom calculation
Date: Mon, 11 May 2015 13:05:03 +0000
Message-Id: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com> (sfid-20150511_150528_015679_F7C93854)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP_VLANs may inherit crypto keys from parent AP.
Moreover AP_VLANs may have PTK keys of their own.
Hence both AP_VLAN sdata and AP sdata must be
inspected.

Some splats I was seeing:

 (a) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wep.c:102 ieee80211_wep_add_iv
 (b) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:73 ieee80211_tx_h_michael_mic_add
 (c) WARNING: CPU: 3 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:433 ieee80211_crypto_ccmp_encrypt

I've seen (a) and (b) with ath9k hw crypto and (c)
with ath9k sw crypto. All of them were related to
insufficient skb tailroom and I was able to
trigger these with ping6 program.

This patch effectively fixes Tx when using
AP_VLANs with WEP and WPA in some setups.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/tx.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8df134213adf..0887d6e5c424 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1593,6 +1593,25 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 /* device xmit handlers */
 
+static bool
+ieee80211_need_crypto_tx_tailroom(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_sub_if_data *parent_sdata;
+
+	if (sdata->crypto_tx_tailroom_needed_cnt)
+		return true;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->bss) {
+		parent_sdata = container_of(sdata->bss,
+					    struct ieee80211_sub_if_data,
+					    u.ap);
+		if (parent_sdata->crypto_tx_tailroom_needed_cnt)
+			return true;
+	}
+
+	return false;
+}
+
 static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb,
 				int head_need, bool may_encrypt)
@@ -1600,7 +1619,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	int tail_need = 0;
 
-	if (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt) {
+	if (may_encrypt && ieee80211_need_crypto_tx_tailroom(sdata)) {
 		tail_need = IEEE80211_ENCRYPT_TAILROOM;
 		tail_need -= skb_tailroom(skb);
 		tail_need = max_t(int, tail_need, 0);
-- 
2.1.4

