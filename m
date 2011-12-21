Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1LUPKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:10:49 -0500
Subject: Re: [PATCH v2 0/2] report stop sched scan when actually done
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1324462262-10277-1-git-send-email-eyal@wizery.com> (sfid-20111221_111141_897967_3E904A2C)
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
	 (sfid-20111221_111141_897967_3E904A2C)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 16:10:44 +0100
Message-ID: <1324480244.3401.6.camel@jlt3.sipsolutions.net> (sfid-20111221_161052_039864_FE40B7C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-21 at 12:11 +0200, Eyal Shapira wrote:
> Changes in mac/cfg80211 to notify userspace
> of NL80211_CMD_SCHED_SCAN_STOPPED only when the driver
> actually reported back that it was stopped. Also
> blocks other attempts until we're really done.
> 
> This fixes a scenario where stop sched scan
> is issued and immediately afterwards a new sched scan
> is requested (e.g. with other parameters).
> Current state caused a race where the driver started
> stopping the sched scan but didn't finish and got
> another sched scan request which it couldn't handle.

Luca really needs to take a close look at this, and I think you should
also take a look to see if this kind of API change can be avoided.

johannes

