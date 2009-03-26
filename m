Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:55391 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZCZMtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 08:49:12 -0400
Date: Thu, 26 Mar 2009 13:49:09 +0100
Message-Id: <1537876674@web.de> (sfid-20090326_134916_649336_2D8C15AF)
MIME-Version: 1.0
From: Chunkeey@web.de
To: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: p54spi - mesh mode summary
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2) Today it doesn't reproduce. Plink establishment passes, altough, w=
arning remains:
>=20
> 3) Beaconing works, but not the way it should: like MPs don't hear ea=
ch other. Timestamps never get in sync
> and both MPs issue beacon during 0.1s beacon interval.
> I've seen it before, with stlc45xx. It shows when LMAC is set up with=
 LMAC_SETUP_IBSS | LMAC_SETUP_TRANSPARENT flags.
> If there's no LMAC_SETUP_TRANSPARENT flag in LMAC setup then timestam=
ps get in sync.

=46YI: The TSF will always reset when a new beacon is submitted to the =
firmware.
The specs talks about that.

> 4) Pings don't go, because MPs don't answer ARP requests sent to it. =
Haven't tested for the root cause yet.
> But again, I have seen this with stlc45xx with two different causes:
> - when LMAC was set up without LMAC_SETUP_TRANSPARENT flag, ARP reque=
sts didn't pass LMAC packet filter
>   and weren't reported to the driver;
Yup, that's because the firmware will filter out any frames which are n=
ot from/for the BSSID.
(the bssid the field right next to the device own MAC in p54_setup_mac)

> - when LMAC was set up with LMAC_SETUP_TRANSPARENT flag firmware seem=
 to truncate last 2 bytes of the packet
>   that it reports.
Heh, that's also a ISL3887 (USB 2nd gen) bug... But PCI devices are not=
 affected.
The reason "why" has probably to do with the firmware's frame alignment=
 code.
Unfortunately the firmware for (ISL3887 and SPI) is rounding "down" to =
4 bytes instead of up...
So the FCS will be clipped... But fortunately the firmware set a bit in=
 the header that tells
us whenever the frames was corrupted or not (P54_HDR_FLAG_DATA_IN_FCS_G=
OOD).

what happens if you change p54spi_rx the following way:?=20

-        skb =3D dev_alloc_skb(len);
+        skb =3D dev_alloc_skb(len + 4);
        if (!skb) {
                dev_err(&priv->spi->dev, "could not alloc skb");
                return 0;
        }

        p54spi_spi_read(priv, SPI_ADRS_DMA_DATA, skb_put(skb, len), len=
);
        p54spi_sleep(priv);

+      skb_put(skb, 4);=20
        if (p54_rx(priv->hw, skb) =3D=3D 0)
                dev_kfree_skb(skb);

=20
> > Is there anything else I can do, or something you want to know?
> Are there other p54 species that use 3826.arm firmware?
I guess no... there are pci/usb/spi and shmem devices but all have thei=
r own firmware.

> Are there other sources of information regarding LMAC interaction exc=
ept
> http://wireless.kernel.org/en/developers/Documentation/specs?action=3D=
AttachFile&do=3Dget&target=3DSTSW45x0C_LMAC_API_ED1P4.pdf ?

hmm, maybe the old islsm... But then, this driver is very old now...
=20
> Who should be contacted with questions about firmware behavior?
>=20
No idea, maybe nokia knows... because the "frame alignment" can also cl=
ip QoS-(Data) or WDS Frames.

Regards,
   Chr
____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger geh=F6rt?=20
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3D3124

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
