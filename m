Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61667 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab1LIUGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 15:06:34 -0500
Received: by ghbz2 with SMTP id z2so2832292ghb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 12:06:33 -0800 (PST)
Message-ID: <4EE26A46.8050906@lwfinger.net> (sfid-20111209_210638_147152_1CADB101)
Date: Fri, 09 Dec 2011 14:06:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net> <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net> <4EE24615.9020003@broadcom.com> <4EE24C22.4000204@lwfinger.net> <4EE26227.8040900@broadcom.com>
In-Reply-To: <4EE26227.8040900@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 01:31 PM, Arend van Spriel wrote:
>
> That is an unexpected code path especially as brcmsmac is probed from
> bcma so SoC interface type should be AI (aka. AMBA AXI). Checked with
> the proprietary driver and there is no type 4.
>
> Can you provide the bcma_device_id information that bcma has collected
> and the bcma_chipinfo for your device?

The bcma core scan provides:

bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)

b43 reports:

b43-phy0: Broadcom 43224 WLAN found (core revision 23)
b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 6

brcmsmac shows:

brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 22

I hope this provides what you need. I did not see anything else in the logs.

Larry

