Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34191 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1BOOEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 09:04:52 -0500
Received: by ewy5 with SMTP id 5so74205ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 06:04:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297773858.3935.13.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	<1296824920.3671.4.camel@jlt3.sipsolutions.net>
	<1296825156.3671.7.camel@jlt3.sipsolutions.net>
	<AANLkTi=eJf+ge7_w1-r1hmZE0aaPzm_NP-Y-v81uctXG@mail.gmail.com>
	<1297773858.3935.13.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Feb 2011 19:34:50 +0530
Message-ID: <AANLkTinGP+Vxm7502wRmCu5g_Nthz0x-sNQ4NFx9uz1n@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 6:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-02-08 at 15:43 +0530, Vivek Natarajan wrote:
>
>> > Maybe the subif queues should be stopped, then flush, then tx nullfunc,
>> > then stop all queues to configure the HW or something like that?
>>
>> I tried this sequence:
>> the subif queues stopped, then flush, then tx nullfunc, and wake subif
>> queues,(we cannot have the queues stopped till we receive tx_status
>> because nullfunc might have failed during tx path itself and mac80211
>> will not receive tx_status)
>
> I've recently been thinking about this -- I'm thinking that maybe we
> should change this behaviour. Right now the tx() routine basically
> always returns OK (except in at76) and I suppose instead it could return
> whether the frame was queued up successfully...
>
>> After some time interval, once again stop queues on receiving ack for
>> nullfunc, configure the hw and then wake up queues. So, during the
>> above time interval, there is a race of queuing a frame to the hw. I
>> have tested this and the issue is quickly reproducible.
>
> Right. The code that sends the nullfunc -- I think it can probably
> sleep? If so, instead of starting the queue for the TX it could just
> flush TX again after sending the nullfunc -- after that either it had
> status for the frame, or the frame was dropped, no?

So, this requires changing all the drivers to return the status for
tx() routine. And this is how I understand this:
stop queues, then send nullfunc, then do a flush to get the status and
wake queues again irrespective of acked or not(but set the ACK_STATUS
correspondingly). If tx() routine of nullfunc fails, then also wake
the queues.
I have sent another version with PS_PENDING and stop/wake queues
combined. That addresses the race that you had mentioned earlier. Do
we need that?

Thanks,
Vivek.
