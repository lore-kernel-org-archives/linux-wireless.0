Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.digadd.de ([195.47.195.236]:33925 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0EZNPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 09:15:37 -0400
Message-ID: <4BFD1ED0.9050309@digadd.de>
Date: Wed, 26 May 2010 15:14:56 +0200
From: "Christian P. Schmidt" <schmidt@digadd.de>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems connectring to an AP with Acer Aspire Revo
References: <4BF795EB.9070902@digadd.de> <1274729665.2091.15280.camel@rchatre-DESK>
In-Reply-To: <1274729665.2091.15280.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2010 09:34 PM, reinette chatre wrote:
> On Sat, 2010-05-22 at 01:29 -0700, Christian P. Schmidt wrote:
>> However, even with the new card, I could not make any kernel from 2.6.32
>> to 2.6.34 connect to any of my access points. Those are a Telekom DSL
>> router and a Juniper NetScreen 5GT Wireless. I tried WEP64, WPA, WPA2,
>> and even no encryption at all. My laptop with an Intel WiFi Link 5300
>> has no problems whatsoever in any of the modes.
> 
> Could you please post some logs captured during your association
> attempts? Were there any errors in your logs? In addition to this,
> having mac80211 verbose debugging enabled will help and also
> wpa_supplicant logs. That will give us a place to start.
> 
> Reinette
> 

wpa_supplicant isn't particularly verbose:


Selected interface 'wlan0'

Interactive mode

> scan_r
bssid / frequency / signal level / flags / ssid
00:10:db:a1:69:21       2447    223
[WPA2-PSK-TKIP+CCMP-preauth][ESS]       digadd
00:10:db:a1:69:20       2447    214     [ESS]   test
<2>Authentication with 00:10:db:a1:69:21 timed out.
> <2>CTRL-EVENT-SCAN-RESULTS
> <2>Trying to associate with 00:10:db:a1:69:20 (SSID='test' freq=2447 MHz)
<2>Authentication with 00:10:db:a1:69:20 timed out.
<2>CTRL-EVENT-SCAN-RESULTS
> <2>Trying to associate with 00:10:db:a1:69:20 (SSID='test' freq=2447 MHz)
<2>Authentication with 00:10:db:a1:69:20 timed out.
<2>CTRL-EVENT-SCAN-RESULTS
> <2>Trying to associate with 00:10:db:a1:69:21 (SSID='digadd' freq=2447
MHz)
<2>Authentication with 00:10:db:a1:69:21 timed out.
> <2>CTRL-EVENT-SCAN-RESULTS
> <2>Trying to associate with 00:10:db:a1:69:21 (SSID='digadd' freq=2447
MHz)
<2>Authentication with 00:10:db:a1:69:21 timed out.

dmesg with verbose mac80211:

[66188.364996] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
in-tree:d
[66188.365474] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[66188.365839] iwlagn 0000:05:00.0: PCI INT A -> Link[LN4A] -> GSI 19
(level, low) -> IRQ 19
[66188.365855] iwlagn 0000:05:00.0: setting latency timer to 64
[66188.365909] iwlagn 0000:05:00.0: Detected Intel Wireless WiFi Link
5100AGN REV=0x54
[66188.386206] iwlagn 0000:05:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[66188.387527] iwlagn 0000:05:00.0: firmware: requesting
iwlwifi-5000-2.ucode
[66188.449118] iwlagn 0000:05:00.0: loaded firmware version 8.24.2.12
[66188.450753] phy1: Selected rate control algorithm 'iwl-agn-rs'
[66198.724027] phy1: device now idle
[66198.725051] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[66199.028356] phy1: device no longer idle - scanning
[66202.396651] phy1: device now idle
[66202.398713] phy1: device no longer idle - working
[66202.398733] wlan0: direct probe to 00:10:db:a1:69:21 (try 1)
[66202.598036] wlan0: direct probe to 00:10:db:a1:69:21 (try 2)
[66202.798041] wlan0: direct probe to 00:10:db:a1:69:21 (try 3)
[66202.998031] wlan0: direct probe to 00:10:db:a1:69:21 timed out
[66203.001034] phy1: device now idle
[66212.399658] phy1: device no longer idle - scanning
[66215.779131] phy1: device now idle
[66215.779591] phy1: device no longer idle - working
[66215.779607] wlan0: direct probe to 00:10:db:a1:69:21 (try 1)
[66215.979026] wlan0: direct probe to 00:10:db:a1:69:21 (try 2)
[66216.179027] wlan0: direct probe to 00:10:db:a1:69:21 (try 3)
[66216.379030] wlan0: direct probe to 00:10:db:a1:69:21 timed out
[66216.382034] phy1: device now idle
[66225.784782] phy1: device no longer idle - scanning
[66229.164447] phy1: device now idle
[66229.164848] phy1: device no longer idle - working
[66229.164864] wlan0: direct probe to 00:10:db:a1:69:20 (try 1)
[66229.364034] wlan0: direct probe to 00:10:db:a1:69:20 (try 2)
[66229.564030] wlan0: direct probe to 00:10:db:a1:69:20 (try 3)
[66229.764027] wlan0: direct probe to 00:10:db:a1:69:20 timed out
[66229.767035] phy1: device now idle
[66239.165261] phy1: device no longer idle - scanning
[66242.537751] phy1: device now idle
[66242.538524] phy1: device no longer idle - working
[66242.538545] wlan0: direct probe to 00:10:db:a1:69:20 (try 1)
[66242.738028] wlan0: direct probe to 00:10:db:a1:69:20 (try 2)
[66242.938033] wlan0: direct probe to 00:10:db:a1:69:20 (try 3)
[66243.138029] wlan0: direct probe to 00:10:db:a1:69:20 timed out
[66243.142031] phy1: device now idle

I kind of feel that no packets are sent, since I can't see them on the
firewall, even with packet dumps, not even association attempts.

Running tcpdump on the client doesn't show anything either, but I'm not
sure whether it would normally capture association attempts.

Regards,
Christian
