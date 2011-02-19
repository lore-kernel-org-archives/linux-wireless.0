Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1BSJ4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:56:36 -0500
Subject: Re: [PATCH] ath9k: Implement op_flush()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110219094943.GA16465@vasanth-laptop>
References: <1298106822-9411-1-git-send-email-vasanth@atheros.com>
	 <1298107440.3725.8.camel@jlt3.sipsolutions.net>
	 <20110219094943.GA16465@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 10:56:30 +0100
Message-ID: <1298109390.3725.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 15:19 +0530, Vasanthakumar Thiagarajan wrote:
> On Sat, Feb 19, 2011 at 02:54:00PM +0530, Johannes Berg wrote:
> > On Sat, 2011-02-19 at 01:13 -0800, Vasanthakumar Thiagarajan wrote:
> > > When op_flush() is called with no drop (drop=false), the driver
> > > tries to tx as many frames as possible in about 100ms on every
> > > hw queue. During this time period frames from sw queue are also
> > > scheduled on to respective hw queue.
> > 
> > Given how long HW queues currently are, I wouldn't set the timeout to
> > 100ms -- mac80211 has no expectation how long this will take, although
> > 100ms seems pretty long I'm not sure it'll always be sufficient?
> 
> It is not that we wait for 100ms always, we return as soon as
> possible if there are no pending frames in sw/hw queues. I never
> hit this timeout though. In the worst case there can be 128 (4 aggr)
> frames pending in sw queue and 2 in hw queue. If we assume each one of
> these aggregates has 4ms duration, we at least need 24ms air time at
> the lowest rate. If they are not part of AMPDU, it would take a
> little bit more I think. So, probably we can give ~40ms timeout,
> is that reasonable?. If i'm reading the code correctly, iwlwifi
> seems to use 2000ms.

Ok. I wasn't concerned about it being too high, I was thinking 100ms
might not be enough, but since you say it will be I guess it's fine.

johannes

