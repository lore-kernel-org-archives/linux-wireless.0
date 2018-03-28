Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46360 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbeC1IGD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 04:06:03 -0400
Message-ID: <1522224360.4222.3.camel@sipsolutions.net> (sfid-20180328_100610_053235_30DE2B06)
Subject: Re: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with
 peer MAC address
From: Johannes Berg <johannes@sipsolutions.net>
To: vthiagar@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Wed, 28 Mar 2018 10:06:00 +0200
In-Reply-To: <bf1c7f4dc442e0e2807b520fe94d7ca2@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
         <1522154870.3050.2.camel@sipsolutions.net>
         <bf1c7f4dc442e0e2807b520fe94d7ca2@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 10:24 +0530, vthiagar@codeaurora.org wrote:

> > The question is how that interacts with having enough space - are you
> > sure this is a concern?
> 
> This will not be an issue at lest for ath10k. This is mainly for a 
> (new)driver
> which implements the offload but has limitation in supporting more than 
> certain
> number of peers. Perhaps we can remove it now and add it when such 
> driver is
> available?

Ok, that's good. Yes, I think that sounds better - I have a hard time
imagining a firmware/driver that has space for the station, but doesn't
automatically allocate a u16 bitmap as part of the station :-)

> > >   * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs 
> > > whether
> > > - *      No Acknowledgement Policy should be applied.
> > > + *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is 
> > > used
> > > + *	to apply No Acknowledgement policy for a particular connected 
> > > station.
> > > + *	Station specific NoAck policy configuration is valid only for 
> > > STA's
> > > + *	current connection, i.e. the configuration will not be used when 
> > > the
> > > + *	station connects back after disconnection/roaming.
> > > + *	When user-space does not include %NL80211_ATTR_MAC, the No
> > > + *	Acknowledgement Policy setting should be treated as per-netdev
> > > + *	configuration.
> > 
> > Here you describe different semantics - i.e. you didn't describe the
> > "previous per-station settings are kept" part. I'm not sure that part
> > makes much sense anyhow?
> 
> Not sure I got this comment right. As mentioned in the doc, the previous 
> settings
> would be reset upon reconnection of the station and any ndev wide 
> configuration
> will be used. As mentioned above, additionally default value will be set 
> to the
> station to mark no per-station configuration is given so far.

I just thought that there was a difference in how this applies to a
certain station.

Btw, we should probably also have a way to *delete* the per-station
configuration, so it uses the default again?

johannes
