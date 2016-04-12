Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58996 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbcDLT6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 15:58:30 -0400
Message-ID: <1460491100.6369.27.camel@sipsolutions.net> (sfid-20160412_215835_011421_C588CEC4)
Subject: Re: [PATCH] cfg80211: remove enum ieee80211_band
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Apr 2016 21:58:20 +0200
In-Reply-To: <570D5243.6070204@broadcom.com> (sfid-20160412_215400_483812_0967FBF6)
References: <1460469487-21008-1-git-send-email-johannes@sipsolutions.net>
	 <570D5243.6070204@broadcom.com> (sfid-20160412_215400_483812_0967FBF6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-12 at 21:53 +0200, Arend van Spriel wrote:
> 
> On 12-04-16 15:58, Johannes Berg wrote:
> > 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This enum is already perfectly aliased to enum nl80211_band, and
> > the only reason for it is that we get IEEE80211_NUM_BANDS out of
> > it. There's no really good reason to not declare the number of
> > bands in nl80211 though, so do that and remove the cfg80211 one.
> So what if a band is added. That would change the value of
> IEEE80211_NUM_BANDS in nl80211. Is it not ABI?

Well, it can't be ABI really since the value is never used. Arguably it
becomes API, but clearly we have the same with NL80211_CMD_MAX and many
others like it, so I see no point in treating the bands here specially.
I even added a comment :)

johannes
