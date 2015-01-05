Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48903 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbbAEOUn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 09:20:43 -0500
From: Avinash Patil <patila@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Mon, 5 Jan 2015 06:20:38 -0800
Subject: RE: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A6A@SC-VEXCH2.marvell.com> (sfid-20150105_152052_300671_2B3FB3EF)
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0),<1420462674.9459.9.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>
	 (sfid-20150105_143403_923577_F829B8B6),<1420465645.9459.13.camel@sipsolutions.net>
In-Reply-To: <1420465645.9459.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] On Behalf Of Johannes Berg [johannes@sipsolutions.net]
Sent: Monday, January 05, 2015 7:17 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Amitkumar Karwar; Cathy Luo
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when offchanel CAC supported

On Mon, 2015-01-05 at 05:28 -0800, Avinash Patil wrote:

> > -     if (netif_carrier_ok(dev))
> > +     if (wiphy_ext_feature_isset(&rdev->wiphy,
> > +                                 NL80211_EXT_FEATURE_OFFCHAN_CAC) &&
> > +         netif_carrier_ok(dev))
> >               return -EBUSY;
>
> >Wait - doesn't that have to be !feature_isset()?
>
> >johannes
>
> If Offchannel CAC is supported (driver has set this bit in wiphy's
> extended features) & carrier is ON, return EBUSY as offchannel CAC may
> be ongoing, isnt it?

>Well, my thinking is this - a new feature flag should allow something
>new.

>Therefore, the patch should essentially be this:

>+ if (!new_feature)
>if (do_old_check)

>Now wrapping that into a single if gives

>- if (do_old_check)
>+ if (!new_feature && do_old_check)

>so the patch looks wrong to me.

I think here we want to  do_old_check only when new_feature is supported; because old check is causing issue for device where new feature is not supported.

Earlier it was:
- if (do_old_check)
Now it is:
+if (new_feature && do_old_check)

I think check is still correct. As you suggested we can nest it...

Please correct me if I am wrong.

-Avinash.