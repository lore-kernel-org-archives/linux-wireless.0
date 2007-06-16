Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:29751 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756690AbXFPWRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 18:17:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Date: Sat, 16 Jun 2007 15:16:11 -0700
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
References: <20070611085950.GA5540@mail.intel.com> <200706161129.13782.flamingice@sourmilk.net> <1182019869.9058.57.camel@johannes.berg>
In-Reply-To: <1182019869.9058.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4179980.ZIoWvcF0Am";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706161516.16447.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4179980.ZIoWvcF0Am
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 16 June 2007 11:51, Johannes Berg wrote:
> On Sat, 2007-06-16 at 11:29 -0700, Michael Wu wrote:
> > I think that decision was made without much consideration to the
> > implementation details.
>
> I don't think the implementation details are much of a problem. It's
> just a bit of message bouncing which is trivial. Except of course when
> you consider wext, but hey, no need to consider that for this discussion
> since you're proposing ditching wext completely. Not that I don't want
> to ditch it, but people still use it and probably will. Heck, people
> still use 'ifconfig'...
>
I'm not proposing to ditch wext completely. When did I say that?

> > I thought it was a good idea then, but passing
> > messages from userspace to the kernel and then to userspace again is
> > really a waste of time.
>
> It's not happening a lot so it's not a waste of *much* time ;)
>
It's a waste of time when nl80211 needs to be patched every time we want an=
=20
additional command in the userspace MLME.

> > NetworkManager already uses wpa_supplicant to avoid all the
> > nasty details of dealing with wireless configuration, so why not keep
> > using it for everything instead of hiding wpa_supplicant behind nl80211?
>
> I hope that nm would start using nl80211 instead of talking to
> wpa_supplicant and just start wpa_supplicant if necessary. Or maybe some
> startup scripts start the userspace MLME (wpa_supplicant) for the
> interfaces during boot/hotplug.
>
I don't think switching NM to nl80211 is reasonable unless you find someone=
 to=20
port all the legacy drivers to cfg80211 too.=20

> > This is
> > more simple and direct and allows the kernel to expose exactly what the
> > hardware/kernel can do. Userspace won't have to change much and nl80211
> > won't have to support every possible thing a userspace MLME would want.
>
> It's not that the kernel will have to support everything that a
> userspace MLME would want, but rather that the kernel needs to support
> everything the MLME would want, to support fullmac drivers.
>
I don't think the needs of a firmware based MLME are necessarily the same a=
s a=20
userspace MLME. Some commands will certainly be the same, but just because=
=20
the commands are there doesn't mean it's good to make them work if you have=
=20
to fake it. The kernel should show what the hardware/stack can do and nothi=
ng=20
more.

> Another counter: when you have a tool like 'iw' that David wrote, then
> it'll need to look for the userspace MLME every time you invoke it and
> start communicating with it instead of the kernel. That's likely a waste
> of much more time than just bouncing the messages.
>
I think the difference is trivial. Using nl80211 for what is effectively IP=
C=20
seems very incorrect to me.

=2DMichael Wu

--nextPart4179980.ZIoWvcF0Am
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGdGEwT3Oqt9AH4aERArdeAKC9IzUC0WnInF7SJ5LcVCzHyKG9PgCcCLQV
wAcIsddOpIhBr4On1ELB89Q=
=aY3v
-----END PGP SIGNATURE-----

--nextPart4179980.ZIoWvcF0Am--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
