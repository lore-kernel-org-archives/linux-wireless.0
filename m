Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54763 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbbCCJXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:23:34 -0500
Message-ID: <1425374612.2450.22.camel@sipsolutions.net> (sfid-20150303_102339_042959_041019AB)
Subject: Re: [PATCH 2/3] mac80211: IBSS fix scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Mar 2015 10:23:32 +0100
In-Reply-To: <1424533961-3869-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150221_165301_817676_E828A7F3)
References: <1424533961-3869-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1424533961-3869-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150221_165301_817676_E828A7F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-02-21 at 16:52 +0100, Janusz Dziedzic wrote:
> In case of wide bandwidth scan all channels we have
> in chandef, not only control one.

I think you should say why :)


> @@ -1381,11 +1450,18 @@ static void ieee80211_sta_find_ibss(struct
> ieee80211_sub_if_data *sdata)
>         /* Selected IBSS not found in current scan results - try to
> scan */
>         if (time_after(jiffies, ifibss->last_scan_completed +
>                                         IEEE80211_SCAN_INTERVAL)) {
> +               struct ieee80211_channel *channels[8];
> +               unsigned int num = 0;

no need to initialize 'num' here.

johannes

