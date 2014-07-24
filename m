Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38505 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaGXJez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 05:34:55 -0400
Received: by mail-pa0-f52.google.com with SMTP id bj1so3590673pad.39
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 02:34:54 -0700 (PDT)
Message-ID: <53D0D335.5050702@aurabindo.in> (sfid-20140724_113458_642243_3EFA8D58)
Date: Thu, 24 Jul 2014 15:04:45 +0530
From: Jay Aurabind <mail@aurabindo.in>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	iwl@linux.intel.com
Subject: Re: [HELP] Intel 7260 powering up / down wifi inconsistency
References: <53CF4CBE.9020402@aurabindo.in> <CANUX_P0cPy5aVg-cv9MqncRsWX8FemkQhvG3KYwG=CUm9xgKVQ@mail.gmail.com>
In-Reply-To: <CANUX_P0cPy5aVg-cv9MqncRsWX8FemkQhvG3KYwG=CUm9xgKVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2014 12:04 PM, Emmanuel Grumbach wrote:
> On Wed, Jul 23, 2014 at 8:48 AM, Jay Aurabind <mail@aurabindo.in> wrote:
>> Dear all,
>>
>> I know this is devel list, but iwlwifi web page points here for support. So here we go.
>>
>> Initially, I couldnt turn off wifi. I am currently on Ubuntu 14.04 (fresh install). I tried the following commands:
>>
>> Via NetworkManger "nmcli nm wifi off"
>> Via TLP "wifi off"
>> Via Unity GUI, Network Menu-> Uncheck "Enable WiFi"
>>
>> These were the methods that I successfully used to switch off wifi in my previous laptop with an atheros card. However, with this "HP ENVY 15T J100" with Intel 7260 Card (possibly single band version), I cannot "really" turn off the wifi and bluetooth. Even when they show turned off in GUI, I mobile can pick them up (confirmed for bluetooth only).
>>
>> In the default state (after powerup), "rfkill list" gives:
>>
>> 0: phy0: Wireless LAN
>>         Soft blocked: no
>>         Hard blocked: no
>> 1: hci0: Bluetooth
>>         Soft blocked: no
>>         Hard blocked: no
>>
>> If I give "rfkill block all", I get this:
>>
>> 0: phy0: Wireless LAN
>>         Soft blocked: yes
>>         Hard blocked: no
>> 1: hci0: Bluetooth
>>         Soft blocked: yes
>>         Hard blocked: no
>>
>> Output of "dmesg | grep iwlwifi" is:
>>
>> [    9.489423] iwlwifi 0000:07:00.0: irq 47 for MSI/MSI-X
>> [    9.633385] iwlwifi 0000:07:00.0: loaded firmware version 22.24.8.0 op_mode iwlmvm
>> [   10.339967] iwlwifi 0000:07:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
>> [   10.340063] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
>> [   10.340323] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
>> [   15.750742] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
>> [   15.751091] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
>>
>>
>> This laptop does not have a dedicated physical wifi "switch". However, F12 is muxed with this function, and also hosts the wifi indicator led.
>>
>> I've noticed that while system is booting up, the wifi is in off state because wifi indicator is orange color, called  "Airplane Mode" in windows 8. This laptop came with win8. Before I wiped it out, I put it to Airplane mode. As soon as Ubuntu starts up, wifi indicator becomes white.
>>
>> But things arent that worse. After I configured tlp to "block" all radio device on startup, wifi & bluetooth is "really" turned off. Now if I use nmcli, I can turn on/off the wifi.
>>
>> So my question is: Why didnt it work the first time (before configuring TLP to disable radio at startup). Doest this behavior indicate a bug ? I actually dont remember if my previous laptop set up, whether I could / couldnt switch wifi *before* configuring TLP to block wifi with nmcli.
>>
> 
> You lost me fairly quickly with lots of details that seem not really
> related. In any case, putting WiFi in rfkill from Windows and then
> removing Windows is not a good idea though.
> 

Now it doesnt look like Ubuntu's private problem. After I updated my system (archlinux), I found this problem to reappear. So I began downgrading packages and I finally figured out the culprit.

This is the one that caused the breakage (from pacman log): 

[PACMAN] upgraded linux-api-headers (3.13.2-1 -> 3.14.1-1)

I reverted back to 3.13.2-1 and wifi toggle is working again. 

The kernel version doestn seem to make any problems. I tried on both 3.12.9-2 and 3.15.5-2 with linux-api-headers 3.13.2-1

So this is *definitely* kernel problem. I dont understand why the api header pacakge is of a lower version than the latest kernel they pack. 

Where should I file a bug report? arch or the kenrel ?
