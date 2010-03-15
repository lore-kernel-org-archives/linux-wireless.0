Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59059 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab0COVnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 17:43:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 14:43:40 -0700
Date: Mon, 15 Mar 2010 14:43:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
Message-ID: <20100315214338.GB4000@tux>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 12, 2010 at 09:46:44PM -0800, Luis R. Rodriguez wrote:
>   * I spotted a check added to bail out for tweaking the ACK/CTS
>     time out values -- this check should no longer be required
>     since Felix sent a proper fix for this recenlty. I removed that
>     hunk:
> 
> @@ -1210,6 +1195,9 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>  		REG_WRITE(ah, AR_PCU_MISC,
>  			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
>  
> +	if (AR_SREV_9271(ah))
> +		return;
> +
>  	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
>  		sifstime = 16;
>  	else
> --

Turns out this hunk is required... but the rf changes are not (patch 4/12)
so I'll just respin and send a new series out.

We should look for a better way to address this issue instead of the above hunk
otherwise we will be skipping all changes to the slot time from mac80211.
Right now ath9k_htc does not support this (BSS_CHANGED_ERP_SLOT) or a 
set_coverage_class() callback.

  Luis
