Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4291 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbZAIQid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:38:33 -0500
Subject: Re: [ath9k-devel] [PATCH v2 08/11] ath9k: remove (u16) casts from
 rtc register access
From: Pavel Roskin <proski@gnu.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1231503868-29226-9-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
	 <1231503868-29226-9-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:38:28 -0500
Message-Id: <1231519108.24032.1.camel@dv> (sfid-20090109_173845_915603_0384E185)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-09 at 13:24 +0100, Gabor Juhos wrote:
> The RTC register offsets don't fit into 'u16' on the AR913x, so we have
> to remove the existing casts.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
> ---
>  drivers/net/wireless/ath9k/hw.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index 088d968..742ecc1 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -1008,7 +1008,7 @@ static void ath9k_hw_init_pll(struct ath_hal *ah,
>  				pll |= SM(0xb, AR_RTC_PLL_DIV);
>  		}
>  	}
> -	REG_WRITE(ah, (u16) (AR_RTC_PLL_CONTROL), pll);
> +	REG_WRITE(ah, (AR_RTC_PLL_CONTROL), pll);

Perhaps you could remove the parentheses as well?  It looks weird
otherwise.

-- 
Regards,
Pavel Roskin
