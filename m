Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:47475 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZGWKua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:50:30 -0400
Received: by bwz28 with SMTP id 28so726949bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:50:29 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/7] cfg80211: increase scan result expire time
Date: Thu, 23 Jul 2009 12:50:36 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20090723100732.5147.73989.stgit@localhost.localdomain> <20090723101428.5147.53956.stgit@localhost.localdomain> <1248345595.19121.25.camel@johannes.local>
In-Reply-To: <1248345595.19121.25.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907231250.37025.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 23. Juli 2009 schrieb Johannes Berg:
> On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> > Using background scanning in mac80211 the time a scan needs to
> > finish can exceed 10 seconds. Hence, increase the scan results
> > expire time to 15 seconds which should be sufficient.
> >     
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> 
> Heh.

;)

Maybe we could later use a dynamic expire time based on the time
the last scan took or something similar. But for now 15 seconds
should suffice.

> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> johannes
> 
> > ---
> > 
> >  net/wireless/scan.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> > index 4ad8b4b..0850b98 100644
> > --- a/net/wireless/scan.c
> > +++ b/net/wireless/scan.c
> > @@ -15,7 +15,7 @@
> >  #include "core.h"
> >  #include "nl80211.h"
> >  
> > -#define IEEE80211_SCAN_RESULT_EXPIRE	(10 * HZ)
> > +#define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
> >  
> >  void __cfg80211_scan_done(struct work_struct *wk)
> >  {
> > 
> > 
> 


