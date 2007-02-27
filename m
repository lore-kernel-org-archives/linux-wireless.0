Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:44808 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933086AbXB0UmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 15:42:13 -0500
Message-ID: <45E497A1.90400@warmcat.com>
Date: Tue, 27 Feb 2007 20:42:09 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jouni Malinen <jkm@devicescape.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Penumbra - Enabling unencrypted broadcasts alongside normal  traffic
References: <45E41A9E.2020908@warmcat.com> <20070227164727.GA10048@devicescape.com>
In-Reply-To: <20070227164727.GA10048@devicescape.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:

Hi Jouni -

>> There is a start on a formal RFC for the broadcast transport protocol here:
>>
>> http://penumbra.warmcat.com/penumbra-rfc-0.0.3.txt
> 
> Could you please extend the description of "Wireless Packet Format" to
> define all fields in the 802.11 header. I would especially be interested
> in seeing what is in the FromDS and ToDS fields of the frame control.
> I'm assuming this is using normal data frames, but that (type and
> subtype fields) should also be described clearly.

I extended it to this:

  frame_control: 08 01               (FCTL_DATA/STYPE_DATA/TODS)
    duration_id: 00 00
          addr1: FF:FF:FF:FF:FF:FF
          addr2: 13:22:33:44:55:66
          addr3: 13:22:33:44:55:66
       seq_ctrl: 00:00

The TODS will always be accepted for transmission by even a pedantic 
device in INFRA mode, and any combination will be accepted in MONITOR 
mode.  Whereas one of the devices (IPW3945?  I forget) would not issue 
packets with FROMDS in INFRA mode IIRC.

>>  - The wireless driver gets the packet for transmission, recognizes the 
>> Magic MAC, disables retries and sets the transmission rate (currently 
>> fixed 54Mbps, but this will change) and transmits the packet as a broadcast
> 
> So this frame is to be sent by the non-AP STAs directly as a broadcast
> frame, not through the AP which is the normal way of transmitting
> frames(?)

Yes -- even further there is nothing in the broadcast frame to identify 
the sender or recipient.  The broadcast frame is not directed at 
anything either: any number of stations are either in range to accept it 
or not.  If you're not in range, but through one or more hops you are in 
range of someone that is, a store-and-forward system that rides of top 
of this enables intercommunication anyway.  So your street or building 
or carpark or train or airplane can be a more interesting place, 
hopefully even if you are not associated or have nothing to associate to.

>> I hope there is some interest in this new capability for wireless 
>> devices in Linux.  To get any kind of widespread use, the capability 
>> needs to be already available in stock kernels and drivers so that the 
>> user only needs to open iptables and run a userspace daemon rather than 
>> patch his wireless drivers and stack.  So this is my reason for 
>> presenting this Request For Comments, to see if it can be considered.
> 
> You would need to add "and configure the wlan driver/802.11 stack to
> enable this". I don't think this has to be disabled by default.

Yes if I understood it I can bring up the monitor interface when the 
daemon is started and take it down when it is stopped.

> Is this only for Linux at the moment or is someone looking at supporting
> this with other OSes?

It will really become more useful with Windows support.  I looked a 
little way into it and found they seem to have a hookable minidriver 
idea for XP SP2 and Vista.  I am hoping somebody with experience on that 
side will write it once the system is easily available on Linux.

>>  - Hardware promisc is needed to catch the packets because they are not 
>> tagged as coming from the local AP.  All the devices I looked at can do 
>> hardware promisc separately from the logical promisc for Monitor mode. 
>> But perhaps this needs to be enabled and disabled in some modal way.
> 
> This has to be disabled by default. There is a reason for such a
> filtering in wlan designs and just enabling promiscuous mode at 802.11
> level is going to considerable increase power needs for the device which
> is not acceptable for many low-power devices.

Fair enough: it seems that creating the logical Monitor interface for rx 
will and using that instead of the current system of private monitoring 
with hardware promisc will take care of that as well, it will only be 
doing promisc while the daemon runs and the interface is up.

-Andy
