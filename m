Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33490 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcAZTzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 14:55:02 -0500
Received: by mail-lf0-f68.google.com with SMTP id z62so10127463lfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 11:55:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453808681.2759.35.camel@sipsolutions.net>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de> <1453808681.2759.35.camel@sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 26 Jan 2016 20:54:31 +0100
Message-ID: <CAGnRvuqSrQLSYhY7x16iwQk_Rnrs4+2Pu9VeofymHExdYpyTgg@mail.gmail.com> (sfid-20160126_205506_576704_2C200B2C)
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 12:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2016-01-19 at 09:04 +0100, Henning Rogge wrote:
>
>> +++ b/net/mac80211/mesh_pathtbl.c
>> @@ -929,12 +929,55 @@ int mesh_path_del(struct ieee80211_sub_if_data
>> *sdata, const u8 *addr)
>>               if (mpath->sdata == sdata &&
>>                   ether_addr_equal(addr, mpath->dst)) {
>>                       __mesh_path_del(tbl, node);
>> -                     goto enddel;
>> +                     goto enddelpath;
>
> C labels are scoped, why rename it?

I think I had a warning with the two labels the same... might be an IDE mistake.

>>               }
>>       }
>>
>>       err = -ENXIO;
>> -enddel:
>> +enddelpath:
>> +     mesh_paths_generation++;
>> +     spin_unlock(&tbl->hashwlock[hash_idx]);
>> +     read_unlock_bh(&pathtbl_resize_lock);
>> +     return err;
>> +}
>> +
>> +/**
>> + * mpp_path_del - delete a mesh proxy path from the table
>> + *
>> + * @addr: addr address (ETH_ALEN length)
>> + * @sdata: local subif
>> + *
>> + * Returns: 0 if successful
>> + */
>> +static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const
>> u8 *addr)
>> +{
>> +     struct mesh_table *tbl;
>> +     struct mesh_path *mpath;
>> +     struct mpath_node *node;
>> +     struct hlist_head *bucket;
>> +     int hash_idx;
>> +     int err = 0;
>> +
>> +     /* flush relevant mpp entries first */
>> +     mpp_flush_by_proxy(sdata, addr);
>> +
>> +     read_lock_bh(&pathtbl_resize_lock);
>> +     tbl = resize_dereference_mpp_paths();
>> +     hash_idx = mesh_table_hash(addr, sdata, tbl);
>> +     bucket = &tbl->hash_buckets[hash_idx];
>> +
>> +     spin_lock(&tbl->hashwlock[hash_idx]);
>> +     hlist_for_each_entry(node, bucket, list) {
>> +             mpath = node->mpath;
>> +             if (mpath->sdata == sdata &&
>> +                 ether_addr_equal(addr, mpath->dst)) {
>> +                     __mesh_path_del(tbl, node);
>> +                     goto enddelmpp;
>
> This has the same use-after-free, I'd say?
> And another instance later in this file.
>
>
>> +                                     spin_lock_bh(&mppath-
>> >state_lock);
>> +                                     mppath->exp_time = jiffies;
>
> That locking seems fairly pointless? You only write to this value here,
> and it's an unsigned long, so in itself it's atomic and there's no
> synchronisation against anything else needed.

Most likely you are right... kernel locking is an arcane knowledge and
I am still looking for a good way to get initiated into it.

Henning
