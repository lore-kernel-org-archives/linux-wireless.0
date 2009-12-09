Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:63502 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625AbZLIG6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 01:58:12 -0500
Message-ID: <4B1F4A88.5000803@gmail.com>
Date: Wed, 09 Dec 2009 07:58:16 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Andi Kleen <andi@firstfloor.org>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in   2.6.32
References: <20091204233202.GA13658@basil.fritz.box> <200912082339.16893.s.L-H@gmx.de> <1260312016.32227.6.camel@johannes.local> <200912090053.25798.s.L-H@gmx.de>
In-Reply-To: <200912090053.25798.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/09 00:53, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Tuesday 08 December 2009, Johannes Berg wrote:
>> On Tue, 2009-12-08 at 23:39 +0100, Stefan Lippers-Hollmann wrote:
>>
>>> Unfortunately this fails to compile for me:
>>
>> well remove the spurious opening brace? :)
> 
> yes, of course - but I have to admit that I didn't look too well at the 
> patch, after your other subthread - sorry about the noise.
> 

Yeah, sorry about the compile error in the patch.

> 
> with the patch applied (powersaving enabled):
> 
> - Downloading a larger file and therefore keeping the interface busy works 
>   now pretty well, while I did hit connection time outs before with 
>   powersaving enabled:
> 	Fetched 89.7MB in 30s (2926kB/s)
> 

Does this mean that the "Arrived at non-free entry" messages are gone with
power-saving enabled?

> - pinging rt61pci results in rather unsteady response times (packet loss 
>   can happen, but rarely), which might be a side effect of the card trying 
>   to sleep.
> 	# ping rt61
> 	PING rt61 (192.168.0.71): 56 data bytes
> 	64 bytes from 192.168.0.71: seq=0 ttl=64 time=1016.131 ms
> 	64 bytes from 192.168.0.71: seq=1 ttl=64 time=17.574 ms
> 	64 bytes from 192.168.0.71: seq=2 ttl=64 time=906.219 ms
> 	64 bytes from 192.168.0.71: seq=3 ttl=64 time=1.499 ms
> 	64 bytes from 192.168.0.71: seq=4 ttl=64 time=801.945 ms
> 	64 bytes from 192.168.0.71: seq=5 ttl=64 time=1.498 ms
> 	64 bytes from 192.168.0.71: seq=6 ttl=64 time=644.036 ms
> 	^C
> 	--- rt61 ping statistics ---
> 	7 packets transmitted, 7 packets received, 0% packet loss
> 	round-trip min/avg/max = 1.498/484.128/1016.131 ms
> 

My guess is that this is due to powersaving being enabled, where mac80211 and
the device go in powersaving mode and then it takes a while before packets
reach the device. I don't think this signifies a bug of some kind.

Johannes, is this correct expected behavior of powersaving?

<snip>

> 
> without the patch applied (powersaving disabled, see patch below which 
> unfortunately disables powersaving for all rt2x00 devices, even though 
> rt2500usb and rt73usb don't seem to be affected):
> 
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -837,6 +837,15 @@ int rt2x00lib_probe_dev(struct rt2x00_de
>  		    BIT(NL80211_IFTYPE_WDS);
>  
>  	/*
> +	 * Disable power saving for the time being, it breaks at least:
> +	 * - rt61pci
> +	 * while it isn't necessary for:
> +	 * - rt2500usb
> +	 * - rt73usb
> +	 */
> +	rt2x00dev->hw->wiphy->ps_default = false;
> +
> +	/*
>  	 * Let the driver probe the device to detect the capabilities.
>  	 */IEEE80211_HW_PS_NULLFUNC_STACK
>  	retval = rt2x00dev->ops->lib->probe_hw(rt2x00dev);
> 

This can be done smarter by removing the IEEE80211_HW_SUPPORTS_PS and
IEEE80211_HW_PS_NULLFUNC_STACK flags from the driver initialization.
This can be done on a per driver basis.

BTW, it is expected that rt2500usb and rt73usb are not affected by the 
originally reported problem, as their queue handling is completely different
from the PCI drivers.
Do you know if they expose the same unsteady ping response time behavior?

---
Gertjan.
