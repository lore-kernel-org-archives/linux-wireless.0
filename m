Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35967 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbbEUKQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 06:16:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips\@linux-mips.org" <linux-mips@linux-mips.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
	<1432123792-4155-7-git-send-email-arend@broadcom.com>
	<CACna6ryt5uNkBXAk8chFyMEQVJLdHELLdA_V5TrLcaAikrTZeg@mail.gmail.com>
	<CACna6ryCgOwkj_nt6Gd1+r826OJu-suPk50YAS1eRVW+kkR7fQ@mail.gmail.com>
	<555DA529.6000901@broadcom.com>
Date: Thu, 21 May 2015 13:16:15 +0300
In-Reply-To: <555DA529.6000901@broadcom.com> (Arend van Spriel's message of
	"Thu, 21 May 2015 11:28:09 +0200")
Message-ID: <87vbfm6xsg.fsf@kamboji.qca.qualcomm.com> (sfid-20150521_121638_314033_C4230EAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 05/21/15 10:28, Rafał Miłecki wrote:
>> On 20 May 2015 at 16:33, Rafał Miłecki<zajec5@gmail.com>  wrote:
>>> I think the best way for achieving this is to rework your patch to
>>> modify include/linux/bcm47xx_nvram.h. You could modify it the same way
>>> you did in your patch for MIPS tree, except for
>>> bcm47xx_nvram_get_contents. Don't implement this function for real (in
>>> .c file), but instead make in dummy inline in a bcm47xx_nvram.h like:
>>> static inline char *bcm47xx_nvram_get_contents(size_t *val_len)
>>> {
>>>          /* TODO: Implement in .c file */
>>>          return NULL;
>>> }
>>
>> One more note.
>> This of course will lead to conflict at some point, but I believe
>> Linus will handle it.
>
> I prefer to avoid tricks so I will ask to drop this patch and wait for
> it to land in the next kernel, ie. 4.2, and resubmit this patch for
> 4.3. I am not in a hurry.

Yes, please :) Let's try to avoid conflicts as much as possible.

-- 
Kalle Valo
