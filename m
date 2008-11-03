Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42166 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbYKCNfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 08:35:31 -0500
Subject: Re: [PATCH] ath5k: fix detection of jumbo frames
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-kernel@vger.kernel.org,
	michael+ath5k@stapelberg.de
In-Reply-To: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 08:35:28 -0500
Message-Id: <1225719328.3575.9.camel@dv> (sfid-20081103_143537_667785_2A4FDC93)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-11-02 at 14:08 -0500, Bob Copeland wrote:
> Set ath5k_rs_status.rs_more using mask + shift.  rs_more is a
> u8, but we were setting it with a bitwise AND of a 16 bit value.
> As a consequence, jumbo frames would not be discarded as intended.
> Then, because the hw rate value of such frames is zero, and, since
> 63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup",
> we do not fall back to the basic rate, such packets would trigger
> the following WARN_ON:

Thanks for catching it!  Please mention rs_antenna in addition to
rs_more.

> -	rs->rs_antenna = rx_status->rx_status_0 &
> -		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
> -	rs->rs_more = rx_status->rx_status_0 &
> -		AR5K_5210_RX_DESC_STATUS0_MORE;
> +	rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
> +		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
> +	rs->rs_more = AR5K_REG_MS(rx_status->rx_status_0,
> +		AR5K_5210_RX_DESC_STATUS0_MORE);

rs_more should be boolean.  It would be better to use "!!" to calculate
rs_rate.  No need to shift anything.  As for rs_antenna, it's fine with
me.

> +#define AR5K_5212_RX_DESC_STATUS0_DECOMP_CRC_ERROR_S	13

This doesn't belong to the patch.  It looks like it's another boolean
value, but it's not currently used.

-- 
Regards,
Pavel Roskin
