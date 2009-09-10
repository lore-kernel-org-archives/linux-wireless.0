Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38653
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbZIJJrr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 05:47:47 -0400
Date: Thu, 10 Sep 2009 02:48:04 -0700 (PDT)
Message-Id: <20090910.024804.30388483.davem@davemloft.net>
To: tm@dev-zero.ch
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtl8180: change PCI DMA mask to DMA_BIT_MASK(32) to
 solve "No suitable DMA available" problems on sparc64.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252575463.30576.59.camel@localhost>
References: <1252575463.30576.59.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tiziano Müller <tm@dev-zero.ch>
Date: Thu, 10 Sep 2009 11:37:43 +0200

> Hi there
> 
> I had problems to get my rtl8185 PCI card running on Sparc64: I always
> got an error about "No suitable DMA available" followed by an error
> that no device could be detected. When comparing the rtl8180 driver to
> others I noticed that others are mostly using DMA_BIT_MASK so I changed
> the custom mask to DMA_BIT_MASK(32) which fixed my issue.

Looks correct to me.

I wonder what it was trying to achieve by clearing the low 8 bits
:-)

Acked-by: David S. Miller <davem@davemloft.net>
