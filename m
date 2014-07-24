Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:39108 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162AbaGXGe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 02:34:28 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so1560611lam.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 23:34:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53CF4CBE.9020402@aurabindo.in>
References: <53CF4CBE.9020402@aurabindo.in>
Date: Thu, 24 Jul 2014 09:34:26 +0300
Message-ID: <CANUX_P0cPy5aVg-cv9MqncRsWX8FemkQhvG3KYwG=CUm9xgKVQ@mail.gmail.com> (sfid-20140724_083439_420416_6310EDD5)
Subject: Re: [HELP] Intel 7260 powering up / down wifi inconsistency
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jay Aurabind <mail@aurabindo.in>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwl@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 8:48 AM, Jay Aurabind <mail@aurabindo.in> wrote:
> Dear all,
>
> I know this is devel list, but iwlwifi web page points here for support. So here we go.
>
> Initially, I couldnt turn off wifi. I am currently on Ubuntu 14.04 (fresh install). I tried the following commands:
>
> Via NetworkManger "nmcli nm wifi off"
> Via TLP "wifi off"
> Via Unity GUI, Network Menu-> Uncheck "Enable WiFi"
>
> These were the methods that I successfully used to switch off wifi in my previous laptop with an atheros card. However, with this "HP ENVY 15T J100" with Intel 7260 Card (possibly single band version), I cannot "really" turn off the wifi and bluetooth. Even when they show turned off in GUI, I mobile can pick them up (confirmed for bluetooth only).
>
> In the default state (after powerup), "rfkill list" gives:
>
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
>
> If I give "rfkill block all", I get this:
>
> 0: phy0: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 1: hci0: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
>
> Output of "dmesg | grep iwlwifi" is:
>
> [    9.489423] iwlwifi 0000:07:00.0: irq 47 for MSI/MSI-X
> [    9.633385] iwlwifi 0000:07:00.0: loaded firmware version 22.24.8.0 op_mode iwlmvm
> [   10.339967] iwlwifi 0000:07:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
> [   10.340063] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
> [   10.340323] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
> [   15.750742] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
> [   15.751091] iwlwifi 0000:07:00.0: L1 Enabled; Disabling L0S
>
>
> This laptop does not have a dedicated physical wifi "switch". However, F12 is muxed with this function, and also hosts the wifi indicator led.
>
> I've noticed that while system is booting up, the wifi is in off state because wifi indicator is orange color, called  "Airplane Mode" in windows 8. This laptop came with win8. Before I wiped it out, I put it to Airplane mode. As soon as Ubuntu starts up, wifi indicator becomes white.
>
> But things arent that worse. After I configured tlp to "block" all radio device on startup, wifi & bluetooth is "really" turned off. Now if I use nmcli, I can turn on/off the wifi.
>
> So my question is: Why didnt it work the first time (before configuring TLP to disable radio at startup). Doest this behavior indicate a bug ? I actually dont remember if my previous laptop set up, whether I could / couldnt switch wifi *before* configuring TLP to block wifi with nmcli.
>

You lost me fairly quickly with lots of details that seem not really
related. In any case, putting WiFi in rfkill from Windows and then
removing Windows is not a good idea though.
