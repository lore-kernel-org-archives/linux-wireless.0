Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44151 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJDOkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2014 10:40:07 -0400
Message-ID: <543006C5.6010807@candelatech.com> (sfid-20141004_164029_072117_B342066E)
Date: Sat, 04 Oct 2014 07:40:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Support for bitrate-mask in wpa_supplicant?
References: <542D87F6.8090306@candelatech.com> <20141004130858.GB2987@w1.fi>
In-Reply-To: <20141004130858.GB2987@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/04/2014 06:08 AM, Jouni Malinen wrote:
> On Thu, Oct 02, 2014 at 10:14:30AM -0700, Ben Greear wrote:
>>  From what I can tell, wpa_supplicant does not have a way to set
>> the tx-bitrate-mask, except for some code
>> to disable 802.11b rates (which I think will in turn (re)enable all
>> of the other rates that may have previously been disabled.
>>
>> So, would it be worthwhile to add support to supplicant to at
>> least configure the legacy rates using the NL80211_CMD_SET_TX_BITRATE_MASK
>> netlink message?
>
> Why would wpa_supplicant be involved in that? What kind of use case
> would benefit from this (vs. setting this through iw, for example)?


First, if supplicant ever calls the disable_b rates logic method
(and I'm not certain it does), it would over-write any other rate
limitations set by iw.

Second, you can only set rates when the netdev is UP, so for a brief
time, the station can be transmitting at non-desired rates.  For testing
purposes, I would like to be able to force stations to be in /b mode,
for instance.  Currently I can fix the transmit rate to be /b rates
shortly after the netdev comes up, but the peer AP transmits at full /a/g/ rates,
so my emulation still has issues.  I'm not sure how the AP determines if
a station is /b or /g, but perhaps it is by receiving frames at /g rates?

If supplicant is doing the setting, it could set the rates right after it
brings the netdev up, but before it starts sending any packets?

And third, when bringing up lots of stations, it will be more efficient
for me to not have to call 'iw' for each device after it comes up.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
