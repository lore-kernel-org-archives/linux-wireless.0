Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:45176 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753285AbdEIM5j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:57:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
Date: Tue, 09 May 2017 14:57:32 +0200
Message-ID: <1863250.VEhGCjvYY0@prime> (sfid-20170509_145742_698526_B776C48E)
In-Reply-To: <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
References: <20170323133048.30062-2-sw@simonwunderlich.de> <1811221.G4Vz0DPyQ8@prime> <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1822450.CG84pIzYTZ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1822450.CG84pIzYTZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey Kalle,

it seems like there was some discussion here and I wouldn't expect too many 
more opinions ... do you think we can have a decision based on what has been 
discussed here?

I'd be happy to rebase the remaining patches if that is necessary.

Thank you!
     Simon

On Friday, April 21, 2017 2:40:51 PM CEST Mathias Kretschmer wrote:
> Hi all,
> 
> as one of the parties who triggered this patch to be included into the
> main line kernel, we do support Simon's or Ben's point of view.
> 
> Safeguards against accidental misuse are in place. Various patches are
> (have been) already in the open, so if someone wants to be evil, it
> can't be prevented.
> 
> Also, these patches do not make up new channels out of the blue, they
> merely enable channels which are allowed in certain countries under
> specific regulations. To me it seems to be the task of the distribution
> manager (or manufacturer) to ensure that only hardware/kernel features
> are made available that are legal in the given jurisdiction.
> 
> The default behavior is to disable those extra channels. If you are
> building, i.e. First Responder solutions, you need to ensure that those
> guys use the systems incl. the frequency spectrum accordingly.
> 
> To be pragmatic and to avoid out-of-tree code maintenance, my vote would
> be for integration into mainline.
> 
> Best regards,
> 
> Mathias
> 
> 
> 
> 
> Hence, for
> 
> On 21-Apr-17 13:29, Simon Wunderlich wrote:
> > Hi,
> > 
> > On Tuesday, April 18, 2017 10:09:59 AM CEST Ben Greear wrote:
> >> [...]
> >> 
> >>>      In my personal view, we have quite a few obstacles which I consider
> >>>      "enough", but would be interesting to hear others opinions ...
> >>> 
> >>> I'll throw in my 2-cents. This patch is treading on very dangerous
> >>> ground.
> >>> I can't speak to other regulatory environments, but at least the FCC is
> >>> cracking down on even the possibility that anyone can operate a WiFi
> >>> device outside the regulatory bounds.
> >> 
> >> These patches make it slightly easier to use the licensed bands, but no
> >> one
> >> can accidentally use them due to the regdb and other constaints in these
> >> patches.
> >> 
> >> So, I don't think these patches offer any fundamental new vulnerability
> >> that should concern the FCC.
> >> 
> >> After all, someone who really wants to do evil can find and apply the
> >> patches without undue effort, and it could easily be that those applying
> >> the patches would then make it even easier to abuse the new channels due
> >> to
> >> laziness or poor coding choices.
> > 
> > I'm with Ben on this one. I also have followed the FCC actions in the past
> > few years, and I've also been involved into that [1,2,3]. There are
> > mailing lists on the topic if you want to get involved. I agree that the
> > topic is important, but I would prefer to not have this patch serving as
> > battleground. :)
> > 
> > The patches proposed here, as Ben says, at least put proper warnings and
> > obstacles which users have to knowingly overcome (or read). It's probably
> > safer than keeping the driver as is and having people apply random patches
> > from the internet which they don't understand or hack the code themselves.
> > Frankly, it's not that hard to enable those channels.
> > 
> > As we have seen by the number of questions and people trying to bring this
> > patch in (Ben and Julian), there is quite some interest for supporting
> > those bands. I've also got a few requests from companies to have it
> > supported (Fraunhofer is one of those).
> > 
> > Cheers,
> > 
> >        Simon
> > 
> > [1] https://www.reddit.com/r/wireless/comments/3irr5b/
> > openwrt_vs_fcc_forced_firmware_lockdown/
> > [2] http://hackaday.com/2016/02/26/fcc-locks-down-router-firmware/
> > [3] https://libreplanet.org/wiki/Save_WiFi
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k


--nextPart1822450.CG84pIzYTZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlkRvLwACgkQoSvjmEKS
nqG/1Q/+IGD8Cisbd833PoR+rhOfvLvCT5+RRZDYYTX37aBQfcVjzaoTPXUoITZv
XQWfoIuPAPuGBBtjUPtrMZI6/4griyP88nUS2jIxOODWsn6SjqnLvfwVn09XiGV8
BHvVphuDAB7nnJHxnrTuw3jesuXyTtUTi4eypbfp73utROlGoN8051YyXSJ9ejak
Fg2BCApIEVSOKj+IkagAX3BhmvHY/Y//YxtFQU2sl64zYmasTN3MA2WtqpLV8nqB
1vzaCk+4VQ0V/U/xDACLLePgWKLwLNyRJynSe832ulT1YoqJ5IgeZtLbXUDw7PX8
V5NRZcLFmASRv5XK4YP1z/KePbbGOfFkkgZkZw7W7Qvp/Jfjq9hGMjH3mkSW58ts
rOwKX87y5/hhybS4tJOy4Lqbvh96CrD9pV1YSumGwjYXY7yTgmnIbFve9FypTnqx
4Qyvn/+NEixV4huLgXYEgV83+Nm/AKNsglyo94AxQrL6gjNUPELOBDgpsvaxFxg+
04yatPAoeQ+mgc16ScSAoyQ/n4QfsGukw0/iFTIZ3pr3xuw6tcXJ22EbmGHY6Ltb
nlkOtmsQ0iCyQ+f7JXLB4N6/j0cBl0ewk2ta5nmmghtbHAjvG0F/MWL4V8h4j7K3
SBHnqsnn8YlNPbVtDtVzKgUIAbV9tibVjoevZq0rO13j3ovrB08=
=cUkm
-----END PGP SIGNATURE-----

--nextPart1822450.CG84pIzYTZ--
