Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:56468 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2HZTlh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 15:41:37 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Roman Thiele <roman.thiele@stusta.mhn.de>
Subject: Re: Getting ASUS USB-N53 out of CONFIG_RT2800USB_UNKNOWN
Date: Sun, 26 Aug 2012 21:30:48 +0200
Message-ID: <3179213.PgkDzT6pU6@eisbaer> (sfid-20120826_214219_907617_D2C7A6A4)
In-Reply-To: <503A7721.4060005@gmail.com>
References: <17042485.dTE7gQicta@eisbaer> <503A7721.4060005@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4567406.ogJDXWkYcZ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart4567406.ogJDXWkYcZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Gertjan,

On Sunday 26 August 2012 21:21:05 Gertjan van Wingerde wrote:
> Hi Maxi,
> 
> On 08/26/12 15:33, Maximilian Engelhardt wrote:
> > Hallo,
> > 
> > I recently bought an Asus USB-N53 Dual Band Wireless Network Adapter and
> > noticed that I have to enable CONFIG_RT2800USB_UNKNOWN to get it working.
> > With this option enabled everything is working fine as far as I have
> > tested.
> > 
> > So I'd line to get things right and move this device out of
> > CONFIG_RT2800USB_UNKNOWN to where it belongs.
> 
> Thanks for identifying the adapter. Moving it out of
> CONFIG_RT2800USB_UNKNOWN is definitely the way to go.
> 
> > Here is the information I have about this device, feel tree to ask if you
> > need anything addition.
> > 
> > Asus Website about the device:
> > http://www.asus.com/Networks/Wireless_Adapters/USBN53/
> > 
> > output of lsusb:
> > Bus 005 Device 013: ID 0b05:179d ASUSTek Computer, Inc. USB-N53 802.11abgn
> > Network Adapter [Ralink RT3572]
> > 
> > output of dmesg:
> > usb 5-6: new high-speed USB device number 13 using ehci_hcd
> > usb 5-6: New USB device found, idVendor=0b05, idProduct=179d
> > usb 5-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > usb 5-6: Product: 802.11 n WLAN
> > usb 5-6: Manufacturer: Ralink
> > usb 5-6: SerialNumber: 1.0
> > usb 5-6: reset high-speed USB device number 13 using ehci_hcd
> > ieee80211 phy6: Selected rate control algorithm 'minstrel_ht'
> > Registered led device: rt2800usb-phy6::radio
> > Registered led device: rt2800usb-phy6::assoc
> > Registered led device: rt2800usb-phy6::quality
> > 
> > 
> > So according to lsusb this is a RT3572 device, which does also match with
> > the chip description from ralink:
> > http://www.ralinktech.com/en/02_products/product.php?sn=1009
> > 
> > I suggest moving the device to the CONFIG_RT2800USB_RT35XX section in
> > rt2800usb.c, see attached patch.
> 
> We need a proper Signed-off-by line from you in accordance with the
> patch submission procedures. I can pick up your patch, add your
> Signed-off-by, and submit it for inclusion upstream, but you have to
> confirm that you are OK with me adding your Signed-off-by to the patch.

Here you go.

Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>

> > diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> > b/drivers/net/wireless/rt2x00/rt2800usb.c index 6cf3365..6681bfc 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> > @@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[]
> > = {> 
> >         { USB_DEVICE(0x1690, 0x0744) },
> >         { USB_DEVICE(0x1690, 0x0761) },
> >         { USB_DEVICE(0x1690, 0x0764) },
> > 
> > +       /* ASUS */
> > +       { USB_DEVICE(0x0b05, 0x179d) },
> > 
> >         /* Cisco */
> >         { USB_DEVICE(0x167b, 0x4001) },
> >         /* EnGenius */
> > 
> > @@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[]
> > = {> 
> >         { USB_DEVICE(0x0b05, 0x1760) },
> >         { USB_DEVICE(0x0b05, 0x1761) },
> >         { USB_DEVICE(0x0b05, 0x1790) },
> > 
> > -       { USB_DEVICE(0x0b05, 0x179d) },
> > 
> >         /* AzureWave */
> >         { USB_DEVICE(0x13d3, 0x3262) },
> >         { USB_DEVICE(0x13d3, 0x3284) },
> 
> ---
> Gertjan

Thanks for your help.

--nextPart4567406.ogJDXWkYcZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQOnloAAoJEIHqZH0kK9IVhyUP/1ISmqPRrh2sgtzEWnE7iFZ4
rBtUvx/+h0E4HHeNYFxrje3eO1pxhxnHT5cIGBIIDyv0yFKMCtZ+LG/Uc+EXlN8A
upSzCJxSzI2nfISUVbUQPQH3B49cgxawZbgh1HLYXOyV5PhlPPHrwehNXYttd540
VI/vkwSvZUhoVr0dFd3K5PWnxzT/Xd5C+hVbG6SU1nQ18yyuW5PxB9206bUD16P7
eZ4ami4EHeVeyHpnImG2C/3OPL0TETKNNN+HCx7beXJiCXjL8iqpYpRYpLa5NW4u
twq2/ia7AqX1NkymmPMp+vn11yhr3Zn3+ghJX0eK8Nt1+pBFf0uifkhpftxHOXeS
rELi3S2Do2nDfPaGxTuNpYy8EGPN+iWeD065GYRrNVCIaeurI5UaucIs0/RZQE1E
qF3v7N2yfOBAg3YBFXICRXby48jpZpsaWGVONrWnkjFEgsSDOyItjyHidU49RnW1
LyGg31eVDa1z96HgMUvxV7bZmkkdRQSSDtdev6xszk272JS31toQanvzxogS8/qK
kRBjFrM3qcsHwGSM0FHFfSUIxzjzVaEOB3+KCubyWsFDEBTouoj6Uww0zLBxkMFK
mVz+gybqMuHgd41mt2eyHS7cu7foiNQMx0vqgPrsHDMGFKe5WuFl+5FBdcDysxxt
SlWm3uL25X2tqlVIKPYe
=9qh3
-----END PGP SIGNATURE-----

--nextPart4567406.ogJDXWkYcZ--

