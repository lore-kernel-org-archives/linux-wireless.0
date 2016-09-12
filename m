Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56400 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754771AbcILGoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 02:44:03 -0400
Message-ID: <1473662637.4201.2.camel@sipsolutions.net> (sfid-20160912_084406_612768_6523DBBD)
Subject: Re: [PATCH] cfg80211: cap 20MHz VHT bitrate at MCS 8
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pedersen, Thomas" <twp@qca.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 12 Sep 2016 08:43:57 +0200
In-Reply-To: <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
References: <1473188417-13987-1-git-send-email-twp@qca.qualcomm.com>
         <2769a14e-964d-4ec2-9f04-ddd332434b78@candelatech.com>
         <38049c4f-da5b-a6ec-bcc4-c803197abcd7@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-07 at 18:20 +0000, Pedersen, Thomas wrote:
> On 09/06/2016 12:07 PM, Ben Greear wrote:
> > 
> > On 09/06/2016 12:00 PM, Thomas Pedersen wrote:
> > > 
> > > Some drivers (ath10k) report MCS 9 @ 20MHz, which
> > > technically isn't allowed. To get more meaningful value
> > > than 0 out of this however, just cap the bitrate for 20MHz
> > > to MCS 8.
> > 
> > If it is actually reporting MCS9, why lie about it?  Report it up
> > the stack as a proper value instead of hiding the issue?
> 
> Good point, will send a v2 extrapolating the value to 86.5Mb/s.

That makes no sense either, IMHO.

Are you saying that ath10k actually somehow manages to use an invalid
bitrate over the air?!

It seems more likely that it's actually just misreporting what it's
doing, and thus the issue should be fixed in ath10k.

johannes
