Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58622 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcFQFNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 01:13:25 -0400
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
Date: Fri, 17 Jun 2016 08:13:17 +0300
In-Reply-To: <CACna6rzXzj4DJNA6855Qy6QnxETnYEPmqtw3Bcx8WWCtYwYvuw@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 17 Jun 2016
 06:59:42 +0200")
Message-ID: <87lh24v1n6.fsf@kamboji.qca.qualcomm.com> (sfid-20160617_071350_717343_AC0A2F22)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> On 16 June 2016 at 17:10, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> Removing P2P interface is handled by sending a proper request to the
>>> firmware. On success firmware triggers an event and driver's handler
>>> removes a matching interface.
>>>
>>> However on event timeout we remove interface directly from the cfg80211
>>> callback. Current code doesn't handle this case correctly as it always
>>> assumes rtnl to be unlocked.
>>>
>>> Fix it by adding an extra rtnl_locked parameter to functions and calling
>>> unregister_netdevice when needed.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> Failed to apply, please rebase:
>>
>> Applying: brcmfmac: fix lockup when removing P2P interface after event timeout
>> Using index info to reconstruct a base tree...
>> Falling back to patching base and 3-way merge...
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> Failed to merge in the changes.
>> Patch failed at 0001 brcmfmac: fix lockup when removing P2P interface after event timeout
>
> What tree did you try it on?
>
> I just went into a dir where I have cloned:
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
>
> My HEAD commit is:
> 034fdd4 Merge ath-current from ath.git
>
> And I can apply this patch cleanly doing:
> curl https://patchwork.kernel.org/patch/9138925/mbox/ | git am

I was trying to apply this to wireless-drivers-next. I didn't get a
confirmation from Arend and I didn't consider the fix important enough
for 4.7. But of course I can reconsider if needed.

-- 
Kalle Valo
