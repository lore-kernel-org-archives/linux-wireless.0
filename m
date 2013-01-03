Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:46830 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003Ab3ACAXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 19:23:05 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] wireless: mwifiex: remove unreachable paths
Date: Wed,  2 Jan 2013 16:23:01 -0800
Message-Id: <1357172581-27760-1-git-send-email-bzhao@marvell.com> (sfid-20130103_012309_740178_CD352886)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sasha Levin <sasha.levin@oracle.com>

We know 'firmware' is non-NULL from the beginning of mwifiex_prog_fw_w_helper,
remove all !firmware paths from the rest of the function.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c |   30 +++---------------------------
 1 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 63ac9f2..5d4a10a 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -786,21 +786,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
-/* This function reads one block of firmware data. */
-static int mwifiex_get_fw_data(struct mwifiex_adapter *adapter,
-			       u32 offset, u32 len, u8 *buf)
-{
-	if (!buf || !len)
-		return -1;
-
-	if (offset + len > adapter->firmware->size)
-		return -1;
-
-	memcpy(buf, adapter->firmware->data + offset, len);
-
-	return 0;
-}
-
 static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				    struct mwifiex_fw_image *fw)
 {
@@ -836,23 +821,14 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			dlen = 0;
 		} else {
 			/* copy the header of the fw_data to get the length */
-			if (firmware)
-				memcpy(&fwdata->fw_hdr, &firmware[tlen],
-				       sizeof(struct fw_header));
-			else
-				mwifiex_get_fw_data(adapter, tlen,
-						    sizeof(struct fw_header),
-						    (u8 *)&fwdata->fw_hdr);
+			memcpy(&fwdata->fw_hdr, &firmware[tlen],
+			       sizeof(struct fw_header));
 
 			dlen = le32_to_cpu(fwdata->fw_hdr.data_len);
 			dnld_cmd = le32_to_cpu(fwdata->fw_hdr.dnld_cmd);
 			tlen += sizeof(struct fw_header);
 
-			if (firmware)
-				memcpy(fwdata->data, &firmware[tlen], dlen);
-			else
-				mwifiex_get_fw_data(adapter, tlen, dlen,
-						    (u8 *)fwdata->data);
+			memcpy(fwdata->data, &firmware[tlen], dlen);
 
 			fwdata->seq_num = cpu_to_le32(fw_seqnum);
 			tlen += dlen;
-- 
1.7.0.2

