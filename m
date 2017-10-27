Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37468 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751854AbdJ0UKm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 16:10:42 -0400
Message-ID: <1509135034.2283.8.camel@sipsolutions.net> (sfid-20171027_221045_985391_70E07ED1)
Subject: Re: Commit 0711d638 breaks mwifiex
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: Jesse Sung <jesse.sung@canonical.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org, Ganapathi Bhat <gbhat@marvell.com>
Date: Fri, 27 Oct 2017 22:10:34 +0200
In-Reply-To: <20171026211313.GA46251@google.com> (sfid-20171026_231319_253350_7EC09DC5)
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
         <1508233890.10607.70.camel@sipsolutions.net>
         <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
         <1508237298.10607.76.camel@sipsolutions.net>
         <20171026211313.GA46251@google.com> (sfid-20171026_231319_253350_7EC09DC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> IIUC, mwifiex hasn't told the firmware to do anything at this point --
> the -EALREADY check is practically the first thing it does within
> connect(). So it just quits the connect() request and tries to carry on
> as usual. It will only do something different if the upper layers tell
> it to do so afterward (e.g., calling disconnect()).

Yeah, that makes sense.

> Yes, that's definitely what's happening. And it's explicitly called out
> in the supplicant's nl80211 driver that this is intentional:
> 
> [...]

Right.

> This is the main code path for supplicant commands like "Reattach",
> which boil down to (for non SME drivers):
> 
> wpas_request_connection()
>   ...
>  -> wpa_supplicant_connect()
>    -> wpa_supplicant_associate()
>      -> wpas_start_assoc_cb()
>        -> wpa_drv_associate()
>          -> wpa_driver_nl80211_associate()
>            -> wpa_driver_nl80211_connect()
> 
> Now for the part I'm not so familiar with: is this really the *expected*
> flow for full-MAC drivers in reattach, reassociate, and roaming flows?
> All of those seem to boil down to this same connect() (and fallback to
> disconnect()+connect() if -EALREADY) flow.

We never implemented a "ROAM" command, so there's not all that much
choice.

> But it doesn't seem like all full-MAC drivers do the same thing. Some
> seem to just blaze ahead with a connect attempt (maybe some firmwares
> automatically interpret this for us?) and never return -EALREADY at all.

Agree, some seem to just do some form of roaming on this, which really
just means they disconnect internally - or perhaps they even try to
roam if it's the same network?

> Sorry if this is slightly off-topic, but I'm trying to understand what
> the general expectations are here, based on my relatively narrow
> experience with a few drivers.

I don't really know either! There aren't that many direct cfg80211
drivers that don't use mac80211, so there's not that much experience.

You're probably well positioned to say what the behaviour _should_ be
though? :-)

I tend to think we should actually do the EALREADY from cfg80211, so
that wpa_s will always be forced to go through this roundabout code
path, but also finally implement a ROAM command, to let drivers have
that option?

Note also that we've always sort of envisioned that drivers
implementing CONNECT would do BSS selection themselves, but I think
there's no automatic way of doing that with wpa_s, and it may not even
be desirable in many cases (unless you really need the power saving
advantage) since it gets us into a situation where we have all these
different algorithms etc.

johannes
