Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:45116 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751365Ab3KFXx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 18:53:29 -0500
Message-ID: <1383782013.7940.41.camel@joe-AO722> (sfid-20131107_005332_836932_D073F2C9)
Subject: Re: [PATCH 6/7] brcmfmac: reduce logging noise accessing SDIO
 SleepCSR register
From: Joe Perches <joe@perches.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 06 Nov 2013 15:53:33 -0800
In-Reply-To: <1383775642-647-7-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
	 <1383775642-647-7-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 23:07 +0100, Arend van Spriel wrote:
> The SleepCSR register is accessed to wakeup the device from the
> host side. Depending on the state of the device this may take
> multiple attempts. The failed attempt are not real failures so
> reduce the log level specifically for this register. The calling
> function will scream when the multiple attempts all failed.
[]
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
[]
> +	if (err_ret) {

Maybe better as:

	if (err_ret && net_ratelimit()) { ?

> +		/*
> +		 * SleepCSR register access can fail when
> +		 * waking up the device so reduce this noise
> +		 * in the logs.
> +		 */
> +		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
> +			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
> +				  rw ? "write" : "read", func, regaddr, *byte,
> +				  err_ret);
> +		else
> +			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
> +				  rw ? "write" : "read", func, regaddr, *byte,
> +				  err_ret);
> +	}


