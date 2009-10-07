Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:43929 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbZJGQnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 12:43:47 -0400
Received: by bwz6 with SMTP id 6so86727bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 09:43:09 -0700 (PDT)
Message-ID: <4ACCC516.7050002@lwfinger.net>
Date: Wed, 07 Oct 2009 11:43:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Albert Herranz <albert_herranz@yahoo.es>
CC: bcm43xx-dev@lists.berlios.de, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] b43: do not stack-allocate pio rx/tx header and tail
 buffers
References: <200910062252.17565.mb@bu3sch.de> <1254866864-18265-1-git-send-email-albert_herranz@yahoo.es>
In-Reply-To: <1254866864-18265-1-git-send-email-albert_herranz@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Albert Herranz wrote:
> The DMA-API debugging facility complains about b43 mapping memory from
> stack for SDIO-based cards.
> 
> Indeed, b43 currently allocates the PIO RX/TX header and tail buffers
> from stack. The solution here is to use heap-allocated buffers instead.
> 
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> ---
> v2
> - embed buffers into struct b43_wl, and make them depend on CONFIG_B43_PIO
> - take into account tail buffers for unaligned length transfers
> 
>  drivers/net/wireless/b43/b43.h  |  168 +++++++++++++++++++++------------------
>  drivers/net/wireless/b43/pio.c  |   78 +++++++++---------
>  drivers/net/wireless/b43/xmit.c |    2 +-
>  3 files changed, 132 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index fa1549a..6607162 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -607,82 +607,7 @@ struct b43_qos_params {
>  	struct ieee80211_tx_queue_params p;
>  };
>  
> -struct b43_wldev;
> -
> -/* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
> -struct b43_wl {
> -	/* Pointer to the active wireless device on this chip */
> -	struct b43_wldev *current_dev;
> -	/* Pointer to the ieee80211 hardware data structure */
> -	struct ieee80211_hw *hw;

What is the reason for moving the definition of struct b43_wl?

Larry

