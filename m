Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:28999 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZCTBAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 21:00:32 -0400
Received: by wf-out-1314.google.com with SMTP id 29so936102wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 18:00:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237224184.5027.600.camel@samson.armitage.org.uk>
References: <1237224184.5027.600.camel@samson.armitage.org.uk>
Date: Thu, 19 Mar 2009 18:00:30 -0700
Message-ID: <43e72e890903191800y7f30a58fheeb1b8f25eb6d7f2@mail.gmail.com> (sfid-20090320_020038_358404_90869F76)
Subject: Re: Oops and other problems in cfg80211
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Quentin Armitage <Quentin@armitage.org.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 10:23 AM, Quentin Armitage
<Quentin@armitage.org.uk> wrote:
> If cfg80211 is compiled with CONFIG_WIRELESS_OLD_REGULATORY defined, if
> insmod is loaded with "insmod cfg80211 ieee80211_regdom=EU" then the
> execution of insmod mac80211, executing insmod ath5k causes an oops.
> This is caused by wiphy_update_regulatory being called when last_request
> == NULL, and the call of reg_is_world_roaming (via reg_process_beacons)
> causes the oops at last_request->initiator != REGDOM_SET_BY_COUNTRY_IE.
>
> If reg_is_world_roaming is modified to check for last_request not being
> NULL, e.g.
> if (last_request && last_request->initiator != REGDOM_SET_BY_COUNTRY_IE
> &&
> then I also get an oops in reg_device_remove where last_request is
> referenced and there is only a subsequent check for it being NULL.
>
> Even if the above two are fixed, it will not associate with the access
> point, and `iwlist wlan0 channels` produces a rather confused list. It
> appears that, despite the comment, in regulatory_init it is necessary to
> call regulatory_hint_core even for the pseudo country EU.

Yes, good catch, the entire code in reg.c assumes this was always
done. We overlooked the fact when "EU" became the only exemption.

> Patch1 below covers the points above, although I am not sure how useful
> the BUG_ON (!last_request) in reg_is_world_roaming is.

Its better to understand the code than sprinkle random BUG_ONs, and in
this particular case you've already found the issue. So lets address
and fix that appropriately.

> Having modified the above, I then found that the regulatory domain was
> not being updated from the Country IE sent by the access point.
>  It
> appears that the code following the comment "so we optimize an early
> check ..." in regulatory_hint_11d is a little over optimized, since if
> the following if statement is true, every path through that block ends
> in "goto out;". Patch 2 below allows the Country IE to be processed
> (note it also needs an extra check around a WARN_ON, and so the
> preceeding comment to that needs considering).

Thanks for reporting this as well, as you noted we didn't check for
the last_request type and just made an assumption. The check should go
on earlier.

Will spin some patches to address this. The right solution really is
to abandon OLD_REG, but that won't happen for stable right now so will
spin some patches to address this for stable.

Thanks,

  Luis
