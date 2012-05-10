Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2EJId2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:33:28 -0400
Message-ID: <4FAB7D52.6060803@qca.qualcomm.com> (sfid-20120510_103334_537008_82A89612)
Date: Thu, 10 May 2012 11:33:22 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: Anthony Ginger <mapfly@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com> <4FA036B6.7040002@lenbrook.com> <4FA03939.4080307@qca.qualcomm.com> <4FA0535D.2060907@lenbrook.com> <4FA21468.6060909@qca.qualcomm.com> <4FA43C79.6020202@lenbrook.com>
In-Reply-To: <4FA43C79.6020202@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2012 11:30 PM, Jonathan Bagg wrote:
> On 12-05-03 01:15 AM, Kalle Valo wrote:
>>
>> That might be challenging. I think it's easier if you add debug messages
>> and try to pinpoint where it is failing. For example
>> ath6kl_cfg80211_change_iface() is a good place to start debugging.
> 
> I tried again and it appears that sometimes (< 10 %) I can make 
> connections to the ath6kl in AP mode.

What exactly happens when a connection fails? What client device are you
using?

> Just to rule out any issues with 
> my configs & tools, I setup a cw1200 sdio using the same software 
> stack.  The cw1200 is working fine for me in AP mode and the output of 
> hostapd is richer.

cw1200 is a mac80211 driver and the interface to user space is different
compared to fullmac devices like ath6kl. That's why the log output is
different.

> Any clues from the ath6kl hostapd output?
> 
> 
> --------hostapd output using ath6kl-------
> 
> nl80211: Event message available
> nl80211: New station d8:a2:5e:08:89:56
> nl80211: Assoc Req IEs - hexdump(len=55): 00 09 4e 31 35 30 2d 66 30 30 
> 32 01 08 82 84 8b 96 24 30 48 6c 21 02 08 10 24 02 01 0e 32 04 0c 12 18 
> 60 dd 09 00 10 18 02 00 00 01 00 00 dd 07 00 50 f2 02 00 01 00
> wlan0: Event ASSOC (0) received
> wlan0: STA d8:a2:5e:08:89:56 IEEE 802.11: associated
> STA did not include WPS/RSN/WPA IE in (Re)AssocReq
>    New STA
> ap_sta_add: register ap_handle_timer timeout for d8:a2:5e:08:89:56 (300 
> seconds - ap_max_inactivity)
> wlan0: STA d8:a2:5e:08:89:56 RADIUS: starting accounting session 
> 00000B62-00000000
> IEEE 802.1X: Ignore STA - 802.1X not enabled or forced for WPS
> hostapd_new_assoc_sta: reschedule ap_handle_timer timeout for 
> d8:a2:5e:08:89:56 (300 seconds - ap_max_inactivity)
> Sending OFFER of 192.168.5.80
> Sending OFFER of 192.168.5.80
> Sending ACK to 192.168.5.80
> Sending ACK to 192.168.5.80
> Sending ACK to 192.168.5.80
> random: Got 8/20 bytes from /dev/random
> nl80211: Event message available

Is this from a failing case? From a quick look I don't see anything
wrong in the logs.

What are the symptoms when the connection fails? Did you check that this
isn't a higher level problem (wrong IP address etc)?

Kalle
