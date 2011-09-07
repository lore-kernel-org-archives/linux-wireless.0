Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1IGMYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 08:24:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R1GVh-0000ci-SV
	for linux-wireless@vger.kernel.org; Wed, 07 Sep 2011 13:41:42 +0200
Subject: Re: [RFC 3/5] mac80211: implement uAPSD
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20110906202725.130077360@sipsolutions.net> (sfid-20110906_222826_173953_844A1DA3)
References: <20110906201703.703254041@sipsolutions.net>
	 <20110906202725.130077360@sipsolutions.net>
	 (sfid-20110906_222826_173953_844A1DA3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 13:41:41 +0200
Message-ID: <1315395701.4002.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +       ieee80211_sta_ps_deliver_response(sta, sta->sta.max_sp,
> +                                         ~delivery_enabled,
> +
> IEEE80211_FRAME_RELEASE_UAPSD);

This is bogus, sta.max_sp is in the QoS Info field format so needs to be
translated into # of frames.

> @@ -386,6 +390,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
>  	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
>  	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
> +	IEEE80211_TX_STATUS_EOSP		= BIT(27),
>  };
>  
>  #define IEEE80211_TX_CTL_STBC_SHIFT		23
> @@ -399,7 +404,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
>  	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
>  	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
> -	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
> +	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_POLL_RESPONSE |   \
>  	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
>  	IEEE80211_TX_CTL_STBC)

EOSP needs to be added to temporary flags too.

johannes

