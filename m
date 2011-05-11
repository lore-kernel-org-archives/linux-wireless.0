Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1EKCXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 22:23:04 -0400
Date: Tue, 10 May 2011 19:23:09 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath6kl: iw dev wlan0 link implementation
Message-ID: <20110511022309.GA8427@suse.de> (sfid-20110511_042313_765671_BBC8D0BF)
References: <20110511020257.1752.97603.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110511020257.1752.97603.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 11, 2011 at 05:02:57AM +0300, Kalle Valo wrote:
> From: Naveen Singh <nsingh@atheros.com>
> 
> implementing the cfg ops that gets called when iw dev wlan0
> link is issued by user. The ops that needs to be implemented
> is get_station.
> 
> kvalo: check the mac address, remove signal_pending() and fix style issues
> 
> Signed-off-by: Naveen Singh <nsingh@atheros.com>
> Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
> ---
>  drivers/staging/ath6kl/os/linux/cfg80211.c |  128 ++++++++++++++++++++++++++++
>  1 files changed, 128 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
> index efd4ae5..3a89e33 100644
> --- a/drivers/staging/ath6kl/os/linux/cfg80211.c
> +++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
> @@ -1460,6 +1460,133 @@ u32 cipher_suites[] = {
>      WLAN_CIPHER_SUITE_CCMP,
>  };
>  
> +bool is_rate_legacy(s32 rate)
> +{
> +	static const s32 legacy[] = { 1000, 2000, 5500, 11000,
> +				      6000, 9000, 12000, 18000, 24000,
> +				      36000, 48000, 54000 };
> +	u8 i;
> +
> +	for (i = 0; i < 12; i++) {

Please use ARRAY_SIZE for this, and your other loop variables to ensure
that you got it right.

thanks,

greg k-h
