Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2F2Gsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 02:48:53 -0400
Message-ID: <1340952528.4488.1.camel@jlt3.sipsolutions.net> (sfid-20120629_084856_523622_8462D7F6)
Subject: Re: [PATCH] brcmsmac: restructure info->control.sta handling as it
 is goning to be removed soon.
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com, linville@tuxdriver.com
Date: Fri, 29 Jun 2012 08:48:48 +0200
In-Reply-To: <1340943304-70933-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_061650_559847_B79CE9A9)
References: <1340943304-70933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120629_061650_559847_B79CE9A9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 21:15 -0700, Thomas Huehn wrote:
> @@ -267,7 +267,9 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
>  static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>  	struct brcms_info *wl = hw->priv;
> +	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>  
> +	tx_info->rate_driver_data[0] = tx_info->control.sta;

It seems that brcmsmac doesn't care about anything but the
tx_info->flags, but it would still seem safer to overwrite the data
before the function returns, rather than as the first thing?

johannes

