Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57372 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbZDONPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 09:15:50 -0400
Date: Wed, 15 Apr 2009 09:02:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: alan-jenkins@tuffmail.co.uk
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Subject: Re: net/wireless/reg.c:1196: =?utf-8?Q?war?=
	=?utf-8?Q?ning=3A_=E2=80=98channel=5Fafter?=
	=?utf-8?B?4oCZ?= may be used uninitialised in this function
Message-ID: <20090415130232.GA21411@tuxdriver.com> (sfid-20090415_151830_398681_8C9F157C)
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com> <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 11:58:39AM +0100, Alan Jenkins wrote:
> [Corrected Luis address]
>=20
> On 4/15/09, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
> > On 4/10/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> >> Thanks pavel, please try this patch:
> >>
> >> From 94505af850bd0961a86e2786238ac0bbe0c44615 Mon Sep 17 00:00:00 =
2001
> >> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> Date: Fri, 10 Apr 2009 11:07:43 -0700
> >> Subject: [PATCH] cfg80211: fix bug while trying to process obeacon=
 hints
> >> on
> >> init
> >>
> >> During initialization we would not have received any beacons
> >> so skip processing reg beacon hints, also adds a check to
> >> reg_is_world_roaming() for last_request before accessing its
> >> fields.
> >
> > Hi again
> >
> > I'm building wireless-testing to test the rfkill-rewrite patches on
> > top of.  I need to apply the patch referenced above as well.
> >
> > When I applied the above patch, I noticed this unrelated warning
> >
> > net/wireless/reg.c: In function =E2=80=98wiphy_update_regulatory=E2=
=80=99:
> > net/wireless/reg.c:1196: warning: =E2=80=98channel_after=E2=80=99 m=
ay be used
> > uninitialised in this function
> > net/wireless/reg.c:1196: note: =E2=80=98channel_after=E2=80=99 was =
declared here
> > net/wireless/reg.c:1196: warning: =E2=80=98channel_before=E2=80=99 =
may be used
> > uninitialised in this function
> > net/wireless/reg.c:1196: note: =E2=80=98channel_before=E2=80=99 was=
 declared here
> >
> > Looking at the code, I think it does need fixing.  There's even a
> > comment which says "this finds them (or not)" - and if they're not
> > found, channel_before / channel_after will be unset.

I reverted the (HT40-related) patch series that last touched that line.
Hopefully that resolves that warning.

> Um, also the new "ath" module taints the kernel
>=20
> ath: module 'unspecified' taints kernel.
>=20
> and I get a new BUG in freq_reg_info_regd.  I'll send the full trace
> as soon as someone reassures it is welcome and wireless-testing is
> really intended for testing at the current time :-).

Someone probably wants to see it. :-)

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
