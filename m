Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2DASpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 14:45:19 -0400
Message-ID: <1333305916.3703.2.camel@jlt3.sipsolutions.net> (sfid-20120401_204551_365522_3216618F)
Subject: Re: [RFC] mac80211:  Support on-channel scan option.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Apr 2012 20:45:16 +0200
In-Reply-To: <1333233041-3246-1-git-send-email-greearb@candelatech.com> (sfid-20120401_003057_469452_61057064)
References: <1333233041-3246-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120401_003057_469452_61057064)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-03-31 at 15:30 -0700, greearb@candelatech.com wrote:


>  static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>  				  struct cfg80211_scan_request *req)
> @@ -438,6 +461,33 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>  	local->scan_req = req;
>  	local->scan_sdata = sdata;
>  
> +	/* If we are scanning only on the current channel, then
> +	 * we do not need to stop normal activities
> +	 */
> +	if ((req->n_channels == 1) &&
> +	    (req->channels[0]->center_freq ==
> +	     local->hw.conf.channel->center_freq)) {
...
> +		return 0;
> +	}
> +
>  	if (local->ops->hw_scan)
>  		__set_bit(SCAN_HW_SCANNING, &local->scanning);

Clearly, you're joking.

johannes

