Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaC1NWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 09:22:51 -0400
Message-ID: <1396012968.4175.28.camel@jlt4.sipsolutions.net> (sfid-20140328_142254_808911_D44F24BE)
Subject: Re: [PATCH v2 01/13] cfg80211: allow drivers to iterate over
 matching combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Mar 2014 14:22:48 +0100
In-Reply-To: <CA+BoTQnpijm3JxXNaCzSf3bDx6OiPDAhseTj7=0Urv4jWav=Wg@mail.gmail.com> (sfid-20140328_142132_253425_72CD8111)
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	 <1395409651-26120-2-git-send-email-michal.kazior@tieto.com>
	 <1396011945.4175.23.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnpijm3JxXNaCzSf3bDx6OiPDAhseTj7=0Urv4jWav=Wg@mail.gmail.com>
	 (sfid-20140328_142132_253425_72CD8111)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-28 at 14:21 +0100, Michal Kazior wrote:

> >> +int cfg80211_iter_combinations(struct wiphy *wiphy,
> >> +                            const int num_different_channels,
> >> +                            const u8 radar_detect,
> >> +                            const int iftype_num[NUM_NL80211_IFTYPES],
> >> +                            void (*iter)(const struct ieee80211_iface_combination *c,
> >> +                                         void *data),
> >> +                            void *data);
> >
> > Maybe *iter should have a non-void return value and allow aborting the
> > loop somehow?
> 
> I don't see much of use for that. You can still use *data for that.

No, I meant to abort the iteration loop, say when the function returns
true (or false, whichever way you want to look at it). That way you can
stop iteration at the first combination that's sufficient.

johannes

