Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59423 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1K2WBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 17:01:25 -0500
Received: by eaak14 with SMTP id k14so3681754eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 14:01:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322579973.4110.22.camel@jlt3.sipsolutions.net>
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	<1322555084.4110.2.camel@jlt3.sipsolutions.net>
	<CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	<1322579973.4110.22.camel@jlt3.sipsolutions.net>
Date: Tue, 29 Nov 2011 17:01:23 -0500
Message-ID: <CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com> (sfid-20111129_230128_515633_913E9680)
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2011/11/29 Johannes Berg <johannes@sipsolutions.net>:
> Hi Nikolay,
>
>> > Conceptually, this seems OK to me, although on broken APs it might mean
>> > connection stalls every minute, not sure how desirable that is?
>>
>>   Do APs broken is such way exist? I.e. APs which declare aggregation
>> support but do not respond to addba.
>
> I seem to remember something ... not really sure.

  If such APs exist I think it might be possible to extend my patch to
do something like the following. For the first time make 10 attempts
to establish addba. If this fails - make no more attempts for the
duration of the connection. If this succeeds - use logic I've added in
the patch. This should handle broken APs and won't allow agg to be
disable because of some random blackout.

>
>>   On the other hand looking at the code I've got an impression that
>> connection doesn't stall while waiting for addba resp, i.e. packets
>> still go though non-agg path. Did I miss something in this regards?
>
> We queue up packets in ieee80211_tx_prep_agg() when
> HT_AGG_STATE_WANT_START is clear but HT_AGG_STATE_OPERATIONAL is not
> set, this is the case after we send the addBA request frame and before
> we get a response. So since the timeout is 1 second, the connection can
> stall for quite a while.

  Is the any particular reason why packets are not being sent via
non-agg path while agg path is being established? I'm not suggesting
that it is wrong, I'm just curious. The delay in data transmission
you've mentioned in regards to my patch is probably applicable here
too, so won't it make sense to ignore agg until it is fully set up?

  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
