Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64401 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0CDArh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 19:47:37 -0500
Received: by fxm19 with SMTP id 19so2236427fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 16:47:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8EFF26.6040005@lwfinger.net>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	<a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com>
	<201003010122.51341.mb@bu3sch.de> <201003022257.51878.mb@bu3sch.de>
	<4B8EFF26.6040005@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 4 Mar 2010 01:47:15 +0100
Message-ID: <69e28c911003031647o23cf5638xb0d29fb1b73aee64@mail.gmail.com>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Nathan Schulte <reklipz@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 4, 2010 at 1:30 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/02/2010 03:57 PM, Michael Buesch wrote:
>
>> A bug in the PCI-E core code is able to show such behavior, because all memory
>> transfers (MMIO and DMA) from the PCI device to the wireless core are translated
>> by the PCI-E core.
>> I think the whole PCI-E core code has to be audited (also the specs, probably).
>
> I have nearly finished the update on the code section of the specs page at
> http://bcm-v4.sipsolutions.net/PCI-E. The part that is not done involves the
> sections that read an address from the SPROM and perform operations on that address.
>
> I found that the chip common registers

Do you mean the ChipCommon registers or the Backplane common registers?

> are mapped at 12K for newer cores on
> PCIe. This explains the 0x3XXX addresses. Similarly, the PCIe registers are
> mapped at 8K - the 0x2XXX addresses. The SPROM is shadowed at 4K or 0x1XXX.
>
> Larry
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
