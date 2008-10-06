Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYJFSeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:34:31 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com> (sfid-20081006_203031_079989_141A8A38)
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
	 <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com>
	 <1223311876.15196.38.camel@johannes.berg>
	 <1223312084.15196.41.camel@johannes.berg>
	 <1ba2fa240810061130w6b1a2282ga80156e7d756c74@mail.gmail.com>
	 (sfid-20081006_203031_079989_141A8A38)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XrzvetUo2Fl3feQFr85i"
Date: Mon, 06 Oct 2008 20:34:00 +0200
Message-Id: <1223318040.3778.18.camel@johannes.berg> (sfid-20081006_203434_220208_24F7AFDD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XrzvetUo2Fl3feQFr85i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 20:30 +0200, Tomas Winkler wrote:

> > Of course, I would very much appreciate you review the actual bug fix i=
n
> > iwl_hcmd_queue_reclaim, which consist of the addition of the line
> >
> > +               bd =3D &txq->bd[index];
>=20
> Okay I found the source of the evil, with your big pointer :)
> The bug caused by this memory optimization juggling we've done and
> very  bad cut and paste coding
> We moved for command buffers from pcI_alloc consitent to kmalloc which
> required pci mapping that that was coded wrongly. Now this kmalloc
> stuff is not good as well since we have this 36 bit memory limitation
> on 64 bit platforms.
> This is the issue I'm trying to address recently I'm not sure what yet
> what allocation schema would be best yet.

That can't be all though; it still crashes right away when I enable 64k
pages on my box.

johannes

--=-XrzvetUo2Fl3feQFr85i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6loUAAoJEKVg1VMiehFYuCcQAL17FsPeUGtOj3NF+SK7ojYM
J+5X4mBxWktBHAiHqnGmO0EFefAHDmshdBgmQ9OSlZS6oTH9IM02oo5vjdYljwNU
rXisxO3NzPe0hbQfulGR7r8SxTPYW/hC7rumdDOsLKxTvjls8v3CdkrY6mx7uvsi
wWCdUqygVCMEDcfmnNqCuS1u9hESp+j+iRTNx3fDh62Uhzc6mmkg8LWobV/69fht
r6xl5C1zTt+uOcX9GevOerlE/V29VjxCkumV4pYlrlY/XgQ5k68ulTYAFNmQd/Zt
S8qujnoqhCXwwl4ehdNJ87ITkTx1Y0t/kjvzhP0MfydgAnEEVujgyOZ0iscNQQkj
0Vu039x1MI5XV3NXCLWUFIENmSq9AiduE1lf1KychreEHG0DBSuIPxZNqxV8XG1P
QkLJT0hyassdDaEbyVZQjZb0fUHKwFgAZPMbh6nwafP3HF8qD11pF6NqKTwzt81S
lX/lxInfrSraTe/VlC4iF+oa6hli4cIIwAdOkB5FykwsFspWNa1DLHZF7APxKZy9
La9WYnB+IAL8etW1hisp4BdyjpRSLaVCUYxwU8Ejg8BrPr50yWImeS18LABtk4Du
iJ2HWupaiCapxoJC4srwbA1qZeSlcaG3CEgoYmfCW/p3Up+avCVnaGHm4Ssv8nMi
0IST+Pqovj2ZJlYLmtfG
=ER/R
-----END PGP SIGNATURE-----

--=-XrzvetUo2Fl3feQFr85i--

