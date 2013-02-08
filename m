Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2969 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096Ab3BHNv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 08:51:27 -0500
Message-ID: <511502D2.3010800@broadcom.com> (sfid-20130208_145134_289611_25A60086)
Date: Fri, 8 Feb 2013 14:51:14 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/5] brcmfmac: fix usb device reset and debugging
 functions
References: <1360321595-31722-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1360321595-31722-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2013 12:06 PM, Arend van Spriel wrote:
> Fixing a problem found in usb device reset that could result in a null
> pointer access. The debugging functions in sdio driver had a locking
> issue and on some devices needed a backplane clock running to function
> properly.

Forgot to mention it, but this series is intended for v3.9 and depends
on the patch series sent couple of days ago identified by:

Message-ID: <1360172447-2424-1-git-send-email-arend@broadcom.com>

Regards,
Arend van Spriel

> Hante Meuleman (2):
>   brcmfmac: use brcmf_if::bssidx as index in interface list
>   brcmfmac: Check null pointer on brcmf_dev_reset.
> 
> Piotr Haber (3):
>   brcmfmac: fix mmc host locking issue
>   brcmfmac: turn clocks on when reading shared info
>   brcmfmac: remove unnecessary locking in trap info processing
> 
>  drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   10 +--
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    8 +++
>  .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   75 ++++++++++----------
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 +-
>  drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    9 ++-
>  drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    5 +-
>  .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +
>  7 files changed, 61 insertions(+), 55 deletions(-)
> 


