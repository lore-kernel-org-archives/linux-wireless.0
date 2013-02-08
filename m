Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63672 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946552Ab3BHQYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 11:24:13 -0500
Received: by mail-ob0-f171.google.com with SMTP id x4so3945915obh.30
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 08:24:12 -0800 (PST)
Message-ID: <511526A8.4010604@lwfinger.net> (sfid-20130208_172556_559794_5AB30236)
Date: Fri, 08 Feb 2013 10:24:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dag Wieers <dag@wieers.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: BCM4321 (b43) on AppleTV (1st gen)
References: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
In-Reply-To: <alpine.LRH.2.02.1302072238200.2736@pikachu.3ti.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2013 05:01 PM, Dag Wieers wrote:
> And that the kernel has been compiled using:
> ----
> CONFIG_B43=m
> CONFIG_B43_SSB=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> CONFIG_B43_PIO=y
> CONFIG_B43_PHY_N=y
> CONFIG_B43_PHY_LP=y
> CONFIG_B43_PHY_HT=y
> CONFIG_B43_LEDS=y
> CONFIG_B43_DEBUG=y
> ----
>
> If the above can be trimmed down for this type of device I'd like to hear that
> as well (e.g. I am not sure if we need PIO or LEDS in this case).
>
> PS I am also interested in any power management capabilities the device has and
> that we could enable when the device is idle, since the system lacks proper
> power management capabilities by itself (suspend/hibernate) and seems to have a
> limited ACPI implementation.

As no one else seems to be responding, I'll try.

In the configuration, you certainly do not need PIO or LEDS. For that particular 
device, you also do not need PHY_LP, as that is strictly an 802.11g PHY. As to 
power-management capabilities, there are no configurable parameters.

What throughput do you get with Broadcom-wl with your setup? That will give you 
an idea of the potential performance of the device. As the equivalent of wl was 
used for the reverse engineering, that will certainly be the upper limit of what 
b43 can do. Only if the RE was perfect could we match that result.

Larry


