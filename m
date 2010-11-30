Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0K3PxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:53:02 -0500
Subject: Re: [PATCH v4] mac80211/rt2x00: add ieee80211_tx_status_ni()
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
In-Reply-To: <20101130154923.GA4618@sig21.net>
References: <20101129145439.GA31910@sig21.net>
	 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
	 <20101129152735.GA32319@sig21.net>
	 <1291045056.3532.5.camel@jlt3.sipsolutions.net>
	 <20101129155126.GA32482@sig21.net>
	 <1291046320.3532.6.camel@jlt3.sipsolutions.net>
	 <20101129161316.GA32760@sig21.net>  <20101130154923.GA4618@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 16:53:00 +0100
Message-ID: <1291132380.3624.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 16:49 +0100, Johannes Stezenbach wrote:

>   * This function may not be called in IRQ context. Calls to this function
>   * for a single hardware must be synchronized against each other. Calls
> - * to this function and ieee80211_tx_status_irqsafe() may not be mixed
> - * for a single hardware.
> + * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
> + * may not be mixed for a single hardware.

I'm ok with this, although technically you can mix
ieee80211_tx_status_ni() and ieee80211_tx_status(), just not either or
both of them with _irqsafe().

johannes

