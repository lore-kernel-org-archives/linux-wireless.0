Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4740 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933971AbYBTUde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:34 -0500
Date: Wed, 20 Feb 2008 15:25:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: when does ath5k filter frames?
Message-ID: <20080220202518.GD3825@tuxdriver.com> (sfid-20080220_203340_020826_46DA6E91)
References: <1203514108.17534.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203514108.17534.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2008 at 02:28:28PM +0100, Johannes Berg wrote:
> Hi,
> 
> In mac80211 we have a whole bunch of cryptic code to handle "filtered"
> frames. The only driver that does that seems to be ath5k, and it doesn't
> really seem to use this since it is intimately tied to
> IEEE80211_TXCTL_CLEAR_DST_MASK which it doesn't check...
> 
> Any ideas? Should we kill all this code and not use whatever hardware
> powersave helpers atheros hardware might have?
> 
> On the other hand, Broadcom also has powersave helpers in
> hardware/firmware, maybe we should generalise to be able to use them as
> well?

Do we understand either of these (i.e. Broadcom or Atheros) helpers
well enough to utilize them?  If so, it sounds like a nice feature
to support.  Hardware/firmware may be able to do nifty things to
save power.

If we don't really know how those helpers work, it may be better just
to remove the unused infrastructure.

Is my opinion useful? :-)

John
-- 
John W. Linville
linville@tuxdriver.com
