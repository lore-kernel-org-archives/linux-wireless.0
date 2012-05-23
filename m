Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52849 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab2EWIv4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 04:51:56 -0400
Received: by lagz14 with SMTP id z14so7189876lag.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 01:51:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK80WHZW8OLs8N9vPhLx8+yVUhOnFU8EGyHQX=Es12gzZ32rNg@mail.gmail.com>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	<1337712022.4470.0.camel@jlt3.sipsolutions.net>
	<CAK80WHZW8OLs8N9vPhLx8+yVUhOnFU8EGyHQX=Es12gzZ32rNg@mail.gmail.com>
Date: Wed, 23 May 2012 11:51:53 +0300
Message-ID: <CAK80WHbLfOYgvNqoyZroGC6zvWs8UYNwRP_TzLmzDjVSqJK8XA@mail.gmail.com> (sfid-20120523_105202_044009_F1BFBEFE)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 23, 2012 at 9:58 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
> On Tue, May 22, 2012 at 9:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2012-05-22 at 09:45 +0300, Victor Goldenshtein wrote:
>>
>>> @@ -388,7 +389,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>>>       if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
>>>           (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
>>>               sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
>>> -             sinfo->signal = (s8)sta->last_signal;
>>> +             if (local->ops->get_rssi)
>>> +                     drv_get_rssi(local, sdata, &sinfo->signal);
>>> +             else
>>> +                     sinfo->signal = (s8)sta->last_signal;
>>>               sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
>>>       }
>>
>> So .. you're filling a per-station value with a generic per-interface
>> callback? What were you thinking? ;-)
>>
>
> This is this is for managed only.
> I can rename the drv_get_rssi() to drv_get_sta_rssi() and to call it
> only for NL80211_IFTYPE_STATION, I think it would clarify things?
>

Alternatively we could leave it as general callback "drv_get_rssi()",
add the peer address and let the driver decide if it supports
retrieval of the rssi for the given peer.  Thus, allowing us to do
something like:

if (!local->ops->get_rssi) || (drv_get_rssi(local, sdata,
sta->sta.addr, &sinfo->signal))
        sinfo->signal = (s8)sta->last_signal;

-- 
Victor.
