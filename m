Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37653 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcEYVIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 17:08:10 -0400
Received: by mail-wm0-f41.google.com with SMTP id z87so76663333wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2016 14:08:08 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: fix setting AP channel with new firmwares
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1464080979-12150-1-git-send-email-zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57461435.9080708@broadcom.com> (sfid-20160525_230833_569079_4BCEA12A)
Date: Wed, 25 May 2016 23:08:05 +0200
MIME-Version: 1.0
In-Reply-To: <1464080979-12150-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24-05-16 11:09, Rafał Miłecki wrote:
> Firmware for new chipsets is based on a new major version of code
> internally maintained at Broadcom. E.g. brcmfmac4366b-pcie.bin (used for
> BCM4366B1) is based on 10.10.69.3309 while brcmfmac43602-pcie.ap.bin was
> based on 7.35.177.56.
> 
> Currently setting AP 5 GHz channel doesn't work reliably with BCM4366B1.
> When setting e.g. 36 control channel with VHT80 (center channel 42)
> firmware may randomly pick one of:
> 1) 52 control channel with 58 as center one
> 2) 100 control channel with 106 as center one
> 3) 116 control channel with 122 as center one
> 4) 149 control channel with 155 as center one
> 
> It seems new firmwares require setting AP mode (BRCMF_C_SET_AP) before
> specifying a channel. Changing an order of firmware calls fixes the
> problem.
> 
> This fix was verified with BCM4366B1 and tested for regressions on
> BCM43602. It's unclear if it's needed (or correct at all) for P2P
> interfaces so it leaves this code unaffected.

In doing so the code reads a bit awkward so if P2P-GO works with the
changed order that would be preferable.

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
