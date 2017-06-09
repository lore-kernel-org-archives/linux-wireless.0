Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:38064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdFITkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 15:40:37 -0400
Date: Fri, 09 Jun 2017 15:40:36 -0400 (EDT)
Message-Id: <20170609.154036.1650264279344295227.davem@davemloft.net> (sfid-20170609_214043_106203_49F86D15)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH net] mac80211: free netdev on dev_alloc_name() error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170609193309.14972-1-johannes@sipsolutions.net>
References: <20170609193309.14972-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  9 Jun 2017 21:33:09 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The change to remove free_netdev() from ieee80211_if_free()
> erroneously didn't add the necessary free_netdev() for when
> ieee80211_if_free() is called directly in one place, rather
> than as the priv_destructor. Add the missing call.
> 
> Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thanks Johannes.
