Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:43464 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaEVTbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 15:31:31 -0400
Received: by mail-qg0-f47.google.com with SMTP id j107so6457010qga.6
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 12:31:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140522192720.GA13440@localhost>
References: <3893194.GDQagdLGN9@desktop.local> <20140522192720.GA13440@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Thu, 22 May 2014 21:31:09 +0200
Message-ID: <CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com> (sfid-20140522_213134_553523_6B3773AC)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I first had planned to just throw them together... but it didn't
worked out and I assume that there is some time where you can have two
entries with the same destination, one of them a normal path
(request), the other one the mapped destination.

Henning Rogge

On Thu, May 22, 2014 at 9:27 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, May 22, 2014 at 05:06:21PM +0200, Henning Rogge wrote:
>> From: Henning Rogge <hrogge@gmail.com>
>>
>> This patch is a preparation for exporting the MPP data of the 802.11s
>> implementation via netlink to userspace. It unifies the content of the
>> mesh_paths and mpp_paths tables in mesh_pathtbl.c without changing
>> the behavior of the code.
>>
>> Signed-off-by: Henning Rogge <hrogge@gmail.com>
>
> I think I fall on the side of your earlier assessment that they
> hold different things and should stay in different tables, even though
> there are 200 lines of identical code here.  Maybe some bits could
> be shared without sharing the data and changing the API?
>
>> -static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
>> -                                   struct ieee80211_sub_if_data *sdata)
>> +/**
>> + * mesh_path_lookup - look up a path in the mesh path table
>> + * @sdata: local subif
>> + * @dst: hardware address (ETH_ALEN length) of destination
>> + * @is_proxied: true to lookup mpp entries, false otherwise
>
> Also, I don't like adding random boolean variables to water down what
> this function does.  It means when looking at the caller you have to go
> back to the definition to see just what is going on here.
>
> We do mpp_path_lookup exactly twice so it seems weird to have to
> change all of the mpath_lookup callers too.
>
> --
> Bob Copeland %% www.bobcopeland.com
