Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1GNJw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 05:52:27 -0400
Subject: Re: [PATCH 5/5] mac80211: mesh beacon includes TIM IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310600747-9583-6-git-send-email-thomas@cozybit.com> (sfid-20110714_014638_433123_1C508A2C)
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	 <1310600747-9583-6-git-send-email-thomas@cozybit.com>
	 (sfid-20110714_014638_433123_1C508A2C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 11:52:24 +0200
Message-ID: <1310637144.3874.2.camel@jlt3.sipsolutions.net> (sfid-20110714_115230_003715_60D3C598)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 16:45 -0700, Thomas Pedersen wrote:

>  			goto out;
> @@ -2269,6 +2270,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
>  			memcpy(skb_put(skb, beacon->head_len), beacon->head,
>  			       beacon->head_len);
>  
> +			pos = skb_put(skb, 6);

You just keep adding here -- how is the length of the skb determined?

johannes

