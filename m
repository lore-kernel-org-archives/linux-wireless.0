Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45785 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaBCCKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 21:10:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21230.64089.741.909535@gargle.gargle.HOWL> (sfid-20140203_031019_422030_D3326D61)
Date: Mon, 3 Feb 2014 07:39:28 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] ath9k_htc: add rx header converter to make it usable by ath9k
In-Reply-To: <1391022424-21087-4-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
	<1391022424-21087-1-git-send-email-linux@rempel-privat.de>
	<1391022424-21087-4-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> +	rx_stats = kzalloc(sizeof(struct ath_rx_status), GFP_KERNEL);
> +	if (unlikely(rx_stats == NULL)) {
> +		ath_err(common, "rx_stats allocation filed!\n");
> +		goto err_nofree;
> +	}
> +	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
> +

This seems a little expensive, since this would happen for every packet,
and a memcpy is already done earlier, for storing the RX status in
rxbuf->rxstatus. Instead of using 'struct ath_htc_rx_status' in
'struct ath9k_htc_rxbuf', why can't 'struct ath_rx_status' be used ?
The values can be converted and stored directly, avoiding this alloc.

Sujith

