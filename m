Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37444 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbeHNOFE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:05:04 -0400
Message-ID: <1534245439.3547.21.camel@sipsolutions.net> (sfid-20180814_131823_000897_6FBD4C10)
Subject: Re: [PATCH] mac80211: ignore SA Query Requests with unknown payload
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>,
        linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Tue, 14 Aug 2018 13:17:19 +0200
In-Reply-To: <1534245376.3547.20.camel@sipsolutions.net> (sfid-20180814_131719_782736_EFD9923D)
References: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
         <1534245118.3547.18.camel@sipsolutions.net>
         (sfid-20180814_131303_339421_811029D4) <1534245376.3547.20.camel@sipsolutions.net>
         (sfid-20180814_131719_782736_EFD9923D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 13:16 +0200, Johannes Berg wrote:
> 
> > Since you change wpa_s to subscribe to the relevant action frame:
> > 
> > > +       /* SA Query Request */
> > > +       if (nl80211_register_action_frame(bss, (u8 *) "\x08\x00", 2) < 0)
> > > +               ret = -1;
> > 
> > we could change the logic to be
> > 
> > if (!frame_includes_OCV || !cfg80211_rx_mgmt(...))
> > 	respond_in_kernel();
> > 
> 
> An easier alternative might be to push ieee80211_process_sa_query_req()
> to after ieee80211_rx_h_userspace_mgmt() so it won't see the frames if
> userspace claimed them, but I'm not sure how that works in AP mode where
> hostapd claims all frames - though I guess these aren't relevant in AP
> mode?

However, then obviously wpa_s has to be able to handle them if OCV isn't
included, which I haven't checked. It probably should be able to anyway
though, since the frame might include other elements that aren't OCV,
causing the kernel to punt it to wpa_s.

johannes
