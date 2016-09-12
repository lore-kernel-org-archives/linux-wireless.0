Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52922 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755887AbcILN0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:26:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8CDPihu028642
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:26:03 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 25chpmpam7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:26:03 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/2] mwifiex: Command 7 handling for USB chipsets
Date: Mon, 12 Sep 2016 18:55:27 +0530
Message-ID: <1473686728-8101-2-git-send-email-akarwar@marvell.com> (sfid-20160912_152606_958717_F910F3F1)
In-Reply-To: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
References: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Firmware image for newer USB chipsets starts with a command 7 block
(special command). It doesn't contain data length field. This patch adds
necessary handling.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++++
 drivers/net/wireless/marvell/mwifiex/usb.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 9213516..8a20620 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1026,6 +1026,10 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			dnld_cmd = le32_to_cpu(fwdata->fw_hdr.dnld_cmd);
 			tlen += sizeof(struct fw_header);
 
+			/* Command 7 doesn't have data length field */
+			if (dnld_cmd == FW_CMD_7)
+				dlen = 0;
+
 			memcpy(fwdata->data, &firmware[tlen], dlen);
 
 			fwdata->seq_num = cpu_to_le32(fw_seqnum);
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index b4e9246..1b49c52 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -51,6 +51,7 @@
 #define FW_DNLD_TX_BUF_SIZE	620
 #define FW_DNLD_RX_BUF_SIZE	2048
 #define FW_HAS_LAST_BLOCK	0x00000004
+#define FW_CMD_7		0x00000007
 
 #define FW_DATA_XMIT_SIZE \
 	(sizeof(struct fw_header) + dlen + sizeof(u32))
-- 
1.9.1
