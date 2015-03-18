Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38291 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbbCRVkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 17:40:10 -0400
Message-ID: <5509F0B5.7030601@broadcom.com> (sfid-20150318_224015_346236_44F00BDB)
Date: Wed, 18 Mar 2015 22:40:05 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: =?UTF-8?B?SsO8cmdlbiBCYXVzYQ==?= <Juergen.Bausa@online.de>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com>
In-Reply-To: <1426714179.26901.37.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/15 22:29, Dan Williams wrote:
> On Wed, 2015-03-18 at 21:24 +0000, Jürgen Bausa wrote:
>> Dan Williams<dcbw@...>  writes:
>>
>>>
>>>>
>>>> Thanks, that worked. Now I have firmware and nvram-file and the driver
>> seems
>>>> to load ok. At least I have an interface wlan0.
>>>>
>>>> However, I am not able to connect.Network-manager just says "interface is
>>>> being set up ..." forever. I have no idea howto debug this. In the other
>>>> post you said that the nl80211 driver should be used instead of wext. I
>>>> found that nl80211 is the default for network-manager. So, whats going
>> wrong
>>>> here?
>>>
>>> Could you provide more NetworkManager logs?  They should look like this;
>>> where do your logs stop?
>>>
>>
>>
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) starting
>> connection 'tuxgang'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) scheduled...
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) started...
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: disconnected ->  prepare (reason 'none') [30 40 0]
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  NetworkManager state is now
>> CONNECTING
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) scheduled...
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) complete.
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) starting...
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: prepare ->  config (reason 'none') [40 50 0]
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0/wireless):
>> connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: added 'ssid' value
>> 'tuxgang'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: added 'scan_ssid'
>> value '1'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: added 'key_mgmt'
>> value 'WPA-PSK'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: added 'auth_alg'
>> value 'OPEN'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: added 'psk' value
>> '<omitted>'
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) complete.
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  Config: set interface
>> ap_scan to 1
>> Mar 18 22:16:40 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: inactive ->  scanning
>> Mar 18 22:16:50 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: scanning ->  associating
>> Mar 18 22:17:00 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason -3)
>
> Something is still wrong with the driver/device.  Here, even though a
> scan has already been done and the SSID found (otherwise NM wouldn't
> have started a connection in the first place) the supplicant is doing
> another scan (10s) and then attempting to associate, which takes 10s
> before NM kills the attempt.
>
> So ignoring the scan issues (eg, why is another 10s scan requires when
> the SSID is already in the supplicant's network list) it still has
> association problems.
>
> NetworkManager allows up to 20s for an auth/assoc since that really,
> really should be enough.  If it's not enough, then something is
> seriously wrong with the hardware or the wifi network.
>
> Next steps:
>
> What does 'dmesg' say here?  Anything about association tries?
>
> After that we try getting supplicant debug logs and figuring out what's
> going on from its point of view.

Hi Dan,

Thanks for checking the network manager log.

Jurgen,

Do you have brcmfmac driver built with CONFIG_BRCMDBG. If so you can 
enable debug output by:

sudo sh -c 'echo 0xd416 > /sys/module/brcmfmac/parameters/debug'

Regards,
Arend

> Dan
>
>> Mar 18 22:17:00 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: associating ->  disconnected
>> Mar 18 22:17:00 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: disconnected ->  scanning
>> Mar 18 22:17:05 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> association took too long.
>> Mar 18 22:17:05 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: config ->  need-auth (reason 'none') [50 60 0]
>> Mar 18 22:17:05 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> asking for new secrets
>> Mar 18 22:17:05 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:17:05 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:17:29 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
>> CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting,
>> secret_name, error)' failed
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) scheduled...
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) started...
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: need-auth ->  prepare (reason 'none') [60 40 0]
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) scheduled...
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) complete.
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) starting...
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: prepare ->  config (reason 'none') [40 50 0]
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0/wireless):
>> connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: added 'ssid' value
>> 'tuxgang'
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: added 'scan_ssid'
>> value '1'
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: added 'key_mgmt'
>> value 'WPA-PSK'
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: added 'auth_alg'
>> value 'OPEN'
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: added 'psk' value
>> '<omitted>'
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) complete.
>> Mar 18 22:17:29 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  Config: set interface
>> ap_scan to 1
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: scanning ->  associated
>> Mar 18 22:17:29 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason -3)
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: associated ->  disconnected
>> Mar 18 22:17:29 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason 6)
>> Mar 18 22:17:29 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: disconnected ->  scanning
>> Mar 18 22:17:39 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: scanning ->  associating
>> Mar 18 22:17:49 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason -3)
>> Mar 18 22:17:49 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: associating ->  disconnected
>> Mar 18 22:17:49 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: disconnected ->  scanning
>> Mar 18 22:17:54 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> association took too long.
>> Mar 18 22:17:54 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: config ->  need-auth (reason 'none') [50 60 0]
>> Mar 18 22:17:54 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> asking for new secrets
>> Mar 18 22:17:54 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:17:54 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:18:00 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
>> CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting,
>> secret_name, error)' failed
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) scheduled...
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) started...
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: need-auth ->  prepare (reason 'none') [60 40 0]
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) scheduled...
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) complete.
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) starting...
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: prepare ->  config (reason 'none') [40 50 0]
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0/wireless):
>> connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: added 'ssid' value
>> 'tuxgang'
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: added 'scan_ssid'
>> value '1'
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: added 'key_mgmt'
>> value 'WPA-PSK'
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: added 'auth_alg'
>> value 'OPEN'
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: added 'psk' value
>> '<omitted>'
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) complete.
>> Mar 18 22:18:00 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Config: set interface
>> ap_scan to 1
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: scanning ->  4-way handshake
>> Mar 18 22:18:00 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason 6)
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: 4-way handshake ->  disconnected
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  Activation (wlan0/wireless):
>> disconnected during association, asking for new key.
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: config ->  need-auth (reason 'supplicant-disconnect') [50 60 8]
>> Mar 18 22:18:00 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: disconnected ->  inactive
>> Mar 18 22:18:07 lina NetworkManager[532]: (NetworkManager:532): libnm-util-
>> CRITICAL **: get_secret_flags: assertion 'is_secret_prop (setting,
>> secret_name, error)' failed
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) scheduled...
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) started...
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: need-auth ->  prepare (reason 'none') [60 40 0]
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) scheduled...
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 1
>> of 5 (Device Prepare) complete.
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) starting...
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: prepare ->  config (reason 'none') [40 50 0]
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0/wireless):
>> connection 'tuxgang' has security, and secrets exist.  No new secrets needed.
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: added 'ssid' value
>> 'tuxgang'
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: added 'scan_ssid'
>> value '1'
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: added 'key_mgmt'
>> value 'WPA-PSK'
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: added 'auth_alg'
>> value 'OPEN'
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: added 'psk' value
>> '<omitted>'
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Activation (wlan0) Stage 2
>> of 5 (Device Configure) complete.
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  Config: set interface
>> ap_scan to 1
>> Mar 18 22:18:07 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: inactive ->  associating
>> Mar 18 22:18:17 lina NetworkManager[532]:<warn>  Connection disconnected
>> (reason -3)
>> Mar 18 22:18:17 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: associating ->  disconnected
>> Mar 18 22:18:17 lina NetworkManager[532]:<info>  (wlan0): supplicant
>> interface state: disconnected ->  scanning
>> Mar 18 22:18:32 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> association took too long.
>> Mar 18 22:18:32 lina NetworkManager[532]:<info>  (wlan0): device state
>> change: config ->  need-auth (reason 'none') [50 60 0]
>> Mar 18 22:18:32 lina NetworkManager[532]:<warn>  Activation (wlan0/wireless):
>> asking for new secrets
>> Mar 18 22:18:32 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>> Mar 18 22:18:32 lina NetworkManager[532]:<warn>  Couldn't disconnect
>> supplicant interface: This interface is not connected.
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

