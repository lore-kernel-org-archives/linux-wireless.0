Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:46578 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZJZO5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:57:16 -0400
Received: by iwn10 with SMTP id 10so5997859iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 07:57:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e14196febc59d9ca25868fec63816139.squirrel@webmail.xs4all.nl>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
	<20090831175932.GC5631@tuxdriver.com> <b88bb1ad0909121654w43215f60lf9d7b90d4b54bf35@mail.gmail.com>
	<4AE1FE7F.2090309@gmail.com> <e14196febc59d9ca25868fec63816139.squirrel@webmail.xs4all.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Oct 2009 07:57:01 -0700
Message-ID: <43e72e890910260757t53a3f56bxddd693603bc0c444@mail.gmail.com>
Subject: Re: Only device wlan1 but no connection Fritz!WLAN USB stick N2.4
To: Ed Vaessen <evaessen@xs4all.nl>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 6:17 AM, Ed Vaessen <evaessen@xs4all.nl> wrote:
> I have a Fritz!Box Fon WLAN 7170 as router and try to connect wireless to
> it with the Fritz!WLAN USB N2.4 stick using the compat-wireless software.
> Without succes so far.

> Oct 25 15:38:38 vaessen-laptop kernel: [ 399.349605] usb 1-1: USB
> disconnect, address 5
> Oct 25 15:38:39 vaessen-laptop kernel: [ 400.608057] usb 1-1: new high
> speed USB device using ehci_hcd and address 6
> Oct 25 15:38:39 vaessen-laptop kernel: [ 400.771795] usb 1-1:
> configuration #1 chosen from 1 choice
> Oct 25 15:38:39 vaessen-laptop kernel: [ 400.888063] usb 1-1: reset high
> speed USB device using ehci_hcd and address 6
> Oct 25 15:38:40 vaessen-laptop kernel: [ 402.044043] usb 1-1: firmware:
> requesting ar9170.fw
> Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465806] Registered led
> device: ar9170-phy1::tx
> Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465846] Registered led
> device: ar9170-phy1::assoc
> Oct 25 15:38:41 vaessen-laptop kernel: [ 402.465851] usb 1-1: Atheros
> AR9170 is registered as 'phy1'
> Oct 25 15:38:41 vaessen-laptop kernel: [ 402.471136] udev: renamed network
> interface wlan0 to wlan1
>
> It seems the firmware is installed.
> Command iwconfig:
>
> lo no wireless extensions.
>
> eth0 no wireless extensions.
>
> pan0 no wireless extensions.
>
> wlan1 IEEE 802.11bg Mode:Managed Access Point: Not-Associated
> Tx-Power=0 dBm
> Retry long limit:7 RTS thrff Fragment thrff
> Power Managementff
>
> Command sudo lshw -C network gives for the wireless this information:
>
> *-network:1 DISABLED
> description: Wireless interface
> physical id: 2
> bus info: usb@1:1
> logical name: wlan1
> serial: 00:1f:3f:09:2d:40
> capabilities: ethernet physical wireless
> configuration: broadcast=yes driver=ar9170usb
> driverversion=2.6.28-16-generic firmware=N/A link=yes multicast=yes
> wireless=IEEE 802.11bg
>
> This 'firmware=N/A' puzzles me.

That's probably from ethtool, and since John added ethtool support all
we would need to do I think is tag the firmware name on the wiphy
struct (wiphy->fw_version). But we haven't added that yet to ar9170.

> I used System->Administration->Network Tools but cannot ping the Fritz!Box
> router
> The interface information says that wireless interface wlan1 is inactive.
>
> How do I make it active?

Bring the interface up first:

ip link set dev wlan1 up

Then use iw to scan for example

  Luis
