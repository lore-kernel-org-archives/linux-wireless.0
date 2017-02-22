Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:49640 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdBVJyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 04:54:38 -0500
Received: from [93.227.204.184] (helo=vbox.localnet)
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <hilberg@kernelconcepts.de>)
        id 1cgTdQ-0001kf-NH
        for linux-wireless@vger.kernel.org; Wed, 22 Feb 2017 10:54:56 +0100
From: Christian Hilberg <hilberg@kernelconcepts.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [rtl8xxxu] rtl8192cu (0bda:8176) on linux-4.9.11 (arm) high sirq rate
Date: Wed, 22 Feb 2017 10:54:26 +0100
Message-ID: <1911802.4OUzV9TSOC@vbox> (sfid-20170222_105444_763948_77C4FC30)
In-Reply-To: <1581189.s4o7FEpKoz@vbox>
References: <1581189.s4o7FEpKoz@vbox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1860135.zBNqNBjcmF"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1860135.zBNqNBjcmF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Hi again,

Am Montag, 20. Februar 2017, 14:51:54 CET schrieb Christian Hilberg:
> Hi all,
> 
> currently I'm testing rtl8xxxu on an ARM device (i.mx28, armv5te) under
> linux-4.9.11 with a RealTek 8192cu (0bda:8176) wifi dongle. Since
> I had to set CONFIG_RTL8XXXU_UNTESTED, I'm prepared to see some
> rough edges here and there. :-)

The rtl8xxxu driver identifies the device as "8188CU", and so does lsusb.

> The driver actually works and I'm getting a stable connection on
> a WPA2 secured wifi network. As a firmware blob, the driver loads
> the "rtl8192cufw_TMSC.bin", which I extracted from [0].
> 
> However, the sirg rate is rather high (between 20% to 50% in top),
> as soon as the device is getting upped, that is, as soon as IFF_UP
> gets written to the device via ioctl().

I've dug further into this.

It shows that if in the driver's rtl8xxxu_identify_chip() routine for the 
RTL8188C variant I set priv->usb_interrupts = 0, then the sirq load vanishes
and the driver apparently still works:

---8<---
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/
net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 82d949ede294..2daacfd059b8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1687,7 +1687,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv 
*priv)
                priv->rx_paths = 1;
                priv->tx_paths = 1;
                priv->rtl_chip = RTL8188C;
-               priv->usb_interrupts = 1;
+               priv->usb_interrupts = 0;
                priv->has_wifi = 1;
        }
---8<---

Seems to me that rtl8xxxu_int_complete() does nothing with the URB data but to 
re-submit it (just to satisfy hardware which wants its interrupts to be 
handled maybe?).

I'm not at all clear whether the above change would be the Right Thing to do.
Jes, do you have any thoughts on this? Are there 8188CU variants which need
interrupts to be handled?

Regards,

	Christian

> [0]
> http://ftp.de.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-r
> ealtek_20161130-2_all.deb


-- 

--nextPart1860135.zBNqNBjcmF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSyhVWrDvSbjNh+VgSjfCBKHNEMEQUCWK1f0gAKCRCjfCBKHNEM
ESDuAKDutvvktt2stZCtowuP95+/VRZgvQCeJmNJ8j+CMZdts6Xf9ZK6UZVbm18=
=SpNL
-----END PGP SIGNATURE-----

--nextPart1860135.zBNqNBjcmF--
