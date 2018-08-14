Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37432 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbeHNOEA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:04:00 -0400
Message-ID: <1534245376.3547.20.camel@sipsolutions.net> (sfid-20180814_131719_782736_EFD9923D)
Subject: Re: [PATCH] mac80211: ignore SA Query Requests with unknown payload
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>,
        linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Tue, 14 Aug 2018 13:16:16 +0200
In-Reply-To: <1534245118.3547.18.camel@sipsolutions.net> (sfid-20180814_131303_339421_811029D4)
References: <20180806224857.14853-1-Mathy.Vanhoef@cs.kuleuven.be>
         <1534245118.3547.18.camel@sipsolutions.net>
         (sfid-20180814_131303_339421_811029D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 13:11 +0200, Johannes Berg wrote:
> On Tue, 2018-08-07 at 00:48 +0200, Mathy Vanhoef wrote:
> > When operating in station mode, ignore SA Query Request frames that
> > contain extra payload data. The kernel doesn't know how to handle these
> > frames. Instead, give userspace a chance to handle these frames.
> > 
> > For example, with Operating Channel Validation, SA Query Requests may
> > now contain an extra Operating Channel Information (OCI) element as
> > payload data. The kernel should ignore these frames, since it does not
> > know how to properly handle them. Instead, let userspace process these
> > frames.
> > 
> > Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
> > ---
> > For background on Operating Channel Validation, see:
> > https://mentor.ieee.org/802.11/dcn/17/11-17-1807-12-000m-defense-against-multi-channel-mitm-attacks-via-operating-channel-validation.docx
> > 
> > A corresponding patchset was also recently submitted to Hostap, see "Add
> > support for Operating Channel Validation (OCV)".
> 
> In a perfect world, this seems fine. However, what if wpa_s doesn't
> implement this (yet)? In that case, wouldn't it be better (or really
> required) to still respond to the SA query request in the kernel?
> 
> Since you change wpa_s to subscribe to the relevant action frame:
> 
> > +       /* SA Query Request */
> > +       if (nl80211_register_action_frame(bss, (u8 *) "\x08\x00", 2) < 0)
> > +               ret = -1;
> 
> we could change the logic to be
> 
> if (!frame_includes_OCV || !cfg80211_rx_mgmt(...))
> 	respond_in_kernel();
> 

An easier alternative might be to push ieee80211_process_sa_query_req()
to after ieee80211_rx_h_userspace_mgmt() so it won't see the frames if
userspace claimed them, but I'm not sure how that works in AP mode where
hostapd claims all frames - though I guess these aren't relevant in AP
mode?

johannes
