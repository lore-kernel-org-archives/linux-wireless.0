Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59505 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaJISkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 14:40:42 -0400
Message-ID: <1412880033.1828.63.camel@jlt4.sipsolutions.net> (sfid-20141009_204045_279259_9245ED74)
Subject: Re: [PATCH] cfg80211: Add support for ACS offloading
From: Johannes Berg <johannes@sipsolutions.net>
To: "Xu, Peng" <pxu@qca.qualcomm.com>
Cc: "Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>,
	cfg80211mac80211 <cfg80211mac80211@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 09 Oct 2014 20:40:33 +0200
In-Reply-To: <6c0aebecfa9d478ea43ba9c10236c19b@nasanexm01a.na.qualcomm.com>
References: <1412373538-17690-1-git-send-email-kyeyoonp@qca.qualcomm.com>
	 <1412847971.1828.42.camel@jlt4.sipsolutions.net>
	 <6c0aebecfa9d478ea43ba9c10236c19b@nasanexm01a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 17:38 +0000, Xu, Peng wrote:

> This change is originated from a problem caused by OBSS scan and ACS
> feature in the driver. When SAP is started, hostapd will do an OBSS
> scan based on the channel setting in hostapd.conf, if the wlan driver
> has the ACS capability, it may choose a different channel. Even it
> notifies hostapd about the channel selection, the OBSS scan result
> may become invalid if a different channel is selected and SAP may end
> up operating in not desired mode.
> This change will allow the wlan driver do the ACS and decide a
> channel, once hostapd is notified, it can then do OBSS scan using that
> channel. ACS operation is done during SAP starting up, beacon is sent
> after channel is selected by driver. 

All of this may be true, but I was asking why this has to be part of
START_AP, and that's not answering that question.

johannes

