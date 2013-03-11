Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab3CKRGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 13:06:48 -0400
Date: Mon, 11 Mar 2013 18:07:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: fixes for virtual monitor add/remove on
 suspend
Message-ID: <20130311170712.GB1430@redhat.com> (sfid-20130311_180652_690586_A6D116E0)
References: <1363021279-9809-1-git-send-email-sgruszka@redhat.com>
 <1363021279-9809-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363021279-9809-2-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 11, 2013 at 06:01:19PM +0100, Stanislaw Gruszka wrote:
> Change suspend/resume and add/remove virtual monitor code (called at
> ieee80211_do_stop) to avoid calling drv callback while we are suspended.
[snip]
> -	if (sdata && ieee80211_sdata_running(sdata))
> -		ieee80211_assign_chanctx(local, sdata);
> +	if (sdata) {
> +		res = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
> +						IEEE80211_CHANCTX_EXCLUSIVE);
> +		if (WARN_ON(res)) {
> +			drv_remove_interface(local, sdata);
> +			rcu_assign_pointer(local->monitor_sdata, NULL);
> +			synchronize_net();
> +			kfree(sdata);
> +		}
Hmm, this probably shouldn't be changed for hw restart case.

Stanislaw
