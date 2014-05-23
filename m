Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35602 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWJIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:08:20 -0400
Received: by mail-ve0-f176.google.com with SMTP id jz11so5894318veb.35
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 02:08:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com>
References: <3893194.GDQagdLGN9@desktop.local>
	<20140522192720.GA13440@localhost>
	<CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com>
Date: Fri, 23 May 2014 17:08:19 +0800
Message-ID: <CAEFj9850c9aD5gKz2B-e=hPnS2vNdY+a4uc9D_+psryE0ywDVA@mail.gmail.com> (sfid-20140523_110832_062906_C8334DEA)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ya, there is a possibility that a mesh node is leaving its MBSS and
joining another new MBSS just behind its original MBSS or vice versa.

By the way, I just wondering whether it would be much faster in path
resolving towards destination behind MBSS if we keep two tables
separately. In typical case, assuming with one or two mesh gates
providing the internet connectivity, we will have large mesh path
table but smaller mpp path table.

---
Chun-Yeow

On Fri, May 23, 2014 at 3:31 AM, Henning Rogge <hrogge@gmail.com> wrote:
> I first had planned to just throw them together... but it didn't
> worked out and I assume that there is some time where you can have two
> entries with the same destination, one of them a normal path
> (request), the other one the mapped destination.
>
> Henning Rogge
>
> On Thu, May 22, 2014 at 9:27 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Thu, May 22, 2014 at 05:06:21PM +0200, Henning Rogge wrote:
>>> From: Henning Rogge <hrogge@gmail.com>
>>>
>>> This patch is a preparation for exporting the MPP data of the 802.11s
>>> implementation via netlink to userspace. It unifies the content of the
>>> mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
>>> the behavior of the code.
>>>
>>> Signed-off-by: Henning Rogge <hrogge@gmail.com>
>>
>> I think I fall on the side of your earlier assessment that they
>> hold different things and should stay in different tables, even though
>> there are 200 lines of identical code here.  Maybe some bits could
>> be shared without sharing the data and changing the API?
>>
>>> -static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
>>> -                                   struct ieee80211_sub_if_data *sdata)
>>> +/**
>>> + * mesh_path_lookup - look up a path in the mesh path table
>>> + * @sdata: local subif
>>> + * @dst: hardware address (ETH_ALEN length) of destination
>>> + * @is_proxied: true to lookup mpp entries, false otherwise
>>
>> Also, I don't like adding random boolean variables to water down what
>> this function does.  It means when looking at the caller you have to go
>> back to the definition to see just what is going on here.
>>
>> We do mpp_path_lookup exactly twice so it seems weird to have to
>> change all of the mpath_lookup callers too.
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
