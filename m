Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaAUOzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 09:55:20 -0500
Message-ID: <1390316116.6199.23.camel@jlt4.sipsolutions.net> (sfid-20140121_155523_429133_C13CAFA5)
Subject: Re: [PATCH 1/7] mac80211: fix possible memory leak on AP CSA failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jan 2014 15:55:16 +0100
In-Reply-To: <1390227670-19030-2-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152540_538746_94EBCBD5)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_152540_538746_94EBCBD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> If CSA for AP interface failed and the interface
> was not stopped afterwards another CSA request
> would leak sdata->u.ap.next_beacon.

>  void ieee80211_csa_finish(struct ieee80211_vif *vif)
>  {
>  	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> @@ -3019,15 +3034,9 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>  	sdata->vif.csa_active = false;
>  	switch (sdata->vif.type) {
>  	case NL80211_IFTYPE_AP:
> -		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
> +		err = ieee80211_ap_finish_csa(sdata);
>  		if (err < 0)
>  			return;
> -
> -		changed |= err;

This looks a bit like somebody had intended to batch the
ieee80211_bss_info_change_notify() calls, which would probably be a good
thing. You're breaking them apart even further - maybe we should
actually batch them instead by moving ieee80211_bss_info_change_notify()
after the switch()?

johannes

