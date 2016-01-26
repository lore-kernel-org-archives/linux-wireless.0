Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:33731 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbcAZTFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 14:05:11 -0500
Received: by mail-lb0-f195.google.com with SMTP id bc4so8706384lbc.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 11:05:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160126183628.GA30183@localhost>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453808485.2759.32.camel@sipsolutions.net> <20160126183628.GA30183@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 26 Jan 2016 20:04:40 +0100
Message-ID: <CAGnRvup8YSZ88RUMc8_18XwGCTNSwZT5g=uDrwNBDAZQBLWGNA@mail.gmail.com> (sfid-20160126_200515_618529_39C04E28)
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with MPath
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 7:36 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Jan 26, 2016 at 12:41:25PM +0100, Johannes Berg wrote:
>> > +           mpp = node->mpath;
>> > +           if (ether_addr_equal(mpp->mpp, proxy)) {
>> > +                   spin_lock(&tbl->hashwlock[i]);
>> > +                   __mesh_path_del(tbl, node);
>> > +                   spin_unlock(&tbl->hashwlock[i]);
>>
>> It also doesn't seem like for_each_mesh_entry() can deal with "node"
>> getting deleted from underneath it? It accesses it through
>> hlist_next_rcu() after the deletion, so you have a use-after-free here
>> afaict.
>
> But __mesh_path_del() doesn't free it immediately: it does:
>
>         hlist_del_rcu(&node->list);
>         call_rcu(&node->rcu, mesh_path_node_reclaim);
>
> ...so this should be ok if in an rcu read-side critical section, right?

The code is a direct copy what was going on the the cleanup path of
the mpath objects... just modified to run on the mpp objects.

Henning
