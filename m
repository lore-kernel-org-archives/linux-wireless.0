Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47999 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1I2J7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 05:59:48 -0400
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110929_112749_887836_A27DE080)
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110929_112749_887836_A27DE080)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 11:59:35 +0200
Message-ID: <1317290375.3974.1.camel@jlt3.sipsolutions.net> (sfid-20110929_115951_929105_4F9AE0DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-29 at 11:27 +0200, Helmut Schaa wrote:
> Allow injected unicast frames to be sent without having to wait
> for an ACK.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> Just in case you're interested in what's the intended purpose of this:
> 
> Some clients are staying on scanned channels for a very short period of
> time. hostapd sends out probe responses for each configured BSSID. Under
> some circumstances I can see that the client already left the channel
> while some probe responses are still sent out and thus retried. This 
> consumes quite some airtime. Commercial wireless APs (Aruba for example)
> seem to disable retries for probe responses to mitigate such issues.

Makes sense, but I wonder if we really should continue using
radiotap :-) Maybe mgmt-tx in nl80211 would be appropriate.

> @@ -1257,7 +1265,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>  		tx->flags |= IEEE80211_TX_UNICAST;
>  		if (unlikely(local->wifi_wme_noack_test))
>  			info->flags |= IEEE80211_TX_CTL_NO_ACK;
> -		else
> +		else if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
>  			info->flags &= ~IEEE80211_TX_CTL_NO_ACK;

??

johannes

