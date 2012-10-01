Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2JAHUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:20:44 -0400
Message-ID: <1349076076.10330.4.camel@jlt4.sipsolutions.net> (sfid-20121001_092048_304482_77ABBDA7)
Subject: Re: [PATCH] mac80211: use __printf attribute in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Oct 2012 09:21:16 +0200
In-Reply-To: <1349020345.1958.1.camel@joe-AO722>
References: <1349018174-22867-1-git-send-email-johannes@sipsolutions.net>
	 <1349020345.1958.1.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-09-30 at 08:52 -0700, Joe Perches wrote:
> On Sun, 2012-09-30 at 17:16 +0200, Johannes Berg wrote:
> > The internal function mac80211_format_buffer() has a
> > printf-style argument list, so add the attribute to
> > have gcc verify that list.
> []
> > diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> []
> > @@ -17,8 +17,8 @@
> []
> > -int mac80211_format_buffer(char __user *userbuf, size_t count,
> > -				  loff_t *ppos, char *fmt, ...)
> > +int __printf(4, 5) mac80211_format_buffer(char __user *userbuf, size_t count,
> > +					  loff_t *ppos, char *fmt, ...)
> >  {
> >  	va_list args;
> >  	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];
> 
> Good idea, but this needs to be added to the prototype
> in debugfs.h not on the function itself.

Oops, good catch, will fix that.

johannes

