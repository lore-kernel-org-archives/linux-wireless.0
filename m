Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0G0Wvo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 18:51:44 -0400
Date: Tue, 27 Jul 2010 15:18:02 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 2.6.32..2.6.33] ath5k: drop warning on jumbo
 frames
Message-ID: <20100727221802.GH14257@kroah.com>
References: <1276641307-10287-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1276641307-10287-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 06:35:07PM -0400, Luis R. Rodriguez wrote:
> commit 9637e516d16a58b13f6098cfe899e22963132be3 upstream.
> 
> Jumbo frames are not supported, and if they are seen it is likely
> a bogus frame so just silently discard them instead of warning on
> them all time. Also, instead of dropping them immediately though
> move the check *after* we check for all sort of frame errors. This
> should enable us to discard these frames if the hardware picks
> other bogus items first. Lets see if we still get those jumbo
> counters increasing still with this.
> 
> Jumbo frames would happen if we tell hardware we can support
> a small 802.11 chunks of DMA'd frame, hardware would split RX'd
> frames into parts and we'd have to reconstruct them in software.
> This is done with USB due to the bulk size but with ath5k we
> already provide a good limit to hardware and this should not be
> happening.
> 
> This is reported quite often and if it fills the logs then this
> needs to be addressed and to avoid spurious reports.
> 
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> 
> Greg, here's a stable ath5k patch which required some manual
> backport. The backported was needed since the sc->stats.rxerr_jumbo
> counter was not available until 2.6.34 and it was used on the upstream
> commit. This goes only compile tested against 2.6.32.y and 2.6.33.y.

Many thanks, I've now commited this one.

greg k-h
