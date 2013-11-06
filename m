Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3KFK6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 05:58:10 -0500
Message-ID: <1383735487.14307.29.camel@jlt4.sipsolutions.net> (sfid-20131106_115814_251610_D4434F58)
Subject: Re: [PATCH] mac80211: fix scheduled scan rtnl deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>
Date: Wed, 06 Nov 2013 11:58:07 +0100
In-Reply-To: <1383730993-18259-1-git-send-email-johannes@sipsolutions.net> (sfid-20131106_104320_884172_2DC34946)
References: <1383730993-18259-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131106_104320_884172_2DC34946)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 10:43 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When changing cfg80211 to use RTNL locking, this caused a
> deadlock in mac80211 as it calls cfg80211_sched_scan_stopped()
> from a work item that's on a workqueue that is flushed with
> the RTNL held.
> 
> Fix this by simply using schedule_work(), the work only needs
> to finish running before the wiphy is unregistered, no other
> synchronisation (e.g. with suspend) is really required since
> for suspend userspace is already blocked anyway when we flush
> the workqueue so will only pick up the event after resume.

Applied.

johannes

