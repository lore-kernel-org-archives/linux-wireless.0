Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab0F3K0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 06:26:14 -0400
Subject: Re: [PATCH 1/2] mac80211: Dont allow to wake up netif tx queues
 while on off channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1277893026.7823.7.camel@jlt3.sipsolutions.net>
References: <1277892907-2401-1-git-send-email-vasanth@atheros.com>
	 <1277893026.7823.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 12:26:11 +0200
Message-ID: <1277893571.7823.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-30 at 12:17 +0200, Johannes Berg wrote:
> On Wed, 2010-06-30 at 03:15 -0700, Vasanthakumar Thiagarajan wrote:
> > Drivers are not supposed to call ieee80211_wake_queue() while operating
> > on off channel during sw scanning,

> That doesn't seem to make sense, since we treat driver and scan stop
> status separately via wake_queue_by_reason()

IOW, the above assertion would seem to be false already.

johannes

