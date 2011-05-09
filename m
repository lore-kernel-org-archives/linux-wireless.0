Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1EIIME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:12:04 -0400
Subject: Re: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304600420-24227-2-git-send-email-coelho@ti.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-2-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:12:00 +0200
Message-ID: <1304928720.3475.0.camel@jlt3.sipsolutions.net> (sfid-20110509_101207_178957_4FE0FC3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-05 at 16:00 +0300, Luciano Coelho wrote:
> Implement new functionality for scheduled scan offload.  With this feature we
> can scan automatically at certain intervals.
> 
> The idea is that the hardware can perform scan automatically and filter on
> desired results without waking up the host unnecessarily.
> 
> Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> commands to the nl80211 interface.  When results are available they are
> reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
> informed when the scheduled scan has stopped with a
> NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
> the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.

Didn't you initially want to differentiate between SCAN_SSIDS and
SSIDS_FILTER?

johannes

