Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:18625 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbAXL0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 06:26:39 -0500
Message-ID: <54C3816D.9070609@broadcom.com> (sfid-20150124_122643_578740_BF28A770)
Date: Sat, 24 Jan 2015 12:26:37 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <jkrause@posteo.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: brcmfmac: kernel panic in brcmf_cfg80211_del_key
References: <1422016318.1212.22.camel@posteo.de>	 <54C258DB.7050308@broadcom.com> <1422055797.1850.14.camel@posteo.de>
In-Reply-To: <1422055797.1850.14.camel@posteo.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/15 00:29, Jörg Krause wrote:
> Hi Arend,
>
> On Fr, 2015-01-23 at 15:21 +0100, Arend van Spriel wrote:
>> On 01/23/15 13:31, Jörg Krause wrote:
>>> Hi all,
>>>
>>> I'm running an wireless device with Linux kernel 3.18.3 and the brcmfmac
>>> driver. When connection the device to my network, I see from time to
>>> time these messages in the kernel log:
>>>
>>> [  899.624759] brcmfmac: brcmf_cfg80211_del_key: invalid key index (4)
>>> [  899.649874] brcmfmac: brcmf_cfg80211_del_key: invalid key index (5)
>>> [  899.678066] cfg80211: Calling CRDA to update world regulatory domain
>>>
>>> I'm not sure about the meaning of the 'invalid key index' messages and
>>> if it may cause some trouble. However the system is running fine.
>>
>> Basically, wpa_supplicant does key deletion for index 0 to 5, but
>> brcmfmac only has 4 keys (0 to 3) hence the message. This is not an issue.
>
> I see!
>
>>
>>> Now I had a test case with two wireless devices having the same hostname
>>> and MAC address in the same network.
>>
>> What? Why is this a test case. That is fundamentally wrong and asking
>> for trouble.
>
> You're absolutely right! To be honest it's not a real test. We're having
> trouble with some wireless audio devices and multiroom playback. In fact
> I wanted to simulate in a quick and dirty way what happens if the audio
> device does not receive some expected UDP packets from the audio
> streaming source because they get lost.
>
>>
>>> The first wireless devices connects to the network and starts receiving
>>> an audio stream via UDP. Another device with same hostname and MAC is
>>> started after this and repeatedly reboots after 30 seconds.
>>>
>>> The first device gets disconnected after the second device connects to
>>> the network. The device is running with the network tools tools
>>> wpa_supplicant, a wpa_action script, udhcpc, avahi, and crda. The device
>>> tries to reconnect to the network. It successfully connects, but
>>> authentification fails. This step produces a lot of the kernel messages
>>> from above.
>>>
>>> Okay, nothing wrong until here I think. But after some time the brcmfmac
>>> driver is dying:
>>>
>>> [  901.799454] ------------[ cut here ]------------
>>> [  901.804332] WARNING: CPU: 0 PID: 104 at
>>> drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c:1076
>>> brcmf_netdev_wait_pend8021x+0xe0/0xf4 [brcmfmac]()
>>> [  901.866565] Modules linked in:
>>> [  901.907705] 	brcmfmac brcmutil
>>> [  901.909298] CPU: 0 PID: 104 Comm: wpa_supplicant Not tainted 3.18.3
>>> #1
>>> [  901.959287] [<c000de40>] (unwind_backtrace) from [<c000c1f4>]
>>> (show_stack+0x10/0x14)
>>> [  901.993628] [<c000c1f4>] (show_stack) from [<c0016400>]
>>> (warn_slowpath_common+0x68/0x88)
>>> [  902.016243] [<c0016400>] (warn_slowpath_common) from [<c00164bc>]
>>> (warn_slowpath_null+0x1c/0x24)
>>> [  902.040249] [<c00164bc>] (warn_slowpath_null) from [<bf016304>]
>>> (brcmf_netdev_wait_pend8021x+0xe0/0xf4 [brcmfmac])
>>> [  902.067408] [<bf016304>] (brcmf_netdev_wait_pend8021x [brcmfmac])
>>> from [<bf0061d8>] (brcmf_cfg80211_get_key+0x1a8/0x374 [brcmfmac])
>>> [  902.098434] [<bf0061d8>] (brcmf_cfg80211_get_key [brcmfmac]) from
>>> [<bf00770c>] (brcmf_cfg80211_del_key+0x1d8/0x2e0 [brcmfmac])
>>> [  902.164527] [<bf00770c>] (brcmf_cfg80211_del_key [brcmfmac]) from
>>> [<bf0078ec>] (brcmf_cfg80211_add_key+0xd8/0x248 [brcmfmac])
>>> [  902.213096] [<bf0078ec>] (brcmf_cfg80211_add_key [brcmfmac]) from
>>> [<c037f368>] (nl80211_new_key+0x108/0x144)
>>> [  902.253581] [<c037f368>] (nl80211_new_key) from [<c02ccb98>]
>>> (genl_rcv_msg+0x22c/0x39c)
>>> [  902.290997] [<c02ccb98>] (genl_rcv_msg) from [<c02cc12c>]
>>> (netlink_rcv_skb+0xb4/0xd8)
>>> [  902.325813] [<c02cc12c>] (netlink_rcv_skb) from [<c02cc958>]
>>> (genl_rcv+0x20/0x34)
>>> [  902.363540] [<c02cc958>] (genl_rcv) from [<c02cbaa8>]
>>> (netlink_unicast+0x14c/0x1cc)
>>> [  902.399402] [<c02cbaa8>] (netlink_unicast) from [<c02cbe98>]
>>> (netlink_sendmsg+0x2b8/0x39c)
>>> [  902.435798] [<c02cbe98>] (netlink_sendmsg) from [<c0297860>]
>>> (sock_sendmsg+0x84/0xa8)
>>> [  902.477184] [<c0297860>] (sock_sendmsg) from [<c0298d28>]
>>> (___sys_sendmsg.part.32+0x284/0x290)
>>> [  902.486197] [<c0298d28>] (___sys_sendmsg.part.32) from [<c0299d34>]
>>> (__sys_sendmsg+0x4c/0x7c)
>>> [  902.555011] [<c0299d34>] (__sys_sendmsg) from [<c0009620>]
>>> (ret_fast_syscall+0x0/0x44)
>>> [  902.591178] ---[ end trace 93a9f5360e80c5ca ]---
>>>
>>> I'm not sure if I should worry about this issue.
>>
>> Well, what is happening here is that the driver got a EAPOL message from
>> the network stack to transmit and then got a key config request. That
>> key config is held until transmit of EAPOL is completed. So it is
>> suspicious.
>
> You're right, it's a warning. Does it mean the network stack gets messy
> due to this wrong setup?

Well, this is what I think happens:

1. we receive M3 of the 4-way handshake from AP.
2. wpa_supplicant derives the encryption keys.
3. wpa_supplicant sends M4 down to the driver.
4. wpa_supplicant configures the keys in driver.

The brcmfmac driver want to assure the M4 message is sent before the 
keys are configured. Otherwise, the M4 message might be sent to the AP 
being encrypted. So when this happens the AP will probably DEAUTH and 
wpa_supplicant will try to connect again. If you keep seeing this 
warning over and over in the log than it is definitely an issue.

Regards,
Arend
