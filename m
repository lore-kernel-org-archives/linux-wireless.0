Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:48428 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbZJLOEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 10:04:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: WARNING: slow-path
Date: Mon, 12 Oct 2009 16:02:58 +0200
Cc: linux-wireless@vger.kernel.org
References: <200910121335.21807.hs4233@mail.mn-solutions.de> <1255352906.30919.11.camel@macbook.infradead.org>
In-Reply-To: <1255352906.30919.11.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910121602.58245.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What happens if you make that last argument NULL instead of
> passing 'dummy' back to it? That makes cfg80211_send_deauth()
> magically do different things w.r.t. locking.

That worked, thanks.


> Johannes, this is _evil_: 

It's not only _evil_, it's also undocumented. I was just
following include/net/cfg80211.h. There is no kernel-doc in the
comments for "cookie", neither in

  [struct cfg80211_ops:]

        int     (*deauth)(struct wiphy *wiphy, struct net_device *dev,
                          struct cfg80211_deauth_request *req,
                          void *cookie);

nor in


void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
                          void *cookie);


so I automatically assumed that I have to provide the "cookie" I
got in my deauth()-handler to cfg80211_send_deauth().

/me says "I can haz a cookie?"

-- 
http://www.holgerschurig.de
