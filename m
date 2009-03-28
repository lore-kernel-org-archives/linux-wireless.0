Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZC1C1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 22:27:04 -0400
Date: Fri, 27 Mar 2009 22:27:00 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/8] mac80211: unify and fix TX aggregation start
Message-ID: <20090328022659.GD5543@bombadil.infradead.org> (sfid-20090328_032712_797334_7FD45176)
References: <20090323162834.154525349@sipsolutions.net> <20090323163052.823346545@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163052.823346545@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:39PM +0100, Johannes Berg wrote:
> When TX aggregation becomes operational, we do a number of steps:
>  1) print a debug message
>  2) wake the virtual queue
>  3) notify the driver
> 
> Unfortunately, 1) and 3) are only done if the driver is first to
> reply to the aggregation request, it is, however, possible that the
> remote station replies before the driver! Thus, unify the code for
> this and call the new function ieee80211_agg_tx_operational in both
> places where TX aggregation can become operational.
> 
> Additionally, rename the driver notification from
> IEEE80211_AMPDU_TX_RESUME to IEEE80211_AMPDU_TX_OPERATIONAL.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Nice catch man!

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
