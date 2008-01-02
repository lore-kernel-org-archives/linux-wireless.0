Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57903 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYABPY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 10:24:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Date: Wed, 2 Jan 2008 16:23:35 +0100
Cc: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
References: <1198253375.16241.76.camel@johannes.berg> <20080102084532.GA17960@infradead.org> <1199263934.4172.69.camel@johannes.berg>
In-Reply-To: <1199263934.4172.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801021623.36089.mb@bu3sch.de> (sfid-20080102_152431_358644_DF834551)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2008 09:52:14 Johannes Berg wrote:
> 
> > Building an algorithm optionally into mac80211 seems rather odd.  In
> > case mac80211 the algorithms should be their own modules and you should
> > use request_module to make sure at least one is loaded.
> 
> We actually do that but people still manage to mess it up because they
> don't install the modules properly or whatever.
> 
> > Or if you
> > really want to make sure one is alway avaiabable always build the
> > simplest one directly and unconditionally into mac80211.ko.
> 
> That'd be an alternative too, I think we have something like that now. I
> don't really like it that much though because for 99% of people it's
> just dead code. Anyway, I'll look into Sam's mail and do a new patch
> depending on that.

What about simply _not_ failing the initialization of mac80211, if no
rc algo is available? I mean, we can just use a fixed rate we get through
WEXT and stuff. Simply start at 1M on init in that case and stay at a fixed
1M until the user sets a different fixed rate through WEXT.

-- 
Greetings Michael.
