Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35690 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbESIYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 04:24:09 -0400
Received: by wicmx19 with SMTP id mx19so107445750wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 01:24:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432020671.7437.5.camel@sipsolutions.net>
References: <1431602181-17700-1-git-send-email-chaitanya.mgit@gmail.com> <1432020671.7437.5.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 19 May 2015 13:53:47 +0530
Message-ID: <CABPxzY+7KDGRs3fO1wsy3FPt__YPBnzr5CcZ_HTEh2ePsdtUdQ@mail.gmail.com> (sfid-20150519_102414_401183_C3ACB0FC)
Subject: Re: [PATCH] mac80211: Fix power save state stuck in ACTIVE caused by
 race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 1:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> It looks like your patch never actually made it to the list - perhaps
> test that before you add me to Cc :)
Sure, i realized that after a few trails and then removed you from CC :-).

>> If we receive suspend after TX path has executed
>> dynamic ps disable work, the driver will be in
>> ACTIVE state during suspend and even after it
>> resumes.
>>
>> As before suspend all data packets are flushed
>> it is safe to put the driver in to sleep for
>> optimal power during suspend or up on resume.
>
> I'm not sure I get it - we always transmit a frame after resume.
Let me explain the sequence of events:

tx_frame:
      dynamic_ps_disable_work.
                 get the chip out of power save.
suspend came:
     dynamic ps timer is cancelled.
    tx queues are flushed.
chip stays out of power save unless there is one more
tx frame which kicks the dynamic ps timer again.



-- 
Thanks,
Regards,
Chaitanya T K.
