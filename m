Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:58944 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751725AbcD3Dwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 23:52:47 -0400
Subject: Re: [PATCH] ath9k: Fix symbol overlap window for half/quarter
 channels
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <1461935194-19632-1-git-send-email-helmut.schaa@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <57242BFD.4060605@openwrt.org> (sfid-20160430_055251_174736_EF408FCB)
Date: Sat, 30 Apr 2016 10:52:29 +0700
MIME-Version: 1.0
In-Reply-To: <1461935194-19632-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-29 20:06, Helmut Schaa wrote:
> Since commit cd6cfd7311a385144a2f9c74f692ae2df3ae033f
> "ath9k: do not set half/quarter channel flags in AR_PHY_MODE" the
> condition "rfMode & (AR_PHY_MODE_QUARTER | AR_PHY_MODE_HALF)" would
> never evaluate to true.
> 
> Fix this by using the available IS_CHAN_HALF_RATE and IS_CHAN_QUARTER_RATE
> marcros instead.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Felix Fietkau <nbd@openwrt.org>
> ---
> Just stumbled over that piece of code while looking into TX99, so
> this is only compile-tested.
> 
> Felix, can you please confirm if this is correct or if removing
> the whole block would be better?
This patch looks good to me.
Acked-by: Felix Fietkau <nbd@openwrt.org>
