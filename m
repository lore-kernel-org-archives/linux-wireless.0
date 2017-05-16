Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55994 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdEPL4H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 07:56:07 -0400
Date: Tue, 16 May 2017 13:55:46 +0200
From: Bastian Bittorf <bb@npl.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        benjamin@sipsolutions.net
Subject: Re: [PATCH 0/7] extend mac80211 mesh DFS and CSA functionality
Message-ID: <20170516115546.GZ18518@medion.lan> (sfid-20170516_135617_020783_134A240E)
References: <20170516092316.15636-1-sw@simonwunderlich.de>
 <20170516094403.GX18518@medion.lan>
 <4020776.cO0ANP896r@prime>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4020776.cO0ANP896r@prime>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Simon Wunderlich <sw@simonwunderlich.de> [16.05.2017 12:24]:
>  * station A detects a Radar, and informs userspace
>  * userspace of station A will initiate a CSA, kernel will execute it (action 
> frame, beacons)
>  * station B picks up the CSA, and executes it as well
>  * station B also marks the channel as unavailable
>  * both station A and station B will send an event to userspace once the 
> channel switch is complete

ah, I remember the slides from last battlemesh.

The "problems" in userspace are: we must maintain a global list
(so each node) which channel is the next best and we must time
the final channel switch. IMHO the specs are saying, that we must
switch within 30 secs after detecting the first radar-pattern.
Also we must mark/show the new channel somehow for new/crashed/upcoming nodes.
quite hard...

bye, bastian
