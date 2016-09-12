Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57247 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754119AbcILJVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:21:46 -0400
Message-ID: <1473672100.4201.15.camel@sipsolutions.net> (sfid-20160912_112205_585248_C88B8AB3)
Subject: Re: [PATCH v2] cfg80211: Remove deprecated
 create_singlethread_workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Sep 2016 11:21:40 +0200
In-Reply-To: <20160830190507.GA11493@Karyakshetra> (sfid-20160830_210511_814586_97B3779A)
References: <20160830190507.GA11493@Karyakshetra>
         (sfid-20160830_210511_814586_97B3779A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-31 at 00:35 +0530, Bhaktipriya Shridhar wrote:
> The workqueue "cfg80211_wq" is involved in cleanup, scan and event
> related
> works. It queues multiple work items &rdev->event_work,
> &rdev->dfs_update_channels_wk,
> &wiphy_to_rdev(request->wiphy)->scan_done_wk,
> &wiphy_to_rdev(wiphy)->sched_scan_results_wk, which require strict
> execution ordering.
> Hence, an ordered dedicated workqueue has been used.
> 
> Since it's a wireless driver, WQ_MEM_RECLAIM has been set to ensure
> forward progress under memory pressure.
> 

Applied, thanks.

johannes
