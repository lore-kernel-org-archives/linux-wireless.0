Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbbIGSnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 14:43:31 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
	<wrfjvbggfhuj.fsf@redhat.com>
	<8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 07 Sep 2015 14:43:28 -0400
In-Reply-To: <8737yrhdm0.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Sun, 06 Sep 2015 16:38:31 +0300")
Message-ID: <wrfjlhcidq9b.fsf@redhat.com> (sfid-20150907_204334_252184_CE272AD1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Hi,
>
> replying to an old thread first.
>
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>> Jes.Sorensen@redhat.com writes:
>>>
>>>>  MAINTAINERS                          |    8 +
>>>>  drivers/net/wireless/Kconfig         |   19 +
>>>>  drivers/net/wireless/Makefile        |    2 +
>>>>  drivers/net/wireless/rtl8xxxu.c | 4500
>>>> ++++++++++++++++++++++++++++++++++
>>>>  drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>>  drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>>>
>>> I think someone else already mentioned, but it would be better that has
>>> it's own directory. Or should this actually be under rtlwifi
>>> directory?
>>
>> I didn't see the need here - it's just 3 files, as long as it doesn't
>> have a huge hierachy of files, a new directory doesn't add much
>> value. If it becomes an issue later, we can move it into a
>> subdirectory.
>
> It's easier that the driver has it's on directory as everything
> (makefile, kconfig etc) is cleanly separated. And actually I would like
> to create a new vendor directory for realtek and have this in
> drivers/net/wireless/realtek/rtl8xxxu/. And later we could move rtlwifi
> under realtek directory as well.

If you want to create drivers/net/wireless/realtek, that is fine with
me, but maybe you can go ahead and create that first and move the
existing drivers in there?

>>>> +T: git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>>> rtl8723au-mac80211
>>>
>>> I doubt that this will be in active enough development that a separate
>>> git tree is needed. wireless-drivers trees should be enough and this
>>> line can be removed.
>>
>> I would like to keep this line, it points to my development tree, which
>> allows users to go back and look through my full development logs, as
>> well as see ongoing work before it's pushed upstream.
>
> I prefer that wireless-drivers(-next).git is used as the baseline for
> wireless driver patches, so please remove this tag. You can document
> your git server in the wiki, commit log and so on.

I will insist on keeping my branch listed as long as I maintain the
driver. Other drivers do the same thing, like iwlwifi. I'm happy to send
you patches against wireless-drivers-next.git though.

>>> I'll do more detailed code review later, but my first impression was
>>> that there was a lot of #if 0 code which is frowned upon.
>>
>> Johannes already brought up the #if 0 pieces. I left those in because I
>> am not done with the driver, and this helps me map the flow of the
>> vendor driver codebase. Those #if 0 lines are not there to sit and rot,
>> but to help future development.
>
> Yeah, I guessed that. But I suspect once the driver is applied we start
> getting patches removing dead code (and rightly so). You could have a
> separate branch with these #if 0 lines if they are important to you.

Most of this is gone by now, so this part of the discussion is less
relevant by now :)

Cheers,
Jes
