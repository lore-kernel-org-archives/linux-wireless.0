Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1891 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbaAODQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 22:16:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.14] mwifiex: fix wrong 11ac bits setting in fw_cap_info
Date: Tue, 14 Jan 2014 19:16:34 -0800
Message-ID: <1389755794-32449-1-git-send-email-bzhao@marvell.com> (sfid-20140115_041648_380715_E788A39A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bit 14 is actually reserved and bit 12 & 13 should be used for
11ac capability in fw_cap_info.

Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b474881..059bc16 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -226,7 +226,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 /* HW_SPEC fw_cap_info */
 
-#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(13)|BIT(14)))
+#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(12)|BIT(13)))
 
 #define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
-- 
1.8.2.3

