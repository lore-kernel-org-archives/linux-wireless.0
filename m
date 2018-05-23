Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39286 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753985AbeEWHIw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:08:52 -0400
Message-ID: <1527059329.3759.3.camel@sipsolutions.net> (sfid-20180523_090856_715858_4082124A)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: Tim Kourt <tim.a.kourt@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 23 May 2018 09:08:49 +0200
In-Reply-To: <49f54bdd-5134-965e-d736-09b991642825@gmail.com> (sfid-20180522_234528_544669_782B1318)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         <1527019967.6787.45.camel@sipsolutions.net>
         <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
         <1527021608.6787.47.camel@sipsolutions.net>
         <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
         <1527022332.6787.51.camel@sipsolutions.net>
         <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com>
         <1527023478.6787.60.camel@sipsolutions.net>
         <c0b00a4c-f98e-6261-976b-d9c7ae708eee@gmail.com>
         <1527024498.6787.67.camel@sipsolutions.net>
         <49f54bdd-5134-965e-d736-09b991642825@gmail.com>
         (sfid-20180522_234528_544669_782B1318)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

> > I'm not sure. It still indicates that a hidden SSID was found, and in
> > general even a real SSID on the same BSSID doesn't indicate that this
> > was the only hidden SSID ...
> 
> Right, but you still get that info conveyed through the Beacon IEs 
> elements on the second/third/etc entry.  So it still seems redundant to 
> include the pure beacon one?

Yeah, it's redundant to some extent. If you're an older application not
looking at BEACON_IES attribute though, you don't see the extra beacon
data in the scan result for the hidden network that had a probe response
received.

Internally, we have to create two different BSS entries so that we can
track the BSSID/channel -> IEs mapping in one, and the potentially
multiple probe responses with different IEs in the other entries. We
ignore that relationship when sending things to userspace, but the
multiple entries are there.

> Also, given that you have to ask for the SSID you want specifically, 
> what practical purpose does it serve to know that this wasn't the only 
> hidden SSID?  I mean you can see that hidden SSIDs are out there, run an 
> active scan for the ones you can use.  If none are there, you can just 
> ignore that bssid...

It's really just the same code though, so we'd have to have extra code
to filter if it has children, and perhaps if the client said it
understood beacon IEs or something like that ... doesn't seem worth it
to save an extra entry being sent to userspace in the (hopefully rare)
case of hidden SSID.
johannes
