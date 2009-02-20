Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZBTXkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 18:40:36 -0500
Date: Fri, 20 Feb 2009 18:40:32 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: ieee80211_regdom module parameter for cfg80211
Message-ID: <20090220234032.GB23428@bombadil.infradead.org> (sfid-20090221_004041_457516_7AAB6D2B)
References: <499C7DC0.4040608@lwfinger.net> <1234992712.4023.60.camel@johannes.local> <20090218220531.GD4246@tesla> <499C8DD2.7000800@lwfinger.net> <20090218224833.GB28733@bombadil.infradead.org> <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com> <43e72e890902201233w95b4aaew1fa0bbf06196d74f@mail.gmail.com> <69e28c910902201307i398b4a89na4ce0205d66ee921@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910902201307i398b4a89na4ce0205d66ee921@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 10:07:05PM +0100, G=E1bor Stefanik wrote:
> On Fri, Feb 20, 2009 at 9:33 PM, Luis R. Rodriguez <mcgrof@gmail.com>=
 wrote:
> > On Fri, Feb 20, 2009 at 11:45 AM, G=E1bor Stefanik
> > <netrolller.3d@gmail.com> wrote:
> >> On Wed, Feb 18, 2009 at 11:48 PM, Luis R. Rodriguez
> >> <mcgrof@bombadil.infradead.org> wrote:
> >>> On Wed, Feb 18, 2009 at 04:38:10PM -0600, Larry Finger wrote:
> >>>> Luis R. Rodriguez wrote:
> >>>> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
> >>>> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
> >>>> >>> On at least one forum, I have seen the recommendation that a=
 user set their
> >>>> >>> regulatory domain by creating the file /etc/modprobe.d/cfg80=
211 with the
> >>>> >>> contents "ieee80211_regdom=3DUS".
> >>>> >>>
> >>>> >>> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set =
in their .config,
> >>>> >>> but will fail if it is not.
> >>>> >>>
> >>>> >>> Should the module_param statement be moved outside the ifdef
> >>>> >>> CONFIG_WIRELESS_OLD...? Setting the module parameter that wa=
y might not make any
> >>>> >>> sense, but it surely shouldn't kill wireless.
> >>>> >> I actually see no reason to not just /honour/ it by calling c=
rda with
> >>>> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
> >>>> >
> >>>> > The idea was that things we want to get rid of will go in OLD_=
REG. Static regdoms
> >>>> > for US, JP and EU fall into that and so does the module parame=
ter. I believe
> >>>> > it is silly to keep the module parameter around as we already =
have userspace
> >>>> > APIs to let users set this.
> >>>>
> >>>> I guess we leave it the way it is. At least the only people that=
 will get caught
> >>>> are those that upgrade their distro.
> >>>
> >>> Yeah, if they disable OLD_REG -- but I am curious which distribut=
ions are using this
> >>> themselves as well. Would you happen to know ? Or are you mostly =
seeing just users
> >>> doing that themselves?
> >>
> >> Yes, I was talking about users doing this, users who upgrade their
> >> kernel without upgrading their distro. Keeping a modparam provides=
 an
> >> easy way for users to upgrade kernels without a full distro upgrad=
e -
> >> modparams have a much simpler syntax than init scripts. If we keep=
 the
> >> modparam as a way to control CRDA, this is what an user has to do =
to
> >> upgrade:
> >> 1. Compile and install the new kernel. (Mostly straightforward, as
> >> long as the user has a config and knows how to use make.)
> >> 2. Compile and install CRDA. (Straightforward.)
> >> 3. echo options cfg80211 ieee80211_regdom=3D"HU" >>
> >> /etc/modprobe.d/options (Straightforward.)
> >>
> >> Removing the modparam changes step 3 to:
> >> 3. Find the init scripts, and edit them to include "iw reg set HU"=
,
> >> making sure it happens early enough, caring about the syntax, taki=
ng
> >> into account differences between distros, etc. Possibly includes
> >> modifying the initramfs/initrd by hand in some odd distros. (Not
> >> straightforward at all, requires knowledge of the distro's inner
> >> workings, such as the init version used, e.g. sysvinit, bsdinit,
> >> upstart, etc.)
> >
> > It seems reasonable to keep the module parameter in case iw is not
> > installed but if users went through the trouble of installing crda =
are
> > we to not expect users to have iw also by 2.6.30?
> >
> > =A0Luis
> >
>=20
> I am not talking about the case when iw is not installed - even if iw
> is installed, it is much easier to edit the module options file than
> the init scripts.

We should strive away from using module parameters and provided we have
a good userspace API it should be up to userspace to figure that stuff =
out.

Although an ieee80211_regdom module parameter may be convenient its not
productive towards what we want as well -- we shouldn't strive to let y=
our
module parameter be the only place to put your location information fro=
m
userspace. Say you suspend to ram, fly to another country -- you'd want
more of an intelligent usersapce figuring out your location for you and=
 you
don't want it to muck with your module parameters.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
