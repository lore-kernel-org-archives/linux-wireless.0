Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1BSKSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 05:18:13 -0500
Subject: Re: [PATCH] ath9k: Implement op_flush()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110219100928.GB16962@vasanth-laptop>
References: <1298106822-9411-1-git-send-email-vasanth@atheros.com>
	 <1298107440.3725.8.camel@jlt3.sipsolutions.net>
	 <20110219094943.GA16465@vasanth-laptop>
	 <1298109390.3725.9.camel@jlt3.sipsolutions.net>
	 <20110219100928.GB16962@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 11:18:09 +0100
Message-ID: <1298110689.3725.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 15:39 +0530, Vasanthakumar Thiagarajan wrote:
> On Sat, Feb 19, 2011 at 03:26:30PM +0530, Johannes Berg wrote:
> > On Sat, 2011-02-19 at 15:19 +0530, Vasanthakumar Thiagarajan wrote:
> > > On Sat, Feb 19, 2011 at 02:54:00PM +0530, Johannes Berg wrote:
> > > > On Sat, 2011-02-19 at 01:13 -0800, Vasanthakumar Thiagarajan wrote:
> > > > > When op_flush() is called with no drop (drop=false), the driver
> > > > > tries to tx as many frames as possible in about 100ms on every
> > > > > hw queue. During this time period frames from sw queue are also
> > > > > scheduled on to respective hw queue.
> > > > 
> > > > Given how long HW queues currently are, I wouldn't set the timeout to
> > > > 100ms -- mac80211 has no expectation how long this will take, although
> > > > 100ms seems pretty long I'm not sure it'll always be sufficient?
> 
> Would not having a long timeout for flush affect bg scanning by
> applications (scan time out)?.

In theory, yes. In practise, if the timeout is so low, your application
is not going to work right anyway :)

johannes

