Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1IFM0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 08:26:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R0ujK-0006GD-4a
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 14:26:18 +0200
Subject: Re: [RFC 2/3] mac80211: unify TIM bit handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110906121534.491842279@sipsolutions.net> (sfid-20110906_141651_215347_47149ADC)
References: <20110906121421.460641040@sipsolutions.net>
	 <20110906121534.491842279@sipsolutions.net>
	 (sfid-20110906_141651_215347_47149ADC)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 14:26:18 +0200
Message-ID: <1315311978.26306.0.camel@jlt3.sipsolutions.net> (sfid-20110906_142623_126207_B2C7E9BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +void sta_info_recalc_tim(struct sta_info *sta)
>  {

> -	__bss_tim_clear(bss, sta->sta.aid);
> +	spin_lock_irqsave(&local->sta_lock, flags);
>  
> -	if (sta->local->ops->set_tim) {
> -		sta->local->tim_in_locked_section = true;
> -		drv_set_tim(sta->local, &sta->sta, false);
> -		sta->local->tim_in_locked_section = false;
> +	have_data = test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF) ||
> +		    !skb_queue_empty(&sta->tx_filtered) ||
> +		    !skb_queue_empty(&sta->ps_tx_buf);

I'll move the locking to after the have_data check, it's not needed
around it.

johannes

