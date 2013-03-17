Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63973 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3CQPGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 11:06:47 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi8so1792199wib.13
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 08:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5145890A.7070308@iki.fi>
References: <041DFAF5-BEDE-4C1A-9863-A04F2DD3049A@bluewin.ch>
	<5144FECC.6050504@lwfinger.net>
	<5145890A.7070308@iki.fi>
Date: Sun, 17 Mar 2013 08:06:46 -0700
Message-ID: <CAJ-Vmon_1AhWYKF61T3+iwyX0TrZuLG1KxVL-HY84Fp7zv5Ycw@mail.gmail.com> (sfid-20130317_160652_738040_7A3DB060)
Subject: Re: rtl8192cu NOT working on Raspberry Pi
From: Adrian Chadd <adrian@freebsd.org>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Clauss <cclauss@bluewin.ch>, ziv_huang@realtek.com,
	georgia@realtek.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 March 2013 02:12, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote:

> Problems I had with rtl8192cu on arm/sunxi, were mostly related to USB host driver not handling unaligned and/or overlapping URB buffers correctly which lead to memory corruption and random crashes. So if you get problematic behavior with latest compat-drivers (+ with the patch Larry pointed out), I'd say look at USB host driver of raspberry.
>
> You can check the workarounds for sunxi-ehci/ohci and tegra-ehci at:
>  https://github.com/linux-sunxi/linux-sunxi/blob/stage/sunxi-3.4/drivers/usb/host/ehci-tegra.c#L386
>  https://github.com/linux-sunxi/linux-sunxi/blob/stage/sunxi-3.4/drivers/usb/host/sw_hci_sunxi.c#L633

FreeBSD just went through this same problem with the USB stack. Please
work with the USB host driver team and eliminate all of the issues
there before blaming the USB wifi driver. :)



Adrian
