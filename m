Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48454 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1BOOlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:41:19 -0500
Received: by wwa36 with SMTP id 36so251180wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 06:41:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297778952.8664.2.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	<1296824920.3671.4.camel@jlt3.sipsolutions.net>
	<1296825156.3671.7.camel@jlt3.sipsolutions.net>
	<AANLkTi=eJf+ge7_w1-r1hmZE0aaPzm_NP-Y-v81uctXG@mail.gmail.com>
	<1297773858.3935.13.camel@jlt3.sipsolutions.net>
	<AANLkTinGP+Vxm7502wRmCu5g_Nthz0x-sNQ4NFx9uz1n@mail.gmail.com>
	<1297778952.8664.2.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Feb 2011 20:11:17 +0530
Message-ID: <AANLkTinAK03xcnS9Fk6BSfmk3UO9y82ANvuUNCc5z1qf@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 7:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-02-15 at 19:34 +0530, Vivek Natarajan wrote:
>> On Tue, Feb 15, 2011 at 6:14 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-02-08 at 15:43 +0530, Vivek Natarajan wrote:
>> >
>> >> > Maybe the subif queues should be stopped, then flush, then tx nullfunc,
>> >> > then stop all queues to configure the HW or something like that?
>> >>
>> >> I tried this sequence:
>> >> the subif queues stopped, then flush, then tx nullfunc, and wake subif
>> >> queues,(we cannot have the queues stopped till we receive tx_status
>> >> because nullfunc might have failed during tx path itself and mac80211
>> >> will not receive tx_status)
>> >
>> > I've recently been thinking about this -- I'm thinking that maybe we
>> > should change this behaviour. Right now the tx() routine basically
>> > always returns OK (except in at76) and I suppose instead it could return
>> > whether the frame was queued up successfully...
>> >
>> >> After some time interval, once again stop queues on receiving ack for
>> >> nullfunc, configure the hw and then wake up queues. So, during the
>> >> above time interval, there is a race of queuing a frame to the hw. I
>> >> have tested this and the issue is quickly reproducible.
>> >
>> > Right. The code that sends the nullfunc -- I think it can probably
>> > sleep? If so, instead of starting the queue for the TX it could just
>> > flush TX again after sending the nullfunc -- after that either it had
>> > status for the frame, or the frame was dropped, no?
>>
>> So, this requires changing all the drivers to return the status for
>> tx() routine.
>
> Not necessarily. I think that if you do the flush() based approach, then
> mac80211 can infer that the frame was dropped by not getting a TX status
> during flush, right? Assuming there's reliable TX status to start with.

Thanks. I will give this a try.

Vivek.
