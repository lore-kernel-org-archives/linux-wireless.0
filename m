Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:33054 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdCSCQQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 22:16:16 -0400
Received: by mail-qt0-f176.google.com with SMTP id i34so87012061qtc.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Mar 2017 19:16:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1489659530.2370.10.camel@sipsolutions.net>
References: <58B09082.7020704@cococorp.com> <1489659530.2370.10.camel@sipsolutions.net>
From: Alexis Green <agreen@uniumwifi.com>
Date: Sat, 18 Mar 2017 18:48:41 -0700
Message-ID: <CAAnMG+MFTe7yU8RGmmGqUvS+TV5Mmm4u8XwJAG+g+WmQt5dj+A@mail.gmail.com> (sfid-20170319_031632_276471_8B585087)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Thank you for the comments, I'll see if I can apply all of your
suggestions and resubmit.

Alexis

On Thu, Mar 16, 2017 at 3:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Sorry - this is the other half of my reply that I accidentally deleted
> before sending...
>
>> +static void flush_tx_skbs(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> +     struct mesh_tx_queue *tx_node;
>> +
>> +     spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
>> +
>> +     /* Note that this check is important because of the two-
>> stage
>> +      * way that ieee80211_if_mesh is initialized.
>> +      */
>
> I think you should fix that rather than work around it. If this is
> called with iftype != mesh then this is super problematic anyway, since
> ifmsh->tx_queue_len would alias some other variable (there's a union).
>
>> +     if (ifmsh->tx_queue_len > 0) {
>> +             mhwmp_dbg(sdata, "flushing %d skbs", ifmsh-
>> >tx_queue_len);
>> +
>> +             while (!list_empty(&ifmsh->tx_queue.list)) {
>> +                     tx_node = list_last_entry(&ifmsh-
>> >tx_queue.list,
>> +                                               struct
>> mesh_tx_queue, list);
>> +                     kfree_skb(tx_node->skb);
>> +                     list_del(&tx_node->list);
>> +                     kfree(tx_node);
>> +             }
>> +             ifmsh->tx_queue_len = 0;
>> +     }
>> +
>> +     spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
>> +}
>
> All of this also gets *vastly* simpler if it's just skb_queue_purge()
> :)
>
>> +     spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
>> +
>> +     list_for_each_entry(tx_node, &ifmsh->tx_queue.list, list) {
>> +             ieee80211_tx_skb(sdata, tx_node->skb);
>> +     }
>
> I don't think you should hold the lock across _tx_skb(), ISTR problems
> with that - particularly with the STA lock, so this might be OK, but it
> might also cause lock ordering issues. It's easy to avoid anyway, so
> better not to do it.
>
> johannes
