Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22625 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0IOSbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 14:31:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 11:31:12 -0700
Date: Wed, 15 Sep 2010 11:31:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Matt Smith <Matt.Smith@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@Atheros.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] ath9k / mac80211: power save fixes
Message-ID: <20100915183116.GB1678@tux>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTinNA9Xb-bq17V_PcyLujaJM-mOWimvQzWMRKpk6@mail.gmail.com>
 <10161E8E-4F96-4B3B-B5D3-27DF9236BF83@Atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <10161E8E-4F96-4B3B-B5D3-27DF9236BF83@Atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taking this thread public for further review and comments.

On Wed, Sep 15, 2010 at 06:33:19AM -0700, Matt Smith wrote:
> Luis,
> 
> Not sure what is meant by "block them".... Are you saying should we
> pause the reordering buffer timeout? 

Yes, that or we simply cancel our existing BAs and reject future
ones until we get back to the home channel. I wonder what is easier
and less bug prone.

> I think we should, as there could be some holes in the
> reordering buffer and it's not fair to time them out and drop
> the packet if we go off-channel.

This was what I was thinking, just was not sure what approach
would be more suitable, either to pause the timers for reorderign
or simply stopping BAs completely until we come back to the
home channel.

> That said, most scans will wait until the medium is idle (~ 200ms),
> so we shouldn't have any holes in the reordering buffer at that time.

In mac80211 right now we do not wait until the medium is idle.
We were reviewing what we should do at the wireless summit in San Francisco
last week. Sam Leffler noted he thought it would be good we simply
defer going offchannel until the medium is idle but my concern is
if we have a constant stream of data, how long would we defer scanning,
and what decision do we use to start scan despite a data stream being
transmitted. There was also some suggestion of using a force scan request
which would not wait for the medium to be idle, this would be more
instrusive.

I do not believe we had any consenus on the approach we should take,
unless others were able to pick something up that I did not. So I'd like
to take the opprortunity now that you mentioned it to talk about it with
you as well. Any recommendations for best strategy for this?

I should note what we end up deciding for both aggregation and scan logic
would also affect how we deal with WiFi direct offchannel operation (ah,
we can talk about WiFi Direct publicly now :))

  Luis

> Matt
> 
> On Sep 14, 2010, at 5:09 PM, Luis R. Rodriguez wrote:
> 
> > Matt,
> > 
> > mac80211 uses a queue to stuff MPDUs from an AMPDUs since we can
> > receive them out of order. We have a timer on these and nuke 'em after
> > it expires. When we're associated and we hit a scan trigger due to
> > RSSI or a desire to go offchannel (WiFi Direct), what do you recommend
> > we do when we go off channel? Should we stop all aggregation sessions
> > and block them until back on our home channel?
> > 
> >  Luis
> > 
> > ---------- Forwarded message ----------
> > From: Luis R. Rodriguez <lrodriguez@atheros.com>
> > Date: Tue, Sep 14, 2010 at 4:40 PM
> > Subject: [PATCH v3 00/11] ath9k / mac80211: power save fixes
> > To: linville@tuxdriver.com
> > Cc: linux-wireless@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
> > 
> > 
> > I reordered the patches, enhanced the commit log entries and
> > and added a new patch to address ANI / the TX monitor, figured I'd just
> > send a new series just to be clear.
> > 
> > My next peet peeve is this:
> > 
> > Sep 14 16:36:02 tux kernel: [ 1369.000106] ath: Set channel: 5220 MHz
> > Sep 14 16:36:02 tux kernel: [ 1369.000116] ath: tx chmask: 3, rx chmask: 3
> > Sep 14 16:36:02 tux kernel: [ 1369.000240] ath: (2412 MHz) -> (5220
> > MHz), conf_is_ht40: 0
> > Sep 14 16:36:02 tux kernel: [ 1369.063449] ath: Set channel: 2412 MHz
> > Sep 14 16:36:03 tux kernel: [ 1369.063459] ath: tx chmask: 3, rx chmask: 3
> > Sep 14 16:36:03 tux kernel: [ 1369.063584] ath: (5220 MHz) -> (2412
> > MHz), conf_is_ht40: 0
> > Sep 14 16:36:03 tux kernel: [ 1369.360111] ath: Set channel: 5240 MHz
> > Sep 14 16:36:03 tux kernel: [ 1369.360120] ath: tx chmask: 3, rx chmask: 3
> > Sep 14 16:36:03 tux kernel: [ 1369.360245] ath: (2412 MHz) -> (5240
> > MHz), conf_is_ht40: 0
> > Sep 14 16:36:03 tux kernel: [ 1369.422736] ath: Set channel: 2412 MHz
> > Sep 14 16:36:03 tux kernel: [ 1369.422745] ath: tx chmask: 3, rx chmask: 3
> > Sep 14 16:36:03 tux kernel: [ 1369.422867] ath: (5240 MHz) -> (2412
> > MHz), conf_is_ht40: 0
> > Sep 14 16:36:03 tux kernel: [ 1369.564685] __ratelimit: 81 callbacks suppressed
> > Sep 14 16:36:03 tux kernel: [ 1369.564692] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564698] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564703] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564708] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564713] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564718] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564723] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564728] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564733] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.564738] phy0: release an RX reorder
> > frame due to timeout on earlier frames
> > Sep 14 16:36:03 tux kernel: [ 1369.720129] ath: Set channel: 5260 MHz
> > Sep 14 16:36:03 tux kernel: [ 1369.720139] ath: tx chmask: 3, rx chmask: 3
> > Sep 14 16:36:03 tux kernel: [ 1369.720263] ath: (2412 MHz) -> (5260
> > MHz), conf_is_ht40: 0
> > 
> > My guess is we are not suspending / stopping the aggregations sessions /
> > or simply extending the timer when going off channel.
> > 
> > Luis R. Rodriguez (10):
> >  ath9k: fix power save race conditions
> >  ath9k: fix regression on beacon loss after bgscan
> >  ath9k: fix enabling ANI / tx monitor after bg scan
> >  mac80211: add helper for reseting the connection monitor
> >  mac80211: reset probe send counter upon connection timer reset
> >  mac80211: reset connection idle when going offchannel
> >  mac80211: make the beacon monitor available externally
> >  mac80211: disable beacon monitor while going offchannel
> >  mac80211: send last 3/5 probe requests as unicast
> >  ath9k: fix regression which disabled ps on ath9k
> > 
> > Senthil Balasubramanian (1):
> >  ath9k: fix regression which prevents chip sleep after CAB data
> > 
> >  drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
> >  drivers/net/wireless/ath/ath9k/init.c  |    3 +-
> >  drivers/net/wireless/ath/ath9k/main.c  |   15 ++++++-----
> >  drivers/net/wireless/ath/ath9k/recv.c  |    9 ++++--
> >  net/mac80211/ieee80211_i.h             |    2 +
> >  net/mac80211/mlme.c                    |   40 +++++++++++++++++++++++--------
> >  net/mac80211/offchannel.c              |    7 +++++
> >  7 files changed, 54 insertions(+), 23 deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
