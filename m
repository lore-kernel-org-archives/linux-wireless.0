Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761414AbZBRWps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 17:45:48 -0500
Date: Wed, 18 Feb 2009 17:45:44 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: ieee80211_regdom module parameter for cfg80211
Message-ID: <20090218224544.GA28733@bombadil.infradead.org> (sfid-20090218_234554_172965_554711AB)
References: <499C7DC0.4040608@lwfinger.net> <1234992712.4023.60.camel@johannes.local> <20090218220531.GD4246@tesla> <69e28c910902181434h37a1de57ob86df10d44271fe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910902181434h37a1de57ob86df10d44271fe7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 11:34:58PM +0100, G=E1bor Stefanik wrote:
> On Wed, Feb 18, 2009 at 11:05 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
> >> > On at least one forum, I have seen the recommendation that a use=
r set their
> >> > regulatory domain by creating the file /etc/modprobe.d/cfg80211 =
with the
> >> > contents "ieee80211_regdom=3DUS".
> >> >
> >> > That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in t=
heir .config,
> >> > but will fail if it is not.
> >> >
> >> > Should the module_param statement be moved outside the ifdef
> >> > CONFIG_WIRELESS_OLD...? Setting the module parameter that way mi=
ght not make any
> >> > sense, but it surely shouldn't kill wireless.
> >>
> >> I actually see no reason to not just /honour/ it by calling crda w=
ith
> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
> >
> > The idea was that things we want to get rid of will go in OLD_REG. =
Static regdoms
> > for US, JP and EU fall into that and so does the module parameter. =
I believe
> > it is silly to keep the module parameter around as we already have =
userspace
> > APIs to let users set this.
>=20
> Keeping the module parameter as a way to set the initial regdomain is
> helpful for users who upgrade the kernel of an older distro.

This makes sense, but what distributions are using this module paramete=
r?
As far as I can tell its only users using it.

And if there are distributions using it -- can we not expect them to st=
op
using it by they disable OLD_REG?

> Adding a
> line to /etc/modprobe.d/options would be a much easier way of setting
> the right regdomain right during bootup than having to edit the init
> scripts

Using init scripts is just one way of doing this, its not the only way.
Userspace can use user-configuration settings through wpa_supplicant,
hostapd, GPS devices can also provide hints, say through the usage of
GeoClue. That's really a lot neater than a module parameter or an init
script.

> and it is also something that CRDA's "make install" could do
> automagically (like "make install regdom=3DHU").

I'd rather not make that a practice provided we want to phase out OLD_R=
EG
and we want userspace to use nl80211 for this.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
