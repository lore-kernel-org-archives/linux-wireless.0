Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:3740 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751298Ab0DMH4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 03:56:35 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-073175392
	for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 16:56:33 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to band
Date: Tue, 13 Apr 2010 16:56:39 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100412073658.28078.32155.stgit@tt-desk> <201004130916.18626.br1@einfach.org> <1271143275.4885.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1271143275.4885.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004131656.40025.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 April 2010 16:21:15 Johannes Berg wrote:
> On Tue, 2010-04-13 at 09:16 +0900, Bruno Randolf wrote:
> > On Monday 12 April 2010 17:40:52 you wrote:
> > > On Mon, 2010-04-12 at 17:34 +0900, Bruno Randolf wrote:
> > > > before we unconditionally used 3 (1Mbps, 2 Mbps) as basic rates. this
> > > > clearly is wrong in the 5GHz band.
> > > 
> > > No, it's fine. Look again at how this works.
> > 
> > (hello? can you please stop treating me like an idiot?)
> > 
> > this means we use 6 and 9 as basic rates in the 5GHz band.
> > we should use 6, 12 and 24.
> 
> No, we can treat 6 and 9 as basic rates if we want to when we create the
> IBSS. You seem to be confusing basic and mandatory rates or something
> else that I can't make sense of. It's NOT "clearly wrong".

ok, i agree that we are probably allowed to choose any basic rates when we 
create an IBSS - but the question is: why would we want to use lower rates?

does it not make sense to use all mandatory rates as basic rates?

as a side note: the reason i am concerned about the basic rates is that when 
we use RTC/CTS (which are sent at a basic rate) thruput gets quite low when 
the basic rates are (too?) low. this is a tradeoff between reliability and 
speed - and probably should be user configurable. so maybe instead of adding a 
"g-only" flag to ibss creation, should i add an iw command for setting the 
basic rates? what do you think about that?

bruno
