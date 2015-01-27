Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60933 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbbA0LBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 06:01:09 -0500
Message-ID: <1422356461.1890.64.camel@sipsolutions.net> (sfid-20150127_120114_857281_0711F7F3)
Subject: Re: [PATCH] cfg80211: PBSS basic support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dedy Lansky <dlansky@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	'Vladimir Kondratiev' <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 27 Jan 2015 12:01:01 +0100
In-Reply-To: <002501d03a1f$024d1e30$06e75a90$@codeaurora.org>
References: <1422345312-2963-1-git-send-email-dlansky@codeaurora.org>
	 <1422347067.1890.49.camel@sipsolutions.net>
	 <002501d03a1f$024d1e30$06e75a90$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 12:50 +0200, Dedy Lansky wrote:

> > > @@ -896,6 +949,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
> > >  	struct cfg80211_bss_ies *ies;
> > >  	struct ieee80211_channel *channel;
> > >  	struct cfg80211_internal_bss tmp = {}, *res;
> > > +	int bss_type;
> > 
> > enum.
> > 
> > Except that you actually forgot to store the BSS type ...
> > 
> > Actually - you didn't add it to the bss struct, but to wdev? Why is it needed there?? I don't see you using it?
> 
> wdev->bss_type refers to the BSS that we are connecting/connected to (Maybe rename to "conn_bss_type"?).
> This member is used in sme.c. It was introduced because once the connect is complete and driver calls cfg80211_connect_result(), cfg needs to find the BSS being connected to.

Ok I was thinking you were adding it to struct cfg80211_bss. Wouldn't
that make a bit more sense? Of course it can also be derived from
cfg80211_bss::channel and cfg80211_bss::capability, your call.

However, it doesn't seem that you need it in wdev if you have it there
inside wdev->current_bss?

johannes

