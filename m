Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38332 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3KHPGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 10:06:15 -0500
From: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>, Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>
Subject: RE: [PATCH] cfg80211: Introduce critical protocol indication for
 p2p connection.
Date: Fri, 8 Nov 2013 15:06:10 +0000
Message-ID: <26F3B0343EE4744AA14EEEF9E1E534511F7AC775@aphydexd01a> (sfid-20131108_160620_438976_2C7B6474)
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
 <1383230593.14302.1.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
 <1383233115.14302.2.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
 <52729681.5020004@broadcom.com>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A8160@aphydexd01a>
 <5273A784.4040900@broadcom.com> <20131102073319.GA3507@w1.fi>
 <5274D5DC.1090508@broadcom.com>
In-Reply-To: <5274D5DC.1090508@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I guess the decision is for Johannes to take, but I see your point.
Johannes, please have your say.

Regards,
Sunil

-----Original Message-----
From: Arend van Spriel [mailto:arend@broadcom.com] 
Sent: Saturday, November 02, 2013 4:07 PM
To: Jouni Malinen
Cc: Undekari, Sunil Dutt; Johannes Berg; linux-wireless@vger.kernel.org; Dan Williams
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for p2p connection.

On 11/02/13 08:33, Jouni Malinen wrote:
> On Fri, Nov 01, 2013 at 02:07:16PM +0100, Arend van Spriel wrote:
>> On 11/01/2013 12:25 PM, Undekari, Sunil Dutt wrote:
>>> The host driver / firmware performs (initiates) a scan on the STA interface in the process of finding a better BSS to roam. This scan is offloaded to the driver / firmware for a better roam experience.
>>> This scans would definitely affect the p2p connection triggered by the supplicant.
>>> Thus, I was suggesting a way to extend the already existing critical protocol indications to also include p2p protocol/connections, so that drivers can defer the scan's (any off channel operations for that matter) on any other interface during this period.
>>
>> I got that. What I meant to say is that you can defer the roaming 
>> related scans when cfg80211 does a .add_virtual_intf() call to the 
>> driver and recommence upon .del_virtual_intf(). I guess this 
>> effectively disables roaming, right?
>
> That sounds quite excessive. The case here is a multi-channel 
> concurrency capable device which has a station connection and 
> wpa_supplicant is about to go through P2P group formation. I see no 
> reason to disable roaming, but it would sound useful to avoid doing 
> the background scans for that at the exact time of the group formation 
> (couple of seconds in most cases).

This is why I was asking for a more detailed usage scenario. Sunil only mentioned the term "P2P connection" which seemed to coarse for this API. 
So if we are talking about P2P group formation it makes sense.

> Currently, there is no way for wpa_supplicant to clearly indicate to 
> the driver that it is about to run through number of quick operations 
> (offchannel Action frame exchange for GO Negotiation, single channel 
> scan, WPS association + EAPOL exchange, data connection association + 
> 4-way handshake). The driver can guess that this is happening (or 
> could use really ugly hacks to see what Action frames are exchanged 
> and determine next likely operation based on that) and as such, would 
> not know how to configure the firmware to avoid background scans for 
> the station interface during this full sequence.

I wanted this API primarily to avoid drivers doing that kind of hacks so I agree. It was intended to avoid extra latencies during IP connection setup, which is probably happening right after the group formation. So I recommend the connection managers to use this API. I think Dan Williams did some initial implementation testing in NetworkManager and had some concerns. I forgot about them completely so not sure how that ended.

> While the background scan should in most cases not completely break 
> the process even with inconvenient timing (or well, hitting one in 
> middle of the three frame GO Negotiation would have potential to time 
> out that exchange), it would be nice if this common sequence could be 
> optimized to avoid extra latencies and to be more robust in general 
> since there is a 15 second timeout for group formation and quite a bit 
> shorter timeouts in practice for the individual operations within the sequence.

I guess the decision is for Johannes to take, but I see your point.

Regards,
Arend

