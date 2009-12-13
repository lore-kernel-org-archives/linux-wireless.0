Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44596 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752155AbZLMKPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 05:15:42 -0500
Received: by ewy19 with SMTP id 19so2443434ewy.21
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2009 02:15:40 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2.6.33] rt2x00: Disable powersaving for rt61pci.
Date: Sun, 13 Dec 2009 11:15:33 +0100
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org, stable@kernel.org
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com> <1260661180-2300-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1260661180-2300-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912131115.33485.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 December 2009, Gertjan van Wingerde wrote:
> We've had many reports of rt61pci failures with powersaving enabled.
> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
> until we have found a proper solution.

This disables powersaving completely, can't we set the default powersaving
to disabled? That way for people for who it does work, it can still be enabled.

Ivo

> Cc: stable@kernel.org
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
> 
> John, this is an urgent fix for 2.6.33 (and stable).
> 
> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 687e17d..2b43a2e 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2543,9 +2543,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00dev->hw->flags =
>  	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -	    IEEE80211_HW_SIGNAL_DBM |
> -	    IEEE80211_HW_SUPPORTS_PS |
> -	    IEEE80211_HW_PS_NULLFUNC_STACK;
> +	    IEEE80211_HW_SIGNAL_DBM;
>  
>  	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
>  	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,


