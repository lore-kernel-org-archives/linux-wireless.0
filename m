Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:56912 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdCQOCJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 10:02:09 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: Re: [PATCH 1/3] ath9k: Support channels in licensed bands
Date: Fri, 17 Mar 2017 15:02:05 +0100
Message-ID: <2318695.ItlGDV16mL@prime> (sfid-20170317_150227_757946_51204AF8)
In-Reply-To: <096bcee2-a991-eac1-8f4f-d7cf7c34730d@neratec.com>
References: <20170316151337.24163-1-sw@simonwunderlich.de> <20170316151337.24163-2-sw@simonwunderlich.de> <096bcee2-a991-eac1-8f4f-d7cf7c34730d@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1612357.8xXe1fcjUP"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1612357.8xXe1fcjUP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, March 17, 2017 2:40:50 PM CET Zefir Kurtisi wrote:
> On 03/16/2017 04:13 PM, Simon Wunderlich wrote:
> > @@ -126,10 +142,14 @@ int ath9k_cmn_init_channels_rates(struct ath_common
> > *common)> 
> >  {
> >  
> >  	struct ath_hw *ah = (struct ath_hw *)common->ah;
> >  	void *channels;
> > 
> > +	int num_5ghz_chan = ARRAY_SIZE(ath9k_5ghz_chantable);
> > +
> > +	if (!IS_ENABLED(CONFIG_ATH9K_LICENSED_CHAN))
> > +		num_5ghz_chan -= ATH9K_NUM_LICENSED_CHANNELS;
> 
> These two lines seem wrong to me, since the extra channels are only added to
> the list if CONFIG_ATH9K_LICENSED_CHAN is defined. If it is not, this cuts
> off the last 7 regular channels, no?

Oh, I think you are right!

I'll revise this part and re-send. Seems I can just get rid of those two lines 
...

Cheers,
    Simon
--nextPart1612357.8xXe1fcjUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAljL7F0ACgkQoSvjmEKS
nqF2GA/9HW5iUi9mY4GWWduj386wIoIwyn1pXGv0rEh8JF7XSyn/btnU5JJEc8s/
4jrv4l4DW4sS3JvoVk/PycZBf7RDS8XTiNmZEOMuEy7NRqPDyKeHn092ZwN+Ric3
FID6RuTWdJGUy3Xzc+f3cr5CZMZ2h/67iD0JoK/Gn+EVk0Xl865ecVbFFXJj9Mol
7gA9mkUgqeNyV2m1oy1n1BGNb76e/54xndhYnPp84CAjCzlNqQZPfRIQm2bXYIfN
o0n+4tFyUMQAB4Fhvs5ABbHdf2AWbd6Lb8EgLB8AInvEFJOkZEZ3baC7HBVL8MnN
qir45IBkYEleUdnjj3POx3kaFNd1gResSG9OyKK1e5K7fjvoKxkGlo169bDviRaW
YO6AHby96i6oZDgrb9lLxPwtg940ZMYSEbzBaqbr3lqL2J/Lbi5naSLOFhGhHm2m
+AXwccpQhNINqL4Fv6zNPT0knVK+TLndFuKP64ZS86rJWUehZd6MV2KroHvC6h7P
z8Q15nvgq51Z0MQ6P0f4gNSUOzV/3WZlZ1OnEAgQ/nW4UitN/gOtTYhWalChsZJr
+4gHWLbdUSvdHj6XB58td0gNnnoe3MvvuJVT3K6us8RIvmlXC2z7/w1A558orMM5
DZNXR1xuDffAb8ZqiSr/C017dN0ESnvxA0RzqO8clCGqN9SQrEI=
=+Wa/
-----END PGP SIGNATURE-----

--nextPart1612357.8xXe1fcjUP--
