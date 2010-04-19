Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0DSI7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 04:59:45 -0400
Subject: Re: [PATCH 7/9] mac80211: add flags for STBC (Space-Time Block
 Coding)
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
In-Reply-To: <4BCC1844.4030607@openwrt.org>
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-2-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-3-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-4-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-5-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-6-git-send-email-nbd@openwrt.org>
	 <1271602602-8538-7-git-send-email-nbd@openwrt.org>
	 <1271606009.3873.0.camel@jlt3.sipsolutions.net>
	 <4BCB2DB3.3020700@openwrt.org>
	 <1271656677.3873.5.camel@jlt3.sipsolutions.net>
	 <4BCC1844.4030607@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 10:59:42 +0200
Message-ID: <1271667582.3873.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 10:45 +0200, Felix Fietkau wrote:
> On 2010-04-19 7:57 AM, Johannes Berg wrote:
> > On Sun, 2010-04-18 at 18:05 +0200, Felix Fietkau wrote:
> > 
> >> >> + * @IEEE80211_TX_CTL_STBC: tells the driver to use Space-Time Block Coding
> >> >> + *  (STBC) for this frame.
> >> >>   */
> >> >>  enum mac80211_tx_control_flags {
> >> >>  	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
> >> >> @@ -299,6 +301,7 @@ enum mac80211_tx_control_flags {
> >> >>  	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
> >> >>  	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
> >> >>  	IEEE80211_TX_CTL_LDPC			= BIT(22),
> >> >> +	IEEE80211_TX_CTL_STBC			= BIT(23),
> >> > 
> >> > What if the # of streams is different? That doesn't look sufficient.
> > 
> >> Hm, you're right. I initially thought the combination of the MCS index
> >> and the STBC flag would be enough, but there are still some corner cases.
> > 
> > Hm actually I guess that should be sufficient? What corner case are you
> > thinking of?
> Support for multi-rate retry and STBC with more than one stream on one
> side, using rates from both MCS0-7 and MCS8-15 in the rate series.
> Rx STBC for only one stream on the other side.

So the flag should be per rate entry instead, no?

johannes

