Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41142 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754240AbeEOPuv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 11:50:51 -0400
Message-ID: <1526399448.4450.10.camel@sipsolutions.net> (sfid-20180515_175119_204556_FB69AE54)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
Date: Tue, 15 May 2018 17:50:48 +0200
In-Reply-To: <20180515102202.2021-1-alexander.wetzel@web.de>
References: <1523258757.3076.5.camel@sipsolutions.net>
         <20180515102202.2021-1-alexander.wetzel@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-15 at 12:22 +0200, Alexander Wetzel wrote:
> 
> Both issues can be prevented by first replacing the key in the HW and
> makeing sure no aggregation sessions are running during the rekey.

I don't think you can do this - just tear down all aggregation sessions
- there are APs out there that will not re-establish them if you tear
them down, or only attempt a given number of times, etc. This will cause
interoperability problems.

OTOH, arguably we have worse interoperability problems today, and anyone
who configures PTK rekeying is deluded that it'll work properly, so
maybe that's not _that_ bad. Hmm.

johannes
