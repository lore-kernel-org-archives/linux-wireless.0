Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdC1L7v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 07:59:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Subject: Re: [PATCH for-4.11 0/2] brcmfmac: fixing use-after-free reports
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 28 Mar 2017 14:59:35 +0300
In-Reply-To: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Tue, 28 Mar 2017 09:11:29 +0100")
Message-ID: <87o9wl7gt4.fsf@purkki.adurom.net> (sfid-20170328_140023_468212_D68AB4AD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Two use-after-free issues were found using KASAN and reported by
> Daniel J Blueman. One of them was submitted as patch. However, no
> response came upon my comments. So decided to push the fixes myself.
>
> These patches are intended for v4.11 and apply to the master branch of
> the wireless-drivers repository.
>
> Arend van Spriel (2):
>   brcmfmac: use local iftype avoiding use-after-free of virtual
>     interface
>   cfg80211: check rdev resume callback only for registered wiphy
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  8 +++++---
>  net/wireless/sysfs.c                                   | 10 ++++------
>  2 files changed, 9 insertions(+), 9 deletions(-)

Why are these in the same patchset, are there any dependencies etc? Or
is it safe that Johannes applies the cfg80211 patch to mac80211.git and
I apply brcmfmac to wireless-drivers.git?

-- 
Kalle Valo
