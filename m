Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58968 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab1EIQOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 12:14:05 -0400
Received: by mail-ew0-f45.google.com with SMTP id 24so1923303ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 09:13:59 -0700 (PDT)
Subject: Re: [PATCH] mac80211: don't drop frames where skb->len < 24 in
 ieee80211_scan_rx()
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1304952399.12202.3.camel@jlt3.sipsolutions.net>
References: <1304950753-2952-1-git-send-email-coelho@ti.com>
	 <1304952399.12202.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 19:13:55 +0300
Message-ID: <1304957635.12586.605.camel@cumari> (sfid-20110509_181409_832169_70D1C3F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 16:46 +0200, Johannes Berg wrote:
> On Mon, 2011-05-09 at 17:19 +0300, Luciano Coelho wrote:
> > This seems to be a leftover from the old days, when we didn't support
> > any frames that didn't contain the full ieee802.11 header.  This is
> > not the case anymore.  It does not cause problems now, because they
> > are only dropped during scan.  But when scheduled scans get merged,
> > this would become a problem because we would drop all small frames
> > while scheduled scan is running.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> >  net/mac80211/scan.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> > index 489b6ad..b7a39c4 100644
> > --- a/net/mac80211/scan.c
> > +++ b/net/mac80211/scan.c
> > @@ -169,9 +169,6 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
> >  	if (ieee80211_is_ctl(fc))
> >  		return RX_CONTINUE;
> >  
> > -	if (skb->len < 24)
> > -		return RX_DROP_MONITOR;
> > -
> 
> You can't just delete it, we use mgmt->da at least in this code path.
> You should just change RX_DROP_MONITOR to RX_CONTINUe here I think.

Oops! I did this in a hurry and didn't think.  I'm sending v2 in a sec.

-- 
Cheers,
Luca.

