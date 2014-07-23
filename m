Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50688 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaGWFsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 01:48:51 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so950218pdj.26
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 22:48:49 -0700 (PDT)
Message-ID: <53CF4CBE.9020402@aurabindo.in> (sfid-20140723_074854_658666_C4CF8722)
Date: Wed, 23 Jul 2014 11:18:46 +0530
From: Jay Aurabind <mail@aurabindo.in>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, iwl@linux.intel.com
Subject: [HELP] Intel 7260 powering up / down wifi inconsistency
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I know this is devel list, but iwlwifi web page points here for support. So here we go.

Initially, I couldnt turn off wifi. I am currently on Ubuntu 14.04 (fresh install). I tried the following commands:

Via NetworkManger "nmcli nm wifi off"
Via TLP "wifi off"
Via Unity GUI, Network Menu-> Uncheck "Enable WiFi"

These were the methods that I successfully used to switch off wifi in my previous laptop with an atheros card. However, with this "HP ENVY 15T J100" with Intel 7260 Card (possibly single band version), I cannot "really" turn off the wifi and bluetooth. Even when they show turned off in GUI, I mobile can pick them up (confirmed for bluetooth only).

In the default state (after powerup), "rfkill list" gives:

0: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: hci0: Bluetooth
	Soft blocked: no
	Hard blocked: no

If I give "rfkill block all", I get this:

0: phy0: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
1: hci0: Bluetooth
	Soft blocked: yes
	Hard blocked: no

Output of "dmesg | grep iwlwifi" is:

[    9.489423] iwlwifi 0000:07:00.0: irq 47 for MSI/MSI-X
[    9.633385] iwlwifi 0000:07:00.0: loaded firmware version 22.24.8.0 op_mode iwlmvm
[   10.339967] iwlwifi 0000:07:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
[   10.340063] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
[   10.340323] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
[   15.750742] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
[   15.751091] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S


This laptop does not have a dedicated physical wifi "switch". However, F12 is muxed with this function, and also hosts the wifi indicator led.

I've noticed that while system is booting up, the wifi is in off state because wifi indicator is orange color, called  "Airplane Mode" in windows 8. This laptop came with win8. Before I wiped it out, I put it to Airplane mode. As soon as Ubuntu starts up, wifi indicator becomes white. 

But things arent that worse. After I configured tlp to "block" all radio device on startup, wifi & bluetooth is "really" turned off. Now if I use nmcli, I can turn on/off the wifi.

So my question is: Why didnt it work the first time (before configuring TLP to disable radio at startup). Doest this behavior indicate a bug ? I actually dont remember if my previous laptop set up, whether I could / couldnt switch wifi *before* configuring TLP to block wifi with nmcli.

Cheers,
Aurabindo

