Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39820 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZGCKKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 06:10:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: minstrel: avoid accessing negative indices in rix_to_ndx()
Date: Fri, 3 Jul 2009 12:10:29 +0200
Cc: Luciano Coelho <luciano.coelho@nokia.com>, linville@tuxdriver.org,
	linux-wireless@vger.kernel.org, kalle.valo@nokia.com,
	vidhya.govindan@nokia.com, nbd@openwrt.org
References: <1246598708-5594-1-git-send-email-luciano.coelho@nokia.com> <1246609742.16770.54.camel@johannes.local>
In-Reply-To: <1246609742.16770.54.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907031210.29648.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 July 2009 10:29:02 Johannes Berg wrote:
> On Fri, 2009-07-03 at 08:25 +0300, Luciano Coelho wrote:
> > If rix is not found in mi->r[], i will become -1 after the loop.  This value
> > is eventually used to access arrays, so we were accessing arrays with a
> > negative index, which is obviously not what we want to do.  This patch fixes
> > this potential problem.
> 
> This seems odd -- are you or are you not saying that this can happen in
> normal operation?
> 
> > @@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
> >  	for (i = rix; i >= 0; i--)
> >  		if (mi->r[i].rix == rix)
> >  			break;
> > -	WARN_ON(mi->r[i].rix != rix);
> > +	WARN_ON(i < 0);
> >  	return i;
> 
> If it can, this warning seems wrong.

Well, the old WARN_ON seems wrong anyway, because it accesses the array
out of bounds. In case the loop did not find the entry, the warn on will look like this:

WARN_ON(mi->r[-1].rix != rix);

So I do think it's correct to replace the WARN_ON with WARN_ON(i < 0), if this can't
happen in normal operation. If it can happen in normal op, the warning should be removed
and the callers of rix_to_ndx() need to be checked.

-- 
Greetings, Michael.
