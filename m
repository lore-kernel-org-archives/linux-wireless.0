Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46153 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAEVyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 16:54:43 -0500
Received: by mail-ob0-f173.google.com with SMTP id uy5so63114806obc.4
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 13:54:43 -0800 (PST)
Message-ID: <54AB0822.7070609@lwfinger.net> (sfid-20150105_225447_099384_A4C74237)
Date: Mon, 05 Jan 2015 15:54:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dougie Lawson <dl1ims@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8192CU / RTL8192CE frequent disconnections on Raspberry Pi
References: <54AAFFD5.8050606@gmail.com>
In-Reply-To: <54AAFFD5.8050606@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 03:19 PM, Dougie Lawson wrote:
> Hi Linux Wireless maintainers,
>
> I'm currently working with the 3.18 kernel and the new ARM device tree support
> on my Raspberry Pis. One major difference from the 3.12.35 kernel is that the
> out-of-tree driver for the RTL8188CUS WiFi dongles has been removed by the
> Raspberry Pi kernel maintainer. So the device is now using the
> rtlwifi/rtl8192cu/rtl8192c_common drivers from the upstream Linux source.
>
> Kernel version is 3.18.0
> Current kernel .config is below
> ver_linux output is attached below
>
> lsusb for the WiFi dongle shows:
> Bus 001 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n
> Wireless Adapter [Realtek RTL8188CUS]
>
> When the system is booted the wlan0 device comes up active, associates to my
> access point and runs OK. Some time later and I've frequently had the failure
> while running apt-get update (pulling lots of data from the Raspbian Wheezy
> repos) the network simply collapses. There's no abnormal messages in dmesg,
> nothing in syslog it just silently fails.

The mac80211-based driver for the RTL81XXCU has not been updated by the USB 
group since it was first released. Kernel 3.18 did include some changes in the 
core routines in rtlwifi. Those came from the PCI group, which is separate, and 
were not necessarily intended to fix rtl8192cu.

No one outside Realtek has any knowledge of the internals of any of the chips, 
thus I have no way to figure out what might cause the driver to fall over on 
heavy loads.

The one think I notice is that you are using old firmware. You can get the 
latest from 
git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git. As I 
have no idea what was changed, I do not know if it will help.

Larry


