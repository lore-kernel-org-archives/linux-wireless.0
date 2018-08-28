Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50712 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1Mj0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:39:26 -0400
Message-ID: <1535446120.5895.6.camel@sipsolutions.net> (sfid-20180828_104852_770265_6B1E6683)
Subject: Re: [PATCH v6 3/3] mac80211: Fix PTK rekey freezes and cleartext
 leaks
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 10:48:40 +0200
In-Reply-To: <20180814104255.4183-4-alexander@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-4-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 12:42 +0200, Alexander Wetzel wrote:
> 
> +	/* PTK only using key ID 0 needs special handling on rekey */
> +	if (new_key && sta && ptk0rekey) {
> +		local = old_key->local;
> +		sdata = old_key->sdata;
> +
> +		/* Stop TX till we are on the new key */
> +		old_key->flags |= KEY_FLAG_TAINTED;
> +		ieee80211_clear_fast_xmit(sta);
> +
> +		/* Aggregation sessions during rekey are complicated due to
> +		 * the reorder buffer. Side step that by blocking aggregation
> +		 * and tear down running connections.
> +		 */
> +		if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
> +			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
> +			ieee80211_sta_tear_down_BA_sessions(sta,
> +							    AGG_STOP_LOCAL_REQUEST);
> +		}
> +
> +		if (new_key->local->ops->replace_key) {
> +			ret = drv_replace_key(old_key->local, sdata,
> +					      &sta->sta, &old_key->conf,
> +					      &new_key->conf);
> +			if (!ret)
> +				new_key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
> +			else
> +				sdata_err(sdata,
> +					  "failed to replace key (%d) for " \
> +					  "STA (%pM) in hardware: ret=(%d)\n",
> +					  old_key->conf.keyidx,
> +					  sta->sta.addr,
> +					  ret);
> +
> +			old_key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
> +		} else {
> +			sdata_info(sdata,
> +				   "Userspace requested a PTK rekey for STA " \
> +				   "%pM while feature not supported! " \
> +				   "This may leak clear text packets or " \
> +				   "freeze the connection.",
> +				   sta->sta.addr);

This seems a bit weird - we know a likely dangerous thing is happening
and only print an info message? Why not just prevent this in the first
place?

johannes
