Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:24822 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab3JYC3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 22:29:39 -0400
Message-ID: <5269D154.5000606@kevlo.org> (sfid-20131025_042951_292684_5EAFC3F9)
Date: Fri, 25 Oct 2013 10:03:00 +0800
From: Kevin Lo <kevlo@kevlo.org>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: update RF registers
 for RT5390
References: <20131024052408.GA7828@ns.kevlo.org> <52694D8B.1030308@01019freenet.de>
In-Reply-To: <52694D8B.1030308@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Hartmann wrote:
> Hi Kevin,

Hi Andreas,

> Kevin Lo wrote:
>> Mirror the latest MediaTek/Ralink driver with respect to RT5390 RF register
>> programming.  The PCI and USB devices use different init values.
> If you (and others here) really want to improve anything for rt2800usb,
> change your development system and use a raspberry pi (PI).
>
> Why PI? Because the PI doesn't cover any broken code / concept / driver
> architecture with hardware resources.
>
> You want to have an example?
>
> This device[1] achieves 140 MBit/s (data receiving) on the PI, measured
> with netperf and rt5572sta compared to rt2800usb, which achieves very
> very very poor 30 MBit/s(! - even w/ best radio conditions can't be
> achieved any more) but an extremely high CPU load at the same time!
>
> If you compare the basic behaviour of rt5572sta and rt2800usb, you will
> see, that rt5572sta uses a completely different usb handling, which
> doesn't need that much CPU resources as the one used by rt2800usb.
>
> Therefore: If you really want to improve rt2800usb, at first take a
> serious look at how usb is handled by rt5572sta and how to save CPU
> resources.
>
> In a nutshell: Use a few, but big USB packets instead of a lot of small
> ones, which needs a lot of interrupts / s and therefore needs a lot of
> CPU resources - which aren't available on the PI at all.

I have a lot of embedded devices (Freescale imx5/imx6, Marvell armanda xp
... etc) here and I've also noticed usb performance issues.

Firstly, I want to sync register settings, which is obtained from the
vendor driver.  When it's done, I will take a look at how usb is handled by
the vendor driver and fix performance issues.  Since I don't have 
datasheets,
I'm not sure updating register values won't help much...

>
>
> Kind regards,
> Andreas
>
>
>
> [1] http://wikidevi.com/wiki/Linksys_AE3000

     Kevin
