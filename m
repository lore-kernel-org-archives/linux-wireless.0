Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:40070 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850Ab1JLIuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:50:39 -0400
Date: Wed, 12 Oct 2011 11:50:30 +0300
From: Jouni Malinen <j@w1.fi>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Subject: Re: [RFC 01/07] wireless-next: WAPI support for hardware-accelerated
 drivers
Message-ID: <20111012085030.GA3698@jm.kir.nu> (sfid-20111012_105042_998869_9D76C9FF)
References: <op.v27rufm9ya27un@edmitar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <op.v27rufm9ya27un@edmitar>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2011 at 03:02:29AM +0200, Dmitry Tarnyagin wrote:
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> @@ -1551,12 +1552,14 @@ enum ieee80211_sa_query_action {
>  #define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
>  #define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
>  #define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
> +#define WLAN_CIPHER_SUITE_SMS4		0x000FAC07
> 
>  /* AKM suite selectors */
>  #define WLAN_AKM_SUITE_8021X		0x000FAC01
>  #define WLAN_AKM_SUITE_PSK		0x000FAC02
>  #define WLAN_AKM_SUITE_SAE			0x000FAC08
>  #define WLAN_AKM_SUITE_FT_OVER_SAE	0x000FAC09
> +#define WLAN_AKM_SUITE_WAPI_PSK		0x000FAC03

Where do these values come from?

00-0F-AC:7 cipher suite selector has already been allocated for other
purposes ("Group addressed traffic not allowed") and similarly, AKM
suite 00-0F-AC:3 is already in use ("FT authentication negotiated over
IEEE 802.1X"). The 00-0F-AC OUI is managed by IEEE 802.11 and you cannot
just pick a random suite type from that OUI and hope for the best. This
will result in conflicts with other uses.

These need to be either allocated by IEEE 802.11 ANA or maybe more
likely, by any vendor that has their own OUI could allocate a unique
identifier for this purpose.

-- 
Jouni Malinen                                            PGP id EFC895FA
