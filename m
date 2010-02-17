Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37170 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933772Ab0BQApj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 19:45:39 -0500
Date: Tue, 16 Feb 2010 19:33:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mwl8k: disable softirqs when accessing sta_notify_list
Message-ID: <20100217003338.GA12419@tuxdriver.com>
References: <1266117186.13902.21.camel@mj> <43e72e891002161203w4498ae09wc7d14d12dd75be09@mail.gmail.com> <1266355712.2659.16.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1266355712.2659.16.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 04:28:32PM -0500, Pavel Roskin wrote:
> On Tue, 2010-02-16 at 12:03 -0800, Luis R. Rodriguez wrote:
> > On Sat, Feb 13, 2010 at 7:13 PM, Pavel Roskin <proski@gnu.org> wrote:
> > > Use spin_[un]lock_bh in mwl8k_sta_notify().  The sta_notify handler is
> > > required to be atomic, yet it can be called in process context, so make
> > > sure one call won't preempt another.
> > 
> > Is this for stable as well?
> 
> Since it wasn't tested on real hardware, I would say no, unless Lennert
> says otherwise.

That's how I saw it as well.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
