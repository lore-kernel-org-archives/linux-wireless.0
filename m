Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43553 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaKXWAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 17:00:11 -0500
Date: Mon, 24 Nov 2014 16:53:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] brcmutil: add helper function to format board
 revision
Message-ID: <20141124215352.GB4484@tuxdriver.com> (sfid-20141124_230019_646812_6EB77B58)
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
 <1416518822-29585-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416518822-29585-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am holding patches 2-4 until we resolve the brcmu_boardrev_str
build thing...

On Thu, Nov 20, 2014 at 10:27:00PM +0100, Arend van Spriel wrote:
> The board revision that is available in hardware can be translated
> so it matches the labelling on the board. This is accomplished by
> this helper function.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmutil/utils.c      | 16 ++++++++++++++++
>  drivers/net/wireless/brcm80211/include/brcmu_utils.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
> index 0f7e1c7..af97f8b 100644
> --- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
> +++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
> @@ -292,4 +292,20 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
>  	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data, size);
>  }
>  EXPORT_SYMBOL(brcmu_dbg_hex_dump);
> +
> +/* Produce a human-readable string for boardrev */
> +char *brcmu_boardrev_str(u32 brev, char *buf)
> +{
> +	char c;
> +
> +	if (brev < 0x100) {
> +		snprintf(buf, 8, "%d.%d", (brev & 0xf0) >> 4, brev & 0xf);
> +	} else {
> +		c = (brev & 0xf000) == 0x1000 ? 'P' : 'A';
> +		snprintf(buf, 8, "%c%03x", c, brev & 0xfff);
> +	}
> +	return buf;
> +}
> +EXPORT_SYMBOL(brcmu_boardrev_str);
> +
>  #endif				/* defined(DEBUG) */
> diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
> index 8ba445b..a043e29 100644
> --- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
> +++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
> @@ -218,4 +218,6 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
>  }
>  #endif
>  
> +char *brcmu_boardrev_str(u32 brev, char *buf);
> +
>  #endif				/* _BRCMU_UTILS_H_ */
> -- 
> 1.9.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
