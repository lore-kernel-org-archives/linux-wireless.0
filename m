Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481AbYEEI2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 04:28:25 -0400
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1209974740.2827.124.camel@debian.sh.intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 (sfid-20080505_044417_821018_3824BECA)  <1209971503.3655.0.camel@johannes.berg>
	 <1209974740.2827.124.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y6FipiVTSpJ9rt3oxjPz"
Date: Mon, 05 May 2008 10:28:16 +0200
Message-Id: <1209976096.3655.19.camel@johannes.berg> (sfid-20080505_102801_992938_6D2D66DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y6FipiVTSpJ9rt3oxjPz
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 16:05 +0800, Zhu Yi wrote:
> On Mon, 2008-05-05 at 09:11 +0200, Johannes Berg wrote:
> > Those conditions will never be true.=20
>=20
> Why? I see mac80211 never passes IEEE80211_IF_TYPE_MNTR to
> add_interface(). But this patch passes the flag in configure_filter().
> Please take a look.

That's not a flag. Yes, I did miss that call
	=EF=BB=BFiwl4965_set_mode(priv, IEEE80211_IF_TYPE_MNTR)
but I still don't think you should treat monitors as a "mode" but rather
as a reason to pass more frames up.

> > In the case of the latter, that is
> > a good thing, in the case of the former that isn't.
>=20
> Could you elaborate?

You're precluding doing any kind of useful monitor operation when the
card is actually up&running, which is quite useful for debugging.

By the second condition, you're short-cutting the RX path so that when a
monitor is enabled any other type of interface won't operation properly,
as far as I can tell.

johannes

--=-Y6FipiVTSpJ9rt3oxjPz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB7FH6Vg1VMiehFYAQIr4BAAtGA2NzQGZRMUUSfDoJTyJX4ntNT2aRBM
lo59SY8VMDBsY7lB+ewd9hJqHGUm//mxCmzrMmY+Y+mGoUr7GysQLjRQsXnmSvhn
Bp1ZD+ITMkNdmKh1o6jPzaGauthuKcHtoFNMZGKMn/ZBDVFZsoHFDqmlfWjZQIDN
/WDXXzZsEjnNGpZ49xnHVSqaBIbxG00wOtlsKlmztd5bw9GFK1kWjJCeVknDfJwt
ItBNarCXDssPwujPvqydDD4s5IHcTT7LUwqY28teXOFZyrx7HL//0FfPt9DAg8FA
pXZuOd2lqe1Wa9TDzaGPjYhQoLjdRaBiPpYVOhhmw+NzwUY5mPn29zAi3txEiGC4
tNvig2Z5r0PT9ob322LHT0EvY/i3LRTeGG9KoFt4HLHKxSGE27rl6Ca7tj1KBkUd
KkvOYxGAdadTSQJF1hOoku9T2RjNkznTX/iL21Xk4bRnWlxbOXhoQ1vZMUrhSthl
e94W16YjB3Dqzkjh1CC4arofAmKZYqFxajemiStd5AdHYHWORVxC72oLBNGuQsSV
gcU5Fota2P0v+GZUEQbH0cR/o4sQagkIAa0ddQ0crPkc5wKO8fm1NtmApiTQOKs2
K7krHUOIeg/4MrH81B78X78cBgrGTDRgEmfSjy7UHBvP1CgSuhl2d0FaA5lDFknj
vTRWV+F8LzA=
=vcXA
-----END PGP SIGNATURE-----

--=-Y6FipiVTSpJ9rt3oxjPz--

