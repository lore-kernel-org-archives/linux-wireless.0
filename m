Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4290 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbYEMUu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 16:50:58 -0400
Date: Tue, 13 May 2008 16:39:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, herbert@gondor.apana.org.au,
	mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080513203906.GB20269@tuxdriver.com> (sfid-20080513_225111_250878_8D4CA094)
References: <20080502.163334.148944203.davem@davemloft.net> <1209807477.3987.9.camel@johannes.berg> <1209824720.1475.6.camel@johannes.berg> <20080512.201751.114868351.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080512.201751.114868351.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 08:17:51PM -0700, David Miller wrote:

> Based upon them I will adjust LL_MAX_HEADER as follows:

> @@ -93,14 +93,16 @@ struct wireless_dev;
>   *	used.
>   */
>   
> -#if !defined(CONFIG_AX25) && !defined(CONFIG_AX25_MODULE) && !defined(CONFIG_TR)
> -#define LL_MAX_HEADER	32
> +#if defined(CONFIG_WLAN_80211) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)

Is WLAN_80211 really the right symbol here?  It applies to more than
just mac80211, and I doubt if full MAC devices need higher values.
It seems like MAC80211 would be the right symbol to add.

John
-- 
John W. Linville
linville@tuxdriver.com
