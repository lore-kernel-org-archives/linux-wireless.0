Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60736 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934855AbdJQJvg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 05:51:36 -0400
Message-ID: <1508233890.10607.70.camel@sipsolutions.net> (sfid-20171017_115140_216992_AD84F94E)
Subject: Re: Commit 0711d638 breaks mwifiex
From: Johannes Berg <johannes@sipsolutions.net>
To: Jesse Sung <jesse.sung@canonical.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc: Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 11:51:30 +0200
In-Reply-To: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com> (sfid-20171017_110449_063483_9C0F4028)
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
         (sfid-20171017_110449_063483_9C0F4028)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> While working on an issue that marvell module stops connecting to AP,
> bisect reveals that the issue starts to happen from commit 0711d638,
> which uses wdev->ssid_len instead of wdev->current_bss to determine
> if driver's .disconnect() should be called.
> 
> It happens because mwifiex_cfg80211_connect() returns -EALREADY
> when it finds wdev->current_bss is valid:
> 
> if (priv->wdev.current_bss) {
>     [PRINT LOG]
>     return -EALREADY;
> }
> 
> This would make cfg80211_connect() set wdev->ssid_len to 0, and thus
> mwifiex_cfg80211_disconnect() won't be called by
> cfg80211_disconnect().

Hmm, none of this makes much sense to me right now.

Does mwifiex treat this -EALREADY as *keeping* an old connection, or
tearing it down entirely?

Because right now clearly cfg80211 assumes, on the one hand, that no
connection is kept (resetting ssid_len), but on the other hand it got
here with current_bss set - so perhaps we should reject that before in
cfg80211, rather than in mwifiex?

I think your fix is invalid because we then reset ssid_len and still
keep an old connection (current_bss) which will lead to strange nl80211
behaviour when getting interface data etc.

johannes
