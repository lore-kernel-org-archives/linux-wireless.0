Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20308 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1GSOiy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 10:38:54 -0400
Message-ID: <4E2596FB.5030105@gnu.org> (sfid-20110719_163857_847785_4E1BBE9E)
Date: Tue, 19 Jul 2011 10:38:51 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] bcma: inform drivers about translation bits needed
 for the board
References: <1311062701-3455-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311062701-3455-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 04:05 AM, Rafał Miłecki wrote:
> When using DMA, drivers need to pass special translation info to the
> hardware.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>

I'm not sure why you are copying it to me.

> +	switch (bus->hosttype) {
> +	case BCMA_HOSTTYPE_PCI:
> +		return 0x40000000;

This is already implemented in ssb_dma_translation(), and the constant 
is called SSB_PCI_DMA.  I think we need a named constant here as well, 
either SSB_PCI_DMA or a new constant BCMA_PCI_DMA.

-- 
Regards,
Pavel Roskin
