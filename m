Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53408 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab0CQN5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 09:57:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 06:57:22 -0700
Date: Wed, 17 Mar 2010 06:56:00 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] wireless: convert reg_regdb_search_lock to mutex
Message-ID: <20100317012559.GD2210@senthil-lnx.colubris.lan>
References: <4B9F86E9.2030702@gmail.com>
 <1268768940-5654-1-git-send-email-linville@tuxdriver.com>
 <20100316100337.GA1732@senthil-lnx.users.atheros.com>
 <20100317002416.GA2095@tuxdriver.com>
 <20100316122449.GA17826@senthil-lnx.users.atheros.com>
 <20100317025656.GA9058@tuxdriver.com>
 <1268796275.7068.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1268796275.7068.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 08:54:35AM +0530, Johannes Berg wrote:
> On Tue, 2010-03-16 at 22:56 -0400, John W. Linville wrote:
> > On Tue, Mar 16, 2010 at 05:54:50PM +0530, Senthil Balasubramanian wrote:
> > > On Wed, Mar 17, 2010 at 05:54:16AM +0530, John W. Linville wrote:
> > > > On Tue, Mar 16, 2010 at 03:33:38PM +0530, Senthil Balasubramanian wrote:
> > > > > On Wed, Mar 17, 2010 at 01:19:00AM +0530, John W. Linville wrote:
> > > > > > Stanse discovered that kmalloc can be called with GFP_KERNEL while
> > > > > This commit log is confusing. It Should be "Stanse discovered kmalloc
> > > > > was called with GFP_KERNEL". Obviously kmalloc with GFP_KERNEL shouldn't
> > > > > be used while holding a spinlock.
> > > > > > holding this spinlock.  It can be a mutex instead.
> > > > 
> > > > Not half so confusing as your criticism... :-)
> > > sorry! if my mail wasn't proper. I didn't meant to blame/criticize.
> > > I was confused when I read the commit log and so I replied.
> > > > 
> > > > Are you objecting to "can be" instead of "was"?
> > > I am not objecting anything...
> > 
> > Criticism is fine -- I just don't understand what you were saying or
> > what you think I should have said in the commit log.
> 
> English at work ... let me guess:
Yes. I basically misread the commit log and understood like GFP_KENREL is allowed
while holding a spinlock. So I replied.

Sorry! for the unnecessary noise.. here... Please ignore my comment.
> 
> For John: "can" == "it could happen that"
> For Senthil: "can" == "may"
> 
> (when really you may NOT do GFP_KERNEL allocations in atomic context)
> 
> johannes
> 
