Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60514 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaICMMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:12:40 -0400
Received: by mail-qg0-f53.google.com with SMTP id z107so8154709qgd.12
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 05:12:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409745133.911.7.camel@jlt4.sipsolutions.net>
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b> <1409745133.911.7.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 3 Sep 2014 14:12:19 +0200
Message-ID: <CAGnRvurXEzkekvYA2bLnObNMpxytH0G1tgXnF5c=90wBCoWmRA@mail.gmail.com> (sfid-20140903_141243_948711_F9E7C410)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2014 at 1:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-09-01 at 13:26 +0200, Henning Rogge wrote:
>> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
>> allows to query the content of the 'mesh proxy path' table of mac80211s via
>> 'get' or 'dump'  operation.
>
> For review and merging, and to make it more obvious to you as well when
> writing commit logs/documentation/etc I'd prefer if you'd split this up
> into separate cfg80211 and mac80211 patches.

Just to make sure I got the split right...

First patch to define the two new cfg80211_ops and the necessary
nl80211/tracing helper functions, second patch that implements
get_mpp() and dump_mpp() functions?

>> +     int     (*get_mpp)(struct wiphy *wiphy, struct net_device *dev,
>> +                          u8 *dst, u8 *mpp, struct mpath_info *pinfo);
>> +     int     (*dump_mpp)(struct wiphy *wiphy, struct net_device *dev,
>> +                           int idx, u8 *dst, u8 *mpp,
>> +                           struct mpath_info *pinfo);
>
> Should dst/mpp be const? Or are those output parameters?

Yes, similar to the get_mpath/dump_mpath cfg80211_ops these are output
parameters. Same thing for pinfo.

> Should it really be mpath_info? I thought this was some other thing?
> Probably just need more documentation :)

mpath and mpp use the same storage object (struct mesh_path), so I
reused the mpath_info struct. As far as I can see its just a "transfer
object" between for cfg80211 that temporarily stores data from the
cfg80211_ops for nl80211 messages.

Shall I create a new struct for the two new cfg80211_ops?

See
