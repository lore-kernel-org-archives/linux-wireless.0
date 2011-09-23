Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab1IWKXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 06:23:09 -0400
Subject: Re: [RFC 2/2] mac80211: Send the management frame at requested rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>
In-Reply-To: <1316773324.4058.2.camel@jlt3.sipsolutions.net> (sfid-20110923_122212_939998_57596E54)
References: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
	 <1316703516-24216-2-git-send-email-rmanohar@qca.qualcomm.com>
	 <1316773324.4058.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110923_122212_939998_57596E54)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 12:23:05 +0200
Message-ID: <1316773385.4058.3.camel@jlt3.sipsolutions.net> (sfid-20110923_122313_671614_2D959DD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-23 at 12:22 +0200, Johannes Berg wrote:

> > +	if (ieee80211_is_probe_req(hdr->frame_control) &&
> > +	    tx->sdata->local->scan_req &&
> > +	    tx->sdata->local->scan_req->no_cck)
> > +		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
> > +
> 
> I think this would make more sense in ieee80211_send_probe_req() rather
> than here where it'll be executed for every frame.

In fact, maybe ieee80211_send_probe_req() should just get an argument to
avoid all the checks.

johannes

