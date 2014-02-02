Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:32976 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaBBWQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 17:16:04 -0500
Received: by mail-ea0-f171.google.com with SMTP id f15so3365525eak.16
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 14:16:02 -0800 (PST)
Message-ID: <52EEC3A1.6090409@gmail.com> (sfid-20140202_231608_626497_6E566182)
Date: Sun, 02 Feb 2014 23:16:01 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
CC: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2500: disable PS by default
References: <1391014457-13412-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1391014457-13412-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/14 17:54, Stanislaw Gruszka wrote:
> It is know that PS cause issues on that old devices, disable it by
> default.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

We seem to be going back and forth on this, but:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500pci.c | 5 +++++
>  drivers/net/wireless/rt2x00/rt2500usb.c | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 0ac5c58..d42425a 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1880,6 +1880,11 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  						   EEPROM_MAC_ADDR_0));
>  
>  	/*
> +	 * Disable powersaving as default.
> +	 */
> +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
> +	/*
>  	 * Initialize hw_mode information.
>  	 */
>  	spec->supported_bands = SUPPORT_BAND_2GHZ;
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 85acc79..9d486a3 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1709,6 +1709,11 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	    IEEE80211_HW_SUPPORTS_PS |
>  	    IEEE80211_HW_PS_NULLFUNC_STACK;
>  
> +	/*
> +	 * Disable powersaving as default.
> +	 */
> +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> +
>  	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
>  	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
>  				rt2x00_eeprom_addr(rt2x00dev,
> 


-- 
---
Gertjan
