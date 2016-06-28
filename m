Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35873 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcF1M4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 08:56:35 -0400
Received: by mail-io0-f174.google.com with SMTP id s63so15584698ioi.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2016 05:56:35 -0700 (PDT)
Date: Tue, 28 Jun 2016 08:56:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Yaniv Machani <yanivma@ti.com>
Cc: linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S . Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Meirav Kama <meiravk@ti.com>
Subject: Re: [PATCH 4/4] mac80211: sta_info: max_peers reached falsely
Message-ID: <20160628125621.GA9223@localhost> (sfid-20160628_145700_880097_817DB92E)
References: <20160628111307.8784-1-yanivma@ti.com>
 <20160628111307.8784-2-yanivma@ti.com>
 <20160628111307.8784-3-yanivma@ti.com>
 <20160628111307.8784-4-yanivma@ti.com>
 <20160628111307.8784-5-yanivma@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160628111307.8784-5-yanivma@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2016 at 02:13:07PM +0300, Yaniv Machani wrote:
> From: Meirav Kama <meiravk@ti.com>
> 
> Issue happened when receiving delete_sta command without
> changing plink_state from ESTAB to HOLDING before.
> When receiving delete_sta command for mesh interface
> verify plink_state is not ESTAB and if so, decrease
> plink count and update beacon.

This should be fixed already (and properly) by the patch
"mac80211: Fix mesh estab links counting" -- please let us
know if you have a case that's still broken with that fix.

-- 
Bob Copeland %% http://bobcopeland.com/
