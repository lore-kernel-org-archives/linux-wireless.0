Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48550 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753515AbdIDNTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 09:19:36 -0400
Message-ID: <1504531173.27801.0.camel@sipsolutions.net> (sfid-20170904_151939_808944_368D7918)
Subject: Re: Incorrect mesh path seq num
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@eero.com>, Greg Maitz <ghh19622@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Sep 2017 15:19:33 +0200
In-Reply-To: <CADjYELxyuT74Ms30Ohu_a6Ymg6RLctf6mehRmw-poLgLMZWiwQ@mail.gmail.com> (sfid-20170901_220755_362447_35ACB724)
References: <CAG5S3ZTRe52qSWt6WEe6K78brrQqc7+HgN_8OQ+RKC9k1WUMCw@mail.gmail.com>
         <CADjYELxyuT74Ms30Ohu_a6Ymg6RLctf6mehRmw-poLgLMZWiwQ@mail.gmail.com>
         (sfid-20170901_220755_362447_35ACB724)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-01 at 13:07 -0700, Thomas Pedersen wrote:
> On Thu, Aug 31, 2017 at 11:30 PM, Greg Maitz <ghh19622@gmail.com>
> wrote:
> > Hi guys,
> > 
> > I'm seeing a problem when I work on the wireless mesh between two
> > linux devices. The root node has 3.18 kernel while the next hop
> > station runs 2.6.37 kernel. I found the mpath->sn value is
> > incorrect
> > most of the time on the device having 2.6.37 kernel. After
> > examining
> > the code, in function hwmp_route_info_get [mesh_hwmp.c], after
> > mesh_path_lookup, the sequence number (i.e, mpath->sn) is
> > incorrect.
> > For instance, I see mpath->sn having value 0x30950000. It should be
> > 0x9530, while the orig_sn is having value 0x9531.
> 
> Looks like an endianess bug. Are you testing on two platforms of
> different endianess?

Even if that's the case, wouldn't it mean some kind of conversion is
missing somewhere?

johannes
