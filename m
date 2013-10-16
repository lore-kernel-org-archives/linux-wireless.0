Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4156 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760444Ab3JPIwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 04:52:01 -0400
Message-ID: <525E53A4.1050800@broadcom.com> (sfid-20131016_105210_510021_CEDE140B)
Date: Wed, 16 Oct 2013 10:51:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] brcmfmac: fixes for MMC hosts without
 scatter-gather
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2013 03:44 PM, Arend van Spriel wrote:
> On our internal test setups it turned out that the MMC host controller
> did not support scatterlists (struct mmc_host::max_segs == 1). It took
> a number of patches to cleanup and support this. While at it some debug
> trace functions were modified and added.

Hi John,

Forgot to mention this series is intended for v3.13 and applies to the 
master branch of the wireless-next repository.

Regards,
Arend

> Arend van Spriel (12):
>    brcmfmac: store address in trace_brcmf_hexdump()
>    brcmfmac: add tracepoint for capturing the SDPCM header
>    brcmfmac: rename variable max_seg_sz to max_seg_cnt for clarity
>    brcmfmac: determine host controller related variables during probe
>    brcmfmac: rework scatter-gather code in brcmf_sdio_buffrw()
>    brcmfmac: rename brcmf_sdio_buffrw()
>    brcmfmac: rework single packet transfers
>    brcmfmac: verify result of brcmf_sdio_addrprep() calls
>    brcmfmac: remove stale code from brcmf_sdcard_recv_chain()
>    brcmfmac: fix brcmf_sdcard_send_pkt() for host without sg support
>    brcmfmac: fix brcmf_sdio_txpkt_prep() for host without sg support
>    brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support
>
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  186 +++++++++++---------
>   .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   17 ++
>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  111 +++++++-----
>   .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    6 +-
>   .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   21 ++-
>   5 files changed, 216 insertions(+), 125 deletions(-)
>


