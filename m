Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56652 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbcCCPq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:46:26 -0500
Message-ID: <1457019983.2044.29.camel@sipsolutions.net> (sfid-20160303_164630_302559_0B9E8F63)
Subject: Re: [PATCH] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
	mohammed@codeaurora.org
Date: Thu, 03 Mar 2016 16:46:23 +0100
In-Reply-To: <1456927710-32073-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1456927710-32073-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 19:38 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'
> This flag will be set when drivers can fill rx_duration ( approximate
> total air time(usecs) for unicast data/management frames from the
> connected client) via 'drv_sta_statistics' callback

So, what's that useful for?

Are you really sure you mean "unicast"? What if the station is the AP?
Why wouldn't multicast frames it transmitted be accounted for?

> Also make sta_info flags 'filled' as 64 bit to accomodate for new

typo: accommodate

johannes
