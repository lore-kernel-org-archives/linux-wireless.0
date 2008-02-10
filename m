Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:35288 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYBJTEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 14:04:09 -0500
Received: by py-out-1112.google.com with SMTP id u52so6439666pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 11:04:07 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] wireless: rt2x00: fix driver menu indenting
Date: Sun, 10 Feb 2008 20:03:25 +0100
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless@vger.kernel.org,
	Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>,
	linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	linville@tuxdriver.com
References: <200802091623.06504.m.bueker@berlin.de> <20080210105252.e0a433ee.randy.dunlap@oracle.com>
In-Reply-To: <20080210105252.e0a433ee.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200802102003.25392.IvDoorn@gmail.com> (sfid-20080210_190414_230822_BA4E3706)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 February 2008, Randy Dunlap wrote:
> On Sat, 9 Feb 2008 16:23:06 +0100 Michael B=FCker wrote:
>=20
> > 2) When selecting "Ralink driver support" (CONFIG_RT2X00), the acco=
mpanying=20
> > drivers (CONFIG_RT2400PCI, CONFIG_RT61PC, ...) appear unindented. T=
hey should=20
> > be indented by four spaces.
>=20
> Yes, patch is below.
>=20
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Michael B=FCker <m.bueker@berlin.de> reports that the RT2x00 drivers
> are not indented as they should be, so use proper dependencies to mak=
e
> them be indented as expected.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Ack-by: Ivo van Doorn <IvDoorn@gmail.com>

---
John,
Could you push this directly into wireless-2.6 and probably upstream as=
 well.

Thanks.

Ivo

> ---
>  drivers/net/wireless/rt2x00/Kconfig |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> --- linux-2.6.24-git21.orig/drivers/net/wireless/rt2x00/Kconfig
> +++ linux-2.6.24-git21/drivers/net/wireless/rt2x00/Kconfig
> @@ -11,18 +11,17 @@ config RT2X00
>  	  will also be created. That library (when the driver is built as
>  	  a module) will be called "rt2x00lib.ko".
> =20
> +if RT2X00
> +
>  config RT2X00_LIB
>  	tristate
> -	depends on RT2X00
> =20
>  config RT2X00_LIB_PCI
>  	tristate
> -	depends on RT2X00
>  	select RT2X00_LIB
> =20
>  config RT2X00_LIB_USB
>  	tristate
> -	depends on RT2X00
>  	select RT2X00_LIB
> =20
>  config RT2X00_LIB_FIRMWARE
> @@ -39,7 +38,7 @@ config RT2X00_LIB_RFKILL
> =20
>  config RT2400PCI
>  	tristate "Ralink rt2400 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -58,7 +57,7 @@ config RT2400PCI_RFKILL
> =20
>  config RT2500PCI
>  	tristate "Ralink rt2500 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select EEPROM_93CX6
>  	---help---
> @@ -77,7 +76,7 @@ config RT2500PCI_RFKILL
> =20
>  config RT61PCI
>  	tristate "Ralink rt61 pci/pcmcia support"
> -	depends on RT2X00 && PCI
> +	depends on PCI
>  	select RT2X00_LIB_PCI
>  	select RT2X00_LIB_FIRMWARE
>  	select EEPROM_93CX6
> @@ -97,7 +96,7 @@ config RT61PCI_RFKILL
> =20
>  config RT2500USB
>  	tristate "Ralink rt2500 usb support"
> -	depends on RT2X00 && USB
> +	depends on USB
>  	select RT2X00_LIB_USB
>  	---help---
>  	  This is an experimental driver for the Ralink rt2500 wireless chi=
p.
> @@ -106,7 +105,7 @@ config RT2500USB
> =20
>  config RT73USB
>  	tristate "Ralink rt73 usb support"
> -	depends on RT2X00 && USB
> +	depends on USB
>  	select RT2X00_LIB_USB
>  	select RT2X00_LIB_FIRMWARE
>  	---help---
> @@ -128,3 +127,4 @@ config RT2X00_DEBUG
>  	---help---
>  	  Enable debugging output for all rt2x00 modules
> =20
> +endif
>=20
> ---------------------------------------------------------------------=
----
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
>=20


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
