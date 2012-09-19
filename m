Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3869 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2ISUVp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:45 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/13] brcmfmac: clear control lock on usb error.
Date: Wed, 19 Sep 2012 22:21:16 +0200
Message-ID: <1348086078-19183-12-git-send-email-arend@broadcom.com> (sfid-20120919_222149_330736_AB922BB0)
In-Reply-To: <1348086078-19183-1-git-send-email-arend@broadcom.com>
References: <1348086078-19183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On a usb error the lock bit should be cleared.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 246d06b..5fe6ec7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -337,6 +337,7 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	err = brcmf_usb_send_ctl(devinfo, buf, len);
 	if (err) {
 		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
+		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
 
@@ -367,6 +368,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	err = brcmf_usb_recv_ctl(devinfo, buf, len);
 	if (err) {
 		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
+		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
 	devinfo->ctl_completed = false;
-- 
1.7.9.5


