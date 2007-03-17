Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:54129 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbXCQO6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 10:58:17 -0400
Message-ID: <45FC0205.2020409@warmcat.com>
Date: Sat, 17 Mar 2007 14:58:13 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com> <200703171459.23246.mb@bu3sch.de>
In-Reply-To: <200703171459.23246.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:

>> +#define IEEE80211_TXCTL_INJECTED_PACKET (1<<10) /* tx into monitor IF */
> 
> What is a driver supposed to do on this flag? More documentation, please.

Hi Michael -

The driver doesn't have to do anything with that flag... it's a private 
mac80211-internal flag to get the attribute that the packet was injected 
into a Monitor interface into ieee80211_tx_control where 
__ieee80211_tx_prepare() can access that information.  By then as I 
understood it the information that the packet came in on the monitor 
interface isn't available because we redirected it to the master 
interface.  That one bit of state, that the packet originated from a 
send() to a Montitor Mode interface is the meaning of the flag.

Currently the information travels like this:

- ieee80211_subif_start_xmit() sees that it is a monitor mode interface 
getting the packet.

  - It sets ieee80211_tx_packet_data.is_injected_into_monitor, which 
travels with the packet inside skb.cb.

  - ieee80211_master_start_xmit() eventually gets the packet and 
examines the ieee80211_tx_packet_data in the skb.cb.  If 
is_injected_into_monitor is set, it sets control.flags |= 
IEEE80211_TXCTL_INJECTED_PACKET.  This is done because at the start of 
ieee80211_master_start_xmit() there is a comment

	/*
	 * copy control out of the skb so other people can use skb->cb
	 */

  - finally the end user __ieee80211_tx_prepare() is able to find the 
state information in control->flags & IEEE80211_TXCTL_INJECTED_PACKET 
and work out if it expects a radiotap header prepended or not from that.

If there's a simpler way I'm happy to use it.

-Andy
