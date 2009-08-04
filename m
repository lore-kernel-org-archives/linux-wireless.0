Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48714 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbZHDRNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:13:08 -0400
Subject: Re: Multiple rfkill knobs for the same hardware interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: mjg59@srcf.ucam.org, linux-wireless@vger.kernel.org
In-Reply-To: <200908041630.00533.arvidjaar@mail.ru>
References: <200908041630.00533.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 10:13:02 -0700
Message-Id: <1249405982.3094.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

> This is mostly the same situation as ACPI vs. platform backlight 
> control. Here on Dell XPS M1330:
> 
> {pts/1}% rfkill list
> 0: dell-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: dell-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 2: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 4: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 
> Arguably, either one in the pair is redundant. Moreover, hard disabling 
> wireless (using slider on notebook side):
> 
> {pts/1}% rfkill list
> 0: dell-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: dell-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 2: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 
> So dell-laptop actually lies claiming that both radios are enabled. Even 
> if this is a bug that can be fixed, having two knobs for exactly the 
> same piece of hardware is confusing at the very least.

this is clearly a bug in the dell-laptop module and it seems that
Matthew fixed that already.

The redundancy is just fine. The new RFKILL subsystem is capable of
handling it and we have OP_CHANGE_ALL for exactly this case. You either
wanna switch Bluetooth on or off. And with a 2.6.31 kernel you can do
exactly this and no longer have to bother with details of the RFKILL
switches representing Bluetooth for example.

Also while we would like to have the platform RFKILL switches mapping to
a device switch, it is in practice not possible since in most cases they
are using some kind of hotplug anyway.

Regards

Marcel


