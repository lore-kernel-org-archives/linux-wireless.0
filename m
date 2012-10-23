Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44161 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756841Ab2JWS6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 14:58:41 -0400
Received: from [173.161.179.205] (port=60085 helo=[10.10.62.51])
	by host200.hostmonster.com with esmtpa (Exim 4.76)
	(envelope-from <ml@dlasys.net>)
	id 1TQjgW-0006Wr-6U
	for linux-wireless@vger.kernel.org; Tue, 23 Oct 2012 12:58:40 -0600
Message-ID: <1351018719.3663.30.camel@hp-dhlii> (sfid-20121023_205845_609855_4827BD76)
Subject: Re: Bandwidth monitoring
From: "David H. Lynch Jr." <ml@dlasys.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 23 Oct 2012 14:58:39 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On Sunday, October 21, 2012 09:58:18 PM David H. Lynch Jr. wrote:
>> I am looking for an easy means to determine the characteristics of a
>> transmitted packet. 
>> Particularly whether it is HT20/HT40-/HT40+ I have used a variety of
>> sniffers, airodump, wireshark, ... and I can not seem to find
anything
>> that will tell me what I am after - or I do not know how to use them.
>differentiating between HT40+ and HT40- will be difficult to do with
>just one standard wifi device (should be possible with two though).

>If you use mac80211, have you setup your monitor channel by adding
>the HT20/HT40+/HT40- flag? 
># iw dev wlanX set channel 1 HT40+ (or HT40-/HT20)


This is setting up to send on channel 1 HT40+ correct ?
I am already doing that I need to know if it is succeeding 
I am using Packettspammer to send with all the channel/frequency
radiotap headers removed.  an setting up using iw for what I want as
above.



>This might help.

>As for retrieving the information:
>If a HT20/HT40  frame was received, it should have a radiotap
>IEEE80211_RADIOTAP_MCS header element (on the monitor interface dump).
>In this element should provide the MCS and flags for 
> - BW40 (if false => HT20, if true => HT40+ or HT40- depending
>   on the channel configuration)
> - Short GI
> - Greenfield flag
> - (LDPC)

Wireshark appears to handle RadioTap - I am seeing lots of other flags
etc. but not BW40.

>But I don't know if any of this information is parsed by any of the
>current tools (depends on the version I guess). At least for wireshark
>you can always look at the raw hex dump of the package, so it should
>be there! The definitions of what RADIOTAP_MCS bit means what are in:
><include/net/ieee80211_radiotap.h>


Googling Radiotap produces lots of comments that suggest that Radiotap
headers - send and receive are not necescarily complete or accurate from
device to device - is that a reasonable conclusion ?



>Regards,
>	Chr

Thanks
--
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@...
More majordomo info at  http://vger.kernel.org/majordomo-info.html


