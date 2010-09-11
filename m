Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3496 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0IKR0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 13:26:53 -0400
Date: Sat, 11 Sep 2010 13:22:50 -0400
From: me@bobcopeland.com
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Subject: Re: [PATCH 3/8] ath5k: Use common ath key management functions
Message-ID: <20100911172250.GE20385@hash.localnet>
References: <20100908070427.11255.17659.stgit@tt-desk> <20100908070443.11255.13951.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100908070443.11255.13951.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 08, 2010 at 04:04:43PM +0900, Bruno Randolf wrote:
> Use common ath key management functions in ath5k. This fixes problems with HW
> encryption in AP mode, which was broken in the ath5k implementation.

We went from this:

> -		key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
> -			       IEEE80211_KEY_FLAG_GENERATE_MMIC);

to:

> +			/* push IV and Michael MIC generation to stack */
> +			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
> +			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
> +				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;

There's no need to special case the flags based on whether the
cipher is TKIP; mac80211 does this already.

> +			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
> +				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;

Ditto, this already only affects CCMP in mac80211 (btw, why can't we do
management frames in hardware?) so it can be more simply written as:

key->flags |= (IEEE80211_KEY_FLAG_GENERATE_IV |
               IEEE80211_KEY_FLAG_GENERATE_MMIC |
               IEEE80211_KEY_FLAG_SW_MGMT);

-- 
Bob Copeland %% www.bobcopeland.com

