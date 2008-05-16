Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50334 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbYEPXFp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 19:05:45 -0400
Message-ID: <482E1344.7080808@lwfinger.net> (sfid-20080517_010547_496161_3AD36B80)
Date: Fri, 16 May 2008 18:05:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: NULL pointer in mac80211:ieee80211_associate
References: <482DFC63.7050908@lwfinger.net> <1210974434.6381.60.camel@johannes.berg>
In-Reply-To: <1210974434.6381.60.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Larry,
> 
>> I think this report is new. If it is a duplicate, I apologize for any noise. 
> 
> I've definitely not seen it before, thanks.
> 
>> The system was last booted at 18:02 on May 15. Until 10:10:58, everything 
>> seemed normal. Then a reason 3 deauthentication arrived, and the following 
>> ensued:
> 
> Actually, the deauthentication is what you're sending, see
> ieee80211_sta_deauthenticate (in mlme.c). Any idea why it would be sent?
> Did you kill wpa_supplicant or something similar?

No, I was just working at the reverse engineering for the LP-PHY code without 
using the network. When I went to check for new E-mail, I found that the b43 
device was off line. Whne it wouldn't reconnect, I found the error message in 
the logs.

> In any case, we wouldn't expect to get a deauth with reason 15
> (WLAN_REASON_4WAY_HANDSHAKE_TIMEOUT) then. Hmm. Maybe that's why
> wpa_supplicant was trying to disassociate as well?
> 
> Still, we should of course not crash :)
> 
>> May 16 10:10:58 larrylap kernel: eth1: deauthenticate(reason=3)
>> May 16 10:10:58 larrylap kernel: eth1: RX deauthentication from 00:1a:70:46:ba:b1 (reason=15)
>> May 16 10:10:58 larrylap kernel: eth1: deauthenticated
>> May 16 10:10:58 larrylap avahi-daemon[3042]: Withdrawing address record for 
>> 192.168.1.122 on eth1.
>> May 16 10:10:58 larrylap avahi-daemon[3042]: Leaving mDNS multicast
>>   group on interface eth1.IPv4 with address 192.168.1.122.
>> May 16 10:10:58 larrylap avahi-daemon[3042]: Interface eth1.IPv4 no longer 
>> relevant for mDNS.
>> May 16 10:10:59 larrylap kernel: eth1: authenticate with AP 00:1a:70:46:ba:b1
>> May 16 10:10:59 larrylap kernel: eth1: RX authentication from 
>> 00:1a:70:46:ba:b1 (alg=0 transaction=2 status=0)
>> May 16 10:10:59 larrylap kernel: eth1: authenticated
>> May 16 10:10:59 larrylap kernel: eth1: associate with AP 00:1a:70:46:ba:b1
>> May 16 10:10:59 larrylap kernel: BUG: unable to handle kernel NULL pointer dereference at 00000000000000c0
>> May 16 10:10:59 larrylap kernel: IP: [<ffffffffa0159eb1>] :mac80211:ieee80211_associate+0x2ba/0x53e
>> May 16 10:10:59 larrylap kernel: PGD b8258067 PUD b8259067 PMD 0
>> May 16 10:10:59 larrylap kernel: Oops: 0000 [1] SMP
> 
> I can definitely not place this, though.
> 
> Can you try to find out what code this corresponds to?

 From objdump with line numbers, it occurs at "for (i = 0; i < 
bss->supp_rates_len; i++) {" in ieee80211_compatible_rates, which I think is 
entered from ieee80211_send_assoc. It seems that bss is NULL. For testing, I 
have placed a WARN_ON(!bss) statement just before the for loop.

Larry

