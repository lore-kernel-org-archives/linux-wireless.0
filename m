Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZAUTPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 14:15:50 -0500
Date: Wed, 21 Jan 2009 14:11:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: poor performance with ath5k; reverting to ath_pci
Message-ID: <20090121191141.GA14710@tuxdriver.com> (sfid-20090121_201555_129077_234A4931)
References: <200901140003.31693.gbburkhardt@verizon.net> <200901151734.46144.gbburkhardt@verizon.net> <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com> <200901202238.08756.gbburkhardt@verizon.net> <20090121151435.GB3643@tuxdriver.com> <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 21, 2009 at 07:22:14PM +0100, Stefanik G=E1bor wrote:
> On Wed, Jan 21, 2009 at 4:14 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Tue, Jan 20, 2009 at 10:38:08PM -0500, Glenn Burkhardt wrote:
> >> On Friday 16 January 2009 10:33:13 Bob Copeland wrote:
> >> > On Thu, Jan 15, 2009 at 5:34 PM, Glenn Burkhardt
> >> >
> >> > <gbburkhardt@verizon.net> wrote:
> >> > > ath5k_pci 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IR=
Q 18
> >> > > ath5k_pci 0000:00:07.0: registered as 'phy0'
> >> > > phy0: Selected rate control algorithm 'pid'
> >> >
> >> > Can you change the rate control algorithm to minstrel and retry?
> >>
> >> I built a 2.6.28.1-9 kernel to get the minstrel code for ath5k.  T=
he
> >> kernel for Suse 11.1 is 2.6.27.7-9.  But that means that more coul=
d have
> >> changed besides the rate control code.
> >>
> >> It looks like minstrel and pid give about the same result, a bit w=
orse that
> >> the ath_pci driver right now.  Performance seems to vary from day =
to day.
> >> I'll experiment some more, and switch transmission channels.  I'm =
not getting
> >> the really poor performance with ath5k right now.
> >>
> >> I haven't looked yet - is there a way to switch to 'pid' rate cont=
rol without
> >> rebuilding the kernel?
> >
> > If you configure your kernel to include multiple rate control
> > algorithms then you can use the 'ieee80211_default_rc_algo' module
> > option for mac80211.  Of course, changing that only works if you
> > rmmod/insmod mac80211.
> >
> > John
>=20
> Judging from this, is it really a good idea to hide pid behind EMBEDD=
ED?

I've been wondering about that myself.  I'm inclined to think no.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
