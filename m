Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33981 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbIFQlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 12:41:35 -0400
Received: by oiev17 with SMTP id v17so34065336oie.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2015 09:41:35 -0700 (PDT)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
To: Kalle Valo <kvalo@codeaurora.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
 <1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
 <87383kps0o.fsf@kamboji.qca.qualcomm.com> <wrfjvbggfhuj.fsf@redhat.com>
 <8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55EC6CBC.90504@lwfinger.net> (sfid-20150906_184140_524755_91F8068A)
Date: Sun, 6 Sep 2015 11:41:32 -0500
MIME-Version: 1.0
In-Reply-To: <8737yrhdm0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2015 08:38 AM, Kalle Valo wrote:
> Hi,
>
> replying to an old thread first.
>
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>> Jes.Sorensen@redhat.com writes:
>>>
>>>>   MAINTAINERS                          |    8 +
>>>>   drivers/net/wireless/Kconfig         |   19 +
>>>>   drivers/net/wireless/Makefile        |    2 +
>>>>   drivers/net/wireless/rtl8xxxu.c | 4500
>>>> ++++++++++++++++++++++++++++++++++
>>>>   drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>>>>   drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
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

I agree with the proposal for this driver to be under a separate directory. As 
this driver evolves to support more devices, it will likely be useful to split 
the current single .c file into a set of files, each containing the specific 
code needed for a given device. At that point, placing these files into a 
separate directory will be needed to keep the base drivers/net/wireless/ as 
clean as possible. We might as well do that now. I have no objections to moving 
rtlwifi under drivers/net/wireless/realtek/. We should even move rtl818x as well.

Larry


