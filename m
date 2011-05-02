Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:46576 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1EBR4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 13:56:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix missing tsf_val TLV
Date: Mon,  2 May 2011 11:00:45 -0700
Message-Id: <1304359245-27453-1-git-send-email-bzhao@marvell.com> (sfid-20110502_195621_013745_3BC41118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mwifiex_cmd_append_tsf_tlv(), two tsf_val TLVs should be
filled in the buffer and then sent to firmware.

The missing first TLV for tsf_val is added back in this patch.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |    7 ++++++-
 drivers/net/wireless/mwifiex/main.h |    2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 042eb77..85fca5e 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -100,7 +100,7 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 			   struct mwifiex_bssdescriptor *bss_desc)
 {
 	struct mwifiex_ie_types_tsf_timestamp tsf_tlv;
-	long long tsf_val;
+	__le64 tsf_val;
 
 	/* Null Checks */
 	if (buffer == NULL)
@@ -116,6 +116,11 @@ mwifiex_cmd_append_tsf_tlv(struct mwifiex_private *priv, u8 **buffer,
 	memcpy(*buffer, &tsf_tlv, sizeof(tsf_tlv.header));
 	*buffer += sizeof(tsf_tlv.header);
 
+	/* TSF at the time when beacon/probe_response was received */
+	tsf_val = cpu_to_le64(bss_desc->network_tsf);
+	memcpy(*buffer, &tsf_val, sizeof(tsf_val));
+	*buffer += sizeof(tsf_val);
+
 	memcpy(&tsf_val, bss_desc->time_stamp, sizeof(tsf_val));
 
 	dev_dbg(priv->adapter->dev, "info: %s: TSF offset calc: %016llx - "
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 1b50303..5043fcd 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -280,7 +280,7 @@ struct mwifiex_bssdescriptor {
 	 * BAND_A(0X04): 'a' band
 	 */
 	u16 bss_band;
-	long long network_tsf;
+	u64 network_tsf;
 	u8 time_stamp[8];
 	union ieee_types_phy_param_set phy_param_set;
 	union ieee_types_ss_param_set ss_param_set;
-- 
1.7.0.2

