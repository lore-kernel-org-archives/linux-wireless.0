Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbeC1Iuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 04:50:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 14:20:34 +0530
From: vthiagar@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with peer
 MAC address
In-Reply-To: <1522224360.4222.3.camel@sipsolutions.net>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
 <1522154870.3050.2.camel@sipsolutions.net>
 <bf1c7f4dc442e0e2807b520fe94d7ca2@codeaurora.org>
 <1522224360.4222.3.camel@sipsolutions.net>
Message-ID: <7031cf9c458fd53091e74dec2ee83d82@codeaurora.org> (sfid-20180328_105041_763644_542DD801)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-28 13:36, Johannes Berg wrote:
> On Wed, 2018-03-28 at 10:24 +0530, vthiagar@codeaurora.org wrote:
> 
>> > The question is how that interacts with having enough space - are you
>> > sure this is a concern?
>> 
>> This will not be an issue at lest for ath10k. This is mainly for a
>> (new)driver
>> which implements the offload but has limitation in supporting more 
>> than
>> certain
>> number of peers. Perhaps we can remove it now and add it when such
>> driver is
>> available?
> 
> Ok, that's good. Yes, I think that sounds better - I have a hard time
> imagining a firmware/driver that has space for the station, but doesn't
> automatically allocate a u16 bitmap as part of the station :-)
> 
>> > >   * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs
>> > > whether
>> > > - *      No Acknowledgement Policy should be applied.
>> > > + *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is
>> > > used
>> > > + *	to apply No Acknowledgement policy for a particular connected
>> > > station.
>> > > + *	Station specific NoAck policy configuration is valid only for
>> > > STA's
>> > > + *	current connection, i.e. the configuration will not be used when
>> > > the
>> > > + *	station connects back after disconnection/roaming.
>> > > + *	When user-space does not include %NL80211_ATTR_MAC, the No
>> > > + *	Acknowledgement Policy setting should be treated as per-netdev
>> > > + *	configuration.
>> >
>> > Here you describe different semantics - i.e. you didn't describe the
>> > "previous per-station settings are kept" part. I'm not sure that part
>> > makes much sense anyhow?
>> 
>> Not sure I got this comment right. As mentioned in the doc, the 
>> previous
>> settings
>> would be reset upon reconnection of the station and any ndev wide
>> configuration
>> will be used. As mentioned above, additionally default value will be 
>> set
>> to the
>> station to mark no per-station configuration is given so far.
> 
> I just thought that there was a difference in how this applies to a
> certain station.

May be the doc needs more update

> 
> Btw, we should probably also have a way to *delete* the per-station
> configuration, so it uses the default again?

Sure. How about setting it to default when the command is received with 
no
NL80211_ATTR_NOACK_MAP attribute for a station?

Vasanth
