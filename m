Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41087 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaI2LqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 07:46:24 -0400
Message-ID: <54294687.1030307@openwrt.org> (sfid-20140929_134627_658113_AF27F8D6)
Date: Mon, 29 Sep 2014 13:46:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz@NSS2
References: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-09-29 02:38, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set, there is no
> behavioral change including in sampling and MCS_GROUP_RATES remains 8.
> When it is, MCS_GROUP_RATES is 10 and we restrict to VHT rates for stats
> readability (though it is possible to use both HT and VHT (unset
> vht_only)).
> ---
>  net/mac80211/Kconfig                       |   7 +
>  net/mac80211/rc80211_minstrel_ht.c         | 263 +++++++++++++++++++++++------
>  net/mac80211/rc80211_minstrel_ht.h         |  33 +++-
>  net/mac80211/rc80211_minstrel_ht_debugfs.c |  30 ++--
>  4 files changed, 261 insertions(+), 72 deletions(-)
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index aeb6a48..39095a9 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -33,6 +33,13 @@ config MAC80211_RC_MINSTREL_HT
>  	---help---
>  	  This option enables the 'minstrel_ht' TX rate control algorithm
>  
> +config MAC80211_RC_MINSTREL_VHT
> +	bool "Minstrel 802.11vht support" if EXPERT
This should be VHT or 802.11ac instead of 802.11vht

> +	depends on MAC80211_RC_MINSTREL_HT
> +	default n
> +	---help---
> +	  This option enables vht in the 'minstrel_ht' TX rate control algorithm
> +
>  choice
>  	prompt "Default rate control algorithm"
>  	depends on MAC80211_HAS_RC
> diff --git a/net/mac80211/rc80211_minstrel_ht.h b/net/mac80211/rc80211_minstrel_ht.h
> index 01570e0..7856062 100644
> --- a/net/mac80211/rc80211_minstrel_ht.h
> +++ b/net/mac80211/rc80211_minstrel_ht.h
> @@ -13,10 +13,33 @@
>   * The number of streams can be changed to 2 to reduce code
>   * size and memory footprint.
>   */
> -#define MINSTREL_MAX_STREAMS	3
> -#define MINSTREL_STREAM_GROUPS	4
> +#ifdef CONFIG_MAC80211_RC_MINSTREL_VHT
> +#define MINSTREL_VHT_MAX_STREAMS	2
> +#else
> +#define MINSTREL_VHT_MAX_STREAMS	0
> +#endif
> +#define MINSTREL_VHT_STREAM_GROUPS	6 /* BW(=3) * SGI(=2) */
> +
> +#define MINSTREL_HT_MAX_STREAMS		3
> +#define MINSTREL_HT_STREAM_GROUPS	4 /* BW(=2) * SGI(=2) */
I think we should get rid of MINSTREL_*_MAX_STREAMS instead of expanding
its use to VHT.

- Felix
