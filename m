Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36111 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbJAV0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 17:26:30 -0400
Received: by ioii196 with SMTP id i196so100502676ioi.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 14:26:30 -0700 (PDT)
Date: Thu, 1 Oct 2015 16:26:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/5] wireless-regdb: Update TW and US rules to latest
 regulations
Message-ID: <20151001212601.GE101875@ubuntu-hedt> (sfid-20151001_232634_540813_A7E5B2CA)
References: <1443682667-29814-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443682667-29814-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 01, 2015 at 02:57:42PM +0800, Chen-Yu Tsai wrote:
> Hi Seth,
> 
> This is v3 of my TW/US 5GHz updates series. Sorry for the long delay.
> 
> Changes since v2:
> 
>   - Moved the US U-NII-1 (5150 ~ 5250 MHz) patch in front of the TW patch
> 
>   - Drop U-NII-1 power limit from 24 dBm to 23 dBm, to be on the safe
>     side of 250mW
> 
> 
> Patch 1 updates the 5470 ~ 5725 MHz rules for Taiwan, specifically
> the opening up of 5600 ~ 5650 MHz spectrum previously allocated to
> weather radars. The transmission power limit is also corrected to
> match the regulations.
> 
> Patch 2 changes the boundary frequencies for each rule for Taiwan to
> match the frequency allocation table. The "regulation" database shouldn't
> care about artificial channel boundaries.
> 
> Patch 3 updates the transmission power limits for 5150 ~ 5250 MHz for
> the US.
> 
> Patch 4 adds the previously unusable 5150 ~ 5250 MHz band for Taiwan.
> 
> Patch 5 updates the transmission power limits for Taiwan, per the NCC's
> official reply. This patch may be slightly controversial, as there is
> no official English document. Either someone will have to independently
> verify this, or translate the Chinese document.

This description doesn't quite match the patches. Patch 4 both adds the
5150-5250 MHz band and increases the power limits for 5250-5350 MHz,
whereas patch 5 changes the DFS master region to DFS-FCC. Previously the
increased power limit for 5250-5350 MHz was part of patch 5 - perhaps
you accidentally moved that part to patch 4 when you were updating the
patches?

So patches 1-3 look fine to me. I suspect you'll want to move the power
limit increase from patch 4 to 5. I'm also going to take a look at a
machine translation of the Chinese document, and if that looks to be in
agreement with your patches then I should be able to apply them next
week sometime.

Thanks,
Seth
