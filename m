Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1DALtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:49:51 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Check for queued frames before
 entering power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
References: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 13:51:45 +0200
Message-ID: <1301658705.3832.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 17:15 +0530, Vivek Natarajan wrote:
> In a highly noisy environment, since the driver could not send
> the packets out in 100ms, some applications stall and eventually
> fail as mac80211 stops the netdevice queues for flush when power
> save is triggered. Most of the WMM testcases fail in the Wifi
> testing because of this.
> Increasing the dynamic ps timeout to 200-300ms helps but in noisy
> channel conditions even if there is a continuous tx traffic, mac80211
> tries to go into PS. The new implementation checks for any frames
> queued in the driver tx queues and based on that mac80211 decides
> to go for power save. This also prevents redundant stopping of
> netdevice queues which helps more applications to run properly.

I think as an API change this needs more justification. Why does this
need a new callback, for example?

johannes

