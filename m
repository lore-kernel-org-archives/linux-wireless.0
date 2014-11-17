Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52229 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbaKQMXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 07:23:39 -0500
Message-ID: <1416227013.2031.1.camel@sipsolutions.net> (sfid-20141117_132344_785773_14AEADE8)
Subject: Re: [RFC] mac80211: allow drivers to provide any statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Mon, 17 Nov 2014 13:23:33 +0100
In-Reply-To: <5469E3F7.7020303@broadcom.com>
References: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
	 <5469E3F7.7020303@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-17 at 13:03 +0100, Arend van Spriel wrote:

> > +	void (*sta_statistics)(struct ieee80211_hw *hw,
> > +			       struct ieee80211_vif *vif,
> > +			       struct ieee80211_sta *sta,
> > +			       struct station_info *sinfo);
> 
> Could consider exposing station_info through ieee80211_sta struct.

We don't keep it in there though, we build it on the fly when we're
asked for statistics, and keep the actual values elsewhere (or even
calculate them on the fly). That'd be a bigger change then to keep in
the struct, and I'm not sure it's worth it since some need more info
than just the value (like ewma) etc.

johannes

