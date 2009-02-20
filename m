Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:51239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZBTTpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:45:19 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2067617fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 11:45:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090218224833.GB28733@bombadil.infradead.org>
References: <499C7DC0.4040608@lwfinger.net>
	 <1234992712.4023.60.camel@johannes.local>
	 <20090218220531.GD4246@tesla> <499C8DD2.7000800@lwfinger.net>
	 <20090218224833.GB28733@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 20:45:17 +0100
Message-ID: <69e28c910902201145h6d9fa472rc81da56ffce16dc0@mail.gmail.com> (sfid-20090220_204524_317727_A338302D)
Subject: Re: ieee80211_regdom module parameter for cfg80211
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 11:48 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Wed, Feb 18, 2009 at 04:38:10PM -0600, Larry Finger wrote:
>> Luis R. Rodriguez wrote:
>> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
>> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
>> >>> On at least one forum, I have seen the recommendation that a use=
r set their
>> >>> regulatory domain by creating the file /etc/modprobe.d/cfg80211 =
with the
>> >>> contents "ieee80211_regdom=3DUS".
>> >>>
>> >>> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in t=
heir .config,
>> >>> but will fail if it is not.
>> >>>
>> >>> Should the module_param statement be moved outside the ifdef
>> >>> CONFIG_WIRELESS_OLD...? Setting the module parameter that way mi=
ght not make any
>> >>> sense, but it surely shouldn't kill wireless.
>> >> I actually see no reason to not just /honour/ it by calling crda =
with
>> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
>> >
>> > The idea was that things we want to get rid of will go in OLD_REG.=
 Static regdoms
>> > for US, JP and EU fall into that and so does the module parameter.=
 I believe
>> > it is silly to keep the module parameter around as we already have=
 userspace
>> > APIs to let users set this.
>>
>> I guess we leave it the way it is. At least the only people that wil=
l get caught
>> are those that upgrade their distro.
>
> Yeah, if they disable OLD_REG -- but I am curious which distributions=
 are using this
> themselves as well. Would you happen to know ? Or are you mostly seei=
ng just users
> doing that themselves?

Yes, I was talking about users doing this, users who upgrade their
kernel without upgrading their distro. Keeping a modparam provides an
easy way for users to upgrade kernels without a full distro upgrade -
modparams have a much simpler syntax than init scripts. If we keep the
modparam as a way to control CRDA, this is what an user has to do to
upgrade:
1. Compile and install the new kernel. (Mostly straightforward, as
long as the user has a config and knows how to use make.)
2. Compile and install CRDA. (Straightforward.)
3. echo options cfg80211 ieee80211_regdom=3D"HU" >>
/etc/modprobe.d/options (Straightforward.)

Removing the modparam changes step 3 to:
3. Find the init scripts, and edit them to include "iw reg set HU",
making sure it happens early enough, caring about the syntax, taking
into account differences between distros, etc. Possibly includes
modifying the initramfs/initrd by hand in some odd distros. (Not
straightforward at all, requires knowledge of the distro's inner
workings, such as the init version used, e.g. sysvinit, bsdinit,
upstart, etc.)

>
>> A clean install should redo the /etc/...
>> tree and do away with such modifications.
>
> Sure, I'd like to see us avoid upgrade issues but I'd also like to ph=
ase out
> module parameters for which we have created equivalent userspace APIs=
=2E I suspect
> this is a reasonable case.
>
> =A0Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
