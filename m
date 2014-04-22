Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbaDVOuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:50:17 -0400
Message-ID: <1398178207.4211.11.camel@jlt4.sipsolutions.net> (sfid-20140422_165103_067959_2069C05F)
Subject: Re: [PATCH 06/12] cfg80211: some workqueue improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:50:07 +0200
In-Reply-To: <84aff9f5916be0f5cfaa4f145670d0ee06fcf4bf.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065510_867756_E4147A12)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <84aff9f5916be0f5cfaa4f145670d0ee06fcf4bf.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065510_867756_E4147A12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:53 +0800, Zhao, Gang wrote:
> Works rdev->rfkill_sync and rdev->sched_scan_results_wk are safely
> stopped when unregistering wiphy.
> 
> Work reg_regdb_work is safely stopped in regulatory_exit(), if related
> config option is enabled.
> 
> Queue work cfg80211_disconnect_work to workqueue cfg80211_wq, since
> it's a work owned by cfg80211, and so it can be safely stopped in
> destroy_workqueue(cfg80211_wq) in cfg80211_exit().

Nope ... think about locking.

> Change flush_work() to more robust cancel_work_sync().

These are not equivalent.

johannes

