Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EKIvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:51:06 -0400
Subject: Re: [RFC PATCH 2/2] ath5k: Add support for cfg80211 antenna setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100511083910.28289.71188.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
	 <20100511083910.28289.71188.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:50:59 +0200
Message-ID: <1273567859.3669.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 17:39 +0900, Bruno Randolf wrote:

> +	if (tx_ant == 1 && rx_ant == 1)
> +		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
> +	else if (tx_ant == 2 && rx_ant == 2)
> +		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
> +	else if (tx_ant == 3 && rx_ant == 3)
> +		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
> +	else
> +		return -EOPNOTSUPP;

That should be -EINVAL, I think.

johannes

