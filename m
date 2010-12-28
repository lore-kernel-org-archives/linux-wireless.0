Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0L1JvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 04:51:07 -0500
Subject: Re: [PATCH RFC] mac80211: Extend channel to frequency mapping for
 802.11j
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Dave Kilroy <kilroyd@googlemail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <201012281843.57453.br1@einfach.org>
References: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
	 <AANLkTi=R58EGLrsT5sTk7JTqWvaeJ5caytHMt3VCSOki@mail.gmail.com>
	 <201012281843.57453.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:51:01 +0100
Message-ID: <1293529861.3526.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 18:43 +0900, Bruno Randolf wrote:

> > You don't have to use them, but there are a few channel/frequency
> > conversion routines in include/ieee80211.h which could be reused in
> > these functions.
> 
> Thanks for that info, I didn't know about those functions. I just checked 
> them and it seems most of them are not used, AFAICT:
> 
> ieee80211_fhss_chan_to_freq - not used
> ieee80211_freq_to_fhss_chan - not used
> ieee80211_hr_chan_to_freq - not used
> ieee80211_freq_to_hr_chan - not used
> ieee80211_erp_chan_to_freq - not used
> ieee80211_freq_to_erp_chan - not used
> ieee80211_ofdm_chan_to_freq - not used
> ieee80211_freq_to_ofdm_chan - not used

Cute -- we should probably just remove these.

> The only two which are used are for 2GHz channels:
> 
> ieee80211_dsss_chan_to_freq - atmel, airo, wl3501_cs, orinoco, rndis_wlan
> ieee80211_freq_to_dsss_chan - atmel, airo, orinoco, zd1201
> 
> Anyhow i guess it would make sense to have a common channel to frequency 
> mapping function for mac80211 and other wireless drivers? The problem is now 
> we have to use enum ieee80211_band which is defined cfg80211.h...

Well, you're a bit wrong -- the function you're modifying is part of
cfg80211. Therefore, including cfg80211.h makes perfect sense, it's also
defined in there (therefore, your patch subject should begin with
"cfg80211:" instead of "mac80211:").

However, of those drivers you list only orinoco and rndis_wlan already
use cfg80211, so for the others using it would introduce an almost
"fake" dependency. In any case, it seems like all that should be
separate patches.

johannes

