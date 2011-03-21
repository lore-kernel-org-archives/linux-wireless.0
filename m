Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59482 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300Ab1CUOBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 10:01:30 -0400
Received: by wwj40 with SMTP id 40so5094859wwj.34
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 07:01:06 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Clamp byte mode transfers for 128x chips
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>
In-Reply-To: <1300452597-13281-1-git-send-email-arik@wizery.com>
References: <1300452597-13281-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 16:00:29 +0200
Message-ID: <1300716029.2593.211.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-18 at 14:49 +0200, Arik Nemtsov wrote:
> On wl128x based devices, when TX packets are aggregated, each packet
> size must be aligned to the SDIO block size, and sent using block mode
> transfers.
> 
> The block size is set to 256 bytes, which is less than the maximum
> possible byte transfer. Thus, if two small packets (< 256 bytes) are
> aggregated, the aggregation buffer size would be 512, and will be sent
> using byte mode transfers. This can have undesired side effects.
> 
> Fix this by setting the MMC_QUIRK_BLKSZ_FOR_BYTE_MODE mmc card quirk.
> For 127x chips this has no effect, as the block size is set to 512
> bytes.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Thanks! Applied and fixed Arik's email address, which was corrupted (or
rather Ido-ized :P)

-- 
Cheers,
Luca.

