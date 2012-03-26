Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45910 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2CZVjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 17:39:02 -0400
Received: by bkcik5 with SMTP id ik5so4375820bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 14:39:00 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH 2/2] mac80211: fix oper channel timestamp updation
Date: Mon, 26 Mar 2012 23:37:25 +0200
Message-ID: <2963819.iAOiN09J6h@linux-ltze.site> (sfid-20120326_233907_936007_3B8B9103)
In-Reply-To: <1332778177.5435.45.camel@jlt3.sipsolutions.net>
References: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com> <1332775418-16865-2-git-send-email-rmanohar@qca.qualcomm.com> <1332778177.5435.45.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 26, 2012 06:09:37 PM Johannes Berg wrote:
> On Mon, 2012-03-26 at 20:53 +0530, Rajkumar Manoharan wrote:
> > At the start of scan, mac80211 stop all vif transmission and inform the
> > AP that the station is leaving the operating channel. But it is not
> > updating the leave_oper_channel timestamp. As the result, the scan
> > decision always set operating channel at the scan start when the listen
> > interval is reduced.
> 
> Could use a better description, but seems OK, Helmut?

Yep, the recent restructuring in the scan code changed some parts. Hence,
this change makes sense to me. However, as Johannes already pointed out the
description could be a bit more precise.

Thanks,
Helmut

> johannes
> 
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  net/mac80211/scan.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index 33cd169..c70e176 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -370,7 +370,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
> >  	 */
> >  	drv_sw_scan_start(local);
> >  
> > -	local->leave_oper_channel_time = 0;
> > +	local->leave_oper_channel_time = jiffies;
> >  	local->next_scan_state = SCAN_DECISION;
> >  	local->scan_channel_idx = 0;
> >  
> 
> 
