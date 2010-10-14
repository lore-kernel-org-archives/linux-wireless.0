Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26555 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0JNGJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 02:09:32 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 23:09:22 -0700
Date: Thu, 14 Oct 2010 11:39:08 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/3] ath9k_hw: remove enum wireless_mode and its users
Message-ID: <20101014060908.GC21903@vasanth-laptop>
References: <1286981008-85124-1-git-send-email-nbd@openwrt.org> <1286981008-85124-2-git-send-email-nbd@openwrt.org> <1286981008-85124-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286981008-85124-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 08:13:28PM +0530, Felix Fietkau wrote:
> +			return &ar5416_11ng_ratetable;
> +		return &ar5416_11g_ratetable;
ineffective return.
>  	case IEEE80211_BAND_5GHZ:
> -		mode = ATH9K_MODE_11A;
>  		if (is_ht)
> -			mode = ATH9K_MODE_11NA_HT20;
> -		if (is_cw_40)
> -			mode = ATH9K_MODE_11NA_HT40PLUS;
> -		break;
> +			return &ar5416_11na_ratetable;
> +		return &ar5416_11a_ratetable;
same here.

Also, legacy rate tables can be removed.

Vasanth
