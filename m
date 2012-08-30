Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3674 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2H3Rn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 13:43:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: prevent possible race condition on usb rx
 control.
Date: Thu, 30 Aug 2012 19:42:58 +0200
Message-ID: <1346348582-20095-2-git-send-email-arend@broadcom.com> (sfid-20120830_194335_127331_D665AEB5)
In-Reply-To: <1346348582-20095-1-git-send-email-arend@broadcom.com>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_usb_tx_ctlpkt sends message using brcmf_usb_send_ctl then
clears boolean and waits for boolean to be set (by another
thread). This can result in situation where flag gets cleared
while result was already received. First clearing the flag and
then sending the data will prevent this.

Reviewed-by: Arend Van Spriel (arend@broadcom.com)
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index a299d42..ac1ed1f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -366,13 +366,13 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	if (test_and_set_bit(0, &devinfo->ctl_op))
 		return -EIO;
 
+	devinfo->ctl_completed = false;
 	err = brcmf_usb_send_ctl(devinfo, buf, len);
 	if (err) {
 		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
 		return err;
 	}
 
-	devinfo->ctl_completed = false;
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo, &devinfo->ctl_completed,
 					    &pending);
 	clear_bit(0, &devinfo->ctl_op);
-- 
1.7.9.5


