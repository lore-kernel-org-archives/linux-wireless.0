Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaAVIyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 03:54:35 -0500
Message-ID: <1390380872.4334.6.camel@jlt4.sipsolutions.net> (sfid-20140122_095438_711979_873B1596)
Subject: Re: [PATCH 2/3] cfg80211: implement multi-vif interface combination
 validation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 09:54:32 +0100
In-Reply-To: <CA+BoTQ=DYBrE=XBn6R4Y2=ag605bLxKq2AfMTOnWZKyTprg04g@mail.gmail.com> (sfid-20140122_071153_051503_667ABF64)
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-3-git-send-email-michal.kazior@tieto.com>
	 <1390318897.6199.49.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=DYBrE=XBn6R4Y2=ag605bLxKq2AfMTOnWZKyTprg04g@mail.gmail.com>
	 (sfid-20140122_071153_051503_667ABF64)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 07:11 +0100, Michal Kazior wrote:

> >> +             if (params[i].wdev && params[i].wdev->wiphy != &rdev->wiphy)
> >> +                     return -EINVAL;
> >
> > How could you ever have a param without a wdev? That seems like a bug as
> > well?
> 
> cfg80211_can_add_interface() calls with wdev == NULL.

Oh, right, sorry.

> >> +             err = cfg80211_is_radar_required(params[i].iftype,
> >> +                                              params[i].chan,
> >> +                                              params[i].chanmode,
> >> +                                              params[i].radar_detect_width);
> >> +             if (err < 0)
> >> +                     return err;
> >> +             else if (err && !params[i].radar_detect_width)
> >> +                     return -EINVAL;
> >
> > That's a bit confusing - why do you pass the radar_detect_width in, and
> > then check it again? Couldn't you just do all the checks in the
> > function, perhaps renamed a bit?
> 
> I can move this into the helper function. Any suggestions for the
> rename? cfg80211_validate_radar_params() and it would return a 0 or an
> errno?

Sounds good to me.

johannes

