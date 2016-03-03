Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49835 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbcCCQUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 11:20:45 -0500
Date: Thu, 3 Mar 2016 21:50:36 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160303162036.GB5243@atheros-ThinkPad-T61> (sfid-20160303_172105_083501_A1C38957)
References: <1456927710-32073-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457019983.2044.29.camel@sipsolutions.net>
 <20160303160048.GA5243@atheros-ThinkPad-T61>
 <1457021271.2044.34.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457021271.2044.34.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi johannes,

On Thu, Mar 03, 2016 at 05:07:51PM +0100, Johannes Berg wrote:
> On Thu, 2016-03-03 at 21:30 +0530, Mohammed Shafi Shajakhan wrote:
> 
> > [shafi] This is part of the Per Station statistics requirement,
> 
> Heh. Whose requirements? :)

[shafi] We have this as part of ath10k debugfs based on the end user (or) a
customer requirement and i think its make more sense to have this common across all
wifi drivers rather thank simply dumping it in ath10k debugfs. I think its
similar to 'ieee80211_frame_duration'(?) in mac80211 but for drivers like ath10k
where this is calculated in firmware for rx and implementation specific.

> 
> > the information from 'iw dev wlan#N station dump' which has
> > rx_duration
> > field will be used by application assesing the statistics
> > /performance of various clients connected to our AP. We will plot
> > a graph based on this information (assesing the rx time spent by
> > AP for various clients).
> > 
> > > 
> > > Are you really sure you mean "unicast"? What if the station is the
> > > AP? Why wouldn't multicast frames it transmitted be accounted for?
> > 
> > [shafi] This is based on the implementation by the driver/firmware.
> > We are focused on the AP side so unicast frames, if you are ok with
> > this change, i can change the documentation to be specific (generic
> > for all the drivers)  something like implementation specific (please
> > advise)
> 
> Ok, but for AP side I don't see the difference between "unicast" and
> "all frames", since all frames from that station should be unicast?
> Apart, perhaps, from some management frames the station might send
> outside the BSS, but that's not likely to matter much?

[shafi] exactly, I can change the documentation as you wish and
this is implementation specific, and we have implemented like this in ath10k
targeting AP mode.

> 
> IOW, why not specify all frames, and let this make some sense for other
> interface modes?
>
[shafi] Agreed.

regards,
shafi
