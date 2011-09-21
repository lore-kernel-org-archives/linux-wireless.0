Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:59778 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab1IUQ2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 12:28:21 -0400
Received: by gwm11 with SMTP id 11so631187gwm.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 09:28:19 -0700 (PDT)
Message-ID: <4E7A109C.2010701@ti.com> (sfid-20110921_182824_699226_4BF4D371)
Date: Wed, 21 Sep 2011 19:28:12 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>, Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>  <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>  <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>
In-Reply-To: <1316619903.2157.546.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21/09/2011 18:45, Luciano Coelho wrote:
> On Wed, 2011-09-21 at 18:31 +0300, Jouni Malinen wrote:
>> On Thu, Sep 08, 2011 at 09:31:01AM +0300, Victor Goldenshtein wrote:
>> That brings up a question: Do we need to have this new function or would it
>> be feasible for cfg80211 to generate the intermediate reports
>> automatically based on cfg80211_inform_bss{,_frame}() calls during the
>> scan?
>
> Very good point! Thinking of it, there is not need to add this new
> function and have the drivers call it.  cfg80211 can find out when to
> send the results by itself, whenever someone calls
> cfg80211_inform_bss_frame(), by checking whether intermediate results
> are enabled or not.
>
> This will simplify the code. :) Thanks for your comments!
>

This could be a little bit problematic, since we need the 
rdev->event_work, for the queue_work(), and wdev->event_list to save a 
copy of the BSS, or just the mac which will be used to fetch the BSS 
before the transmission (still not sure about it ..), and it seems like 
these two can be obtained form sdata->dev, so it's look like that we 
need this function and it should be in ieee80211_scan_rx.


Thanks,
Victor.
