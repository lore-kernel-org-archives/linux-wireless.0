Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59579 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1K2POu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 10:14:50 -0500
Received: by eeuu47 with SMTP id u47so1121915eeu.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 07:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322555084.4110.2.camel@jlt3.sipsolutions.net>
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	<1322555084.4110.2.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 10:14:48 -0500
Message-ID: <CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com> (sfid-20111129_161501_542780_FD605266)
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  Thanks for your comments!

2011/11/29 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2011-11-28 at 21:27 -0500, Nikolay Martynov wrote:
>> Currently code allows three (HT_AGG_MAX_RETRIES) unanswered addba
>> requests. When this limit is reached aggregation is turned off for
>> given TID permanently. This doesn't seem right: three requests is
>> not that much, some 'blackout' can happen, but effect of it affects
>> whole connection indefinitely.
>>   This patch adds a period of time (1 minute) after which counter of
>> sent addba requests is reset so addba requests can be sent again.
>>   The traffic impact should be negligible, but connection will be more
>> stable.
>
> Conceptually, this seems OK to me, although on broken APs it might mean
> connection stalls every minute, not sure how desirable that is?

  Do APs broken is such way exist? I.e. APs which declare aggregation
support but do not respond to addba.
  On the other hand looking at the code I've got an impression that
connection doesn't stall while waiting for addba resp, i.e. packets
still go though non-agg path. Did I miss something in this regards?

>
>> -     /* we have tried too many times, receiver does not want A-MPDU */
>>       if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
>> -             ret = -EBUSY;
>> -             goto err_unlock_sta;
>> +             unsigned int timestamp = jiffies_to_msecs(jiffies);
>> +             if (timestamp - sta->ampdu_mlme.last_addba_req_time[tid] >
>> +                 HT_AGG_RETRIES_PERIOD) {
>
> this logic is confusing -- why ms? jiffies should be absolutely OK for
> minute-long timeouts.

  Sure, I'll change this to use jiffies.
  Thanks.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
