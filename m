Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36675 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbaCECn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 21:43:29 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3.14 1/2] mwifiex: copy AP's HT capability info correctly
Date: Tue, 4 Mar 2014 18:43:13 -0800
Message-ID: <1393987394-12856-1-git-send-email-bzhao@marvell.com> (sfid-20140305_034334_153578_8DBF567D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

While preparing association request, intersection of device's HT
capability information and corresponding fields advertised by AP
is used.

This patch fixes an error while copying this field from AP's
beacon.

Cc: <stable@vger.kernel.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 79ead92..d9c65b6 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -317,8 +317,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		ht_cap->header.len =
 				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
 		memcpy((u8 *) ht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *) bss_desc->bcn_ht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_ht_cap,
 		       le16_to_cpu(ht_cap->header.len));
 
 		mwifiex_fill_cap_info(priv, radio_type, &ht_cap->ht_cap);
-- 
1.8.2.3

