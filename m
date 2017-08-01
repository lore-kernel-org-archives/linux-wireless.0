Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35391 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdHABie (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 21:38:34 -0400
Received: by mail-pg0-f66.google.com with SMTP id l64so354834pge.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 18:38:34 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [v2 PATCH 2/2] mwifiex: pcie: compatible with wifi-only image while extract wifi-part fw
Date: Tue,  1 Aug 2017 01:38:24 +0000
Message-Id: <1501551504-8560-2-git-send-email-huxinming820@gmail.com> (sfid-20170801_033838_257993_F9438189)
In-Reply-To: <1501551504-8560-1-git-send-email-huxinming820@gmail.com>
References: <1501551504-8560-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Sometimes, we might using wifi-only firmware with a combo firmware name,
in this case, do not need to filter bluetooth part from header.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
---
v2: fix comment format/grammar (Brain)
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 3da1eeb..dc4e054 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1985,7 +1985,8 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
  * (3) wifi image.
  *
  * This function bypass the header and bluetooth part, return
- * the offset of tail wifi-only part.
+ * the offset of tail wifi-only part. If the image is already wifi-only,
+ * that is start with CMD1, return 0.
  */
 
 static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
@@ -1993,7 +1994,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
 	const struct mwifiex_fw_data *fwdata;
 	u32 offset = 0, data_len, dnld_cmd;
 	int ret = 0;
-	bool cmd7_before = false;
+	bool cmd7_before = false, first_cmd = false;
 
 	while (1) {
 		/* Check for integer and buffer overflow */
@@ -2014,20 +2015,29 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
 
 		switch (dnld_cmd) {
 		case MWIFIEX_FW_DNLD_CMD_1:
-			if (!cmd7_before) {
-				mwifiex_dbg(adapter, ERROR,
-					    "no cmd7 before cmd1!\n");
+			if (offset + data_len < data_len) {
+				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
 				ret = -1;
 				goto done;
 			}
-			if (offset + data_len < data_len) {
-				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
+
+			/* Image start with cmd1, already wifi-only firmware */
+			if (!first_cmd) {
+				mwifiex_dbg(adapter, MSG,
+					    "input wifi-only firmware\n");
+				return 0;
+			}
+
+			if (!cmd7_before) {
+				mwifiex_dbg(adapter, ERROR,
+					    "no cmd7 before cmd1!\n");
 				ret = -1;
 				goto done;
 			}
 			offset += data_len;
 			break;
 		case MWIFIEX_FW_DNLD_CMD_5:
+			first_cmd = true;
 			/* Check for integer overflow */
 			if (offset + data_len < data_len) {
 				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
@@ -2037,6 +2047,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
 			offset += data_len;
 			break;
 		case MWIFIEX_FW_DNLD_CMD_6:
+			first_cmd = true;
 			/* Check for integer overflow */
 			if (offset + data_len < data_len) {
 				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
@@ -2053,6 +2064,7 @@ static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
 			}
 			goto done;
 		case MWIFIEX_FW_DNLD_CMD_7:
+			first_cmd = true;
 			cmd7_before = true;
 			break;
 		default:
-- 
1.9.1
