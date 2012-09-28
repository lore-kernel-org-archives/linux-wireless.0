Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:28624
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522Ab2I1IJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 04:09:32 -0400
Message-ID: <50655B36.5060500@posedge.com> (sfid-20120928_100949_408028_9D0D4364)
Date: Fri, 28 Sep 2012 13:39:26 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC v2] cfg80211: VHT regulatory
References: <5046FB3D.6090803@posedge.com>   <1346852356.4364.9.camel@jlt4.sipsolutions.net>   <50481C2E.5040303@posedge.com>  <1346925298.5469.4.camel@jlt4.sipsolutions.net>  <50489165.1080902@posedge.com> <1347019809.4256.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347019809.4256.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2012 05:40 PM, Johannes Berg wrote:
>
> We don't have to do any calculation in kernel though as far as I can
> tell? Maybe we do need the channel, but I think in terms of
> *specifying*, in particular in the nl80211 and cfg80211 APIs, we should
> stick to the standard if we're going to change it now.
>

struct ieee80211_channel_config {
         enum ieee80211_chan_width chan_width;
         u16 center_freq1;
         u16 center_freq2;
         u16 prim_chan_freq;
};

If we stick to standard, all u16 become u8, as their values range is 
from 1-200. But these numbers have to be converted to freqKHz in 
reg_chan_use_permitted() to find fits in reg rule or not?
Is that ok?

If so I have to use below formulas to get freqKHz.

Channel center frequency [MHz]
= Channel starting frequency + 5 x dot11CurrentChannelCenterFrequencyIndex

Primary 20 MHz channel center frequency [MHz]
= Channel starting frequency + 5  dot11CurrentPrimaryChannel

Thanks,
Mahesh
