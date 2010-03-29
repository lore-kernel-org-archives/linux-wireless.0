Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31427 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0C2WUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 18:20:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 15:20:10 -0700
Date: Mon, 29 Mar 2010 15:20:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Wiktor Zajas <w.zajas@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: add the 0cf3:1006 TL-WN422G v2 device
 ID now
Message-ID: <20100329222008.GA2852@tux>
References: <43e72e891003281631i52f2800k23581c055fbc32ac@mail.gmail.com>
 <43e72e891003281632x17f6d1d9i82640d96baa84096@mail.gmail.com>
 <c13c21871003281831u74976d85lb3d4ece2d59c1f86@mail.gmail.com>
 <43e72e891003281929hfff3821p65a9c42f15d9f6db@mail.gmail.com>
 <c13c21871003281948y40edee0bi36c185b9dfaf4036@mail.gmail.com>
 <43e72e891003282006l266141ehb78a2f4d46db76d6@mail.gmail.com>
 <c13c21871003282118s80d7c8era5585af4a3377bc3@mail.gmail.com>
 <c13c21871003282131x1ebaaee8h74f737c797b71b84@mail.gmail.com>
 <19376.15678.641255.41127@gargle.gargle.HOWL>
 <20100329214009.804ec23f.wzajas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100329214009.804ec23f.wzajas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 12:40:09PM -0700, Wiktor Zajas wrote:
> Thanks so much for this driver, it's working flawlessly. Only one minor problem
> was "Michael MIC failure detected", changing to AES helped.

Not sure if Sujith's patch posted yesterday would fix this.

> I don't know if what I've done is correct, in order to recognize my card
> (TL-WN422G v2) I've added "ATH9K_FW_USB_DEV(0x1006, "ar9271.fw")," to
> "ath9k_hif_usb_ids[]", and changed "#define AR9271_USB 0x9271" to
> "#define AR9271_USB 0x1006", is this the right thing to do ?

Sort of, try this patch:

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_htc: add the 0cf3:1006 TL-WN422G v2 device ID

Reported-by: Wiktor Zajas <w.zajas@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index fc4f6e8..a7664e4 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -21,6 +21,7 @@
 
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	ATH9K_FW_USB_DEV(0x9271, "ar9271.fw"),
+	ATH9K_FW_USB_DEV(0x1006, "ar9271.fw"), /* TL-WN422G v2 */
 	{ },
 };
 
-- 
1.6.3.3


********************************************************************************
                            Git Achievement Unlocked!                            

                         Apprentice Archivist (Level 3)                         
 Prepare each commit with its patch in one file per commit with git format-patch 
********************************************************************************

