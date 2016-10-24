Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52158 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934973AbcJXNd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 09:33:27 -0400
Message-ID: <1477316004.4085.17.camel@sipsolutions.net> (sfid-20161024_153330_450598_2344DCF9)
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if
 requested
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <a@unstable.cc>
Cc: linux-wireless@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Date: Mon, 24 Oct 2016 15:33:24 +0200
In-Reply-To: <20161024121129.GA8925@prodigo.lan>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com>
         <1447464560-28104-2-git-send-email-antonio@meshcoding.com>
         <1448016547.3141.4.camel@sipsolutions.net> <564F1790.7030309@open-mesh.com>
         <20161024121129.GA8925@prodigo.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I think it would be reasonable only if the target channel is the
> > one we are using and we have done CSA. But when scanning non-
> > operative channels I don't think this could work.

> this has been sleeping for a while.. :)
> Would it make sense to rebase it and resubmit it for inclusion?
> 
> Given the previous discussion we could change the logic as:
> * always passively scan DFS channels that are not usable
> * always actively scan DFS channels that are usable (i.e. CAC was
> performed).

Doesn't that contradict what you said above?

If we scan, don't we possibly lose our CAC result anyway, since we went
off-channel? In FCC at least? In ETSI I think we're allowed to do that
for a bit?

Anyway, why not just always scan passively, to simplify?

johannes
