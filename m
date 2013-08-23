Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:45386 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab3HWXsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 19:48:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: fix ext_capab IE structure definition
Date: Fri, 23 Aug 2013 16:48:22 -0700
Message-ID: <1377301703-8853-2-git-send-email-bzhao@marvell.com> (sfid-20130824_014835_546836_1CEB57CB)
In-Reply-To: <1377301703-8853-1-git-send-email-bzhao@marvell.com>
References: <1377301703-8853-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

EXT_CAPAB_IE format involves IEEE header followed by bytestream of
capabilities. Current structure has incorrect member u8 for data;
fix it by defining it as u8[0].

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c | 10 ++++++----
 drivers/net/wireless/mwifiex/fw.h  |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 41e9d25..b579a2e 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -292,6 +292,7 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_extcap *ext_cap;
 	int ret_len = 0;
 	struct ieee80211_supported_band *sband;
+	struct ieee_types_header *hdr;
 	u8 radio_type;
 
 	if (!buffer || !*buffer)
@@ -388,17 +389,18 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 	}
 
 	if (bss_desc->bcn_ext_cap) {
+		hdr = (void *)bss_desc->bcn_ext_cap;
 		ext_cap = (struct mwifiex_ie_types_extcap *) *buffer;
 		memset(ext_cap, 0, sizeof(struct mwifiex_ie_types_extcap));
 		ext_cap->header.type = cpu_to_le16(WLAN_EID_EXT_CAPABILITY);
-		ext_cap->header.len = cpu_to_le16(sizeof(ext_cap->ext_cap));
+		ext_cap->header.len = cpu_to_le16(hdr->len);
 
-		memcpy((u8 *)ext_cap + sizeof(struct mwifiex_ie_types_header),
+		memcpy((u8 *)ext_cap->ext_capab,
 		       bss_desc->bcn_ext_cap + sizeof(struct ieee_types_header),
 		       le16_to_cpu(ext_cap->header.len));
 
-		*buffer += sizeof(struct mwifiex_ie_types_extcap);
-		ret_len += sizeof(struct mwifiex_ie_types_extcap);
+		*buffer += sizeof(struct mwifiex_ie_types_extcap) + hdr->len;
+		ret_len += sizeof(struct mwifiex_ie_types_extcap) + hdr->len;
 	}
 
 	return ret_len;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c9ad1c0..f80f30b 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1330,7 +1330,7 @@ struct mwifiex_ie_types_2040bssco {
 
 struct mwifiex_ie_types_extcap {
 	struct mwifiex_ie_types_header header;
-	u8 ext_cap;
+	u8 ext_capab[0];
 } __packed;
 
 struct host_cmd_ds_mac_reg_access {
-- 
1.8.2.3

