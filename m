Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTIsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 03:48:55 -0500
Message-ID: <1384937328.14295.3.camel@jlt4.sipsolutions.net> (sfid-20131120_094859_410199_5D9949F3)
Subject: Re: QoS Data packets causing massive packet loss in
 ieee80211_sta_manage_reorder_buf.
From: Johannes Berg <johannes@sipsolutions.net>
To: Blaise Gassend <blaise@suitabletech.com>
Cc: linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Date: Wed, 20 Nov 2013 09:48:48 +0100
In-Reply-To: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com> (sfid-20131120_094152_985311_4DCD3B9E)
References: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com>
	 (sfid-20131120_094152_985311_4DCD3B9E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I have been tracing the packets through the code, and it appears that
> the loss happens in ieee80211_sta_manage_reorder_buf. It appears that
> when there are broadcast QoS Data packets, their sequence numbers get
> mixed with non-broadcast QoS Data sequence numbers causing out-of-date
> sequence number conditions to get triggered spuriously.
> 
> As far as I can tell broadcast QoS Data packets coming from the AP are
> pretty rare (the other networks I have access seem to use Data packets
> for broadcast traffic from the AP), but are legal. So I'm suspecting
> that the AP is behaving correctly, but is triggering a so-far rare bug
> in mac80211.
> But this problem is likely to become much more widespread if Aruba's
> 802.11ac firmware triggers it.
> 
> I'm not a deep 802.11 expert or a mac80211 so I could certainly use
> some help here. I am putting the details I have gathered below, and
> would love any suggestions/advice. Currently, my impression is that we
> might need a special tid_rx for broadcast packets similar to the
> special handling of broadcast packets in ieee80211_parse_qos.

I think we just need to skip reorder processing for multicast, since
they won't be aggregated anyway?

http://p.sipsolutions.net/d00799dd2201676a.txt

Then again I'm not really sure why we didn't do this before??

johannes

