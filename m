Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:41465 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932177Ab0CaILo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 04:11:44 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0258173102
	for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 17:11:42 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local data structure
Date: Wed, 31 Mar 2010 17:12:12 +0900
References: <4BA24A12.4030208@gmail.com> <201003211101.16481.randolf.bruno@gmail.com> <1269281564.7645.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1269281564.7645.1.camel@jlt3.sipsolutions.net>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003311712.12301.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 March 2010 03:12:44 you wrote:
> On Sun, 2010-03-21 at 11:01 +0900, Bruno Randolf wrote:
> > On Sunday 21 March 2010 05:40:05 Johannes Berg wrote:
> > > On Sat, 2010-03-20 at 21:02 +0100, Lorenzo Bianconi wrote:
> > > > >> setup 2 wireless cards, talking to each other (i use IBSS) on
> > > > >> different
> > > > 
> > > > >> machines. then setup routing like this:
> > > > PC1<--ethernet cable-->Device1<--wireless link-->Device2<--ethernet
> > > > cable-->PC2
> > > 
> > > I'm not really sure how this scenario differs from injecting traffic
> > > locally, but I'll try to reproduce.
> > 
> > if you generate traffic locally it's enough to stop the queues, this will
> > cause userspace to stop generating traffic. in the forwarding case (which
> > we are talking about) stopping the queues will not stop the sender to
> > send traffic, thus we have to start dropping packets at some point.
> 
> So I tried this scenario, and I see the queues stopping, and traffic
> being dropped quite as you'd want it. Even the race condition that I
> noticed didn't ever trigger.
> 
> Please make sure you're using a kernel recent enough to include the
> fixes, maybe try compat-wireless.

so it must be an ath5k bug then... lorenzo's description just resembled my 
case so much, that i thought it could be the same bug. sorry to have bothered 
you with this...

bruno
