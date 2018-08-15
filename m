Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51628 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbeHOMIq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 08:08:46 -0400
Message-ID: <1534324580.3547.33.camel@sipsolutions.net> (sfid-20180815_112108_024901_EA7F6A67)
Subject: Re: [PATCH] mac80211: ignore SA Query Requests with unknown payload
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Wed, 15 Aug 2018 11:16:20 +0200
In-Reply-To: <20180815005419.2e73c068@cs.kuleuven.be>
References: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
         <1534245118.3547.18.camel@sipsolutions.net>
         <1534245376.3547.20.camel@sipsolutions.net>
         <1534245439.3547.21.camel@sipsolutions.net>
         <20180815005419.2e73c068@cs.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-15 at 00:54 -0400, Mathy Vanhoef wrote:

> > An easier alternative might be to push ieee80211_process_sa_query_req()
> > to after ieee80211_rx_h_userspace_mgmt() so it won't see the frames if
> > userspace claimed them, but I'm not sure how that works in AP mode where
> > hostapd claims all frames - though I guess these aren't relevant in AP
> > mode?
> > 
> > However, then obviously wpa_s has to be able to handle them if OCV isn't
> > included, which I haven't checked. It probably should be able to anyway
> > though, since the frame might include other elements that aren't OCV,
> > causing the kernel to punt it to wpa_s.
> 
> SA Query request frames are also relevant in AP mode. They are fully
> handled by hostapd currently.

OK. But I see that they've never been handled by the kernel there - we
check and do only in STATION mode.

> With the OCV patch, wpa_s will also be able to handle SA Query requests
> that don't contain the OCI element. So if userspace registered SA Query
> request frames, it makes sense to send *all* SA Query requests to
> userspace. Additionally, older versions of wpa_s won't register SA
> Query request frames, meaning the kernel will still handle them, and
> hence everything will still work normally.

Right, good.

> So to me, it make sense to only let the kernel reply to SA Query
> requests when operating in station mode *and* when the userspace didn't
> register SA Query frames. In that case, I suppose we can send a SA
> Query response as is done currently, i.e., any payload in the SA Query
> request is ignored?

Sure, I think that's fair.

So basically that means we can just move the handling of SA query
request to *after* userspace redirection - in anything but station mode
nothing changes (hostapd asks for all action frames but handles this one
and we don't), and without changes to wpa_s in station mode also nothing
changes since it won't ask for the frame, and if it does ask for it then
it can as well handle all ...

johannes
