Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57412 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPWGP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 17:06:15 -0500
Message-ID: <1516140365.410.51.camel@sipsolutions.net> (sfid-20180116_230619_045910_A605F430)
Subject: Re: [PATCH v2 03/10] rtlwifi: Add sta_statistics of mac80211's op,
 and set filled=0 by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
Date: Tue, 16 Jan 2018 23:06:05 +0100
In-Reply-To: <87608124kn.fsf@purkki.adurom.net>
References: <20180111070932.9929-1-pkshih@realtek.com>
         <20180111070932.9929-4-pkshih@realtek.com>
         <87608124kn.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-16 at 17:42 +0200, Kalle Valo wrote:

> > When using iwconfig to check wifi status, wext uses 'static struct' of
> > sinfo to get station info so sinfo->filled will be persistent. Since the
> > commit 2b9a7e1bac24 ("mac80211: allow drivers to provide most station
> > statistics") assumes driver initializes sinfo->filled to declare supported
> > fields, without initialization it will report wrong info. This commit
> > simply set 'filled' to be zero simply, and left sinfo to be filled by
> > mac80211.

Huh, this can't be right.

> Adding an empty op like that feels pointless, IMHO (but without checking
> mac80211 sources) not having the op should be the same as filled = 0. To
> me this smells like a bug in mac80211.
> 
> Johannes, what do you think?

It can't be right. It would've broken each and every driver out there,
other than the one or two who implement this.

However, it looks like PK is actually correct - *wext* does appear to
be broken! nl80211 does this:

                memset(&sinfo, 0, sizeof(sinfo));
                err = rdev_dump_station(rdev, wdev->netdev, sta_idx,
                                        mac_addr, &sinfo);


and

        memset(&sinfo, 0, sizeof(sinfo));

...

        err = rdev_get_station(rdev, dev, mac_addr, &sinfo);

and has a bug in cfg80211_cqm_rssi_update(). Wext also has bugs, I'll
send out a fix.

johannes
