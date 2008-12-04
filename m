Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51015 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYLDPaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 10:30:13 -0500
Date: Thu, 4 Dec 2008 10:22:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>,
	Luis Rodriguez <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless: Incorrect LEAP authentication algorithm
	identifier.
Message-ID: <20081204152224.GA4989@tuxdriver.com> (sfid-20081204_163018_436408_8989FBA9)
References: <20081204150813.GA7816@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081204150813.GA7816@senthil-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 08:38:13PM +0530, Senthil Balasubramanian wrote:
> This patch fixes a regression introduced by
> "wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts"
> LEAP authentication algorithm identifier should be 128.
> 
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
>  include/linux/ieee80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index a6ec928..c4e6ca1 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -836,7 +836,7 @@ struct ieee80211_ht_info {
>  /* Authentication algorithms */
>  #define WLAN_AUTH_OPEN 0
>  #define WLAN_AUTH_SHARED_KEY 1
> -#define WLAN_AUTH_LEAP 2
> +#define WLAN_AUTH_LEAP 128
>  
>  #define WLAN_AUTH_CHALLENGE_LEN 128

What is the regression?  What problem does this cause?

AFAICT this value is only used internally, so it shouldn't matter
what the actual value is.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
