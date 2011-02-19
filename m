Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38946 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1BSKKu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 05:10:50 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 02:10:29 -0800
Date: Sat, 19 Feb 2011 15:39:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Implement op_flush()
Message-ID: <20110219100928.GB16962@vasanth-laptop>
References: <1298106822-9411-1-git-send-email-vasanth@atheros.com> <1298107440.3725.8.camel@jlt3.sipsolutions.net> <20110219094943.GA16465@vasanth-laptop> <1298109390.3725.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1298109390.3725.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 19, 2011 at 03:26:30PM +0530, Johannes Berg wrote:
> On Sat, 2011-02-19 at 15:19 +0530, Vasanthakumar Thiagarajan wrote:
> > On Sat, Feb 19, 2011 at 02:54:00PM +0530, Johannes Berg wrote:
> > > On Sat, 2011-02-19 at 01:13 -0800, Vasanthakumar Thiagarajan wrote:
> > > > When op_flush() is called with no drop (drop=false), the driver
> > > > tries to tx as many frames as possible in about 100ms on every
> > > > hw queue. During this time period frames from sw queue are also
> > > > scheduled on to respective hw queue.
> > > 
> > > Given how long HW queues currently are, I wouldn't set the timeout to
> > > 100ms -- mac80211 has no expectation how long this will take, although
> > > 100ms seems pretty long I'm not sure it'll always be sufficient?

Would not having a long timeout for flush affect bg scanning by
applications (scan time out)?.

Vasanth
