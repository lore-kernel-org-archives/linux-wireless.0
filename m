Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54513 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbcDEM01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:26:27 -0400
Message-ID: <1459859183.18188.48.camel@sipsolutions.net> (sfid-20160405_142630_203168_81553BE3)
Subject: Re: [PATCH 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 14:26:23 +0200
In-Reply-To: <1456244101.9910.21.camel@sipsolutions.net> (sfid-20160223_171518_567734_0CFC1B55)
References: <1455876110-12758-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1455876110-12758-2-git-send-email-janusz.dziedzic@tieto.com>
	 <1456237769.9910.20.camel@sipsolutions.net> <56CC725D.1080209@openwrt.org>
	 <1456244101.9910.21.camel@sipsolutions.net>
	 (sfid-20160223_171518_567734_0CFC1B55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 17:15 +0100, Johannes Berg wrote:

> > > Perhaps we could live with this being done only for the fast-xmit
> > > case?
> > I don't think we should pass padded vs non-padded frames depending
> > on
> > whether fast-xmit was used. The non-fast-xmit codepath could simply
> > do the memmove at the end of the tx handlers though.
> I guess that's fair. Would it be sufficent though?
> 

So it turns out the patch 1/2 actually makes the code *bigger* for some
reason.

Janusz, can you see if the above suggestion would be good enough?

Hopefully high-tpt cases would all run through fast-xmit anyway.

johannes
