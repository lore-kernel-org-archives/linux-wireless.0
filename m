Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1AXVgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:36:21 -0500
Subject: Re: [PATCHv4] wl12xx: Increase scan channel dwell time for passive
 scans
From: Luciano Coelho <coelho@ti.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295848914-3765-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295848914-3765-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 23:36:28 +0200
Message-ID: <1295904988.4430.3.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 07:01 +0100, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> Below, mTU is milli-TU (TU/1000).
> 
> The passive scan channel dwell time currently used is 30-60mTU. A typical
> beacon interval for AP's is 100TU. This leads to a ~30% worst-case probability
> of finding an AP via passive scanning.
> 
> For 5GHz bands for DFS frequencies passive scanning is the only scanning
> option. Hence for these, the probability of finding an AP is very low.
> 
> To fix this, increase the passive channel scan dwell times (also the early
> leave value, as 5GHz channels are still typically very silent.) Use a value
> of 100TU, because that covers most typical AP configurations.
> 
> Based on testing the probability of finding an AP (100TU beacon interval) on
> a single scan round are as follows (based on 100 iterations):
> 
> dwell min/max (TU)   | probability
> ---------------------+------------
> 30/60                | 35%
> 60/60                | 56%
> 80/80                | 77%
> 100/100              | 100%
> 
> Total scan times now and after the change:
> 
> Region | Before (s) | After (s)
> -------+------------+----------
> 00     | 0.77       | 1.48
> FI     | 0.95       | 2.01
> US     | 0.91       | 1.76
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Applied and removed the mention to milli-TUs, as agreed on IRC.

Thanks Juuso!

-- 
Cheers,
Luca.

