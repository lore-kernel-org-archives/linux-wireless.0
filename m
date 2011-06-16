Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3836 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1FPJIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 05:08:20 -0400
Message-ID: <4DF9C7F0.9090308@broadcom.com> (sfid-20110616_110823_643992_0317DACF)
Date: Thu, 16 Jun 2011 11:08:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Pavel Roskin" <proski@gnu.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if
 rate_lowest_index() fails
References: <20110615220252.1918.73638.stgit@mj.roinet.com>
In-Reply-To: <20110615220252.1918.73638.stgit@mj.roinet.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2011 12:02 AM, Pavel Roskin wrote:
> WARN_ON is not enough, as we cannot return a valid index, and the
> callers will use whatever we return, causing a cascade of oopses and
> eventually a panic.
>
> Signed-off-by: Pavel Roskin<proski@gnu.org>
> ---
>   0 files changed, 0 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index e33fe79..d117019 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -3108,10 +3108,10 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
>   		if (rate_supported(sta, sband->band, i))
>   			return i;
>
> -	/* warn when we cannot find a rate. */
> -	WARN_ON(1);
> +	/* If we cannot find any rate, we are in trouble. */
> +	BUG_ON(1);
>
> -	return 0;
> +	return -EINVAL;
>   }

I would expect some description what the caller should do when -EINVAL 
is returned. Could even argue whether you want a BUG_ON or allow the 
caller (driver) to reset the hardware, reassociate, etc. upon -EINVAL. I 
am not sure under which circumstances this could happen so there may 
really be no way out.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


