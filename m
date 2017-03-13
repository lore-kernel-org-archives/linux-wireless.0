Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33682 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdCMMot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 08:44:49 -0400
From: Johan Hovold <johan@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: [PATCH 1/2] wireless: ath9k_htc: fix NULL-deref at probe
Date: Mon, 13 Mar 2017 13:44:20 +0100
Message-Id: <20170313124421.28587-1-johan@kernel.org> (sfid-20170313_134548_815021_7458FF14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure to check the number of endpoints to avoid dereferencing a
NULL-pointer or accessing memory beyond the endpoint array should a
malicious device lack the expected endpoints.

Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index de2d212f39ec..9206955e865a 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1219,6 +1219,9 @@ static int send_eject_command(struct usb_interface *interface)
 	u8 bulk_out_ep;
 	int r;
 
+	if (iface_desc->desc.bNumEndpoints < 2)
+		return -ENODEV;
+
 	/* Find bulk out endpoint */
 	for (r = 1; r >= 0; r--) {
 		endpoint = &iface_desc->endpoint[r].desc;
-- 
2.12.0
