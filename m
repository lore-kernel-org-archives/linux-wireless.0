Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:44576 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab1GNGZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 02:25:36 -0400
Date: Thu, 14 Jul 2011 09:25:22 +0300
From: Jouni Malinen <j@w1.fi>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
Message-ID: <20110714062522.GA2534@jm.kir.nu> (sfid-20110714_082539_770908_909A9DDF)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
 <1310600747-9583-6-git-send-email-thomas@cozybit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1310600747-9583-6-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 04:45:47PM -0700, Thomas Pedersen wrote:
> Even though we don't currently implement PS for mesh points, the
> standard asks us to include a TIM element in beacons. Include an empty
> element for now.

Is it allowed to not support PS in this type of case? AP does not have
such option..

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> @@ -2269,6 +2270,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
> +			pos = skb_put(skb, 6);
> +			*pos++ = WLAN_EID_TIM;
> +			*pos++ = 4;
> +			*pos++ = 0;	/* DTIM count */
> +			*pos++ = 0;	/* DTIM period */

The DTIM Period value 0 is reserved and does not really make much
sense.. Would it be better to set this to 1?

-- 
Jouni Malinen                                            PGP id EFC895FA
