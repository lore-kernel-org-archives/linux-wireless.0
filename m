Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754000AbdCOV7J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 17:59:09 -0400
Date: Wed, 15 Mar 2017 14:59:02 -0700 (PDT)
Message-Id: <20170315.145902.1038598966216203408.davem@davemloft.net> (sfid-20170315_225919_165880_62BBF3AE)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sowmini.varadhan@oracle.com, dvyukov@google.com,
        johannes.berg@intel.com
Subject: Re: [PATCH] nl80211: fix dumpit error path RTNL deadlocks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170315132913.26088-1-johannes@sipsolutions.net>
References: <20170315132913.26088-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 15 Mar 2017 14:29:13 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sowmini pointed out Dmitry's RTNL deadlock report to me, and it turns out
> to be perfectly accurate - there are various error paths that miss unlock
> of the RTNL.
> 
> To fix those, change the locking a bit to not be conditional in all those
> nl80211_prepare_*_dump() functions, but make those require the RTNL to
> start with, and fix the buggy error paths. This also let me use sparse
> (by appropriately overriding the rtnl_lock/rtnl_unlock functions) to
> validate the changes.
> 
> Reported-by: Sowmini Varadhan <sowmini.varadhan@oracle.com>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Johannes, I assume I will get this in a future pull request?
