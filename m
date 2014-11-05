Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56439 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbaKEGFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 01:05:50 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [Patch v2 5/5] mwifiex: fix warning while starting BSS
Date: Wed, 5 Nov 2014 17:04:31 +0530
Message-ID: <1415187271-17914-5-git-send-email-akarwar@marvell.com> (sfid-20141105_070553_593152_9353B69B)
In-Reply-To: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
References: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We see this warning while starting mwifiex AP:
Unsupported RX-STBC, default to 2x2

This was happening because of wrong offset while copying HT
capabilities from BSS configuration of start_ap handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 300bab4..0f347fd 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -167,7 +167,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	ht_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, params->beacon.tail,
 				 params->beacon.tail_len);
 	if (ht_ie) {
-		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
+		memcpy(&bss_cfg->ht_cap, ht_ie,
 		       sizeof(struct ieee80211_ht_cap));
 		cap_info = le16_to_cpu(bss_cfg->ht_cap.cap_info);
 		memset(&bss_cfg->ht_cap.mcs, 0,
-- 
1.8.1.4

