Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:52056 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752763AbdBUOv5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:51:57 -0500
Date: Tue, 21 Feb 2017 16:43:35 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Subject: Re: [RFC v2 1/2] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
Message-ID: <20170221144335.GA17601@w1.fi> (sfid-20170221_155200_827299_F158FFB2)
References: <20170221123758.5339-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221123758.5339-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2017 at 01:37:57PM +0100, Johannes Berg wrote:
> Add a new NL80211_ATTR_PMK attribute that might be passed as part
> of NL80211_CMD_CONNECT command, and contain the PSK (which is the
> PMK, hence the name.)

> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> +#define WLAN_PMK_LEN			32

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>  struct cfg80211_crypto_settings {
> +	const u8 *psk;

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> +	[NL80211_ATTR_PMK] = { .len = WLAN_PMK_LEN },

While the existing WPA2-PSK cases all use 32 octet PMK, there are also
48 octet PMKs in use with EAP (Suite B 192-bit level and FILS with
SHA384). Patch 2/2 seemed to look at the PMK length as well.. Should the
same be done already with 1/2 so that the PSK case is separately
validating exact match with 32 octets in length for PMK = PSK while the
other cases allow longer PMK as well?

I never remember how the attr policy .len works, so that may already be
the implicit behavior here, but it would be clearer to be more explicit
about the possible lengths of the WLAN_ATTR_PMK and not assume that
WLAN_PMK_LEN definition is the only possible option.

-- 
Jouni Malinen                                            PGP id EFC895FA
