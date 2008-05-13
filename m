Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbYEPPym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:54:42 -0400
Subject: Re: [PATCH stable] libertas: Extend CMD_MESH_CONFIG to get and set
	persistent mesh default params.
From: Dan Williams <dcbw@redhat.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Cavagnolo <brian@cozybit.com>, devel@laptop.org,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>,
	Javier Cardona <javier@cozybit.com>,
	Ricardo Carrano <carrano@ricardocarrano.com>
In-Reply-To: <69e28c910805160851v7be6ccd0qc5f8538748941e80@mail.gmail.com>
References: <482c8eb8.0b97600a.08e2.ffff8ee3@mx.google.com>
	 <1210946949.3008.16.camel@pmac.infradead.org>
	 <1210949448.6381.13.camel@johannes.berg>
	 <69e28c910805160851v7be6ccd0qc5f8538748941e80@mail.gmail.com>
Content-Type: text/plain; charset=utf8
Date: Tue, 13 May 2008 11:54:38 -0400
Message-Id: <1210694078.24737.12.camel@localhost.localdomain> (sfid-20080516_175446_097541_22A9D5E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-16 at 17:51 +0200, Stefanik G=C3=A1bor wrote:
> On Fri, May 16, 2008 at 4:50 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2008-05-16 at 15:09 +0100, David Woodhouse wrote:
> >> On Thu, 2008-05-15 at 11:01 -0700, Brian Cavagnolo wrote:
> >> > This patch is based on a patch from Shailendra Govardhan.  It in=
troduces
> >> > several new iwprivs: {get,set}_bootflag {get,set}_boottime {get,=
set}_def_chan
> >> > {get,set}_def_protid {get,set}_def_metid {get,set}_def_meshcap
> >> > {get,set}_def_meshid.  These commands are only supported on Marv=
ell hardware
> >> > that implements persistent defaults, such as the OLPC Active Ant=
enna.
> >> > Accordingly, this patch may not be suitable for upstream merging=
=2E
> >
> >> But this is the _one_ thing which might actually be OK to do with =
a
> >> private ioctl, since it's very hardware-specific. Unlike like all =
the
> >> mesh-mangling stuff where we really ought to be compatible with o1=
1s.
> >>
> >> So maybe, just maybe, we _can_ do this with iwpriv and push that
> >> upstream.
> >
> > Maybe we do, after all, need an iwpriv equivalent in cfg80211/nl802=
11 so
> > that we can kill wext at some point.
> >
> > Or maybe this should be in sysfs or so?
> >
> > johannes
> >
>=20
> Or maybe in configfs? That's a better place for configuration options=
=2E
> (BTW rt2x00 uses debugfs as an iwpriv replacement, so that's another
> possibility.)

I keep proposing debugfs too, but in some cases the commands aren't jus=
t
for poking around with stuff.  configfs is probably a better answer to
tweakables that aren't just ricer-geekporn.

Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
