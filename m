Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41693 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753781AbcJLHoM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 03:44:12 -0400
Message-ID: <1476256604.5271.5.camel@sipsolutions.net> (sfid-20161012_094435_845609_34556089)
Subject: Re: [PATCHv3 2/3] mac80211: check A-MSDU inner frame source address
 on AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Date: Wed, 12 Oct 2016 09:16:44 +0200
In-Reply-To: <1475493257-21841-2-git-send-email-michael-dev@fami-braun.de> (sfid-20161003_131433_693019_40C59037)
References: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
         <1475493257-21841-2-git-send-email-michael-dev@fami-braun.de>
         (sfid-20161003_131433_693019_40C59037)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-03 at 13:14 +0200, Michael Braun wrote:
> When using WPA security, the station and thus the required key is
> identified by its mac address when packets are received. So a
> station usually cannot spoof its source mac address.
> 
> But when a station sends an A-MSDU frame, port control and crypto
> is done using the outer mac address, while the packets delivered
> and forwarded use the inner mac address.
> This might affect ARP/IP filtering on the AccessPoint.
> 
> IEEE 802.11-2012 mandates that the outer source mac address should
> match the inner source address (section 8.3.2.2). For the destination
> mac address, matching is not required, as a wifi client may send all
> its traffic to the AP in order to have it forwarded.

This doesn't apply over my series now, so I'm dropping it - I have the
bare minimum mwifiex changes to let it compile, but no additional
checks.

Marvell folks: take note, you'll want to have these checks in your
driver, so need to pass the right check_da/check_sa arguments
(depending on the interface type) to the function. See

https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=002a02b6d1be6aba55c7391a030c0358fada81c5

johannes
