Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0K2P6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:58:42 -0500
Subject: Re: [PATCH v2 RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20101129155126.GA32482@sig21.net>
References: <20101129145439.GA31910@sig21.net>
	 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
	 <20101129152735.GA32319@sig21.net>
	 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
	 <20101129155126.GA32482@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:58:40 +0100
Message-ID: <1291046320.3532.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 16:51 +0100, Johannes Stezenbach wrote:


> -void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
> +void __ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
> +			   int (*netif_rx_func)(struct sk_buff *skb))

This seems weird to me -- why not just do

static inline void ieee80211_tx_status_ni(...)
{
	local_bh_disable();
	ieee80211_tx_status(...);
	local_bh_enable();
}

johannes

