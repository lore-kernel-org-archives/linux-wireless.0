Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tor.lindesign.se ([194.17.154.111]:58079 "EHLO tor.lindesign.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYDEOju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 10:39:50 -0400
Message-ID: <47F78F2F.8000605@tor.lindesign.se> (sfid-20080405_154013_544991_73F973EF)
Date: Sat, 05 Apr 2008 16:39:43 +0200
From: Bachman Kharazmi <bachman@tor.lindesign.se>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [SOLVED] Re: compat-wireless iwl4965 on hp/compaq 2510p
References: <47F75EB4.9090703@tor.lindesign.se>	 <1207396223.3860.9.camel@johannes.berg>	 <47F76814.7010405@tor.lindesign.se>	 <1207396488.3860.12.camel@johannes.berg>	 <47F76A0A.3080806@tor.lindesign.se> <1ba2fa240804050637g13a92505j5d4d65234db8c6fc@mail.gmail.com> <47F78349.8080704@tor.lindesign.se>
In-Reply-To: <47F78349.8080704@tor.lindesign.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's what I did:
(-Compiled my own 2.6.24-4 instead of using debian kernel.)
-Booted XPee and hoped that all the clicking enabled the WLAN device. It 
seem to be a software button, like a touch panel.
-Entered BIOS, disabled switching wlan button to hopefully keep the 
state constant(ON).

And finally I did configure my WEP, and requested IP and now I'm online ;)

thx guys! /Bachman

Bachman Kharazmi wrote:
> Not that easy.
> When the module is loaded I press the (touch) panel where the wireless 
> icon is. This still doesn't turn on the WLAN LED.
> Nothing in dmesg then I press the touchbutton.
> 
> lapp:/tmp# cat /sys/bus/pci/drivers/iwl4965/0000\:10\:00.0/rf_kill
> 2
> 
> echo "1" > /sys/bus/pci/drivers/iwl4965/0000\:10\:00.0/rf_kill
> iwl4965: Error sending REPLY_CARD_STATE_CMD: enqueue_hcmd failed: -5
> 
> echo "0" > /sys/bus/pci/drivers/iwl4965/0000\:10\:00.0/rf_kill
> iwl4965: WARNING: Requesting MAC access during RFKILL wakes up NIC
> 
> lapp:/tmp# cat /sys/bus/pci/drivers/iwl4965/0000\:10\:00.0/rf_kill
> 2
> 
> /Bachman
> Tomas Winkler wrote:
>> On Sat, Apr 5, 2008 at 3:01 PM, Bachman Kharazmi
>> <bachman@tor.lindesign.se> wrote:
>>> lapp:/tmp# ip link set wlan0 up
>>>  SIOCSIFFLAGS: No such device
>>>
>>>  lapp:/tmp# iwconfig
>>>  lo        no wireless extensions.
>>>
>>>  eth1      no wireless extensions.
>>>
>>>  wmaster0  no wireless extensions.
>>>
>>>  wlan0     IEEE 802.11  ESSID:"planet_mars"
>>>           Mode:Managed  Frequency:2.412 GHz  Access Point: 
>>> Not-Associated
>>>           Tx-Power=0 dBm
>>>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>>>           Encryption key:B200-A927-32DA-86E9-0DEF-EFF3-FB
>>>           Link Quality:0  Signal level:0  Noise level:0
>>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>
>>>
>>>  note that dmesg sais
>>>  iwl4965: Detected Intel Wireless WiFi Link 4965AGN
>>>  iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
>>>  phy1: Selected rate control algorithm 'iwl-4965-rs'
>>>  ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
>>>  iwl4965: Radio disabled by HW RF Kill switch
>>
>> ___iwl4965: Radio disabled by HW RF Kill switch___  this would explain
>> the problem
>>
>> can you please enable the RF?
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
