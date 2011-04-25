Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61859 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab1DYK0X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:26:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:25:56 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/5] wireless: Fix warnings due to -Wunused-but-set-variable
Date: Mon, 25 Apr 2011 15:56:16 +0530
Message-ID: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com> (sfid-20110425_122637_789455_5CA656D0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings are exposed by gcc 4.6.
net/wireless/reg.c: In function 'freq_reg_info_regd':
net/wireless/reg.c:675:38: warning: variable 'pr' set but not used
[-Wunused-but-set-variable]
net/wireless/lib80211_crypt_wep.c: In function 'lib80211_wep_build_iv':
net/wireless/lib80211_crypt_wep.c:99:12: warning: variable 'len' set but
not used [-Wunused-but-set-variable]

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/wireless/lib80211_crypt_wep.c |    3 +--
 net/wireless/reg.c                |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index e2e8887..2f265e0 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -96,13 +96,12 @@ static int lib80211_wep_build_iv(struct sk_buff *skb, int hdr_len,
 			       u8 *key, int keylen, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	u32 klen, len;
+	u32 klen;
 	u8 *pos;
 
 	if (skb_headroom(skb) < 4 || skb->len < hdr_len)
 		return -1;
 
-	len = skb->len - hdr_len;
 	pos = skb_push(skb, 4);
 	memmove(pos, pos + 4, hdr_len);
 	pos += hdr_len;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 58d6995..2642d18 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -672,11 +672,9 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	for (i = 0; i < regd->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
 		const struct ieee80211_freq_range *fr = NULL;
-		const struct ieee80211_power_rule *pr = NULL;
 
 		rr = &regd->reg_rules[i];
 		fr = &rr->freq_range;
-		pr = &rr->power_rule;
 
 		/*
 		 * We only need to know if one frequency rule was
-- 
1.7.4.4

