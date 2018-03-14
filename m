Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:54541 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeCNM6T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:58:19 -0400
Received: by mail-wm0-f41.google.com with SMTP id h76so3900489wme.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 05:58:18 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: drop Inter-Access Point Protocol packets by
 default
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180314110119.13631-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>,
        bridge@lists.linux-foundation.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA91C67.90001@broadcom.com> (sfid-20180314_135827_434438_D36D51DA)
Date: Wed, 14 Mar 2018 13:58:15 +0100
MIME-Version: 1.0
In-Reply-To: <20180314110119.13631-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/14/2018 12:01 PM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> Testing brcmfmac with more recent firmwares resulted in AP interfaces
> not working in some specific setups. Debugging resulted in discovering
> support for IAPP in Broadcom's firmwares. This is an obsoleted standard
> and its implementation is something that:
> 1) Most people don't need / want to use
> 2) Can allow local DoS attacks
> 3) Breaks AP interfaces in some specific bridge setups
>
> To solve issues it can cause this commit modifies brcmfmac to drop IAPP
> packets. If affects:
> 1) Rx path: driver won't be sending these unwanted packets up.
> 2) Tx path: driver will reject packets that would trigger STA
>     disassociation perfromed by a firmware (possible local DoS attack).
>
> It appears there are some Broadcom's clients/users who care about this
> feature despite the drawbacks. They can switch it on by a newly added
> Kconfig option.

Thanks for taking this approach. Looks fine except for .... (see below)

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>   drivers/net/wireless/broadcom/brcm80211/Kconfig    | 20 +++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 39 ++++++++++++++++++++++
>   2 files changed, 59 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> index 9d99eb42d917..876787ef991a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
> @@ -68,6 +68,26 @@ config BRCMFMAC_PCIE
>   	  IEEE802.11ac embedded FullMAC WLAN driver. Say Y if you want to
>   	  use the driver for an PCIE wireless card.
>
> +config BRCMFMAC_IAPP
> +	bool "Partial support for obsoleted Inter-Access Point Protocol"
> +	depends on BRCMFMAC
> +	---help---
> +	  Most of Broadcom's firmwares can send 802.11f ADD frame every
> +	  time new STA connects to the AP interface. Some recent ones
> +	  can also disassociate STA when they receive such a frame.

I do not see any evidence that this would occur only for recent 
firmware. That stuff is old and not touched recently.

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 19048526b4af..db6987015fb1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c

[...]

>   static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>   					   struct net_device *ndev)
>   {
> @@ -250,6 +278,12 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>   		goto done;
>   	}
>
> +	if (!IS_ENABLED(CONFIG_BRCMFMAC_IAPP) && brcmf_skb_is_iapp(skb)) {
> +		dev_kfree_skb(skb);
> +		ret = -EINVAL;
> +		goto done;
> +	}

This is not right. The function must return netdev_tx_t type. Here is 
kerneldoc of .start_xmit():

  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
  *                               struct net_device *dev);
  *	Called when a packet needs to be transmitted.
  *	Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you should stop
  *	the queue before that can happen; it's for obsolete devices and weird
  *	corner cases, but the stack really does a non-trivial amount
  *	of useless work if you return NETDEV_TX_BUSY.
  *	Required; cannot be NULL.

You may want to increase dropped netstat or add driver internal 
statistic counter so there is visibility of IAPP packets being dropped.

Regards,
Arend
