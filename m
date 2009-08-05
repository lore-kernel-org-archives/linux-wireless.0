Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63125 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZHEVAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 17:00:03 -0400
Received: by bwz19 with SMTP id 19so346980bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 14:00:03 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>, luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: make irq handling interface specific
References: <20090804033908.GA1903@hash.localnet>
	<87hbwoniog.fsf@litku.valot.fi> <20090804122229.GA3337@hash.localnet>
	<877hxionnt.fsf@litku.valot.fi> <20090805135618.GA7468@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 06 Aug 2009 00:00:00 +0300
In-Reply-To: <20090805135618.GA7468@hash.localnet> (Bob Copeland's message of "Wed\, 5 Aug 2009 09\:56\:18 -0400")
Message-ID: <873a86nfhr.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> In SDIO, the host driver requests the IRQ and invokes a callback to the
> card driver.  This differs from SPI, so the relevant code needs to be
> interface-specific.  This patch pushes the irq code down into _spi.c
> and _sdio.c, and adds enable/disable callbacks.

[...]

> v2: make sdio irq functions void to match wl1251.h

Thanks, I applied this version to my local tree now.

All pending wl1251 patches are now here:

http://www.valot.fi/kalle/wl1251/patches/wl1251-add-sdio/2009-08-05-20:50/

It includes your sdio patches, quite a few patches from our internal
tree and a workaround to make association work again. With these patches
dhcp and ping works with wep on wl1251 using spi. So things look good
again.

I haven't checked the patches at all, there might be some stupidity in
them. I'll do that tomorrow and try to send them to John ASAP.

Luca, I'm pretty sure that the workaround helps with wl1271 also. Just
take the wl->channel fix and the filter hack and it should work.

-- 
Kalle Valo
