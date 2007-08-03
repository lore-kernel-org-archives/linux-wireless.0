Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp166.iad.emailsrvr.com ([207.97.245.166]:45188 "EHLO
	smtp166.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761930AbXHCW6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 18:58:12 -0400
Message-ID: <46B3B2AD.1040509@gentoo.org>
Date: Fri, 03 Aug 2007 18:56:45 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: further plan wrt. monitor interfaces
References: <1186178959.13315.30.camel@johannes.berg>
In-Reply-To: <1186178959.13315.30.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 1)
> Define new filter flags
>  * FIF_PROMISC_IN_BSS	(BSS filters still on, but otherwise promisc)
>  * FIF_ALLMULTI		(all multicast frames are allowed through)
>  * FIF_BROADCAST	(broadcast frames are allowed through)
>  * FIF_FCSFAIL		(frames with bad FCS are allowed through)
>  * FIF_PLCPFAIL		(frames with bad PLCP checksum are allowed through)
>  * FIF_CONTROL		(control frames are shown)
>  * FIF_OTHER_BSS	(frames from other BSSes are shown, subject to the
> 			 other filters)
> [missing anything?]

Incase this wasn't clear to anyone else, the proposal is that we add a 
bitfield to the set_multicast_list parameters for the above flags. The 
stack would then 'fabricate' some calls to set_multicast_list.

I like the filter flags concept here, but I think this may be better as 
its own callback, or perhaps we should just rename set_multicast_list to 
configure_filter or something like that.

This also sounds nice to implement from a driver standpoint. After 
documenting how I feel the soft/hard monitor interfaces should behave 
should we have such a system, I'm not keen on the idea of actually 
implementing that.


As for the other problems mentioned in followup mails, how about 
something like the following:

A new configure_device callback with these parameters:
  - ieee80211_hw *hw
  - int state: possible values NOCHANGE, ON, OFF
  - int filter_flags: FIF_ flags from above
  - u8 *mac_addr

This would combine the ideas of add_interface, remove_interface and 
open/stop into one.

state: this would become ON when the first interface is brought up, and 
would become OFF when the last interface is brought down. For all other 
calls into this function, state is NOCHANGE

filter_flags: Johannes' proposal above

mac_addr: if NULL, do not do anything. Otherwise, change the device MAC 
address to the one provided. This may be provided as all-zeros in some 
situations.

During a fairly standard session, the callback would be called in the 
following ways:

Device gets plugged in, registers interface. Default managed wlan0 gets 
created.
User brings wlan0 up.
    -> callback called with (hw, ON, default FIF, device MAC)
    -> driver powers up device, sets mac address and filtering
User creates new additional monitor interface and brings it up
    -> callback called with (hw, NOCHANGE, new FIF, NULL)
    -> driver changes filtering params
User deletes managed interface (wlan0)
    -> callback called with(hw, NOCHANGE, maybe new FIF?, 0x000000000000)
    -> driver changes filtering params and writes zero mac addr
User deletes monitor interface
    -> callback called with (hw, OFF, dontcare, dontcare)
    -> driver powers down device

After thinking through the above, I wonder if we should also roll 
config_interface into this: also pass in a BSSID for RX filtering 
purposes (or NULL of no change required).

Also I was wanting to add communication from mac80211 to the driver 
about supported rates in the ESS (softmac does this, zd1211rw uses this 
info). This would also fall in the same category. And maybe we should 
add the multicast list above too.

I feel the above would make life fairly easy for drivers, or am I 
over-designing this? Perhaps I am also missing some considerations for 
IBSS/AP mode...

Daniel
