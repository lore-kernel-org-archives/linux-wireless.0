Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60320 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932952Ab2FVOhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 10:37:09 -0400
Message-ID: <1340375828.31821.11.camel@joe2Laptop> (sfid-20120622_163725_973326_440DEFC6)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 22 Jun 2012 07:37:08 -0700
In-Reply-To: <1340370882-9258-5-git-send-email-johannes@sipsolutions.net>
References: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
	 <1340370882-9258-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 15:14 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a few things that make the debugging
> in mac80211 painful:
>  * pr_debug makes it require *both* Kconfig and
>    dynamic configuration -- move to pr_info

pr_info can clutter the log.

>  * the macros still need trailing newlines

That's not a bad thing.


> @@ -317,7 +318,7 @@ ieee80211_agg_splice_packets(struct ieee80211_sub_if_data *sdata,
>  	ieee80211_stop_queue_agg(sdata, tid);
>  
>  	if (WARN(!tid_tx, "TID %d gone but expected when splicing aggregates"
> -			  " from the pending queue\n", tid))
> +			  " from the pending queue", tid))


defective.

Don't remove newlines in single modules.

Using a single style _with_ a newline limits defects and
limits the likely misuse in other styles.


