Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52104 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1GSSqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 14:46:35 -0400
Received: by pvg12 with SMTP id 12so4093938pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 11:46:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E259A1B.3040306@gnu.org>
References: <1311062701-3455-1-git-send-email-zajec5@gmail.com>
	<1311062701-3455-2-git-send-email-zajec5@gmail.com>
	<4E259A1B.3040306@gnu.org>
Date: Tue, 19 Jul 2011 20:46:33 +0200
Message-ID: <CACna6rxSSGaJNyAcHWkWmnN3y33F5f9A38vjhu89-ffVuB1zog@mail.gmail.com> (sfid-20110719_204644_001282_6040082A)
Subject: Re: [PATCH 2/2] b43: bcma: get DMA translation bits
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 lipca 2011 16:52 użytkownik Pavel Roskin <proski@gnu.org> napisał:
> On 07/19/2011 04:05 AM, Rafał Miłecki wrote:
>
>> +#ifdef CONFIG_B43_BCMA
>> +       case B43_BUS_BCMA:
>> +               dma->translation =
>> bcma_dma_translation(dev->dev->bdev->bus);
>> +               break;
>> +#endif
>
> How about we set dma->translation to 0x40000000 for 32-bit DMA and to
> 0x80000000 for 64-bit DMA and remove shifting translation by 1 in the 64-bit
> DMA code?  There should be a warning for non-PCI devices here. No ifdefs, no
> separate treatment of different buses.
>
> I think we are adding too much complexity here.

Warning is generated on bcma_dma_translation side. We could make that
function return s32 and return negative values of error, but not sure
if it's worth it. We will get warning anyway.

After checking specs (http://bcm-v4.sipsolutions.net/802.11/DMA) I've
to agree that our shifting looks crazy. Probably ssb function was
implemented and someone added 64-bit DMA support without modifying
ssb.

There is no reason to shift value by 1. Routing mask is always
0xC0000000. It's just about different values:
DMA32: 0x1 == Client Mode Translation (1GB)
DMA64: 0x2 == Client Mode Translation (2 Zettabytes)


Well, I've to say it was really worth to CC you :)

-- 
Rafał
