Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34878 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1IVGtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:49:42 -0400
Received: by mail-bw0-f50.google.com with SMTP id zt19so2891544bkb.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 23:49:41 -0700 (PDT)
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Luciano Coelho <coelho@ti.com>
To: victorg@ti.com
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4E7AD88C.4020806@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
	 <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>
	 <4E7A109C.2010701@ti.com> <1316623133.3940.55.camel@jlt3.sipsolutions.net>
	 <4E7AD88C.4020806@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 09:49:37 +0300
Message-ID: <1316674177.2157.563.camel@cumari> (sfid-20110922_084951_571725_4C5CB47D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 09:41 +0300, Victor Goldenshtein wrote: 
> On 21/09/2011 19:38, Johannes Berg wrote:
> 
> >> This could be a little bit problematic, since we need the
> >> rdev->event_work, for the queue_work(), and wdev->event_list to save a
> >> copy of the BSS, or just the mac which will be used to fetch the BSS
> >> before the transmission (still not sure about it ..), and it seems like
> >> these two can be obtained form sdata->dev, so it's look like that we
> >> need this function and it should be in ieee80211_scan_rx.
> >
> > It is not an issue to send a genl message with GFP_ATOMIC.
> >
> 
> 
> The GFP_ATOMIC is for the event info allocation, and not for the genl 
> message, it have to be "GFP_ATOMIC" otherwise we will get kernel warnings.

I guess what Johannes meant is that you can send the genl message in
atomic context, so you don't need to save stuff and use the event work.
You can just send it immediately when cfg80211_inform_bss() and
cfg80211_inform_bss_frame() are called.

I'm not really sure you can send genl messages while atomic, I think I
had problems with that earlier, but you can try. ;)

-- 
Cheers,
Luca.

