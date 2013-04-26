Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3DZOO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 10:14:58 -0400
Message-ID: <1366985693.8295.12.camel@jlt4.sipsolutions.net> (sfid-20130426_161502_432292_A188529E)
Subject: Re: [PATCH] mac80211 allow HT override of ampdu factor/density
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 26 Apr 2013 16:14:53 +0200
In-Reply-To: <1366985513.8295.10.camel@jlt4.sipsolutions.net> (sfid-20130426_161201_039179_76312B45)
References: <1365522579-20771-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130409_174951_558534_9705BDF1) <1366985513.8295.10.camel@jlt4.sipsolutions.net>
	 (sfid-20130426_161201_039179_76312B45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-26 at 16:11 +0200, Johannes Berg wrote:
> On Tue, 2013-04-09 at 17:49 +0200, Simon Wunderlich wrote:
> > In the current implementation, amdpu changes are applied to own_cap,
> > but never actually applied to the stations ht settings, leaving these
> > overrides without effect.
> > 
> > Fix this by using the minimum (factor) or maximum (density) of the
> > respective remote and own ampdu values.
> 
> Applied, sorry I missed this.

No, hold on, I take that back.

This patch is wrong, there's no relation between our own capabilities
and the peer station's, so the current behaviour is correct. Maybe the
overrides are not properly applied in ieee80211_apply_htcap_overrides()
and then that doesn't take effect in ieee80211_add_ht_ie(), but clearly
that'd require a different change.

johannes

