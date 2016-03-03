Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56724 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbcCCQHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 11:07:55 -0500
Message-ID: <1457021271.2044.34.camel@sipsolutions.net> (sfid-20160303_170758_945250_D6F5470B)
Subject: Re: [PATCH] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Date: Thu, 03 Mar 2016 17:07:51 +0100
In-Reply-To: <20160303160048.GA5243@atheros-ThinkPad-T61>
References: <1456927710-32073-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1457019983.2044.29.camel@sipsolutions.net>
	 <20160303160048.GA5243@atheros-ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-03 at 21:30 +0530, Mohammed Shafi Shajakhan wrote:

> [shafi] This is part of the Per Station statistics requirement,

Heh. Whose requirements? :)

> the information from 'iw dev wlan#N station dump' which has
> rx_duration
> field will be used by application assesing the statistics
> /performance of various clients connected to our AP. We will plot
> a graph based on this information (assesing the rx time spent by
> AP for various clients).
> 
> > 
> > Are you really sure you mean "unicast"? What if the station is the
> > AP? Why wouldn't multicast frames it transmitted be accounted for?
> 
> [shafi] This is based on the implementation by the driver/firmware.
> We are focused on the AP side so unicast frames, if you are ok with
> this change, i can change the documentation to be specific (generic
> for all the drivers)  something like implementation specific (please
> advise)

Ok, but for AP side I don't see the difference between "unicast" and
"all frames", since all frames from that station should be unicast?
Apart, perhaps, from some management frames the station might send
outside the BSS, but that's not likely to matter much?

IOW, why not specify all frames, and let this make some sense for other
interface modes?

johannes
