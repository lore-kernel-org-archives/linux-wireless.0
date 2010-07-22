Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0GVKO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 06:14:59 -0400
Subject: Re: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100722101142.GA4355@vasanth-laptop>
References: <1279790703-11521-1-git-send-email-vasanth@atheros.com>
	 <1279792601.12439.1.camel@jlt3.sipsolutions.net>
	 <20100722101142.GA4355@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 12:14:54 +0200
Message-ID: <1279793694.12439.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 15:41 +0530, Vasanthakumar Thiagarajan wrote:
> > Just go and implement flush() and all these issues will go away and you
> > will stop thinking that you need to touch queues from channel switching.
> > They have nothing to do with each other.
> 
> 
> I thought about it also, but i'll hit the same issue 
> when ieee80211_scan_state_leave_oper_channel() flushes
> the hw tx queues where driver is not supposed to wake
> up the queues as drv_flush() is called only after stopping
> all queues.

I don't get it. The driver can start/stop queues at _any_ time it wants
to. Regardless of what mac80211 is doing, all that goes via
IEEE80211_QUEUE_STOP_REASON_DRIVER which is never touched by mac80211
itself.

johannes

