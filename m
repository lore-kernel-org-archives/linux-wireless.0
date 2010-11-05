Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31564 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0KETpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:45:39 -0400
Subject: Re: [RFC 07/15] cfg80211: add periodic scan results handler
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885676.3659.5.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-8-git-send-email-luciano.coelho@nokia.com>
	 <1288885676.3659.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 22:00:20 +0200
Message-ID: <1288987220.25600.16.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:47 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> 
> > +void cfg80211_periodic_results(struct cfg80211_periodic_request *req)
> > +{
> > +	WARN_ON(req != wiphy_to_dev(req->wiphy)->periodic_req);
> > +
> > +	queue_work(cfg80211_wq, &wiphy_to_dev(req->wiphy)->periodic_wk);
> > +}
> 
> why even pass it in?

Yeah, I'll recheck this.  Probably remove this periodic_req in local
entirely.


-- 
Cheers,
Luca.

