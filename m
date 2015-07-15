Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbGOC0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 22:26:17 -0400
Date: Tue, 14 Jul 2015 19:26:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6655: Fix missing power saving support
Message-ID: <20150715022617.GA28660@kroah.com> (sfid-20150715_042621_021624_0F35B95D)
References: <1434881155-3464-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434881155-3464-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 21, 2015 at 11:05:53AM +0100, Malcolm Priestley wrote:
> Add IEEE80211_HW_SUPPORTS_PS to ieee80211_hw flags
> enabling this feature.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6655/device_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index 0bfc939..b1357af 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -1819,7 +1819,8 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
>  	priv->hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
>  		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>  		IEEE80211_HW_SIGNAL_DBM |
> -		IEEE80211_HW_TIMING_BEACON_ONLY;
> +		IEEE80211_HW_TIMING_BEACON_ONLY |
> +		IEEE80211_HW_SUPPORTS_PS;
>  
>  	priv->hw->max_signal = 100;

The api changed here, and this patch doesn't apply.  Can you respin it
against the latest -rc tree and resend?

thanks,

greg k-h
