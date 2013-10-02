Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3JBIof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:44:35 -0400
Message-ID: <1380703470.13329.1.camel@jlt4.sipsolutions.net> (sfid-20131002_104438_731250_A9BA0C32)
Subject: Re: [PATCH] nl80211: Provide per channel maximum regulatory
 transmit power
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Oct 2013 10:44:30 +0200
In-Reply-To: <1380699789-3765-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20131002_094321_138487_B88345D4)
References: <1380699789-3765-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20131002_094321_138487_B88345D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 09:43 +0200, Helmut Schaa wrote:
> In some cases its not only required to know the maximum transmit power
> the hw is capable of. Instead, userspace (hostapd) might want to know
> the maximum transmit power as defined in the current regulatory domain
> (for example for 802.11d country IEs).

Why wouldn't it use (the equivalent of) "iw reg get" for that?


> +	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_REG_TX_POWER,
> +			DBM_TO_MBM(chan->max_reg_power)))
> +		goto nla_put_failure;

This would have to go into the "if (large)" part because otherwise older
userspace can't read the info at all since it overflows the buffer.

johannes

