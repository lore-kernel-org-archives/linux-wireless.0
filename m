Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51563 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2CPNif (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:35 -0400
Message-ID: <4F634259.7040107@etit.tu-chemnitz.de> (sfid-20120316_143842_804261_776D594F)
Date: Fri, 16 Mar 2012 14:38:33 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] UAPSD: WLAN_STA_PS flag  cleared prematurely?
References: <4F630757.6070901@etit.tu-chemnitz.de> <1331901852.6753.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331901852.6753.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/12 13:44, Johannes Berg wrote:
> On Fri, 2012-03-16 at 10:26 +0100, Marco Porsch wrote:
>> Hi all,
>>
>> in sta_info.c : ieee80211_sta_ps_deliver_response the
>> IEEE80211_TX_STATUS_EOSP is set for all to-be-sent frames, not only for
>> the last. But only the last buffered frame actually gets the EOSP flag.
>>
>>
>> /* set EOSP for the frame */
>> if (reason == IEEE80211_FRAME_RELEASE_UAPSD&&
>>       qoshdr&&  skb_queue_empty(&frames))
>> 	*qoshdr |= IEEE80211_QOS_CTL_EOSP;
>>
>> info->flags |= IEEE80211_TX_STATUS_EOSP |
>>          IEEE80211_TX_CTL_REQ_TX_STATUS;
>>
>>
>> Consequence is, that the WLAN_STA_SP flag gets cleared (multiple times)
>> in ieee80211_tx_status before the last frame with EOSP has been sent.
>> Is this correct?
>
> Looks like the bug is above, the EOSP/TX_STATUS should only be set for
> the last frame?

I Agree. But what about the case, when the last frame is not a QoS 
frame? Can this even happen - or is U-APSD only for QoS STA?
Then we would have to manually append a QoS Null with the EOSP flag + 
TX_STATUS?

So like this:

/* set EOSP for the _last_ frame or appended a QoS Null when needed */
if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
     skb_queue_empty(&frames)) {
	if (qoshdr) {
		*qoshdr |= IEEE80211_QOS_CTL_EOSP;

		info->flags |= IEEE80211_TX_STATUS_EOSP |
		               IEEE80211_TX_CTL_REQ_TX_STATUS;
	} else {
		ieee80211_send_null_response(sdata, tid, reason);
	}
}

Open issues:
Which tid?
Would this Null now be sent after or before the last frame?
What if the EOSP frame is lost?

Regards,
Marco

