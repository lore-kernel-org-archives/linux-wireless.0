Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40055 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934074AbbI1Rsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 13:48:31 -0400
Message-ID: <56097D6D.1010509@broadcom.com> (sfid-20150928_194848_307760_719823BB)
Date: Mon, 28 Sep 2015 19:48:29 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/16] brcmfmac: new device support and P2P fixes
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2015 10:08 PM, Arend van Spriel wrote:
> This series is intended for v4.4 containing the following highlights:
>
> * support for BCM4350, BCM4365, and BCM4366 PCIE devices.
> * fixed for legacy P2P and P2P device handling.
> * correct set and get tx-power.
>
> The series should be applied to master branch of the wireless-drivers-next
> repository after the series sent earlier with
> Message-ID: <1440620104-2715-1-git-send-email-arend@broadcom.com>
> and patch "brcmfmac: Reset PCIE devices after recognition." with
> Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com>.

Hi Kalle,

If my administration is correct there are 29 patches pending. Any chance 
these will get applied. Or did I miss some remarks requiring a resend.

Regards,
Arend

> Hante Meuleman (16):
>    brcmfmac: Fix exception handling.
>    brcmfmac: Add support for the BCM4350 PCIE device.
>    brcmfmac: Fix set and get tx-power functions.
>    brcmfmac: Only assign primary netdev to if2bss array.
>    brcmfmac: Inform p2p module about p2pon through API
>    brcmfmac: Fix bug in flowring management.
>    brcmfmac: Make p2pon module param always available.
>    brcmfmac: Workaround in change vif for wpa_supplicant support.
>    brcmfmac: Deleting of p2p device is leaking memory.
>    brcmfmac: Only handle p2p_stop_device if vif is valid
>    brcmfmac: Fix p2p bug for older firmwares.
>    brcmfmac: Add module parameter to disable features.
>    brcmfmac: Fix race condition bug when deleting p2p interface.
>    brcmfmac: Add support for the BCM4365 and BCM4366 PCIE devices.
>    brcmfmac: Fix TDLS setup by properly handling p2p noif.
>    brcmfmac: Accept events when TDLS is used in combination with p2p.
>
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 186 +++++++--------------
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |   3 +-
>   drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 111 ++++++++++--
>   drivers/net/wireless/brcm80211/brcmfmac/core.c     |  34 +++-
>   drivers/net/wireless/brcm80211/brcmfmac/feature.c  |  13 ++
>   drivers/net/wireless/brcm80211/brcmfmac/flowring.h |   2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  26 ++-
>   drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |   3 +
>   drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  92 ++++++----
>   drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |   5 +-
>   drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  31 ++++
>   .../net/wireless/brcm80211/include/brcm_hw_ids.h   |  11 ++
>   include/linux/bcma/bcma.h                          |   2 +
>   13 files changed, 331 insertions(+), 188 deletions(-)
>

