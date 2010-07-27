Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0G0Wvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 18:51:46 -0400
Date: Tue, 27 Jul 2010 15:22:25 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Peter Stuge <peter@stuge.se>
Subject: Re: [stable] [PATCH 2.6.32.y] ath9k: re-enable ps by default for
 new single chip families
Message-ID: <20100727222225.GJ14257@kroah.com>
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 06:19:19PM -0400, Luis R. Rodriguez wrote:
> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
> 
> The newer single chip hardware family of chipsets have not been
> experiencing issues with power saving set by default with recent
> fixes merged (even into stable). The remaining issues are only
> reported with AR5416 and since enabling PS by default can increase
> power savings considerably best to take advantage of that feature
> as this has been tested properly.
> 
> For more details on this issue see the bug report:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14267
> 
> We leave AR5416 with PS disabled by default, that seems to require
> some more work.
> 
> Cc: stable@kernel.org
> Cc: Peter Stuge <peter@stuge.se>
> Cc: Justin P. Mattock  <justinmattock@gmail.com>
> Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> 
> Greg, this is the long promised backport of the patch titled
> "ath9k: re-enable ps by default for new single chip families" backported
> down to 2.6.32.y. This just goes test compiled. Manual backport
> was required from the upstream Linus patch since the flag
> WIPHY_FLAG_PS_ON_BY_DEFAULT was not used back on 2.6.32 so instead
> we use the equivalent hw->wiphy->ps_default bool.
> 
> Apologies for the delay, was just stuck with other stuff.
> 
> I'll remove this from the stable pending list for 802.11 [1] once
> this gets sucked in.

Now queued up, thanks.

greg k-h
