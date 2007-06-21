Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:50445 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXFUWxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 18:53:34 -0400
Message-ID: <467B0163.1010804@warmcat.com>
Date: Thu, 21 Jun 2007 23:53:23 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Sam Leffler <sam@errno.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: radiotap for TX
References: <1182375853.3714.103.camel@johannes.berg> <467AE460.1070606@errno.com> <467AE9D8.2030602@warmcat.com> <467AFB5F.6050100@errno.com>
In-Reply-To: <467AFB5F.6050100@errno.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sam Leffler wrote:
> [radiotap mailing list dropped since it is members only]
> 
> Andy Green wrote:
>> Sam Leffler wrote:
>>
>>> Note that using a monitor mode interface for transmit is a bad idea.  It
>>> is likely you will encounter devices that disallow any packet transmit
>>> when operating in monitor mode.  In practice this can be worked around
>>> by using a non-monitor operating mode for the device (e.g. adhoc mode
>>> w/o setting up beacons) but exporting this notion to user mode is bad
>>> IMO.  In net80211 there is an adhoc-demo mode which is essentially adhoc
>>> mode which was originally added for functionality found in old lucent
>>> cards but more recently has been used for building applications that
>>> want a "raw 802.11 device".
>>
>> Hi -
>>
>> In mac80211 you can run multiple network interfaces off the one physical
>> device, so you can have an associated WPA connection on one network
>> interface and another logical "monitor mode" network interface up on the
>> one physical device.  "Monitor mode" in this case can be the results of
>> a promiscuous hardware RX that is filtered for the Managed mode logical
>> interface ... this is AIUI.  So in that way "Monitor Mode" no longer
>> means a single modal device setting, but really the delivery somehow of
>> packets to a logical network interface that belongs to the physical
>> device.
> 
> I've had working vap code for >3 years.

Just pointing out that "monitor mode" in this context is now a logical
attribute for a network interface divorced from hardware settings.  One
can add another TX-only "injection mode" logical network interface mode
but it buys you nothing over using the otherwise meaningless TX action
of the existing monitor mode.  Because most usage cases want to monitor
RX as well having the RX side of Monitor Mode around makes sense for
these cases too.

>> Injecting down a "monitor mode interface" then only means to use a
>> logical network interface that locally is configured to "Monitor Mode",
>> it doesn't have the same definite implication for physical device
>> configuration as before mac80211.  (Well.. AIUI).  So hopefully this
>> objection may not apply.
> 
> As I described, some devices may allow rx-only operation on channels
> otherwise disallowed by regulatory constraints.  As such overloading
> monitor operation with transmit is just a bad idea if you want to take
> full advantage of what h/w provides.  I'm just suggesting that you're
> defining an abstraction that's going to get you into trouble.

Well, the injection code can look if the channel is rx only and drop the
packet, if something else doesn't check already.  Since TX on monitor
mode is not only currently completely unused, but will never be used as
part of a "Monitor" action, I don't see so much trouble it can get me
into to choose that place to overload the injection semantic.

But if you have a better plan I am interested to hear any proposal.

-Andy
