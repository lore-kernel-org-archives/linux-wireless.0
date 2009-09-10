Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44396 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZIJTZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:25:22 -0400
Received: by fxm17 with SMTP id 17so346862fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 12:25:24 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: halt the embedded CPU before loading firmware
References: <20090818033356.GB524@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 10 Sep 2009 22:25:22 +0300
In-Reply-To: <20090818033356.GB524@hash.localnet> (Bob Copeland's message of "Mon\, 17 Aug 2009 23\:33\:56 -0400")
Message-ID: <87bpli38m5.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> After initial power-up, the embedded cpu is usually halted.  However,
> if we down the interface and only do a soft reset before bringing
> the interface back up, it will still be running and the firmware
> loading code will bail out.  This change halts the CPU before loading
> the firmware, enabling a second call to wl1251_boot() to succeed
> without a hard reset.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

(Even though  the patch is already in wireless-testing.)

> Hi Kalle,

Hi Bob,

sorry for the long delay. Last few weeks has been crazy :)

> Thoughts on this?  It fixes my remaining issue with warm card reset.
> I think Android code does this in the firmware loader:

I'm fine with this. I tested the patch with spi and it works fine.

Thanks again.

-- 
Kalle Valo
