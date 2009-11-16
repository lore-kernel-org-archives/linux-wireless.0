Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:6029 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZKPRZ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 12:25:56 -0500
Message-ID: <4B018B26.2070008@irobot.com>
Date: Mon, 16 Nov 2009 09:25:58 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com> <1258191039.6167.40.camel@johannes.local>
In-Reply-To: <1258191039.6167.40.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have only three stations in an ad-hoc network, where all three can 
hear the other two, only one of them should be beaconing, correct?  If 
this is true, it's not clear to me how the non beaconing stations will 
update their rate information about each other based on the beacon.  It 
seems like, in the case we're "absent other information", we also need 
to send a probe request, OR we need to get the bitrate information from 
the next probe request we receive from them (neither of which we seem to 
be doing).

Johannes Berg wrote:
> On Fri, 2009-11-13 at 14:35 -0800, Adam Wozniak wrote:
>
>   
>> I've traced it down to this bit in rx.c in prepare_for_handlers():
>>
>>         case NL80211_IFTYPE_ADHOC:
>>                 [ stuff deleted ]
>>                 } else if (!rx->sta) {
>>                         int rate_idx;
>>                         if (rx->status->flag & RX_FLAG_HT)
>>                                 rate_idx = 0; /* TODO: HT rates */
>>                         else
>>                                 rate_idx = rx->status->rate_idx;
>>
>>                         rx->sta = ieee80211_ibss_add_sta(sdata, bssid, 
>> hdr->addr2,
>>                                 BIT(rate_idx));
>>                 }
>>                 break;
>>
>> I don't think this is right.  I know the issue is here, because if I 
>> change to "BIT(rate_idx) | 0xfff" the problem corrects.  Either we need 
>> to (a) set it properly here or (b) make sure something else happens 
>> before or after.  I'm not sure we have enough context here to do (a).
>>     
>
> Hmm. This BIT(..) was basically here to ensure we have at least a single
> good rate absent other information. If we do not receive a probe or
> beacon frame from that peer at least once, but add it to our IBSS only
> due to a single received data frame, we add the bitrate that this frame
> was transmitted at so we have one rate that we know it can transmit (and
> presumably also receive).
>
> What should happen is that once it starts beaconing we pick up a beacon
> and extend our set of known good rates.
>
> johannes
>   

