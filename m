Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50898 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab3HFBxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 21:53:22 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: modify mwifiex_is_pattern_supported() routine
Date: Mon, 5 Aug 2013 18:51:58 -0700
Message-ID: <1375753920-10100-2-git-send-email-bzhao@marvell.com> (sfid-20130806_035327_037773_29E3E33B)
In-Reply-To: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
References: <1375753920-10100-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It is modified so that it can be reused for coalesce feature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 326f4d9..62c3d98 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2309,7 +2309,8 @@ EXPORT_SYMBOL_GPL(mwifiex_del_virtual_intf);
 
 #ifdef CONFIG_PM
 static bool
-mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq)
+mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq,
+			     u8 max_byte_seq)
 {
 	int j, k, valid_byte_cnt = 0;
 	bool dont_care_byte = false;
@@ -2327,12 +2328,12 @@ mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq)
 					dont_care_byte = true;
 			}
 
-			if (valid_byte_cnt > MWIFIEX_MEF_MAX_BYTESEQ)
+			if (valid_byte_cnt > max_byte_seq)
 				return false;
 		}
 	}
 
-	byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] = valid_byte_cnt;
+	byte_seq[max_byte_seq] = valid_byte_cnt;
 
 	return true;
 }
@@ -2375,7 +2376,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 	for (i = 0; i < wowlan->n_patterns; i++) {
 		memset(byte_seq, 0, sizeof(byte_seq));
 		if (!mwifiex_is_pattern_supported(&wowlan->patterns[i],
-						  byte_seq)) {
+						  byte_seq,
+						  MWIFIEX_MEF_MAX_BYTESEQ)) {
 			wiphy_err(wiphy, "Pattern not supported\n");
 			kfree(mef_entry);
 			return -EOPNOTSUPP;
-- 
1.8.2.3

