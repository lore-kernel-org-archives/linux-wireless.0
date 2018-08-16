Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727640AbeHPNmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 09:42:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [DEBUG PATCH] brcmfmac: add firmware watchdog running on host machine
References: <20180815180101.15087-1-zajec5@gmail.com>
Date: Thu, 16 Aug 2018 13:45:00 +0300
In-Reply-To: <20180815180101.15087-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Wed, 15 Aug 2018 20:01:01 +0200")
Message-ID: <87wosqtwsz.fsf@purkki.adurom.net> (sfid-20180816_124507_431692_27FE1DAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> It may happen for FullMAC firmware to crash. It should be detected and
> ideally somehow handled by a driver.
>
> Since commit ff4445a8502c ("brcmfmac: expose device memory to
> devcoredump subsystem") brcmfmac has BRCMF_E_PSM_WATCHDOG event handler
> but it wasn't enough to detect all kind of crashes. E.g. Netgear R8000
> (BCM4709A0 + 3 x BCM43602) user was exepriencing firmware crashes that
> never resulted in passing BRCMF_E_PSM_WATCHDOG to the host driver.
>
> That made me implement this trivial software watchdog that simply checks
> periodically if firmware still replies to the commands.
>
> Luckily this patch DOES NOT seem to be needed anymore since the commit
> 8a3ab2f38f16 ("brcmfmac: trigger memory dump upon firmware halt
> signal"). That change allows brcmfmac to detect firmware crashes
> successfully.
>
> This patch is being posted for research/debugging purposes only. It
> SHOULD NOT be applied until someone notices a firmware crash that
> doesn't trigger the BRCMF_D2H_DEV_FWHALT signal.

Kudos for making it clear that I can safely drop this in patchwork :)
This makes it so much easier for me.

--=20
Kalle Valo
