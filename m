Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3275 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbaCECn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 21:43:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3.14 2/2] mwifiex: save and copy AP's VHT capability info correctly
Date: Tue, 4 Mar 2014 18:43:14 -0800
Message-ID: <1393987394-12856-2-git-send-email-bzhao@marvell.com> (sfid-20140305_034333_639889_7D797CF3)
In-Reply-To: <1393987394-12856-1-git-send-email-bzhao@marvell.com>
References: <1393987394-12856-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

While preparing association request, intersection of device's
VHT capability information and corresponding field advertised
by AP is used.

This patch fixes a couple errors while saving and copying vht_cap
and vht_oper fields from AP's beacon.

Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c | 3 +--
 drivers/net/wireless/mwifiex/scan.c | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index bb43251..c92f27a 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -192,8 +192,7 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 		vht_cap->header.len  =
 				cpu_to_le16(sizeof(struct ieee80211_vht_cap));
 		memcpy((u8 *)vht_cap + sizeof(struct mwifiex_ie_types_header),
-		       (u8 *)bss_desc->bcn_vht_cap +
-		       sizeof(struct ieee_types_header),
+		       (u8 *)bss_desc->bcn_vht_cap,
 		       le16_to_cpu(vht_cap->header.len));
 
 		mwifiex_fill_vht_cap_tlv(priv, &vht_cap->vht_cap,
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0e8ca7b..f139244 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2311,12 +2311,12 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 			 curr_bss->ht_info_offset);
 
 	if (curr_bss->bcn_vht_cap)
-		curr_bss->bcn_ht_cap = (void *)(curr_bss->beacon_buf +
-						curr_bss->vht_cap_offset);
+		curr_bss->bcn_vht_cap = (void *)(curr_bss->beacon_buf +
+						 curr_bss->vht_cap_offset);
 
 	if (curr_bss->bcn_vht_oper)
-		curr_bss->bcn_ht_oper = (void *)(curr_bss->beacon_buf +
-						 curr_bss->vht_info_offset);
+		curr_bss->bcn_vht_oper = (void *)(curr_bss->beacon_buf +
+						  curr_bss->vht_info_offset);
 
 	if (curr_bss->bcn_bss_co_2040)
 		curr_bss->bcn_bss_co_2040 =
-- 
1.8.2.3

