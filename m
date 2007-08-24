Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44419
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXHXKSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:18:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch 7/7] b43: Fix and cleanup hwcrypto
Date: Fri, 24 Aug 2007 12:16:50 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20070823222153.073035000@bu3sch.de> <20070823222157.102919000@bu3sch.de> <1187950112.24933.3.camel@johannes.berg>
In-Reply-To: <1187950112.24933.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708241216.50441.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 August 2007 12:08:32 Johannes Berg wrote:
> On Fri, 2007-08-24 at 00:22 +0200, Michael Buesch wrote:
> 
> >  struct b43_key {
> > -	void *keyconf;
> > -	bool enabled;
> > +	/* If keyconf is NULL, this key is disabled.
> > +	 * keyconf is a cookie. Don't derefenrence it outside of the set_key
> > +	 * path, because b43 doesn't own it. */
> > +	struct ieee80211_key_conf *keyconf;
> 
> Just for clarification, you're allowed to dereference it as well if you
> wish but most things you can do with it (e.g. change hw key index) are
> racy.

That's what "because b43 doesn't own it" means. :)

-- 
Greetings Michael.
