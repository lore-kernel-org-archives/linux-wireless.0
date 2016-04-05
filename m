Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53686 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbcDEKEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 06:04:13 -0400
Message-ID: <1459850650.18188.42.camel@sipsolutions.net> (sfid-20160405_120424_889521_019ECD54)
Subject: Re: [PATCH v3] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
	mohammed@codeaurora.org
Date: Tue, 05 Apr 2016 12:04:10 +0200
In-Reply-To: <1457529357-19077-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1457529357-19077-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The implementation seems fine now, but I think the commit log needs some work.

> Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'

I think it'd be worthwhile to describe the attribute a bit more,
including why you're adding it.

> This flag

There's no flag.

>  will be set when drivers can fill rx_duration (aggregate
> PPDU duration(usecs) for all the frames from a peer) 

You have the description here, but putting it with the attribute would
be better.

> via 'drv_sta_statistics' callback

drv_sta_statistics is a mac80211 detail, that's not relevant at
cfg80211 level; mentioning that is just confusing. This can well used
by non-mac80211 drivers.

> Also make sta_info flags 'filled' as 64 bit to accommodate for new
> per station stats. 

That sentence doesn't parse well.

> Extend 'PUT_SINFO' for supporting rx_duration
> field and any new per sta information in future

That sentence I think should just be removed.

johannes
