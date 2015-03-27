Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35979 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbbC0DXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 23:23:50 -0400
Received: by pdbcz9 with SMTP id cz9so82634959pdb.3
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 20:23:50 -0700 (PDT)
Message-ID: <5514CD33.30508@gmail.com> (sfid-20150327_042355_175897_6BE0ECA2)
Date: Fri, 27 Mar 2015 08:53:31 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless - ML <linux-wireless@vger.kernel.org>,
	meuleman@broadcom.com, robertcnelson@gmail.com,
	hostap@lists.shmoo.com
Subject: Re: AP mode failed on wandboard with brcm4329 chip
References: <55123F22.8070405@gmail.com> <5513F3C7.9080503@gmail.com> <55143B2D.9080805@broadcom.com>
In-Reply-To: <55143B2D.9080805@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend van Spriel,

On 03/26/2015 10:30 PM, Arend van Spriel wrote:

> On 03/26/15 12:55, Varka Bhadram wrote:
>> On 03/25/2015 10:22 AM, Varka Bhadram wrote:
>>> Hi,
>>>
>>> I am trying setup wandboard-quad as Access Point. It has BRCM4329
>>> WiFi chip on it.
>>>
>>> As a client is working fine. But facing problem as a AP
>>>
>>> I did following steps...
>>>
>>> *1*. Linux kernel Configuration: Linux-3.19
>>>
>>>     *i.**Device Drivers>  Network device support>  Wireless LAN*
>>>         <M>    Broadcom IEEE802.11n embedded FullMAC WLAN driver
>>>     [*]   SDIO bus interface support for FullMAC driver
>>>     [ ]   USB bus interface support for FullMAC driver
>>>     [ ]   PCIE bus interface support for FullMAC driver
>>>     [ ]   Broadcom device tracing
>>>     [*]   Broadcom driver debug functions
>>>     <*>    IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)
>>>     [*]     Support downloading firmware images with Host AP driver
>>>     [*]       Support for non-volatile firmware download
>>>     <  >      Host AP driver for Prism2/2.5/3 in PLX9052 PCI adaptors
>>>     <  >      Host AP driver for Prism2.5 PCI adaptors
>>>
>>>     *ii.**  Networking support>  Wireless*
>>>     <M>    cfg80211 - wireless configuration API
>>>     [*]     nl80211 testmode command
>>>     [*]     enable developer warnings
>>>     [ ]     cfg80211 regulatory debugging
>>>     [ ]     cfg80211 certification onus
>>>     [ ]     enable powersave by default
>>>     [ ]     cfg80211 DebugFS entries
>>>     [ ]     use statically compiled regulatory rules database
>>>     [ ]     cfg80211 wireless extensions compatibility
>>>     [*]   lib80211 debugging messages
>>>     <  >    Generic IEEE 802.11 Networking Stack (mac80211)
>>>
>>> *2*. Copied brcm4329 firmware and nvram txt file into
>>> lib/firmware/brcm/
>>>
>>> *3*. hostapd.conf
>>> interface=wlan0
>>> driver=nl80211
>>> logger_stdout=-1
>>> logger_stdout_level=2
>>> ssid=Service_Location
>>> hw_mode=g
>>> channel=1
>>> auth_algs=3
>>> max_num_sta=5
>>> wpa=2
>>> wpa_passphrase=scient12
>>> wpa_key_mgmt=WPA-PSK
>>> wpa_pairwise=CCMP TKIP
>>> rsn_pairwise=CCMP
>>> #wme_enabled=1
>>> #ieee80211n=1
>>> #ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]
>>> *4*. After booting into the wandboard, did the following operations
>>>
>>> $ modprobe brcmfmac
>>>
>>> $ dmesg
>>> [    9.147276] cfg80211: Calling CRDA to update world regulatory domain
>>> [    9.171600] brcmfmac: F1 signature read @0x18000000=0x9934329
>>> [    9.172649] brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive
>>> strength init donefor  chip 4329 rev 3 pmurev 6
>>> [    9.379309] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
>>> wl0: Sep  2 2011 14:48:19 version 4.220.48
>>> [    9.398690] brcmfmac: brcmf_setup_wiphybands: rxchain error (-52)
>>>
>>> $ hostapd -B hostapd.conf
>>> Configuration file: hostapd.conf
>>> Failed to create interface mon.wlan0: -95 (Operation not supported)
>>> wlan0: Could not connect to kernel driver
>>> Using interface wlan0 with hwaddr 40:2c:f4:ae:10:64 and
>>> ssid"Service_Location"
>>> random: Cannot read from /dev/random: Resource temporarily unavailable
>>> random: Only 0/20 bytes of strong random data available from
>>> /dev/random
>>> random: Not enough entropy pool availablefor  secure operations
>>> WPA: Not enough entropy in random poolfor  secure operations -
>>> update keys later when the first station connects
>>> Failed to set beacon parameters
>>> wlan0: Could not connect to kernel driver
>>> Interface initialization failed
>>> wlan0: interface state UNINITIALIZED->DISABLED
>>> wlan0: AP-DISABLED
>>> wlan0: Unable to setup interface.
>>> wlan0: interface state DISABLED->DISABLED
>>> wlan0: AP-DISABLED
>>> hostapd_free_hapd_data: Interface wlan0 wasn't started
>>> nl80211: deinit ifname=wlan0 disabled_11b_rates=0
>>>
>>> $ dmesg
>>> [   30.870671] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -52
>>> [   30.997372]*brcmfmac: brcmf_cfg80211_start_ap: setting AP mode
>>> failed -52*
>>> [   31.171152] brcmfmac: _brcmf_set_multicast_list: Setting
>>> BRCMF_C_SET_PROMISC failed, -52
>>>
>>>
>>>
>>> Thanks
>>> -- 
>>> Varka Bhadram
>> Ping...? Am i missing anything...?
>
> I am not sure what happened with the initial email, but I never
> received it. My best bet is that the firmware is not supporting AP
> mode. Could you execute the following:
>
> $ hexdump /lib/firmware/brcm/brcmfmac4329-sdio.bin | tail -20
>
> Where did this firmware come from?
>
> Regards,
> Arend

Thanks for responding..

I used firmware which is there in linux-firmware[1] git tree.

$ hexdump /lib/firmware/brcm/brcmfmac4329-sdio.bin | tail -20

003de10 00f0 0200 4500 006f 4f13 8702 e728 1300
003de20 014f 60bc 0213 a117 0200 025e 00f0 02d3
003de30 a887 00e7 4c13 0801 6740 0a00 0139 e087
003de40 4705 392a 8801 0260 3703 00a2 5e02 f002
003de50 d900 8701 0560 2a47 0039 de02 f002 0000
003de60 0000 0000 0000 8600 61d6 0483 30dc 2800
003de70 614f 194e 235b 2215 5552 4969 4708 3128
003de80 0000 0000 0000 0000 0000 8e00 77ff b001
003de90 ffc6 e221 319e 010d 32bd 0208 3400 3233
003dea0 6239 2f31 6473 6f69 672d 632d 6364 662d
003deb0 6c75 316c 6e31 722d 6365 616c 6d69 722d
003dec0 6d6f 2d6c 6d77 2d65 6e70 2d6f 6f61 2d65
003ded0 6b70 6674 6c69 6574 2d72 656b 7065 6c61
003dee0 7669 2d65 656d 726d 6465 7875 3631 5620
003def0 7265 6973 6e6f 203a 2e34 3232 2e30 3834
003df00 302e 4320 4352 203a 6337 6539 3932 3937
003df10 4420 7461 3a65 4620 6972 3220 3130 2d31
003df20 3930 302d 2032 3431 343a 3a38 3432 5020
003df30 5444 0095                              
003df34

Also pasted NVRAM text file at [2]. Please check it.

Is this problem occurred because of firmware..? 

If so where is the AP supported firmware binary and NVRAM file..?

Thanks..

[1]: https://kernel.googlesource.com/pub/scm/linux/kernel/git/firmware/linux-firmware
[2]: http://paste.ubuntu.com/10687373/

-- 
Varka Bhadram

