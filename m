Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:47743 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694Ab2EWHEM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 03:04:12 -0400
Received: by lahi5 with SMTP id i5so5078614lah.28
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 00:04:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337712022.4470.0.camel@jlt3.sipsolutions.net>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
	<1337712022.4470.0.camel@jlt3.sipsolutions.net>
Date: Wed, 23 May 2012 09:58:35 +0300
Message-ID: <CAK80WHZW8OLs8N9vPhLx8+yVUhOnFU8EGyHQX=Es12gzZ32rNg@mail.gmail.com> (sfid-20120523_090415_707058_99C7F06C)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 22, 2012 at 9:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-05-22 at 09:45 +0300, Victor Goldenshtein wrote:
>
>> @@ -388,7 +389,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>>       if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
>>           (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
>>               sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
>> -             sinfo->signal = (s8)sta->last_signal;
>> +             if (local->ops->get_rssi)
>> +                     drv_get_rssi(local, sdata, &sinfo->signal);
>> +             else
>> +                     sinfo->signal = (s8)sta->last_signal;
>>               sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
>>       }
>
> So .. you're filling a per-station value with a generic per-interface
> callback? What were you thinking? ;-)
>

This is this is for managed only.
I can rename the drv_get_rssi() to drv_get_sta_rssi() and to call it
only for NL80211_IFTYPE_STATION, I think it would clarify things?


-- 
Victor.
