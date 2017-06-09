Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:59014 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdFIGvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 02:51:42 -0400
Subject: Re: Wifi-Event for when initial 4-way completes?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
 <f1334e7f-1d86-00fd-cfba-7ce56b8a9f81@neratec.com>
 <bbf39c69-66a5-1e23-77df-1945d0036719@candelatech.com>
 <f46b90e9-5281-b9d5-d335-3ec4eb4c5c22@candelatech.com>
From: Wojciech Dubowik <wojciech.dubowik@neratec.com>
Message-ID: <7c2b90a3-bed4-1809-c856-621e611830cb@neratec.com> (sfid-20170609_085145_864686_36DA1343)
Date: Fri, 9 Jun 2017 08:51:39 +0200
MIME-Version: 1.0
In-Reply-To: <f46b90e9-5281-b9d5-d335-3ec4eb4c5c22@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ben,

Yes, you are right. There is a case when wpa supplicant is in connected 
state

but the last EAPOL to AP was lost. Client won't be able to communicate 
and AP will

deauthenticate after a while or not. It's easily reproducible with a 
frame corrupter

patch I have sent some time ago. The worst case is when last EAPOL is 
lost and

deauthentication frame from AP as well. It can leave client in dead 
state for

minutes.


I have been debugging such case reported by our customers and it turns out

that supplicant is using L2 send for EAPOL messages without any feedback 
from

mac80211 layer. It means that client has no idea whether these frames have

been acked or not. AP (in mac80211) is using nl command and gets the 
status of the ack

although it's not the last message in the chain.

I have made a patch to send EAPOL on the station with same command as AP

and check for this case i.e. deauthenticate immediately when client is in

connected state but last EAPOL hasn't been acked.

I will try to send it upstream as soon as it's cleaned up a bit.

Br,

Wojtek


On 08/06/17 17:41, Ben Greear wrote:
> On 06/08/2017 08:21 AM, Ben Greear wrote:
>> On 06/07/2017 12:25 AM, Wojciech Dubowik wrote:
>>> Hello Ben,
>>>
>>> I have been using this part of wpa_supplicant to notify that 4-Way 
>>> handshake is completed.
>>>
>>> around line 868 in wpa_supplicant.c
>>>
>>> #if defined(CONFIG_CTRL_IFACE) || !defined(CONFIG_NO_STDOUT_DEBUG)
>>>                 wpa_msg(wpa_s, MSG_INFO, WPA_EVENT_CONNECTED "- 
>>> Connection to "
>>>                         MACSTR " completed [id=%d id_str=%s%s]",
>>>                         MAC2STR(wpa_s->bssid),
>>>                         ssid ? ssid->id : -1,
>>>                         ssid && ssid->id_str ? ssid->id_str : "",
>>>                         fils_hlp_sent ? " FILS_HLP_SENT" : "");
>>> #endif /* CONFIG_CTRL_IFACE || !CONFIG_NO_STDOUT_DEBUG */
>>>
>>> You can pack whatever notification message inside the if statement.
>>
>> I'm not sure that actually is correct?  For instance, I see this in a 
>> case where
>> WPA-2 was not succesfully negotiated (note the reason-2 disconnect)
>>
>> IFNAME=sta9 <3>SME: Trying to authenticate with 00:0e:8e:f8:73:96 
>> (SSID='ota-9k-2 space' freq=5180 MHz)
>> IFNAME=sta9 <3>Trying to associate with 00:0e:8e:f8:73:96 
>> (SSID='ota-9k-2 space' freq=5180 MHz)
>> IFNAME=sta9 <3>Associated with 00:0e:8e:f8:73:96
>> IFNAME=sta9 <3>CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
>> IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 
>> [PTK=CCMP GTK=CCMP]
>> IFNAME=sta9 <3>CTRL-EVENT-CONNECTED - Connection to 00:0e:8e:f8:73:96 
>> completed [id=0 id_str=]
>> IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 
>> [PTK=CCMP GTK=CCMP]
>> IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 
>> [PTK=CCMP GTK=CCMP]
>> IFNAME=sta9 <3>WPA: Key negotiation completed with 00:0e:8e:f8:73:96 
>> [PTK=CCMP GTK=CCMP]
>> IFNAME=sta9 <3>CTRL-EVENT-DISCONNECTED bssid=00:0e:8e:f8:73:96 reason=2
>>
>>
>> Looks like I might need to add another message about EAPOL 4-way 
>> completing?
>
> Based on a sniff, it seems that the 3/4 was sent in this case, but the 
> 4/4 was not
> received from the AP.  Maybe the 3/4 is (re)sent incorrectly 
> sometimes....I have run into similar
> bugs in the past.
>
> Thanks,
> Ben
>
>
