Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59130 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbcBWKF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:05:28 -0500
Message-ID: <1456221926.2041.5.camel@sipsolutions.net> (sfid-20160223_110532_901091_C27E1B5D)
Subject: Re: [PATCH v2] mac80211: fix wiphy supported_band access
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Sven Eckelmann <sven@narfation.org>, nbd@openwrt.org
Date: Tue, 23 Feb 2016 11:05:26 +0100
In-Reply-To: <1455880681-6194-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160219_121803_721053_11E59082)
References: <1455880681-6194-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160219_121803_721053_11E59082)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 12:18 +0100, Lorenzo Bianconi wrote:
> Fix wiphy supported_band access in tx radiotap parsing introduced
> in commit 5ec3aed9ba4c ("mac80211: Parse legacy and HT rate in
> injected frames"). In particular, info->band is always set to 0
> (IEEE80211_BAND_2GHZ) since it has not assigned yet.
> This cause a kernel crash on 5GHz only devices.
> Move ieee80211_parse_tx_radiotap() after info->band assignment
> 
Applied.

johannes
