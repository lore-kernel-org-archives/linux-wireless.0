Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:63061 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbXIIIup (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 04:50:45 -0400
Date: Sun, 9 Sep 2007 10:50:43 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: COMMON symbol warnings
Message-ID: <20070909085043.GA12021@deine-taler.de>
References: <1189100314.28781.112.camel@johannes.berg> <20070908130118.GA11648@infradead.org> <200709081835.02212.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709081835.02212.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:

> On Saturday 08 September 2007, Christoph Hellwig wrote:
> > > WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw-mac80211/zd1211rw-mac80211] is COMMON symbol
> > > WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw/zd1211rw] is COMMON symbol
> > > 
> > > any idea what that means?
> > 
> > Yes.  It means a variable is declared in multiple places and the linker
> > merges it for you.  The fix is to make sure these are declared extern in
> > all places but one.
> 
> Do you need an own workqueue in zd? Can you use the one mac80211 exports?

We could use the one mac80211 exports. This has been on my TODO
list for quite some time. But given the other problems we still
have, this hasn't been the highest priority. There is no bug here,
the only issue is that resource usage is a little bit higher. The
warning is from my point of view useless, because it is always
shown regardless whether there is a problem or not.

-- 
Uli Kunitz
