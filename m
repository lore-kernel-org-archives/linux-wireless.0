Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36333 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab2JTCU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: handle extended supported rates IE for AP
Date: Fri, 19 Oct 2012 19:19:20 -0700
Message-Id: <1350699561-852-7-git-send-email-bzhao@marvell.com> (sfid-20121020_042030_518924_A0BA335B)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

During start_ap handler, some rates come as extended supported
rates IE - part of beacon tail IE. This patch adds support for
parsing them and adding to bss_rates TLV for bss_start command
to firmware.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index d95a2d5..8dd7224 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -188,10 +188,19 @@ mwifiex_set_uap_rates(struct mwifiex_uap_bss_param *bss_cfg,
 	int var_offset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	const u8 *var_pos = params->beacon.head + var_offset;
 	int len = params->beacon.head_len - var_offset;
+	u8 rate_len = 0;
 
 	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_SUPP_RATES, var_pos, len);
-	if (rate_ie)
+	if (rate_ie) {
 		memcpy(bss_cfg->rates, rate_ie + 1, rate_ie->len);
+		rate_len = rate_ie->len;
+	}
+
+	rate_ie = (void *)cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES,
+					   params->beacon.tail,
+					   params->beacon.tail_len);
+	if (rate_ie)
+		memcpy(bss_cfg->rates + rate_len, rate_ie + 1, rate_ie->len);
 
 	return;
 }
-- 
1.7.0.2

