Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:42766 "HELO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759064Ab2DZUDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 16:03:40 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix static checker warnings
Date: Thu, 26 Apr 2012 13:02:57 -0700
Message-Id: <1335470577-1832-1-git-send-email-bzhao@marvell.com> (sfid-20120426_220344_136595_39ABFAA9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

"oui_type" in structure "ieee_types_vendor_header" is not used separately,
so include it in "oui" array. Now complete oui will be compared fixing
following warnings.

drivers/net/wireless/mwifiex/sta_ioctl.c:1410 mwifiex_set_gen_ie_helper()
        error: memcmp() 'pvendor_ie->oui' too small (3 vs 4)
drivers/net/wireless/mwifiex/sta_ioctl.c:1435 mwifiex_set_gen_ie_helper()
        error: memcmp() 'pvendor_ie->oui' too small (3 vs 4)
drivers/net/wireless/mwifiex/scan.c:1177 mwifiex_update_bss_desc_with_ie()
        error: memcmp() 'vendor_ie->vend_hdr.oui' too small (3 vs 4)
drivers/net/wireless/mwifiex/scan.c:1185 mwifiex_update_bss_desc_with_ie()
        error: memcmp() 'vendor_ie->vend_hdr.oui' too small (3 vs 4)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 2a2caba..5f6adeb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -993,8 +993,7 @@ struct mwifiex_ie_types_wmm_queue_status {
 struct ieee_types_vendor_header {
 	u8 element_id;
 	u8 len;
-	u8 oui[3];
-	u8 oui_type;
+	u8 oui[4];	/* 0~2: oui, 3: oui_type */
 	u8 oui_subtype;
 	u8 version;
 } __packed;
-- 
1.7.0.2

