Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13048 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaINHcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 03:32:41 -0400
Message-ID: <54154496.3070809@broadcom.com> (sfid-20140914_093321_708089_29B490B4)
Date: Sun, 14 Sep 2014 09:32:38 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
	<netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 0/4 linux-next] drivers/net: use container_of where possible
References: <1410640709-18295-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1410640709-18295-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/14 22:38, Fabian Frederick wrote:
> Small patchset using container_of instead of casting on first structure member address.

Hi Fabian,

I think you need to split up this series. One for the ethernet drivers 
and one for the wireless driver. As there is not dependency between the 
patches they can each go through their own subsystem git tree. Generally 
I tend to submit patches to the subsystem maintainer and Cc the 
appropriate mailing lists.

Regarding the patches for brcmsmac, you can add

Acked-by: Arend van Spriel <arend@broadcom.com>

Regards,
Arend

> Fabian Frederick (4):
>    net: fec: use container_of to resolve bufdesc_ex from bufdesc
>    bna: use container_of to resolve bufdesc_ex from bufdesc
>    brcm80211: use container_of to resolve brcms_phy from brcms_phy_pub
>    brcm80211: use container_of to resolve dma_info from dma_pub
>
>   drivers/net/ethernet/brocade/bna/bna_enet.c        |   9 +-
>   drivers/net/ethernet/brocade/bna/bna_tx_rx.c       |   4 +-
>   drivers/net/ethernet/freescale/fec_main.c          |   4 +-
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  38 +++----
>   .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  | 122 ++++++++++-----------
>   .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   6 +-
>   .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   8 +-
>   7 files changed, 97 insertions(+), 94 deletions(-)
>

