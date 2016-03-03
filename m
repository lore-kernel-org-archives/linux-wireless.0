Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbcCCQBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 11:01:03 -0500
Date: Thu, 3 Mar 2016 21:30:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160303160048.GA5243@atheros-ThinkPad-T61> (sfid-20160303_170122_835904_D19CB155)
References: <1456927710-32073-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457019983.2044.29.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457019983.2044.29.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

thanks for taking time to review this.

On Thu, Mar 03, 2016 at 04:46:23PM +0100, Johannes Berg wrote:
> On Wed, 2016-03-02 at 19:38 +0530, Mohammed Shafi Shajakhan wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'
> > This flag will be set when drivers can fill rx_duration ( approximate
> > total air time(usecs) for unicast data/management frames from the
> > connected client) via 'drv_sta_statistics' callback
> 
> So, what's that useful for?

[shafi] This is part of the Per Station statistics requirement,
the information from 'iw dev wlan#N station dump' which has rx_duration
field will be used by application assesing the statistics
/performance of various clients connected to our AP. We will plot
a graph based on this information (assesing the rx time spent by
AP for various clients).

> 
> Are you really sure you mean "unicast"? What if the station is the AP?
> Why wouldn't multicast frames it transmitted be accounted for?

[shafi] This is based on the implementation by the driver/firmware.
We are focused on the AP side so unicast frames, if you are ok with this change,
i can change the documentation to be specific (generic for all the drivers) 
something like implementation specific (please advise)
> 
> > Also make sta_info flags 'filled' as 64 bit to accomodate for new
> 
> typo: accommodate

[shafi] will fix this

regards,
shafi

