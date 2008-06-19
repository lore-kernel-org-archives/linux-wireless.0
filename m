Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:10151 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbYFSXcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:32:20 -0400
Received: by py-out-1112.google.com with SMTP id p76so454286pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 16:32:20 -0700 (PDT)
Subject: Re: [PATCH 2/3] mac80211: get rid of function pointers in TX path
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080619232434.586735000@sipsolutions.net>
References: <20080619232229.202159000@sipsolutions.net>
	 <20080619232434.586735000@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 16:32:01 -0700
Message-Id: <1213918321.6591.4.camel@brick> (sfid-20080620_013226_097297_B90C8F2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-20 at 01:22 +0200, Johannes Berg wrote:
> +#define CALL_TXH(txh)		\
> +	res = txh(tx);		\
> +	if (res != TX_CONTINUE)	\
> +		goto txh_done;
> +
> +	CALL_TXH(ieee80211_tx_h_check_assoc)
> +	CALL_TXH(ieee80211_tx_h_sequence);
> +	CALL_TXH(ieee80211_tx_h_ps_buf);
> +	CALL_TXH(ieee80211_tx_h_select_key);
> +	CALL_TXH(ieee80211_tx_h_michael_mic_add);
> +	CALL_TXH(ieee80211_tx_h_rate_ctrl);
> +	CALL_TXH(ieee80211_tx_h_misc);
> +	CALL_TXH(ieee80211_tx_h_fragment);
> +	/* handlers after fragment must be aware of tx info fragmentation! */
> +	CALL_TXH(ieee80211_tx_h_encrypt);
> +	CALL_TXH(ieee80211_tx_h_calculate_duration);
> +	CALL_TXH(ieee80211_tx_h_stats);
> +#undef CALL_TXH

Unnecessary ; after each CALL_TXH()...except the first.

Same thing for 3/3 on the receive side.

Other than that (small) bit, looks ok at first glance.

Harvey

