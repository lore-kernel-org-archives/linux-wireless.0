Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:6750 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbZKRUbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 15:31:13 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2422423fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 12:31:18 -0800 (PST)
Message-ID: <4B045992.6070600@lwfinger.net>
Date: Wed, 18 Nov 2009 14:31:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Enforce DMA descriptor memory constraints
References: <200911182053.05488.mb@bu3sch.de>
In-Reply-To: <200911182053.05488.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2009 01:53 PM, Michael Buesch wrote:
> Enforce all device constraints on the descriptor memory region.
> 
> There are several constraints on the descriptor memory, as documented
> in the specification. The current code does not enforce them and/or
> incorrectly enforces them.
> 
> Those constraints are:
> - The address limitations on 30/32bit engines, that also apply to
>   the skbs.
> - The 4k alignment requirement on 30/32bit engines.
> - The 8k alignment requirement on 64bit engines.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> It's not entirely clear if any 64bit devices exist that _really_ need the 8k
> alignment. However, I think it does not hurt much if we enforce it anyway.
> The patch removes the always-set-GFP_DMA-on-64bit-devices hack. The combination of
> the new enforcements should be enough to keep every device happy, including those
> which needed the GFP_DMA hack. The new code will dynamically check if GFP_DMA is
> required, instead of statically doing it all the time.
> John, please queue for the next feature release. This patch still needs a fair
> amount of testing. I think the best way to get it is to simply apply it. If this
> causes any regressions, we can (temporary) revert it.
> 
> This also is a candidate for a b43legacy backport.

Tested OK for BCM4312 (14e4:4315).

I will port/test on b43legacy as I have the hardware.

Larry

