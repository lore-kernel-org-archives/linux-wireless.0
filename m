Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0I1Ltz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 07:49:55 -0400
Subject: Re: [PATCH] mac80211: Fix WMM driver queue configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1285673972-10502-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1285673972-10502-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 13:49:49 +0200
Message-ID: <1285674589.3885.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 14:39 +0300, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The WMM parameter configuration function (ieee80211_sta_wmm_params) only
> configures the WMM parameters to the driver is the wmm_last_param_set
> counter value is changed by the AP.
> 
> The wmm_last_param_set is initialized to -1 on association in order to ensure
> the configuration is made to the driver at least once on association, but
> currently this initialization is done *after* the WMM parameter configuration
> function was called.
> 
> This leads to unreliability in the driver getting properly configured on first
> association (depending on what counter value the AP happens to use.) When
> disassociating (the wmm default parameters are configured to the driver) and
> then reassociating, due to the above the WMM configuration is not set to the
> driver at all.
> 
> On drivers without beacon filtering the problem is corrected by later beacons,
> but on drivers with beacon filtering the WMM will remain permanently incorrectly
> configured.
> 
> Fix this by moving the initialization of wmm_last_param_set to -1 before
> ieee80211_sta_wmm_params is called on association.

Good catch!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

