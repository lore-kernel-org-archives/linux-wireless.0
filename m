Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49907 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1DKG3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 02:29:35 -0400
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/7] ath5k: optimize tx descriptor setup
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 11 Apr 2011 09:29:28 +0300
In-Reply-To: <1302453139-11437-1-git-send-email-nbd@openwrt.org> (Felix Fietkau's message of "Sun\, 10 Apr 2011 18\:32\:13 +0200")
Message-ID: <87fwppmhbr.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Use local variables to reduce the number of load/store operations on uncached
> memory.

A comment in the code would be nice as well. Otherwise later on
someone decides to "optimise" and remove the local variables :)

>  	/* Clear descriptor */
> -	memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
> +	memset(&desc->ud.ds_tx5212.tx_stat, 0,
> +	       sizeof(desc->ud.ds_tx5212.tx_stat));

Is this an unrelated change? Or maybe I just missed something.

-- 
Kalle Valo
