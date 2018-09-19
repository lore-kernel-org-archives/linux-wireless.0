Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:60354 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbeITCPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 22:15:23 -0400
Message-ID: <1537389335.10305.92.camel@sipsolutions.net> (sfid-20180919_223550_345465_9AF09A96)
Subject: Re: Problem with sending pkt on a monitor port
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Sep 2018 22:35:35 +0200
In-Reply-To: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com> (sfid-20180919_223316_460674_F032A088)
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
         (sfid-20180919_223316_460674_F032A088)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 13:33 -0700, Ben Greear wrote:
> This is with a modified 4.16.18+ kernel, though the code in question
> is from 2011, so this is not new...
> 
> I am attempting to use radiotap packet injection on a monitor port.
> 
> In the ieee80211_monitor_start_xmit method, before this code below
> runs, sdata is 'moni6a', my monitor port.  But, since I have a
> station wlan1 with the same MAC address, then when this code is
> completed, stdata becomes wlan1.
> 
> Ath10k has all sorts of issues transmitting raw frames, and sending on
> the wrong vdev only makes it even more broken!
> 
> If user-space binds a socket to a monitor vdev and transmits a frame,
> why would we want to change the vdev here?

For one, the driver has no concept of the original vif, since monitor
vifs aren't added to it.

Secondly, the old hostapd code before nl80211 injects frames that way,
and they need to go there.

johannes
