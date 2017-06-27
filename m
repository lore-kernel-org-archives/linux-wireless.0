Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35676 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdF0IHG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 04:07:06 -0400
Received: by mail-qk0-f195.google.com with SMTP id 16so2997823qkg.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 01:07:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWe71ww6Yt8dt_nrzenACZrNx8ooCp9_Ss+pwvDK8sgKDBaKA@mail.gmail.com>
References: <CABWe71xWAruWUurYeLV=+G=tagnSmohS3KG0m-M+G9eBjrG_Ow@mail.gmail.com>
 <CABWe71xq3h42Ho3iwA8yi-xfA5eu5r_gnOr03M9n2zLgoFTV6A@mail.gmail.com> <CABWe71ww6Yt8dt_nrzenACZrNx8ooCp9_Ss+pwvDK8sgKDBaKA@mail.gmail.com>
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Tue, 27 Jun 2017 16:07:05 +0800
Message-ID: <CABWe71y4CWD+OQDk6mCyv4DawiQd4P3CrvWp7mweQ7peJgZ+1Q@mail.gmail.com> (sfid-20170627_100907_335939_D674BE0F)
Subject: Re: mac80211: out of date seq number cause network stall
To: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all,

When recieve block ack request ctrl packet. I catch some error packet
with ssn bigger than last recevice packet seq number. Then

ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
                                 start_seq_num, frames);

will update head_seq_num to a wrong number. Which cause packet loss.


So I think there should be a check start_seq_num should less than last
seq number.

Index: compat-wireless-2017-01-31/net/mac80211/rx.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- compat-wireless-2017-01-31.orig/net/mac80211/rx.c   2017-02-02
19:15:23.000000000 +0800
+++ compat-wireless-2017-01-31/net/mac80211/rx.c        2017-06-27
16:06:07.688053203 +0800
@@ -1040,6 +1040,8 @@
                goto out;
        }

+       tid_agg_rx->last_mpdu_seq_num =3D mpdu_seq_num;
+
        /*
         * If frame the sequence number exceeds our buffering window
         * size release some previous frames to make room for this one.
@@ -2642,6 +2644,8 @@
                                  TU_TO_EXP_TIME(tid_agg_rx->timeout));

                spin_lock(&tid_agg_rx->reorder_lock);
+               if(ieee80211_sn_less(tid_agg_rx->last_mpdu_seq_num,
start_seq_num))
+                       start_seq_num =3D
ieee80211_sn_inc(tid_agg_rx->last_mpdu_seq_num);
                /* release stored frames up to start of BAR */
                ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
                                                 start_seq_num, frames);
Index: compat-wireless-2017-01-31/net/mac80211/sta_info.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- compat-wireless-2017-01-31.orig/net/mac80211/sta_info.h
2017-06-19 20:36:19.945264458 +0800
+++ compat-wireless-2017-01-31/net/mac80211/sta_info.h  2017-06-27
15:53:57.610946298 +0800
@@ -207,6 +207,7 @@
        struct timer_list session_timer;
        struct timer_list reorder_timer;
        unsigned long last_rx;
+       u16 last_mpdu_seq_num;
        u16 head_seq_num;

On Sun, Jun 25, 2017 at 6:33 PM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@gma=
il.com> wrote:
> hi,
>
> In function `ieee80211_sta_manage_reorder_buf`:
>
> 1104         /* frame with out of date sequence number */
> 1105         if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
> 1106                 dev_kfree_skb(skb);
> 1107                 goto out;
> 1108         }
> 1109
>
> head_seq_num will out of oder, in ath9k wds mode.  But i can not find
> why will out of order.
>
> [ 1549.043719]  mac80211 mpdu_seq_num: 325  head_seq_num:326
> [ 1549.053979]  mac80211 mpdu_seq_num: 325  head_seq_num:1263
> [ 1549.072450]  mac80211 mpdu_seq_num: 326  head_seq_num:1263
>
> head_seq_num out of order. Then almost 1000 packet will drop. I have
> read function `ieee80211_sta_manage_reorder_buf` and add some debug
> info. I suppose this bug is not caused by this function.
>
> I grep all mac80211 code, and there's no code change  head_seq_num.
>
> Please help.
>
> On Sun, Jun 25, 2017 at 1:49 AM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@g=
mail.com> wrote:
>> Hi,
>>
>> I found `head seq number` bigger than all seq num:
>>
>> [ 3887.972639] ma80211 with out of date seq number: 1296 1297 1889
>> [ 3887.977134] ma80211 with out of date seq number: 1296 1298 1889
>> [ 3887.983082] ma80211 with out of date seq number: 1296 1299 1889
>> [ 3887.988929] ma80211 with out of date seq number: 1296 1300 1889
>> [ 3887.994861] ma80211 with out of date seq number: 1296 1301 1889
>> [ 3888.000764] ma80211 with out of date seq number: 1296 1302 1889
>> [ 3888.006638] ma80211 with out of date seq number: 1296 1303 1889
>> [ 3888.012576] ma80211 with out of date seq number: 1296 1304 1889
>>
>> On Sun, Jun 25, 2017 at 1:21 AM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@=
gmail.com> wrote:
>>> Hi,
>>>
>>> I first find this bug in wds ath9k mode.
>>>
>>> When use iperf3, so many out of date seq number, in mac80211 function
>>> ieee80211_sta_manage_reorder_buf:
>>>
>>> [ 1248.968407] mac80211 with out of date seq number: 2551 2547 2552
>>> [ 1248.972972] mac80211 with out of date seq number: 2551 2548 2552
>>> [ 1248.978800] mac80211 with out of date seq number: 2551 2549 2552
>>> [ 1248.984760] mac80211 with out of date seq number: 2551 2550 2552
>>> [ 1248.990636] mac80211 with out of date seq number: 2551 2551 2552
>>>
>>>
>>> `previous seq number` `current seq number` `head seq num`.
>>>
>>>
>>> when `head seq number` - `current seq num` > 200 . Iperf3 will block.
