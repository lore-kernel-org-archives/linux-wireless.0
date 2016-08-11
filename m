Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56439 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbcHKVMj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 17:12:39 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH 12/16] net: wireless: broadcom: brcm80211: brcmfmac: usb: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:05:31 +0200
Message-Id: <1470949539-25392-13-git-send-email-wsa-dev@sang-engineering.com> (sfid-20160811_231251_512870_7454AD6D)
In-Reply-To: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949539-25392-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 98b15a9a2779f4..fa26619a7945d9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1099,15 +1099,11 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	devinfo->tx_freecount = ntxq;
 
 	devinfo->ctl_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!devinfo->ctl_urb) {
-		brcmf_err("usb_alloc_urb (ctl) failed\n");
+	if (!devinfo->ctl_urb)
 		goto error;
-	}
 	devinfo->bulk_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!devinfo->bulk_urb) {
-		brcmf_err("usb_alloc_urb (bulk) failed\n");
+	if (!devinfo->bulk_urb)
 		goto error;
-	}
 
 	return &devinfo->bus_pub;
 
-- 
2.8.1

