Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42818 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbJ1TEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 15:04:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] ssb: pick PCMCIA host code support from b43 driver
References: <1444850346-23085-1-git-send-email-zajec5@gmail.com>
	<1444886605-17010-1-git-send-email-zajec5@gmail.com>
Date: Wed, 28 Oct 2015 21:04:28 +0200
In-Reply-To: <1444886605-17010-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 15 Oct 2015
 07:23:25 +0200")
Message-ID: <874mhau85f.fsf@kamboji.qca.qualcomm.com> (sfid-20151028_200438_798020_A4C9E98B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> ssb bus can be found on various "host" devices like PCI/PCMCIA/SDIO.
> Every ssb bus contains cores AKA devices.
> The main idea is to have ssb driver scan/initialize bus and register
> ready-to-use cores. This way ssb drivers can operate on a single core
> mostly ignoring underlaying details.
>
> For some reason PCMCIA support was split between ssb and b43. We got
> PCMCIA host device probing in b43, then bus scanning in ssb and then
> wireless core probing back in b43. The truth is it's very unlikely we
> will ever see PCMCIA ssb device with no 802.11 core but I still don't
> see any advantage of the current architecture.
>
> With proposed change we get the same functionality with a simpler
> architecture, less Kconfig symbols, one killed EXPORT and hopefully
> cleaner b43. Since b43 supports both: ssb & bcma I prefer to keep ssb
> specific code in ssb driver.
>
> This mostly moves code from b43's pcmcia.c to bridge_pcmcia_80211.c. We
> already use similar solution with b43_pci_bridge.c. I didn't use "b43"
> in name of this new file as in theory any driver can operate on wireless
> core.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Applied manually to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
