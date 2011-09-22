Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42483 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963Ab1IVGlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:41:24 -0400
Received: by mail-gy0-f171.google.com with SMTP id 3so2280722gyh.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 23:41:23 -0700 (PDT)
Message-ID: <4E7AD88C.4020806@ti.com> (sfid-20110922_084128_242796_868C8D56)
Date: Thu, 22 Sep 2011 09:41:16 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <coelho@ti.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>  <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>  <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>  <4E7A109C.2010701@ti.com> <1316623133.3940.55.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316623133.3940.55.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/09/2011 19:38, Johannes Berg wrote:

>> This could be a little bit problematic, since we need the
>> rdev->event_work, for the queue_work(), and wdev->event_list to save a
>> copy of the BSS, or just the mac which will be used to fetch the BSS
>> before the transmission (still not sure about it ..), and it seems like
>> these two can be obtained form sdata->dev, so it's look like that we
>> need this function and it should be in ieee80211_scan_rx.
>
> It is not an issue to send a genl message with GFP_ATOMIC.
>


The GFP_ATOMIC is for the event info allocation, and not for the genl 
message, it have to be "GFP_ATOMIC" otherwise we will get kernel warnings.


Victor.
