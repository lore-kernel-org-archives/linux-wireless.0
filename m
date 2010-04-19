Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50248 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0DSIqE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 04:46:04 -0400
Message-ID: <4BCC1844.4030607@openwrt.org>
Date: Mon, 19 Apr 2010 10:45:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 7/9] mac80211: add flags for STBC (Space-Time Block Coding)
References: <1271602602-8538-1-git-send-email-nbd@openwrt.org>	 <1271602602-8538-2-git-send-email-nbd@openwrt.org>	 <1271602602-8538-3-git-send-email-nbd@openwrt.org>	 <1271602602-8538-4-git-send-email-nbd@openwrt.org>	 <1271602602-8538-5-git-send-email-nbd@openwrt.org>	 <1271602602-8538-6-git-send-email-nbd@openwrt.org>	 <1271602602-8538-7-git-send-email-nbd@openwrt.org>	 <1271606009.3873.0.camel@jlt3.sipsolutions.net>	 <4BCB2DB3.3020700@openwrt.org> <1271656677.3873.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1271656677.3873.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-19 7:57 AM, Johannes Berg wrote:
> On Sun, 2010-04-18 at 18:05 +0200, Felix Fietkau wrote:
> 
>> >> + * @IEEE80211_TX_CTL_STBC: tells the driver to use Space-Time Block Coding
>> >> + *  (STBC) for this frame.
>> >>   */
>> >>  enum mac80211_tx_control_flags {
>> >>  	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
>> >> @@ -299,6 +301,7 @@ enum mac80211_tx_control_flags {
>> >>  	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
>> >>  	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
>> >>  	IEEE80211_TX_CTL_LDPC			= BIT(22),
>> >> +	IEEE80211_TX_CTL_STBC			= BIT(23),
>> > 
>> > What if the # of streams is different? That doesn't look sufficient.
> 
>> Hm, you're right. I initially thought the combination of the MCS index
>> and the STBC flag would be enough, but there are still some corner cases.
> 
> Hm actually I guess that should be sufficient? What corner case are you
> thinking of?
Support for multi-rate retry and STBC with more than one stream on one
side, using rates from both MCS0-7 and MCS8-15 in the rate series.
Rx STBC for only one stream on the other side.

- Felix
