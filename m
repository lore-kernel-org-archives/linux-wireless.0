Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34026 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0CCUam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 15:30:42 -0500
Date: Wed, 3 Mar 2010 15:27:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix HT configuration
Message-ID: <20100303202746.GG23920@tuxdriver.com>
References: <19339.34073.723714.219572@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19339.34073.723714.219572@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 01, 2010 at 02:42:57PM +0530, Sujith wrote:
> Handling HT configuration changes involved setting the channel
> with the new HT parameters and then issuing a rate_update()
> notification to the driver.
> 
> This behavior changed after the off-channel changes. Now, the channel
> is not updated with the new HT params in enable_ht() - instead, it
> is now done when the scan work terminates. This results in the driver
> depending on stale information, defaulting to non-HT mode always.
> 
> Fix this by passing the new channel type to the driver.
> 
> Cc: stable@kernel.org
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  include/net/mac80211.h |    3 ++-
>  net/mac80211/mlme.c    |    3 ++-
>  net/mac80211/rate.h    |    5 +++--
>  3 files changed, 7 insertions(+), 4 deletions(-)

This should be combined with "ath9k: Fix HT rate control configuration"
-- I'll take care of it.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
