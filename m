Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54262 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbIFNij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 09:38:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<87383kps0o.fsf@kamboji.qca.qualcomm.com>
	<wrfjvbggfhuj.fsf@redhat.com>
Date: Sun, 06 Sep 2015 16:38:31 +0300
In-Reply-To: <wrfjvbggfhuj.fsf@redhat.com> (Jes Sorensen's message of "Tue, 28
	Apr 2015 10:27:48 -0400")
Message-ID: <8737yrhdm0.fsf@kamboji.qca.qualcomm.com> (sfid-20150906_153842_330899_6113A03B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

replying to an old thread first.

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>> Jes.Sorensen@redhat.com writes:
>>
>>>  MAINTAINERS                          |    8 +
>>>  drivers/net/wireless/Kconfig         |   19 +
>>>  drivers/net/wireless/Makefile        |    2 +
>>>  drivers/net/wireless/rtl8xxxu.c | 4500
>>> ++++++++++++++++++++++++++++++++++
>>>  drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>  drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
>>
>> I think someone else already mentioned, but it would be better that has
>> it's own directory. Or should this actually be under rtlwifi
>> directory?
>
> I didn't see the need here - it's just 3 files, as long as it doesn't
> have a huge hierachy of files, a new directory doesn't add much
> value. If it becomes an issue later, we can move it into a
> subdirectory.

It's easier that the driver has it's on directory as everything
(makefile, kconfig etc) is cleanly separated. And actually I would like
to create a new vendor directory for realtek and have this in
drivers/net/wireless/realtek/rtl8xxxu/. And later we could move rtlwifi
under realtek directory as well.

>>> +T: git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>>> rtl8723au-mac80211
>>
>> I doubt that this will be in active enough development that a separate
>> git tree is needed. wireless-drivers trees should be enough and this
>> line can be removed.
>
> I would like to keep this line, it points to my development tree, which
> allows users to go back and look through my full development logs, as
> well as see ongoing work before it's pushed upstream.

I prefer that wireless-drivers(-next).git is used as the baseline for
wireless driver patches, so please remove this tag. You can document
your git server in the wiki, commit log and so on.

>> I'll do more detailed code review later, but my first impression was
>> that there was a lot of #if 0 code which is frowned upon.
>
> Johannes already brought up the #if 0 pieces. I left those in because I
> am not done with the driver, and this helps me map the flow of the
> vendor driver codebase. Those #if 0 lines are not there to sit and rot,
> but to help future development.

Yeah, I guessed that. But I suspect once the driver is applied we start
getting patches removing dead code (and rightly so). You could have a
separate branch with these #if 0 lines if they are important to you.

-- 
Kalle Valo
