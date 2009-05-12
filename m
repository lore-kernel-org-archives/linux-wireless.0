Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41129 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbZELPPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 11:15:42 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
Date: Tue, 12 May 2009 17:15:39 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200905120109.09906.chunkeey@web.de> <1242110389.3873.53.camel@johannes.local>
In-Reply-To: <1242110389.3873.53.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200905121715.39702.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 May 2009 08:39:49 Johannes Berg wrote:
> On Tue, 2009-05-12 at 01:09 +0200, Christian Lamparter wrote:
> 
> > +		if ((ar->tx_stats[i].len < ar->tx_stats[i].limit) &&
> > +		    (ieee80211_queue_stopped(ar->hw, i)))
> > +			ieee80211_wake_queue(ar->hw, i);
> 
> There's no reason to test _stopped first, and doing so is racy.
uhh, agreed _stopped is not necessary, but where's the race condition?

> 
> >  	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> > +		err = ar9170_stop_and_flush_queues(ar);
> > +		if (err)
> > +			goto out;
> 
> Why don't you do that in the pre-scan method?
dunno, will pre_scan cb code end up in 2.6.30 as well?

Regards,
	Chr 
