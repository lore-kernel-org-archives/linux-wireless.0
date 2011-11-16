Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1KPPh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 10:37:59 -0500
Date: Wed, 16 Nov 2011 16:39:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Subject: Re: [PATCH 1/3] mac80211: Minor optimization in minstrel_ht tx
 status path
Message-ID: <20111116153929.GA5490@redhat.com> (sfid-20111116_163802_860401_6B2C1F4E)
References: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 14, 2011 at 03:28:18PM +0100, Helmut Schaa wrote:
> @@ -421,8 +421,8 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
>  		mi->sample_packets += info->status.ampdu_len;
>  
>  	for (i = 0; !last; i++) {
> -		last = (i == IEEE80211_TX_MAX_RATES - 1) ||
> -		       !minstrel_ht_txstat_valid(&ar[i + 1]);
> +		last = !minstrel_ht_txstat_valid(&ar[i + 1]) ||
> +		       (i == IEEE80211_TX_MAX_RATES - 1);
This make possible that we read outsite from ar[] border. Normally 
that should not couse any troubles, but I think it could confuse
something like kmemcheck. Perhaps whould be better to just add
unlikely(i == IEEE80211_TX_MAX_RATES - 1) ?

Stanislaw
