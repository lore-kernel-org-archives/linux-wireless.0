Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37316 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab3DBJ14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 05:27:56 -0400
Date: Tue, 2 Apr 2013 11:27:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] Revert "NFC: microread: Fix MEI build failure"
Message-ID: <20130402092751.GE17363@zurbaran> (sfid-20130402_112807_151546_A3F0D52B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This reverts commit 63cd353c34a08af2d1935f8d0c2b6b091714ff79.

We no longer need this fix as the MEI bus APIs are now merged into
char-misc-next.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---

John, this one is for wireless-next and will fix the conflict between net-next
and wireless that Stephen reported today.

---
 drivers/nfc/microread/mei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 13bde92..eef38cf 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -48,7 +48,7 @@ struct mei_nfc_hdr {
 #define MEI_NFC_MAX_READ (MEI_NFC_HEADER_SIZE + MEI_NFC_MAX_HCI_PAYLOAD)
 
 struct microread_mei_phy {
-	struct mei_device *device;
+	struct mei_device *mei_device;
 	struct nfc_hci_dev *hdev;
 
 	int powered;
-- 
1.7.10.4

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
