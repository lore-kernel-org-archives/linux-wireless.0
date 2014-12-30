Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:64671 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaL3SjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 13:39:19 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so12822125lab.26
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2014 10:39:17 -0800 (PST)
Message-ID: <54A2F151.6040205@cogentembedded.com> (sfid-20141230_193940_792709_3DD0B3B4)
Date: Tue, 30 Dec 2014 21:39:13 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Ben Greear <greearb@candelatech.com>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Yanbo Li <yanbol@qti.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ath10k: a few incorrect return handling fix-up
References: <1419942046-17985-1-git-send-email-der.herr@hofr.at> <54A2DE7C.1050602@cogentembedded.com> <20141230182842.GA18361@opentech.at>
In-Reply-To: <20141230182842.GA18361@opentech.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/30/2014 09:28 PM, Nicholas Mc Guire wrote:

>>> wait_for_completion_timeout does not return negative values so the tests
>>> for <= 0 are not needed and the case differentiation in the error handling
>>> path unnecessary.

>>     I decided to verify your statement and I saw that it seems wrong.
>> do_wait_for_common() can return -ERESTARTSYS and the return value gets
>> returned by its callers unchanged.

> the -ERESTARTSYS only can be returned if state matches but
> wait_for_completion_timemout passes TASK_UNINTERRUPTIBLE
> so signal_pending_state will return 0 and never negativ

> my understanding of the callchain is:
> wait_for_completion_timemout with TASK_UNINTERRUPTIBLE
>    -> wait_for_common(...TASK_UNINTERRUPTIBLE)
>      -> __wait_for_common(...TASK_UNINTERRUPTIBLE)
>        -> do_wait_for_common(...TASK_UNINTERRUPTIBLE)
>          -> signal_pending_state(TASK_UNINTERRUPTIBLE...)

> static inline int signal_pending_state(long state, struct task_struct *p)
> {
>          if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
>                  return 0;

    Right. I didn't look into TASK_UNINTERRUPTIBLE thing before sending my mail.

> so wait_for_completion_timemout should return 0 or 1 only

    0 or the remaining time, to be precise.

>>> patch was only compile tested x86_64_defconfig + CONFIG_ATH_CARDS=m
>>> CONFIG_ATH10K=m

>>> patch is against linux-next 3.19.0-rc1 -next-20141226

>>     Rather patches. It would have been better to send one patch instead of
>> 4 patches with the same name.

> sorry for that - I had split it into separate patches as it was
> in different files - giving them the same name of course was a bit
> brain-dead.

    You should have mentioned the modified files in the subject. But IMHO it 
would be better to have just one patch.

> please do give it one more look - if the above argument is invalid
> I apologize for the noise.

    It's me who should apologize. :-<

> thx!
> hofrat

WBR, Sergei

