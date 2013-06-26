Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52387 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab3FZSc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 14:32:59 -0400
Message-ID: <51CB33D9.1070104@openwrt.org> (sfid-20130626_203302_156121_D0101952)
Date: Wed, 26 Jun 2013 20:32:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Use libnl-configurable values for retry counts
References: <1372267723-25072-1-git-send-email-jp.tosoni@acksys.fr>
In-Reply-To: <1372267723-25072-1-git-send-email-jp.tosoni@acksys.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-26 7:28 PM, Jean-Pierre Tosoni wrote:
> From: J.P. Tosoni <jp.tosoni@acksys.fr>
> 
> In the rate control algorithms, the maximum retry count is limited by
> a) a constant value obtained from the hardware driver
> b) a constant limit (6ms) on the time allowed for all
>    retries of each frame.
> 
> Replace the retry count by existing configurable values from nl80211.
> Use wiphy->retry_short for management frames.
> Use wiphy->retry_long for other frames.
That seems a bit arbitrary.

> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
> index ac7ef54..502d0c9 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -592,11 +592,7 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
>  	/* maximum time that the hw is allowed to stay in one MRR segment */
>  	mp->segment_size = 6000;
>  
> -	if (hw->max_rate_tries > 0)
> -		mp->max_retry = hw->max_rate_tries;
> -	else
> -		/* safe default, does not necessarily have to match hw properties */
> -		mp->max_retry = 7;
> +	mp->max_retry = hw->conf.long_frame_max_tx_count;
minstrel_alloc is called at rate control init time. You're not making
max_retry configurable here, it'll pick the default value of
hw->conf.long_frame_max_tx_count and never update it again.

- Felix
