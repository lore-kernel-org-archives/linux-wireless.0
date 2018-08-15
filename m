Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes4.cs.kuleuven.be ([134.58.40.3]:45214 "EHLO
        hermes4.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbeHOHof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 03:44:35 -0400
Received: from hermes4.cs.kuleuven.be. (localhost [127.0.0.1])
        by hermes4.cs.kuleuven.be.  with ESMTP id w7F4s2MS017789
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 06:54:02 +0200
Received: (from defang@localhost)
        by hermes4.cs.kuleuven.be. (8.14.4/8.14.4/Submit) id w7F4pEf5017757
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 06:51:14 +0200
Date: Wed, 15 Aug 2018 00:54:19 -0400
From: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211: ignore SA Query Requests with unknown payload
 data
Message-ID: <20180815005419.2e73c068@cs.kuleuven.be> (sfid-20180815_065942_852068_F8521239)
In-Reply-To: <1534245439.3547.21.camel@sipsolutions.net>
References: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
        <1534245118.3547.18.camel@sipsolutions.net>
        <1534245376.3547.20.camel@sipsolutions.net>
        <1534245439.3547.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I also think we shouldn't necessarily punt too short or otherwise
> malformed frames to userspace, what's the point? We currently
> drop/ignore those, and can continue to do so afaict?

Agreed, we should drop too short or malformed frames.

> An easier alternative might be to push ieee80211_process_sa_query_req()
> to after ieee80211_rx_h_userspace_mgmt() so it won't see the frames if
> userspace claimed them, but I'm not sure how that works in AP mode where
> hostapd claims all frames - though I guess these aren't relevant in AP
> mode?
> 
> However, then obviously wpa_s has to be able to handle them if OCV isn't
> included, which I haven't checked. It probably should be able to anyway
> though, since the frame might include other elements that aren't OCV,
> causing the kernel to punt it to wpa_s.

SA Query request frames are also relevant in AP mode. They are fully
handled by hostapd currently.

With the OCV patch, wpa_s will also be able to handle SA Query requests
that don't contain the OCI element. So if userspace registered SA Query
request frames, it makes sense to send *all* SA Query requests to
userspace. Additionally, older versions of wpa_s won't register SA
Query request frames, meaning the kernel will still handle them, and
hence everything will still work normally.

So to me, it make sense to only let the kernel reply to SA Query
requests when operating in station mode *and* when the userspace didn't
register SA Query frames. In that case, I suppose we can send a SA
Query response as is done currently, i.e., any payload in the SA Query
request is ignored?

Cheers,
Mathy
