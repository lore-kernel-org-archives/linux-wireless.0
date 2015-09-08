Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46832 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbbIHQmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 12:42:11 -0400
Message-ID: <1441730528.1906.19.camel@sipsolutions.net> (sfid-20150908_184219_812199_D19AFDAE)
Subject: Re: [PATCH 2/2] mac80211: Copy tx'ed beacons to monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Date: Tue, 08 Sep 2015 18:42:08 +0200
In-Reply-To: <1441193011-2040-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20150902_132536_818116_B46E2197)
References: <1441193011-2040-1-git-send-email-helmut.schaa@googlemail.com>
	 <1441193011-2040-2-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20150902_132536_818116_B46E2197)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I applied patch 1, but 

> +	/* send a copy to monitor interfaces */
> +	if (!ieee80211_hw_check(hw, BEACON_TX_STATUS) &&
> +	    hw_to_local(hw)->monitors) {
> +		struct sk_buff *copy = skb_copy(bcn, GFP_ATOMIC);
> +		if (copy) {
> +			shift = ieee80211_vif_get_shift(vif);
> +			sband = hw->wiphy
> ->bands[ieee80211_get_sdata_band(vif_to_sdata(vif))];
> +			ieee80211_tx_monitor(hw_to_local(hw), copy, 
> sband, 1, shift, false);
> +		}
> +	}
> +
> 
Please add a blank line after declarations and try to get shorter lines
here.

johannes
