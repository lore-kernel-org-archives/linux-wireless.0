Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:5610 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755146Ab0FNBvj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 21:51:39 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-057846296
	for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 10:51:37 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable all tasklets while resetting
Date: Mon, 14 Jun 2010 10:50:59 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20100611101221.26538.46913.stgit@tt-desk> <AANLkTilzHEhYgPyOnUtHk9HrOuSyyifwoI3hN6VUG1Xr@mail.gmail.com> <AANLkTik0Q2JM_DNaiLxc33Nn6dpI6uT52uG7b8-F4QjW@mail.gmail.com>
In-Reply-To: <AANLkTik0Q2JM_DNaiLxc33Nn6dpI6uT52uG7b8-F4QjW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006141050.59607.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 June 2010 23:38:15 Bob Copeland wrote:
> On Fri, Jun 11, 2010 at 10:21 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Fri, Jun 11, 2010 at 6:41 AM, Johannes Berg
> > 
> > <johannes@sipsolutions.net> wrote:
> >> I have no idea how long a reset can take, but this means that all these
> >> tasklets will spin while your reset is running if they were scheduled.
> > 
> > It looks to me like tasklet_action() will bail out when the tasklet has a
> > positive t->count (which disable elevates) rather than spin.  What did I
> > miss?
> 
> As Johannes pointed out on irc, I missed that it re-raises the softirq. 
> doh!

well, what else can we do? we have to make sure the tasklets don't run 
concurrently to a reset to keep rx and tx buffers consistent.

we disable interrupts right after disabling the tasklets, so they should not 
be scheduled again, right? actually, we should disable interrupts first, and 
then disable tasklets... but then it should be safe, no?

bruno
