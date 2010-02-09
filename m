Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab0BII5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 03:57:39 -0500
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4101002090036g5f672005mda7389da8db1e322@mail.gmail.com>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
	 <1265702244.3783.16.camel@johannes.berg>
	 <8e92b4101002090036g5f672005mda7389da8db1e322@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZXzxPt4J0ksMwkICGLqo"
Date: Tue, 09 Feb 2010 09:57:35 +0100
Message-ID: <1265705855.3783.26.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZXzxPt4J0ksMwkICGLqo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-09 at 14:06 +0530, Vivek Natarajan wrote:
> On Tue, Feb 9, 2010 at 1:27 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Mon, 2010-02-08 at 17:47 +0530, Vivek Natarajan wrote:
> >> +     if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
> >> +             (local->hw.flags & IEEE80211_HW_TX_STATUS) &&
> >> +             local->ps_sdata && !(local->scanning)) {
> >> +             if (info->flags & IEEE80211_TX_STAT_ACK) {
> >> +                     local->ps_sdata->u.mgd.flags |=3D
> >> +                                     IEEE80211_STA_NULLFUNC_ACKED;
> >> +                     ieee80211_queue_work(&local->hw,
> >> +                                      &local->dynamic_ps_enable_work)=
;
> >> +             } else
> >> +                     mod_timer(&local->dynamic_ps_timer, jiffies +
> >> +                                     msecs_to_jiffies(10));
> >> +     }
> >
> > I think this needs to check against injected frames as well

> Any monitor mode injected frame should be dropped by the
> check of ps_sdata which is set only during the station mode.

Yes, but you could have a monitor virtual interface and a station
virtual interface, and start injecting nullfunc packets. That'd be kinda
stupid, but we wouldn't want to act on them.

> > Also, you're still missing documentation on IEEE80211_HW_TX_STATUS.
> I think you missed the v4 with the name changed as
> IEEE80211_HW_REPORTS_TX_ACK_STATUS.
> I will send it once again with modified indentation.

Yeah I only saw v4 when I read the list, and replied to the version in
my inbox.

johannes

--=-ZXzxPt4J0ksMwkICGLqo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcSN8AAoJEODzc/N7+QmaFUgQAJyPxAoH7om2MME8ugF5MOEN
tHJw/McCLsZvoGczzSEtNlTUCRNBN6BVeoiUkMtNq5fBPIx7/hPQyGz9dW4ENx8t
FVgP6BRU2FsyOaqf+5tnjsIt77/nX3cViYGcryH0Spl0SDGBDt0QHfYRLNBv2K5O
QwdnwrSNMPqdPohIltBf2AC783CH6VTNSKxh/TWWAAvhVliVnXPuptieIbFczwPL
BJjSh27LP6Q9WZyrzPO1Gk46QyrManyjN4tWFNC2B6w5xjxiwjG5HQoqbIvxrt5k
ThFrAEp/RK7cm4uklD50qGsB7UHHOLOf86yWMMgJn9nf5AJ4Y/WyN7Y55EAGLsID
igUJlUQ+caAc/vs+4ckVe+lbpBWfgcewe6jVUvZ0zeaCEnQmv56EZSIRVbJ5KLmo
XnXzfE6pAYNU2LW0MxoOUbadx+qN2oe/6migeO0kDW66isLRaV5YkVk/1eIQeUhi
kHn6c0m0db2n61vWBAv7PyguiquH5nC+gXafBRS3UwF0wsPVDOt/au9Fu3/kq4aq
TVBCmwLoSBKkBRscuXTjQU5AkQDqc5D1WWbtDd2S4FaT1UngMf2FYZXinMTcmrf4
0hK9DhvMSslfcproQF+wzy8AaAgT4zQaaKkDFM4yBqdwv1XAXL19iYq0HTsiQO1Q
hEZZ4d8GYZFejtES9sHJ
=sa1K
-----END PGP SIGNATURE-----

--=-ZXzxPt4J0ksMwkICGLqo--

