Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32814 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbaICMZo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:25:44 -0400
Message-ID: <1409747141.911.15.camel@jlt4.sipsolutions.net> (sfid-20140903_142603_764346_38603C28)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Wed, 03 Sep 2014 14:25:41 +0200
In-Reply-To: <CAGnRvurXEzkekvYA2bLnObNMpxytH0G1tgXnF5c=90wBCoWmRA@mail.gmail.com> (sfid-20140903_141241_269308_AA781655)
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b>
	 <1409745133.911.7.camel@jlt4.sipsolutions.net>
	 <CAGnRvurXEzkekvYA2bLnObNMpxytH0G1tgXnF5c=90wBCoWmRA@mail.gmail.com>
	 (sfid-20140903_141241_269308_AA781655)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-03 at 14:12 +0200, Henning Rogge wrote:
> On Wed, Sep 3, 2014 at 1:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2014-09-01 at 13:26 +0200, Henning Rogge wrote:
> >> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
> >> allows to query the content of the 'mesh proxy path' table of mac80211s via
> >> 'get' or 'dump'  operation.
> >
> > For review and merging, and to make it more obvious to you as well when
> > writing commit logs/documentation/etc I'd prefer if you'd split this up
> > into separate cfg80211 and mac80211 patches.
> 
> Just to make sure I got the split right...
> 
> First patch to define the two new cfg80211_ops and the necessary
> nl80211/tracing helper functions, second patch that implements
> get_mpp() and dump_mpp() functions?

Right. That way you have one patch that defines the API etc., and
another that implements it, and it's easier to review and document the
APIs in the right places etc.

I don't always insist on this, but it's a pretty big patch so I'd prefer
it this way (and it also should be almost trivial to split)

> >> +     int     (*get_mpp)(struct wiphy *wiphy, struct net_device *dev,
> >> +                          u8 *dst, u8 *mpp, struct mpath_info *pinfo);
> >> +     int     (*dump_mpp)(struct wiphy *wiphy, struct net_device *dev,
> >> +                           int idx, u8 *dst, u8 *mpp,
> >> +                           struct mpath_info *pinfo);
> >
> > Should dst/mpp be const? Or are those output parameters?
> 
> Yes, similar to the get_mpath/dump_mpath cfg80211_ops these are output
> parameters. Same thing for pinfo.

Yeah I figured pinfo was, wasn't sure about the others :)

> > Should it really be mpath_info? I thought this was some other thing?
> > Probably just need more documentation :)
> 
> mpath and mpp use the same storage object (struct mesh_path), so I
> reused the mpath_info struct. As far as I can see its just a "transfer
> object" between for cfg80211 that temporarily stores data from the
> cfg80211_ops for nl80211 messages.

Indeed, it is.

> Shall I create a new struct for the two new cfg80211_ops?

No need, I just wasn't sure it really needed the same data so figured
I'd ask.

> See

I guess you got cut off there :)

johannes

