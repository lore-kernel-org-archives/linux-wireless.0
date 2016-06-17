Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52005 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbcFQJt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 05:49:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4.7 FIX] brcmfmac: fix lockup when removing P2P interface after event timeout
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com>
	<877fdpw4no.fsf@kamboji.qca.qualcomm.com>
	<CACna6rzXzj4DJNA6855Qy6QnxETnYEPmqtw3Bcx8WWCtYwYvuw@mail.gmail.com>
	<87lh24v1n6.fsf@kamboji.qca.qualcomm.com>
	<CACna6rym3y0sqAUptgnt-mUiBidFGzVAzw4XcYr95q6MD2r5yw@mail.gmail.com>
Date: Fri, 17 Jun 2016 12:49:19 +0300
In-Reply-To: <CACna6rym3y0sqAUptgnt-mUiBidFGzVAzw4XcYr95q6MD2r5yw@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 17 Jun 2016
 07:33:20 +0200")
Message-ID: <87h9csuov4.fsf@kamboji.qca.qualcomm.com> (sfid-20160617_114949_139891_391D6300)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

>>>> Failed to apply, please rebase:
>>>>
>>>> Applying: brcmfmac: fix lockup when removing P2P interface after event timeout
>>>> Using index info to reconstruct a base tree...
>>>> Falling back to patching base and 3-way merge...
>>>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>>>> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>>>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>>> Failed to merge in the changes.
>>>> Patch failed at 0001 brcmfmac: fix lockup when removing P2P interface after event timeout
>>>
>>> What tree did you try it on?
>>>
>>> I just went into a dir where I have cloned:
>>> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
>>>
>>> My HEAD commit is:
>>> 034fdd4 Merge ath-current from ath.git
>>>
>>> And I can apply this patch cleanly doing:
>>> curl https://patchwork.kernel.org/patch/9138925/mbox/ | git am
>>
>> I was trying to apply this to wireless-drivers-next. I didn't get a
>> confirmation from Arend and I didn't consider the fix important enough
>> for 4.7. But of course I can reconsider if needed.
>
> I think I agree it won't hurt to get it into -next. Noone earlier
> reported this bug and it seems to be there for a long time. Also
> applying it to -next will allow avoiding merge conflicts and immediate
> development work on -next.

Exactly, there is a cost when taking patches to wireless-drivers.git and
that's why I try to keep the bar high. Regressions and user reported
bugs take priority, other fixes are handled case by case.

> I'll resend this patch rebased on -next soon.

Thanks.

-- 
Kalle Valo
