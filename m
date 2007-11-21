Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36202 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbXKUUC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 15:02:27 -0500
Message-ID: <47448ED1.9090100@lwfinger.net> (sfid-20071121_200230_664228_D13B6AFF)
Date: Wed, 21 Nov 2007 14:02:25 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Changes to enable BCM4311 rev 02 with wireless core
 revision 13
References: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net> <200711212044.08265.mb@bu3sch.de>
In-Reply-To: <200711212044.08265.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 21 November 2007 20:31:53 Larry Finger wrote:
>> The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
>> has not been supported until now. The changes include the following:
>>
>> (1) Add the 802.11 rev 13 device to the ssb_device_id table to load =
b43.
>> (2) Add PHY revision 9 to the supported list.
>> (3) Fix 64-bit addressing errors.
>> (4) Remove some magic numbers in the DMA setup.
>>
>> The DMA implementation for this chip supports full 64-bit addressing=
 with
>> one exception. Whenever the Descriptor Ring Buffer is in high memory=
, a
>> fatal DMA error occurs. This problem was not present in 2.6.24-rc2 d=
ue
>> to code to "Bias the placement of kernel pages at lower PFNs". When
>> commit 44048d70 reverted that code, the DMA error appeared. As a "fi=
x",
>> use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At p=
resent,
>> this problem is thought to arise from a hardware error. The present =
driver
>> allocates one ring buffer for RX and six for TX; however, only one o=
f the
>> TX buffers is used. To minimize any system impact associated with us=
ing low
>> memory, this patch removes the allocation of the unused buffers.
>>
>> This patch has been tested by C=C3=A9dric Caumont <icare40@hotmail.c=
om>.
>>
>=20
>> @@ -954,19 +955,21 @@ int b43_dma_init(struct b43_wldev *dev)
>> =20
>>  	err =3D -ENOMEM;
>>  	/* setup TX DMA channels. */
>> -	ring =3D b43_setup_dmaring(dev, 0, 1, dma64);
>> +	ring =3D b43_setup_dmaring(dev, 1, 1, dma64);
>>  	if (!ring)
>>  		goto out;
>> -	dma->tx_ring0 =3D ring;
>> +	dma->tx_ring1 =3D ring;
>> =20
>> -	ring =3D b43_setup_dmaring(dev, 1, 1, dma64);
>> +	/* The driver only uses ring1 for TX - skip setup for the rest */
>> +#if 0
>=20
> NACK.

Are you NACKing the "if 0" or the elimination of the unused TX rings? P=
erhaps we could have

	if (ring->dma64)
		goto out;

Larry
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
