Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51786 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbbCZRAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 13:00:32 -0400
Message-ID: <55143B2D.9080805@broadcom.com> (sfid-20150326_180035_721125_FC3F7470)
Date: Thu, 26 Mar 2015 18:00:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>
CC: linux-wireless - ML <linux-wireless@vger.kernel.org>,
	<meuleman@broadcom.com>, <robertcnelson@gmail.com>,
	<hostap@lists.shmoo.com>
Subject: Re: AP mode failed on wandboard with brcm4329 chip
References: <55123F22.8070405@gmail.com> <5513F3C7.9080503@gmail.com>
In-Reply-To: <5513F3C7.9080503@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/15 12:55, Varka Bhadram wrote:
> On 03/25/2015 10:22 AM, Varka Bhadram wrote:
>> Hi,
>>
>> I am trying setup wandboard-quad as Access Point. It has BRCM4329 WiFi chip on it.
>>
>> As a client is working fine. But facing problem as a AP
>>
>> I did following steps...
>>
>> *1*. Linux kernel Configuration: Linux-3.19
>>
>> 	*i.**Device Drivers>  Network device support>  Wireless LAN*
>>     	<M>    Broadcom IEEE802.11n embedded FullMAC WLAN driver
>> 	[*]   SDIO bus interface support for FullMAC driver
>> 	[ ]   USB bus interface support for FullMAC driver
>> 	[ ]   PCIE bus interface support for FullMAC driver
>> 	[ ]   Broadcom device tracing
>> 	[*]   Broadcom driver debug functions
>> 	<*>    IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)
>> 	[*]     Support downloading firmware images with Host AP driver
>> 	[*]       Support for non-volatile firmware download
>> 	<  >      Host AP driver for Prism2/2.5/3 in PLX9052 PCI adaptors
>> 	<  >      Host AP driver for Prism2.5 PCI adaptors
>>
>> 	*ii.**  Networking support>  Wireless*
>> 	<M>    cfg80211 - wireless configuration API
>> 	[*]     nl80211 testmode command
>> 	[*]     enable developer warnings
>> 	[ ]     cfg80211 regulatory debugging
>> 	[ ]     cfg80211 certification onus
>> 	[ ]     enable powersave by default
>> 	[ ]     cfg80211 DebugFS entries
>> 	[ ]     use statically compiled regulatory rules database
>> 	[ ]     cfg80211 wireless extensions compatibility
>> 	[*]   lib80211 debugging messages
>> 	<  >    Generic IEEE 802.11 Networking Stack (mac80211)
>>
>> *2*. Copied brcm4329 firmware and nvram txt file into lib/firmware/brcm/
>>
>> *3*. hostapd.conf
>> interface=wlan0
>> driver=nl80211
>> logger_stdout=-1
>> logger_stdout_level=2
>> ssid=Service_Location
>> hw_mode=g
>> channel=1
>> auth_algs=3
>> max_num_sta=5
>> wpa=2
>> wpa_passphrase=scient12
>> wpa_key_mgmt=WPA-PSK
>> wpa_pairwise=CCMP TKIP
>> rsn_pairwise=CCMP
>> #wme_enabled=1
>> #ieee80211n=1
>> #ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]
>> *4*. After booting into the wandboard, did the following operations
>>
>> $ modprobe brcmfmac
>>
>> $ dmesg
>> [    9.147276] cfg80211: Calling CRDA to update world regulatory domain
>> [    9.171600] brcmfmac: F1 signature read @0x18000000=0x9934329
>> [    9.172649] brcmfmac: brcmf_sdio_drivestrengthinit: No SDIO Drive strength init donefor  chip 4329 rev 3 pmurev 6
>> [    9.379309] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Sep  2 2011 14:48:19 version 4.220.48
>> [    9.398690] brcmfmac: brcmf_setup_wiphybands: rxchain error (-52)
>>
>> $ hostapd -B hostapd.conf
>> Configuration file: hostapd.conf
>> Failed to create interface mon.wlan0: -95 (Operation not supported)
>> wlan0: Could not connect to kernel driver
>> Using interface wlan0 with hwaddr 40:2c:f4:ae:10:64 and ssid"Service_Location"
>> random: Cannot read from /dev/random: Resource temporarily unavailable
>> random: Only 0/20 bytes of strong random data available from /dev/random
>> random: Not enough entropy pool availablefor  secure operations
>> WPA: Not enough entropy in random poolfor  secure operations - update keys later when the first station connects
>> Failed to set beacon parameters
>> wlan0: Could not connect to kernel driver
>> Interface initialization failed
>> wlan0: interface state UNINITIALIZED->DISABLED
>> wlan0: AP-DISABLED
>> wlan0: Unable to setup interface.
>> wlan0: interface state DISABLED->DISABLED
>> wlan0: AP-DISABLED
>> hostapd_free_hapd_data: Interface wlan0 wasn't started
>> nl80211: deinit ifname=wlan0 disabled_11b_rates=0
>>
>> $ dmesg
>> [   30.870671] brcmfmac: _brcmf_set_multicast_list: Setting BRCMF_C_SET_PROMISC failed, -52
>> [   30.997372]*brcmfmac: brcmf_cfg80211_start_ap: setting AP mode failed -52*
>> [   31.171152] brcmfmac: _brcmf_set_multicast_list: Setting BRCMF_C_SET_PROMISC failed, -52
>>
>>
>>
>> Thanks
>> --
>> Varka Bhadram
> Ping...? Am i missing anything...?

I am not sure what happened with the initial email, but I never received 
it. My best bet is that the firmware is not supporting AP mode. Could 
you execute the following:

$ hexdump /lib/firmware/brcm/brcmfmac4329-sdio.bin | tail -20

Where did this firmware come from?

Regards,
Arend
