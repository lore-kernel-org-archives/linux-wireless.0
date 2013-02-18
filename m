Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33777 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3BRTLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:11:48 -0500
Received: by mail-bk0-f46.google.com with SMTP id j5so2734168bkw.33
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 11:11:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361214203.8555.40.camel@jlt4.sipsolutions.net>
References: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com> <1361214203.8555.40.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 18 Feb 2013 11:11:26 -0800
Message-ID: <CAG6hwVPAAU-funSovS=3Lh1YddPpKa2xc1SS0bS3A-axqUt01w@mail.gmail.com> (sfid-20130218_201152_263547_AECE596E)
Subject: Re: [PATCH] mac80211: fix the problem of unicast forwarding from DS
 to DS in Mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, cedric.voncken@acksys.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 18, 2013 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-02-18 at 19:16 +0800, Chun-Yeow Yeoh wrote:
>> Unicast frame with unknown forwarding information always trigger
>> the path discovery assuming destination is always located inside the
>> MBSS. This patch allows the forwarding to look for mesh gate if path
>> discovery inside the MBSS has failed.
>>
>> Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  net/mac80211/tx.c |   15 ++++++++++++---
>>  1 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index 5b9602b..dce3af3 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -1844,9 +1844,18 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>>               }
>>
>>               if (!is_multicast_ether_addr(skb->data)) {
>> -                     mpath = mesh_path_lookup(sdata, skb->data);
>> -                     if (!mpath)
>> -                             mppath = mpp_path_lookup(sdata, skb->data);
>> +                     struct sta_info *next_hop;
>> +
>> +                     mpath = mesh_path_lookup(skb->data, sdata);
>> +                     if (mpath)
>> +                             next_hop = rcu_dereference(mpath->next_hop);
>> +
>> +                     if (!mpath || (mpath && (!next_hop ||
>> +                                     !(mpath->flags & MESH_PATH_ACTIVE))))
>> +                             mppath = mpp_path_lookup(skb->data, sdata);
>
> Heck, even the logic is wrong. Ok actually just weird -- if (!mpath || !
> next_hop || ...) would be totally sufficient.
>
>> +                     if (mppath && mpath)
>> +                             mesh_path_del(mpath->dst, mpath->sdata);
>
> You really delete paths because packets are transmitted along them?

I think he's deleting the mpath if an mppath was found (mpath is not
valid), but this cleanup will happen in the housekeeping work anyway,
so it's not needed here.

-- 
Thomas
