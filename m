Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2772 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbFDOze (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 10:55:34 -0400
Message-ID: <557066E3.6030008@broadcom.com> (sfid-20150604_165538_213031_82DE91C4)
Date: Thu, 4 Jun 2015 16:55:31 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>	<556701E9.8090807@broadcom.com>	<CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com>	<55678789.60802@broadcom.com>	<CACna6rz=jrkFDkePMvPNRk_X4UwxdwGecGxtdynXgpJCkN-0FA@mail.gmail.com>	<55681D51.1070503@broadcom.com> <556EEF3C.7000107@broadcom.com> <87y4jzpn6x.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4jzpn6x.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/15 16:23, Kalle Valo wrote:
> Hi Arend,
>
> Arend van Spriel<arend@broadcom.com>  writes:
>
>>>> I really don't want to have you annoyed because the need of rebasing
>>>> your patch. What you said about Ralf's tree and linux-next isn't
>>>> exactly true. I do believe Kalle won't merge linux-next into
>>>> wireless-driver-next, so we have to wait for 4.2-rc1, then for Dave
>>>> merging Linus's tree, then Kalle merging Dave's tree.
>>>
>>> Well, it is an integration issue. So yes, wireless-drivers-next (and
>>> net-next) would not build for CONFIG_BCM47XX with the brcmfmac patch,
>>> because of the missing mips patch. However, the linux-next tree will
>>> have no build issue and consequently 4.2-rc1 will have no build issue. I
>>> think this is acceptable although I would like to hear the opinion of
>>> Kalle on this.
>>
>> Hi Kalle,
>>
>> Do you have an opinion on this? mips-next and linux-next now have the
>> function brcmfmac needs for CONFIG_BCM47XX so I could submit brcmfmac
>> patch, but that means wireless-drivers-next (and net-next) will not
>> build for CONFIG_BCM47XX until after the 4.2 merge window.
>
> The answer is clear: we must not ever break the build deliberately, in
> under any circumstances. Mistakes of course always happen but if we know
> a patch will break the build it should not be applied.
>
> So if patch A has a build dependency on patch B in another tree, we have
> to wait for that patch B to trickle down to wireless-drivers-next before
> I can commit patch A. There are other ways to speed this up if really
> needed but I don't see this case is important enough for the extra
> hurdle.
>
> I haven't followed all the details so I might be missing something but I
> think it would be good just to wait for 4.2-rc1, it's not that far
> anyway, and go with the original Arend's plan.

Ok. I will submit the brcmfmac patch relying on the mips change to 
wireless-drivers-next for 4.3 after 4.2-rc1 merge window. I will ack the 
patch from Rafal in seperate email.

Regards,
Arend
