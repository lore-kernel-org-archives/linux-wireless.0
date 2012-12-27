Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2L0HpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 02:45:00 -0500
Message-ID: <1356594315.15149.1.camel@jlt4.sipsolutions.net> (sfid-20121227_084507_769440_2D8D74F2)
Subject: Re: Fw: [Bug 51901] New: mac80211/cfg.c:1995: possible bad call to
 memcpy ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 27 Dec 2012 08:45:15 +0100
In-Reply-To: <20121222135545.1f134c5a@samsung-9> (sfid-20121222_225554_897530_D9193457)
References: <20121222135545.1f134c5a@samsung-9>
	 (sfid-20121222_225554_897530_D9193457)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-12-22 at 13:55 -0800, Stephen Hemminger wrote:

> static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device
> *dev,
>                     int rate[IEEE80211_NUM_BANDS])
> {
>     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> 
>     memcpy(sdata->vif.bss_conf.mcast_rate, rate, sizeof(rate));

Seems fine to me. If anyone's bothered by the warning, patch welcome,
but the code is ok since it's an array.

johannes

