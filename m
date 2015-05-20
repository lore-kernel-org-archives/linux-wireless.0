Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33209 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbbETN6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:58:14 -0400
Received: by wgjc11 with SMTP id c11so53937617wgj.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 06:58:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432129299.19214.16.camel@sipsolutions.net>
References: <1431602181-17700-1-git-send-email-chaitanya.mgit@gmail.com>
 <1432020671.7437.5.camel@sipsolutions.net> <CABPxzY+7KDGRs3fO1wsy3FPt__YPBnzr5CcZ_HTEh2ePsdtUdQ@mail.gmail.com>
 <1432129299.19214.16.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 20 May 2015 19:27:52 +0530
Message-ID: <CABPxzY+v_7SbKJp5AkFzpdZiMkojrHWwjGiKqR7t25DPdtn7mQ@mail.gmail.com> (sfid-20150520_155817_235759_0DD6C5DE)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by
 race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 7:11 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2015-05-19 at 13:53 +0530, Krishna Chaitanya wrote:
>
>> > I'm not sure I get it - we always transmit a frame after resume.
>> Let me explain the sequence of events:
>>
>> tx_frame:
>>       dynamic_ps_disable_work.
>>                  get the chip out of power save.
>> suspend came:
>>      dynamic ps timer is cancelled.
>>     tx queues are flushed.
>> chip stays out of power save unless there is one more
>> tx frame which kicks the dynamic ps timer again.
>
> So initially, for suspend, this shouldn't matter.
Some chipsets are using power_save state from mac80211
to stay in DOZE mode, so in that case we end up
drawing more power. We can force the chipset fw to enter
DOZE independent of the mac80211 power save state but
when resuming the chip FW should again configure as per
mac80211 power save state.

> And after suspend we always transmit a frame. What gives?

Yes, but we have seen that in idle case this delay is more like
30secs-1min depending on the keepalive packet.

Till that time the chip is active and drawing more power.
