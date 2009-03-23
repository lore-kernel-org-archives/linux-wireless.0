Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37055 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbZCWTpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 15:45:41 -0400
Date: Mon, 23 Mar 2009 15:43:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
Message-ID: <20090323194313.GG3285@tuxdriver.com> (sfid-20090323_204543_993636_108528F1)
References: <1236939917.5235.7.camel@johannes.local> <1236941058.5235.12.camel@johannes.local> <20090320160308.GB28965@jm.kir.nu> <1237622383.5100.162.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237622383.5100.162.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 21, 2009 at 08:59:43AM +0100, Johannes Berg wrote:
> On Fri, 2009-03-20 at 18:03 +0200, Jouni Malinen wrote:
> > On Fri, Mar 13, 2009 at 11:44:18AM +0100, Johannes Berg wrote:
> > 
> > > --- wireless-testing.orig/net/mac80211/debugfs.c	2009-03-13 11:36:57.000000000 +0100
> > > +++ wireless-testing/net/mac80211/debugfs.c	2009-03-13 11:41:53.000000000 +0100
> > > +static ssize_t reset_write(struct file *file, const char __user *user_buf,
> > > +			   size_t count, loff_t *ppos)
> > 
> > > +	__ieee80211_suspend(&local->hw);
> > > +	__ieee80211_resume(&local->hw);
> > 
> > This seems to have broken build if CONFIG_PM is not defined: pm.c, with
> > these functions, is not included.
> 
> Indeed, this file should depend on CONFIG_PM too I suppose, will fix
> that. OTOH, a future patch I have will require _resume to always be
> present, so I'm inclined to just always put the code in. I'll come up
> with a fix in any case.

I fixed this in wireless-testing.  Feel free to change it as you like it.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
