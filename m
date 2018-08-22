Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49142 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbeHVKvZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 06:51:25 -0400
Message-ID: <1534922856.25523.60.camel@sipsolutions.net> (sfid-20180822_092749_166175_B26CAA86)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Wed, 22 Aug 2018 09:27:36 +0200
In-Reply-To: <7999c366492a4523456227fb49329bf2@codeaurora.org>
References: <7999c366492a4523456227fb49329bf2@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 15:08 -0700, Pradeep Kumar Chitrapu wrote:

> > Right. However, I guess we could allow updating/changing this setting 
> > on
> > the fly through nl80211_set_beacon() which already allows changing 
> > other
> > non-beacon parameters (like the probe or assoc response templates), and
> > then we can use your approach. Basically changing "SET_BEACON" to be a
> > bit like "CHANGE_AP".
> 
> Agree. ( ftm_responder param will have to be added in 
> cfg80211_beacon_data
> instead of cfg80211_ap_settings)

Right. I'm not even sure that all devices can disable it though, so we
may be in a bind here? I think ours (Intel) can't, for example, disable
FTM responder without disabling the AP (at least momentarily)...

Should we just ignore that? Or perhaps add a separate capability for it?

Maybe there's even hardware that cannot change the elements (LCI/Civic
location) on the fly?

johannes
