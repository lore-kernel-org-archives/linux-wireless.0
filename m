Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59675 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3CAWaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 17:30:08 -0500
Message-ID: <1362177004.24973.12.camel@jlt4.sipsolutions.net> (sfid-20130301_233012_232570_455B324F)
Subject: Re: [PATCH] mac80211: add VHT capabilities station debugfs file
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Mar 2013 23:30:04 +0100
In-Reply-To: <1362176856.2116.27.camel@joe-AO722>
References: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net>
	 <1362176856.2116.27.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 14:27 -0800, Joe Perches wrote:
> On Fri, 2013-03-01 at 23:12 +0100, Johannes Berg wrote:
> > Add a new debugfs file to view a station's VHT capabilities.
> []
> > diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> []
> > @@ -325,6 +325,36 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
> >  }
> >  STA_OPS(ht_capa);
> >  
> > +static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
> > +				 size_t count, loff_t *ppos)
> > +{
> > +	char buf[512], *p = buf;
> 
> 512?  Kinda large don't you think?
> You use maybe 128.

Ah, well, copy/paste from HT, and then I removed the printing of flags
because I was too lazy to write a bunch of code for it ... I guess I'll
shrink it.

johannes

