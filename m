Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:32856 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdAVM17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jan 2017 07:27:59 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Clement Perrochaud <clement.perrochaud@effinnov.com>
Cc: Charles Gorand <charles.gorand@effinnov.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@ml01.01.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] nfc: nxp-nci: use msleep for long delays
Date: Sun, 22 Jan 2017 13:28:39 +0100
Message-Id: <1485088119-17986-1-git-send-email-der.herr@hofr.at> (sfid-20170122_132802_872341_431CD88C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ulseep_range() uses hrtimers and provides no advantage over msleep()
for larger delays. For this large delay msleep() is preferable.

Fixes: commit 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Link: http://lkml.org/lkml/2017/1/11/377
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
Problem was found by cocinelle script.

nxp_nci_i2c_write takes the negative return code as indicator that the
NFC device was probably in stand-by mode, the first transaction attempt
woke it up and that after 110ms latest it would be ready to receive.
Overrunning this time by a few milliseconds will not hurt though so
msleep() should be fine here.

Patch was compile tested with: x86_64_defconfig + CONFIG_NFC=m,
CONFIG_NFC_NCI=m, CONFIG_NFC_NXP_NCI=m, CONFIG_NFC_NXP_NCI_I2C=m

Patch is against 4.10-rc4 (localversion-next is next-20170120)

 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 36099e5..ceb815c 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -86,7 +86,7 @@ static int nxp_nci_i2c_write(void *phy_id, struct sk_buff *skb)
 	r = i2c_master_send(client, skb->data, skb->len);
 	if (r < 0) {
 		/* Retry, chip was in standby */
-		usleep_range(110000, 120000);
+		msleep(110);
 		r = i2c_master_send(client, skb->data, skb->len);
 	}
 
-- 
2.1.4
