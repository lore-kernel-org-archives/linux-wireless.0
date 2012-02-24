Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45937 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2BXOHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 09:07:24 -0500
Received: by bkcjm19 with SMTP id jm19so2011654bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 06:07:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save mode.
Date: Fri, 24 Feb 2012 15:07:11 +0100
Cc: linux-wireless@vger.kernel.org
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <4F468AC1.1050100@lri.fr> <4F4791FC.9080707@lri.fr>
In-Reply-To: <4F4791FC.9080707@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201202241507.11251.chunkeey@googlemail.com> (sfid-20120224_150730_316695_951683FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, February 24, 2012 02:34:52 PM Nicolas Cavallari wrote:
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

That's really odd... Doesn't your ath9k client say why it deauthed from
the ap in the first place? Furthermore, [I think] there's no such thing
as a "silent disassociation", I bet we will find the missing deauth
frames stuck in a queue as well...

Regards,
	Chr
