Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36965 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750988AbcI1Mtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:49:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCjVmk032606
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:46 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25r7ghjfb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:49:46 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/8] mwifiex: vendor_ie length check for parse WMM IEs
Date: Wed, 28 Sep 2016 18:18:24 +0530
Message-ID: <1475066908-11771-4-git-send-email-akarwar@marvell.com> (sfid-20160928_144950_200702_AD366813)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

While copying the vendor_ie obtained from the cfg80211_find_vendor_ie()
to the struct mwifiex_types_wmm_info, length/size was inappropriate.
This patch corrects the required length needed to the
mwifiex_types_wmm_info

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index a7e9f54..35d8636 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -404,7 +404,7 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 		       struct cfg80211_ap_settings *params)
 {
 	const u8 *vendor_ie;
-	struct ieee_types_header *wmm_ie;
+	const u8 *wmm_ie;
 	u8 wmm_oui[] = {0x00, 0x50, 0xf2, 0x02};
 
 	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
@@ -412,9 +412,9 @@ mwifiex_set_wmm_params(struct mwifiex_private *priv,
 					    params->beacon.tail,
 					    params->beacon.tail_len);
 	if (vendor_ie) {
-		wmm_ie = (struct ieee_types_header *)vendor_ie;
-		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
-		       sizeof(bss_cfg->wmm_info));
+		wmm_ie = vendor_ie;
+		memcpy(&bss_cfg->wmm_info, wmm_ie +
+		       sizeof(struct ieee_types_header), *(wmm_ie + 1));
 		priv->wmm_enabled = 1;
 	} else {
 		memset(&bss_cfg->wmm_info, 0, sizeof(bss_cfg->wmm_info));
-- 
1.9.1
