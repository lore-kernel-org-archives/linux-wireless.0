Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:56759 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab3GDC7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 22:59:23 -0400
Received: by mail-qa0-f44.google.com with SMTP id o13so3989598qaj.17
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 19:59:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51D41899.1010608@kaiwen.me>
References: <51D3E2C7.7020605@kaiwen.me>
	<CAChKcEmU9MMrC4gP4Vi3WWENTAC4+rtDK6mxA=5phdsEDxipxQ@mail.gmail.com>
	<51D41899.1010608@kaiwen.me>
Date: Thu, 4 Jul 2013 08:29:22 +0530
Message-ID: <CAChKcEnx12SE+qjYcp0yDpxB=w0gLKw9LM7z1=Dyz0=V91_TLw@mail.gmail.com> (sfid-20130704_045926_545923_F62E8C10)
Subject: Re: Use of 5GHz frequencies with Wi-Fi Direct
From: Gagan Goyal <gagsbond@gmail.com>
To: =?ISO-8859-1?Q?K=E9vin_THIERRY?= <kevin.thierry@kaiwen.me>
Cc: linux-wireless@vger.kernel.org, ronan lanoe <ronan.lanoe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that peer device is configured to use 2.4 Ghz channel.
Plz share the complete connection logs to confirm.

//Gagan

On 7/3/13, Kévin THIERRY <kevin.thierry@kaiwen.me> wrote:
> I'm using an Atheros WB222 Wi-Fi card.
>
> $ iw list
>
> [...]
> /Frequencies://
> //* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)//
> //* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)//
> //* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)//
> //* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)//
> //* 5260 MHz [52] (17.0 dBm) (passive scanning, no IBSS, radar detection)//
> //* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)//
> //* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)//
> //* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)//
> //* 5500 MHz [100] (disabled)//
> //* 5520 MHz [104] (disabled)//
> //* 5540 MHz [108] (disabled)//
> //* 5560 MHz [112] (disabled)//
> //* 5580 MHz [116] (disabled)//
> //* 5600 MHz [120] (disabled)//
> //* 5620 MHz [124] (disabled)//
> //* 5640 MHz [128] (disabled)//
> //* 5660 MHz [132] (disabled)//
> //* 5680 MHz [136] (disabled)//
> //* 5700 MHz [140] (disabled)//
> //* 5745 MHz [149] (17.0 dBm) (passive scanning, no IBSS)//
> //* 5765 MHz [153] (17.0 dBm) (passive scanning, no IBSS)//
> //* 5785 MHz [157] (17.0 dBm) (passive scanning, no IBSS)//
> //* 5805 MHz [161] (17.0 dBm) (passive scanning, no IBSS)//
> //* 5825 MHz [165] (17.0 dBm) (passive scanning, no IBSS)/
> [...]
>
>
> wpa_supplicant config file :
>
> /ctrl_interface=/var/run/wpa_supplicant//
> //ap_scan=1//
> //device_name=kevin_PC//
> //device_type=1-0050F204-1//
> //p2p_oper_reg_class=115//
> //p2p_oper_channel=36//
> //country=US/
>
>
> wpa_supplicant debug at start :
>
> /ctrl_interface='/var/run/wpa_supplicant'//
> //ap_scan=1//
> //device_name='kevin_PC'//
> //p2p_oper_reg_class=115//
> //p2p_oper_channel=36//
> //country='US'//
> //nl80211: interface wlan5 in phy phy0//
> //rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0//
> //rfkill: initial event: idx=1 type=2 op=0 soft=1 hard=0//
> //nl80211: Set mode ifindex 4 iftype 2 (STATION)//
> //nl80211: Subscribe to mgmt frames with non-AP handle 0x1e332f0//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 04 0a//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 04 0b//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 04 0c//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 04 0d//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=6): 04 09 50 6f 9a 09//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=5): 7f 50 6f 9a 09//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=1): 06//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 0a 07//
> //nl80211: Register frame type=0xd0 nl_handle=0x1e332f0//
> //nl80211: Register frame match - hexdump(len=2): 0a 11//
> //netlink: Operstate: linkmode=1, operstate=5//
> //nl80211: Using driver-based off-channel TX//
> //nl80211: TDLS supported//
> //nl80211: TDLS external setup//
> //nl80211: Use separate P2P group interface (driver advertised support)//
> //nl80211: driver param='(null)'//
> //nl80211: Regulatory information - country=US//
> //nl80211: 2402-2472 @ 40 MHz//
> //nl80211: 5170-5250 @ 40 MHz//
> //nl80211: 5250-5330 @ 40 MHz//
> //nl80211: 5490-5600 @ 40 MHz//
> //nl80211: 5650-5710 @ 40 MHz//
> //nl80211: 5735-5835 @ 40 MHz//
> //nl80211: Added 802.11b mode based on 802.11g information//
> //wlan5: Own MAC address: 00:0b:6b:7f:92:56//
> //wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=0
> set_tx=0 seq_len=0 key_len=0//
> //wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=1
> set_tx=0 seq_len=0 key_len=0//
> //wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=2
> set_tx=0 seq_len=0 key_len=0//
> //wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=3
> set_tx=0 seq_len=0 key_len=0//
> //wlan5: RSN: flushing PMKID list in the driver//
> //nl80211: Flush PMKIDs//
> //wlan5: State: DISCONNECTED -> INACTIVE//
> //WPS: Set UUID for interface wlan5//
> //WPS: UUID based on MAC address - hexdump(len=16): 97 71 b0 a8 da ca 57
> bf 99 80 01 b3 3f 50 26 de//
> //EAPOL: SUPP_PAE entering state DISCONNECTED//
> //EAPOL: Supplicant port status: Unauthorized//
> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
> //EAPOL: KEY_RX entering state NO_KEY_RECEIVE//
> //EAPOL: SUPP_BE entering state INITIALIZE//
> //EAP: EAP entering state DISABLED//
> //EAPOL: Supplicant port status: Unauthorized//
> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
> //EAPOL: Supplicant port status: Unauthorized//
> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
> //P2P: Own listen channel: 1//
> //P2P: Configured operating channel: 115:36//
> //P2P: Add operating class 81//
> //P2P: Channels - hexdump(len=12): 01 02 03 04 05 06 07 08 09 0a 0b 0d//
> //wlan5: Added interface wlan5//
> //wlan5: State: INACTIVE -> DISCONNECTED//
> //wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)//
> //netlink: Operstate: linkmode=-1, operstate=5//
> //random: Got 18/20 bytes from /dev/random//
> //RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])//
> //RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added//
> //nl80211: if_removed already cleared - ignore event//
> //EAPOL: disable timer tick//
> //EAPOL: Supplicant port status: Unauthorized//
> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
> //random: Got 2/2 bytes from /dev/random//
> //nl80211: Ignore event for foreign ifindex 2/
>
>
> It seems that the 5 GHz channels are added but the 2.4 GHz channels are
> still there and used instead of the frequency 5180.
>
> Kévin
>
> Le 03/07/2013 11:59, Gagan Goyal a écrit :
>> Hi Kevin,
>>
>> plz make sure that driver advertise the support for both the bands and
>> provide all the supported frequencies.
>>
>> During Supplicant init, supplicant read the driver capabilities and
>> along with other things the supported band and frequencies are stored.
>>
>> P2p global data is then initialized with same data.
>>
>> Cheers
>>
>> Gagan
>>
>> On 7/3/13, Kévin THIERRY <kevin.thierry@kaiwen.me> wrote:
>>> Hi,
>>>
>>> Is there a way to force the use of 5GHz frequencies with Wi-Fi Direct ?
>>> (Or define the 5GHz frequencies as preferred ?)
>>>
>>> I tried to add the freq_list option in wpa_supplicant config file
>>> without success. (I think this option should be set in a network block
>>> but there is no network block for Wi-Fi Direct...)
>>> "freq_list=5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560
>>> 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825"
>>>
>>> Thanks,
>>>
>>> Kevin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>
>
