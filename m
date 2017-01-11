Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59242 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763119AbdAKJZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 04:25:34 -0500
Message-ID: <1484126730.23671.5.camel@sipsolutions.net> (sfid-20170111_102537_821578_700CC51E)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Date: Wed, 11 Jan 2017 10:25:30 +0100
In-Reply-To: <5b561668eb5b4804b0007d03bc723f9d@SC-EXCH02.marvell.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
         <1483624722.4394.21.camel@sipsolutions.net>
         <5b561668eb5b4804b0007d03bc723f9d@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-10 at 01:32 +0000, David Lin wrote:

> > The only thing that really seems questionable to me is the whole
> > beacon parsing (and apparent rebuilding in firmware?). It's very
> > odd that you could do that, with a softmac device where all the
> > authentication and association is handled by hostapd anyway, and
> > you can't possibly pretend to handle everything hostapd might throw
> > at you - this will mean that you'll have features hostapd and every
> > other mac80211 supports that you will silently drop afaict - which
> > is rather unexpected.
> > 
> > First, you're parsing the data obtained from hostapd, in
> > mwl_fwcmd_parse_beacon(), and then you send them all to the
> > firmware in mwl_fwcmd_set_ies(), but only the things you actually
> > understood. New higher-level features you don't understand, or
> > vendor beacon IEs that aren't WMM, would be completely dropped.
> > 
> > I'm not very happy with that behaviour.
> > 
> > Why does the firmware require this? Why not just pack all IEs into
> > the pcmd->ie_list_len_proprietary, and leave everything else 0? Or
> > - if perhaps firmware for some reason requires HT/VHT to be treated
> > specially, only parse out the ones that are really needed specially
> > and leave everything else in the ie_list_len_proprietary?
> > 
> > Also, this is dropping all the encryption stuff - even those are
> > extensible btw, and hostapd might do so. Having the firmware
> > rebuild those out of out-of-band information is very unexpected for
> > a mac80211 driver.
> > 
> 
> This driver just extracts needed IEs which is used for the host
> command of firmware. I think we will not support other vendor IEs.
> And if needed, we can add them to pcmd->ie_list_proprietary.

Sure, I see that you're doing this. It still makes no sense though,
since all management frames are handled by hostapd anyway. It would
make some sense if you actually were going to handle association in the
firmware, but it makes no sense here, as far as I can tell.

I'm not sure how hard a line I should draw here, but I'll warn you now
that I won't take this into consideration when adding new features to
mac80211, and certainly Jouni won't take it into account when adding
new features to hostapd, so that such new features will then SILENTLY
and UNEXPECTEDLY (due to mac80211) not work with your driver.

I strongly advise you to reconsider this and try to pass through all
the IEs so that newly added features that shouldn't require firmware
interaction (since hostapd is handling all the association handshake
and IEs to advertise the feature) will automatically and cleanly work.

If you really can't do that, for some reason, then for my benefit as
the mac80211 maintainer and future maintainers of your driver, I'd like
to have documentation in the driver as to why the firmware needs the
driver to split up all those IEs and what it does with them. After all,
a common-sense analysis would suggest that the firmware has no need for
it, since all configuration should come through other places and all
IEs are just for going out on the air.

johannes
