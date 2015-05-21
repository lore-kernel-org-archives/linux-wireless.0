Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:49854 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbEUJ2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 05:28:12 -0400
Message-ID: <555DA529.6000901@broadcom.com> (sfid-20150521_112818_422321_E655DF9A)
Date: Thu, 21 May 2015 11:28:09 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>	<1432123792-4155-7-git-send-email-arend@broadcom.com>	<CACna6ryt5uNkBXAk8chFyMEQVJLdHELLdA_V5TrLcaAikrTZeg@mail.gmail.com> <CACna6ryCgOwkj_nt6Gd1+r826OJu-suPk50YAS1eRVW+kkR7fQ@mail.gmail.com>
In-Reply-To: <CACna6ryCgOwkj_nt6Gd1+r826OJu-suPk50YAS1eRVW+kkR7fQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/21/15 10:28, Rafał Miłecki wrote:
> On 20 May 2015 at 16:33, Rafał Miłecki<zajec5@gmail.com>  wrote:
>> I think the best way for achieving this is to rework your patch to
>> modify include/linux/bcm47xx_nvram.h. You could modify it the same way
>> you did in your patch for MIPS tree, except for
>> bcm47xx_nvram_get_contents. Don't implement this function for real (in
>> .c file), but instead make in dummy inline in a bcm47xx_nvram.h like:
>> static inline char *bcm47xx_nvram_get_contents(size_t *val_len)
>> {
>>          /* TODO: Implement in .c file */
>>          return NULL;
>> }
>
> One more note.
> This of course will lead to conflict at some point, but I believe
> Linus will handle it.

I prefer to avoid tricks so I will ask to drop this patch and wait for 
it to land in the next kernel, ie. 4.2, and resubmit this patch for 4.3. 
I am not in a hurry.

Regards,
Arend
