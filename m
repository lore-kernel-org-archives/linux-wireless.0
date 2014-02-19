Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaBSL2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:28:15 -0500
Message-ID: <1392809288.4733.15.camel@jlt4.sipsolutions.net> (sfid-20140219_122817_677000_DD480A49)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Date: Wed, 19 Feb 2014 12:28:08 +0100
In-Reply-To: <CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com> (sfid-20140219_122748_813993_609B11E6)
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1392807806.4733.14.camel@jlt4.sipsolutions.net>
	 <CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com>
	 (sfid-20140219_122748_813993_609B11E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 12:27 +0100, Janusz Dziedzic wrote:
> On 19 February 2014 12:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:
> >
> >> -#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
> >> -{                                                    \
> >> -     .freq_range.start_freq_khz = MHZ_TO_KHZ(start), \
> >> -     .freq_range.end_freq_khz = MHZ_TO_KHZ(end),     \
> >> -     .freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw), \
> >> -     .power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
> >> -     .power_rule.max_eirp = DBM_TO_MBM(eirp),        \
> >> -     .flags = reg_flags,                             \
> >> +#define REG_RULE_EXT(start, end, bw, gain, eirp, dfs_cac, reg_flags) \
> >> +{                                                                    \
> >> +     .freq_range.start_freq_khz = MHZ_TO_KHZ(start),                 \
> >> +     .freq_range.end_freq_khz = MHZ_TO_KHZ(end),                     \
> >> +     .freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),                 \
> >> +     .power_rule.max_antenna_gain = DBI_TO_MBI(gain),                \
> >> +     .power_rule.max_eirp = DBM_TO_MBM(eirp),                        \
> >> +     .flags = reg_flags,                                             \
> >> +     .dfs_cac_ms = dfs_cac,                                          \
> >>  }
> >>
> >> +#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
> >> +     REG_RULE_EXT(start, end, bw, gain, eirp, 0, reg_flags)
> >
> > I don't see any users of this, is that really useful?
> >
> 
> genregdb.awk using this when internal regdb is used.

Ah ok, thanks.

johannes

