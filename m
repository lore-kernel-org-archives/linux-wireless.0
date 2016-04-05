Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57081 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbcDEMjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:39:13 -0400
Date: Tue, 5 Apr 2016 18:08:56 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>, g@codeaurora.org
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH v3] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160405123856.GA23252@atheros-ThinkPad-T61> (sfid-20160405_143916_055396_8227EB91)
References: <1457529357-19077-1-git-send-email-mohammed@qca.qualcomm.com>
 <1459850650.18188.42.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459850650.18188.42.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Apr 05, 2016 at 12:04:10PM +0200, Johannes Berg wrote:
> Hi,
> 
> The implementation seems fine now, but I think the commit log needs some work.

[shafi] thanks for reviewing.

> 
> > Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'
> 
> I think it'd be worthwhile to describe the attribute a bit more,
> including why you're adding it.

[shafi] will update in v4

> 
> > This flag
> 
> There's no flag.

[shafi] i will replace it with the name 'NL80211_STA_INFO_RX_DURATION'

> 
> >  will be set when drivers can fill rx_duration (aggregate
> > PPDU duration(usecs) for all the frames from a peer) 
> 
> You have the description here, but putting it with the attribute would
> be better.

[shafi] ok

> 
> > via 'drv_sta_statistics' callback
> 
> drv_sta_statistics is a mac80211 detail, that's not relevant at
> cfg80211 level; mentioning that is just confusing. This can well used
> by non-mac80211 drivers.

[shafi] agreed, will remove it.

> 
> > Also make sta_info flags 'filled' as 64 bit to accommodate for new
> > per station stats. 
> 
> That sentence doesn't parse well.
> 
> > Extend 'PUT_SINFO' for supporting rx_duration
> > field and any new per sta information in future
> 
> That sentence I think should just be removed.

[shafi] ok.

-shafi
