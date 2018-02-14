Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48638 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967114AbeBNKq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 05:46:29 -0500
Message-ID: <1518605187.21268.1.camel@sipsolutions.net> (sfid-20180214_114633_271058_255671A9)
Subject: Re: mac80211 scan results, signal value not reliable
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 14 Feb 2018 11:46:27 +0100
In-Reply-To: <AM4PR0101MB2305974B5EC0ABE4A24204DAE4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <AM4PR0101MB23058FC2795B1FAF71CBF4F2E4F30@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
         (sfid-20180208_104936_856405_3756BBC7) <1518296953.2029.6.camel@sipsolutions.net>
         <AM4PR0101MB2305974B5EC0ABE4A24204DAE4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-14 at 10:10 +0000, Jean Pierre TOSONI wrote:
> > 
> > However, it looks like you're right and ieee80211_bss_info_update()
> > doesn't take the flag into account. Bit strange that we even have
> > the flag I guess, since we treat 0 as an invalid value in various
> > places, being too high power to realistically receive anyway.
> 
> The problem is that 0 is invalid as a SIGNAL_DBM value but this is
> dubious for a SIGNAL_UNSPEC value which appears to be still in use
> in a couple of drivers.

Huh, good point, that's ancient history to me and I forget :-)

> > Want to send a patch? There seem to be a few more places as well,
> 
> I am working on a 3.18 kernel; so I can either make the patch from
> an old compat-wireless, or make the patch from your last tree but
> I cannot test it; are you interested anyways?

The only useful patch would be on the last tree. :-)

> > e.g.
> > in rx.c for cfg80211_report_obss_beacon() and cfg80211_rx_mgmt().
> 
> There is also mlme.c, the ifmgd->ave_beacon_signal should not be updated
> with an invalid signal;
> and in the last tree, the ibss join passes an uninitialized signal
> value to cfg80211_inform_bss_frame_data().

Good catch!

johannes
