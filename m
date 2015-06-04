Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34385 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbFDOX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 10:23:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: use direct data pointer in NVRAM parser struct
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
	<556701E9.8090807@broadcom.com>
	<CACna6rwm5L1tSd7S=9PNKnju-sxHxhYPbA0EcdJ5K=MwJzJvUA@mail.gmail.com>
	<55678789.60802@broadcom.com>
	<CACna6rz=jrkFDkePMvPNRk_X4UwxdwGecGxtdynXgpJCkN-0FA@mail.gmail.com>
	<55681D51.1070503@broadcom.com> <556EEF3C.7000107@broadcom.com>
Date: Thu, 04 Jun 2015 17:23:18 +0300
In-Reply-To: <556EEF3C.7000107@broadcom.com> (Arend van Spriel's message of
	"Wed, 3 Jun 2015 14:12:44 +0200")
Message-ID: <87y4jzpn6x.fsf@kamboji.qca.qualcomm.com> (sfid-20150604_162330_489033_4D678335)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Arend van Spriel <arend@broadcom.com> writes:

>>> I really don't want to have you annoyed because the need of rebasing
>>> your patch. What you said about Ralf's tree and linux-next isn't
>>> exactly true. I do believe Kalle won't merge linux-next into
>>> wireless-driver-next, so we have to wait for 4.2-rc1, then for Dave
>>> merging Linus's tree, then Kalle merging Dave's tree.
>>
>> Well, it is an integration issue. So yes, wireless-drivers-next (and
>> net-next) would not build for CONFIG_BCM47XX with the brcmfmac patch,
>> because of the missing mips patch. However, the linux-next tree will
>> have no build issue and consequently 4.2-rc1 will have no build issue. I
>> think this is acceptable although I would like to hear the opinion of
>> Kalle on this.
>
> Hi Kalle,
>
> Do you have an opinion on this? mips-next and linux-next now have the
> function brcmfmac needs for CONFIG_BCM47XX so I could submit brcmfmac
> patch, but that means wireless-drivers-next (and net-next) will not
> build for CONFIG_BCM47XX until after the 4.2 merge window.

The answer is clear: we must not ever break the build deliberately, in
under any circumstances. Mistakes of course always happen but if we know
a patch will break the build it should not be applied.

So if patch A has a build dependency on patch B in another tree, we have
to wait for that patch B to trickle down to wireless-drivers-next before
I can commit patch A. There are other ways to speed this up if really
needed but I don't see this case is important enough for the extra
hurdle.

I haven't followed all the details so I might be missing something but I
think it would be good just to wait for 4.2-rc1, it's not that far
anyway, and go with the original Arend's plan.

-- 
Kalle Valo
