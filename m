Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51608 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761153AbdEXKrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 06:47:25 -0400
Message-ID: <1495622843.2665.11.camel@sipsolutions.net> (sfid-20170524_124952_880917_A096E05C)
Subject: Re: WPA and WPA2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 May 2017 12:47:23 +0200
In-Reply-To: <20170524101309.GA2319@eros>
References: <20170524072750.GI8158@eros>
         <1495611651.2665.9.camel@sipsolutions.net> <20170524101309.GA2319@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-24 at 20:13 +1000, Tobin C. Harding wrote:

> For this driver I think it matters. It is not a soft MAC driver, but
> it is not a Full MAC either. The firmware was released in 2009, I
> don't imagine it is getting any updates. The WEXT driver adds/checks
> the TKIP Michael MIC in software.

Right. It might matter, but it depends - does the device actually
select the BSS (AP) to connect to?

It only really matters if it selects the BSS, or tries to roam, or
builds the association request IEs itself. If it doesn't do any of
those, and just takes the IEs from wpa_supplicant, it will not matter -
then it would only matter what key cipher you configure.

> Perhaps for the initial cfg80211 implementation we could simply
> support RSN only (i.e either WPA2 or no security)?

I'm not sure how much that buys you, but sure, doing things step by
step isn't a bad idea in general :)

> > Does this driver actually work with standard wpa_supplicant?
> 
> I'm not sure, I got hardware in the mail a couple of days ago but
> have not tested it yet. The current driver may be broken thanks to my
> refactoring efforts of late. I believe it was tested and functional
> when it was first brought into staging. I do not know to what depth
> it was tested.

I think you should try this first, and try to get some kind of logging
out to see what's going on with the firmware. Perhaps even put
tracepoints like iwlwifi has (iwlwifi_dev_hcmd) to see what
communication goes on with the device...

If it does work with the standard supplicant with wext, then I believe
it has to be using the IEs from there, and then the whole WPA/WPA2
thing shouldn't matter.

johannes
