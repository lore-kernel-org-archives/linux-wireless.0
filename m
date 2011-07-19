Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62156 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1GSOwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 10:52:13 -0400
Message-ID: <4E259A1B.3040306@gnu.org> (sfid-20110719_165216_590043_EBE3A9C1)
Date: Tue, 19 Jul 2011 10:52:11 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: bcma: get DMA translation bits
References: <1311062701-3455-1-git-send-email-zajec5@gmail.com> <1311062701-3455-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311062701-3455-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 04:05 AM, Rafał Miłecki wrote:

> +#ifdef CONFIG_B43_BCMA
> +	case B43_BUS_BCMA:
> +		dma->translation = bcma_dma_translation(dev->dev->bdev->bus);
> +		break;
> +#endif

How about we set dma->translation to 0x40000000 for 32-bit DMA and to 
0x80000000 for 64-bit DMA and remove shifting translation by 1 in the 
64-bit DMA code?  There should be a warning for non-PCI devices here. 
No ifdefs, no separate treatment of different buses.

I think we are adding too much complexity here.

-- 
Regards,
Pavel Roskin
