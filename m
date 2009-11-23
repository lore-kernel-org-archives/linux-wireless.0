Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:36020 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZKWT03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:26:29 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1067526eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 11:26:35 -0800 (PST)
Message-ID: <4B0AE1E8.8080106@gmail.com>
Date: Mon, 23 Nov 2009 20:26:32 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 6/6] mac80211: Allow extra TX headroom to be consumed
 by drivers.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-4-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-5-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-6-git-send-email-gwingerde@gmail.com>	 <1258960565-26736-7-git-send-email-gwingerde@gmail.com> <1258972904.7094.150.camel@johannes.local>
In-Reply-To: <1258972904.7094.150.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 11:41, Johannes Berg wrote:
> On Mon, 2009-11-23 at 08:16 +0100, Gertjan van Wingerde wrote:
>> Allow drivers to consume the extra TX headroom they are requesting instead
>> of assuming they will give it back. This specifically is the case for
>> the rt2x00 driver, as a large part of the requested extra TX headroom is
>> used to properly align the frame for DMA usage, and the frame is never
>> moved back to the original location.
>> Fix this by reserving TX headroom accounting for both the driver requested
>> amount and the special monitor interface header that needs to be added,
>> instead of just the maximum of the two.
>>
>> See http://marc.info/?l=linux-kernel&m=125892467801662&w=2 for details.
> 
>> -	local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
>> -				   sizeof(struct ieee80211_tx_status_rtap_hdr));
>> +	local->tx_headroom = local->hw.extra_tx_headroom +
>> +				   sizeof(struct ieee80211_tx_status_rtap_hdr);
> 
> Even though the radiotap header currently is only 13 bytes long, I don't
> really like this, you're not consuming all of extra_tx_headroom! I'd
> rather have a definition somewhere
> 
> #define MAC80211_TX_STATUS_HEADROOM		13
> 
> (with a BUILD_BUG_ON(sizeof(rtap_hdr) == MAC80211_TX_STATUS_HEADROOM))
> so that you can make the driver set
> 	extra_tx_headroom = max_t(MAC80211_TX_STATUS_HEADROOM, txi) + align;
> 

We're just talking about a small amount of bytes (max 8 in the rt2x00 case),
but I'll look into this direction.
Probably will have to combine patches 5 & 6 of the series then, though.

---
Gertjan.
