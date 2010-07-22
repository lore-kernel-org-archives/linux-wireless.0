Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52305 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0GVKMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 06:12:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 03:12:05 -0700
Date: Thu, 22 Jul 2010 15:41:42 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix stop in tx date traffic after scan
Message-ID: <20100722101142.GA4355@vasanth-laptop>
References: <1279790703-11521-1-git-send-email-vasanth@atheros.com> <1279792601.12439.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1279792601.12439.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Just go and implement flush() and all these issues will go away and you
> will stop thinking that you need to touch queues from channel switching.
> They have nothing to do with each other.


I thought about it also, but i'll hit the same issue 
when ieee80211_scan_state_leave_oper_channel() flushes
the hw tx queues where driver is not supposed to wake
up the queues as drv_flush() is called only after stopping
all queues.

Vasanth
