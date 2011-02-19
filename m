Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38795 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab1BSKB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 05:01:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 02:01:35 -0800
Date: Sat, 19 Feb 2011 15:30:33 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Implement op_flush()
Message-ID: <20110219100033.GA16962@vasanth-laptop>
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
> > 
> > It is not that we wait for 100ms always, we return as soon as
> > possible if there are no pending frames in sw/hw queues. I never
> > hit this timeout though. In the worst case there can be 128 (4 aggr)
> > frames pending in sw queue and 2 in hw queue. If we assume each one of
> > these aggregates has 4ms duration, we at least need 24ms air time at
> > the lowest rate. If they are not part of AMPDU, it would take a
> > little bit more I think. So, probably we can give ~40ms timeout,
> > is that reasonable?. If i'm reading the code correctly, iwlwifi
> > seems to use 2000ms.
> 
> Ok. I wasn't concerned about it being too high, I was thinking 100ms
> might not be enough, but since you say it will be I guess it's fine.

Yeah, I misread it. This 100ms timeout is on every ac queue and is pretty
much good enough from my testing.

Vasanth
