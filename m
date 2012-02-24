Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2BXNjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 08:39:03 -0500
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in
 power-save mode.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4F4791FC.9080707@lri.fr> (sfid-20120224_143533_449788_ED2A82B4)
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
	 <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr>
	 <201202231908.16364.chunkeey@googlemail.com> <4F468AC1.1050100@lri.fr>
	 <4F4791FC.9080707@lri.fr> (sfid-20120224_143533_449788_ED2A82B4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 14:39:01 +0100
Message-ID: <1330090741.3426.16.camel@jlt3.sipsolutions.net> (sfid-20120224_143908_909728_3F8EA632)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 14:34 +0100, Nicolas Cavallari wrote:
> On 23/02/2012 19:51, Nicolas Cavallari wrote:
> > On 23/02/2012 19:08, Christian Lamparter wrote:
> >> On Thursday, February 23, 2012 06:27:59 PM Nicolas Cavallari wrote:
> >>> On 23/02/2012 17:52, Christian Lamparter wrote:
> >>>> On Thursday, February 23, 2012 04:53:34 PM Nicolas Cavallari wrote:
> >>>>> While this seems to fix my problem, there could still be problems remaining
> >>>>> in this code path.  Particularly carl9170_tx_status will do lots of things
> >>>>> like incrementing counters and waking up mac80211 queues...
> >>>> That should be alright. As a rule of thumb, for every call to
> >>>> carl9170_tx_accounting [called by carl9170_op_tx tx handler]
> >>>> we need to call carl9170_tx_status. If the station is still in
> >>>> ps mode, mac80211 will cache the station's frames and sets
> >>>> the TIM bits. 
> >>> Part of the reason i wrote this, is because, while this patch fixes the
> >>> memory accounting problem and prevent the AP from stopping working, the
> >>> powersaving station sometimes cannot communicate with the AP anymore
> >>> (other stations can). The station uses ath9k, and is just really doing a
> >>> background scan. The first traces that i have just indicate that the
> >>> station entered powersave mode, then sends probe requests and probe
> >>> requests directed to the AP, then sends authentication requests to the
> >>> AP (?), but the AP does not respond to any of them...
> >>>
> >> Do you run an 802.11n ap on carl9170?
> > No, it's a 802.11g currently.
> > My current wild guess is that, the responses to those requests are
> > somehow still queued ...
> 
> And i was right...
> 
> /*
>  * Ignore doze->wake transitions that are
>  * indicated by non-data frames, the standard
>  * is unclear here, but for example going to
>  * PS mode and then scanning would cause a
>  * doze->wake transition for the probe request,
>  * and that is clearly undesirable.
>  */
> if (ieee80211_is_data(hdr->frame_control) &&
>     !ieee80211_has_pm(hdr->frame_control))
> 	ap_sta_ps_end(sta);
> 
> As (re)associations requests and Auth frames are not data frames,
> mac80211 still considers that the station is still in powersave mode, so
> it still queues frames, and even queues the responses to the auth
> frames. Except that the station disassociated silently, and is trying to
> re-associate after a short time.
> 
> Shouldn't mac80211 transition the sta to "awake" when receiving
> auth/assoc frames ?

I don't think so, that would make us send frames to the station it no
longer deserves to have. Hostapd should instead delete & re-create the
station entry, I think?

johannes

