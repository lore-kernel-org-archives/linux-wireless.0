Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0CVSMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 14:12:39 -0400
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
 ieee80211_local data structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <randolf.bruno@googlemail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201003211101.16481.randolf.bruno@gmail.com>
References: <4BA24A12.4030208@gmail.com>
	 <f74418681003201302g3ed2902bp230a1ce93d165831@mail.gmail.com>
	 <1269117605.4611.0.camel@jlt3.sipsolutions.net>
	 <201003211101.16481.randolf.bruno@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 11:12:44 -0700
Message-ID: <1269281564.7645.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-21 at 11:01 +0900, Bruno Randolf wrote:
> On Sunday 21 March 2010 05:40:05 Johannes Berg wrote:
> > On Sat, 2010-03-20 at 21:02 +0100, Lorenzo Bianconi wrote:
> > > >> setup 2 wireless cards, talking to each other (i use IBSS) on
> > > >> different
> > > 
> > > >> machines. then setup routing like this:
> > > PC1<--ethernet cable-->Device1<--wireless link-->Device2<--ethernet
> > > cable-->PC2
> > 
> > I'm not really sure how this scenario differs from injecting traffic
> > locally, but I'll try to reproduce.
> 
> if you generate traffic locally it's enough to stop the queues, this will 
> cause userspace to stop generating traffic. in the forwarding case (which we 
> are talking about) stopping the queues will not stop the sender to send 
> traffic, thus we have to start dropping packets at some point. 

So I tried this scenario, and I see the queues stopping, and traffic
being dropped quite as you'd want it. Even the race condition that I
noticed didn't ever trigger.

Please make sure you're using a kernel recent enough to include the
fixes, maybe try compat-wireless.

johannes

