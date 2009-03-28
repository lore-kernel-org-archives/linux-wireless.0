Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZC1FEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 01:04:16 -0400
Date: Sat, 28 Mar 2009 01:04:13 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Reinette Chattre <reinette.chatre@intel.com>
Subject: Re: [PATCH 8/8] mac80211/iwlwifi: move virtual A-MDPU queue
	bookkeeping to iwlwifi
Message-ID: <20090328050413.GG5543@bombadil.infradead.org> (sfid-20090328_060419_242630_B0271EFE)
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.563402186@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163053.563402186@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:42PM +0100, Johannes Berg wrote:
> This patch removes all the virtual A-MPDU-queue bookkeeping from
> mac80211. Curiously, iwlwifi already does its own bookkeeping, so
> it doesn't require much changes except where it needs to handle
> starting and stopping the queues in mac80211.
> 
> To handle the queue stop/wake properly, we rewrite the software
> queue number for aggregation frames and internally to iwlwifi keep
> track of the queues that map into the same AC queue, and only talk
> to mac80211 about the AC queue. The implementation requires calling
> two new functions, iwl_stop_queue and iwl_wake_queue instead of the
> mac80211 counterparts.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Reinette Chattre <reinette.chatre@intel.com>

This one I enjoyed the most. Fucking awesome.

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
