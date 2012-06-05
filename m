Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:46061 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab2FEO3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 10:29:54 -0400
Received: by lbok6 with SMTP id k6so5233824lbo.18
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 07:29:51 -0700 (PDT)
Message-ID: <1338906589.13935.243.camel@cumari.coelho.fi> (sfid-20120605_162957_608913_926832A2)
Subject: Re: [PATCH] wlcore/wl12xx/wl18xx: don't use TX align quirk for
 wl127x
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Tue, 05 Jun 2012 17:29:49 +0300
In-Reply-To: <1338880471-854-1-git-send-email-coelho@ti.com>
References: <1338880471-854-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 10:14 +0300, Luciano Coelho wrote:
> When we moved the identify_chip operation to an earlier stage (ie. to
> the probe function), we broke wl127x support because during HW init we
> would set the WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN.
> 
> To avoid this, set this quirk in the identify_chip operations and only
> force it to be unset if the bus module doesn't support it.  We were
> doing the opposite and setting the flag if the bus module supports it.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied and pushed to wl12xx/master.

-- 
Cheers,
Luca.

