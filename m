Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2993 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3JCLZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 07:25:56 -0400
Message-ID: <524D543B.7010906@broadcom.com> (sfid-20131003_132600_799114_9F30795C)
Date: Thu, 3 Oct 2013 13:25:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] brcmfmac: cleanup and new device support
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2013 01:05 PM, Arend van Spriel wrote:
> This series has a few cleanup patches fixing a sparse error, cleaning
> up the rx path and also changing the firmware filename approach after
> getting feedback on this by Stephen Warren. The remaining patches are
> adding support for the BCM4339 SDIO chipset.
>
> This series is intended for v3.13 kernel and applies to the master
> branch of the wireless-next repository.

Hi John,

Did you miss this series from last week?

Regards,
Arend

> Arend van Spriel (2):
>    brcmfmac: fix sparse error 'bad constant expression'
>    brcmfmac: rework rx path bus interface
>
> Franky Lin (4):
>    brcmfmac: sync firmware event list
>    brcmfmac: add BCM4339 SDIO interface support
>    brcmfmac: add valid core index check in related functions
>    brcmfmac: reserve memory for bus layer in sk_buff::cb
>
> Hante Meuleman (1):
>    brcmfmac: Use fw filename and nvram based of devid for sdio.
>
>   .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   11 +-
>   drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 -
>   drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
>   .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   38 ++--
>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  234 ++++++++++++--------
>   drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |    5 +-
>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +
>   .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   28 +++
>   .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    8 +
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    5 +-
>   .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
>   11 files changed, 211 insertions(+), 125 deletions(-)
>


