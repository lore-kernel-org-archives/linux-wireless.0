Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34099 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdFXRtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Jun 2017 13:49:55 -0400
Received: by mail-qk0-f182.google.com with SMTP id d78so21824034qkb.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jun 2017 10:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWe71xWAruWUurYeLV=+G=tagnSmohS3KG0m-M+G9eBjrG_Ow@mail.gmail.com>
References: <CABWe71xWAruWUurYeLV=+G=tagnSmohS3KG0m-M+G9eBjrG_Ow@mail.gmail.com>
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Sun, 25 Jun 2017 01:49:53 +0800
Message-ID: <CABWe71xq3h42Ho3iwA8yi-xfA5eu5r_gnOr03M9n2zLgoFTV6A@mail.gmail.com> (sfid-20170624_195010_512624_AD4C592E)
Subject: Re: mac80211: out of date seq number cause network stall
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found `head seq number` bigger than all seq num:

[ 3887.972639] ma80211 with out of date seq number: 1296 1297 1889
[ 3887.977134] ma80211 with out of date seq number: 1296 1298 1889
[ 3887.983082] ma80211 with out of date seq number: 1296 1299 1889
[ 3887.988929] ma80211 with out of date seq number: 1296 1300 1889
[ 3887.994861] ma80211 with out of date seq number: 1296 1301 1889
[ 3888.000764] ma80211 with out of date seq number: 1296 1302 1889
[ 3888.006638] ma80211 with out of date seq number: 1296 1303 1889
[ 3888.012576] ma80211 with out of date seq number: 1296 1304 1889

On Sun, Jun 25, 2017 at 1:21 AM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@gma=
il.com> wrote:
> Hi,
>
> I first find this bug in wds ath9k mode.
>
> When use iperf3, so many out of date seq number, in mac80211 function
> ieee80211_sta_manage_reorder_buf:
>
> [ 1248.968407] mac80211 with out of date seq number: 2551 2547 2552
> [ 1248.972972] mac80211 with out of date seq number: 2551 2548 2552
> [ 1248.978800] mac80211 with out of date seq number: 2551 2549 2552
> [ 1248.984760] mac80211 with out of date seq number: 2551 2550 2552
> [ 1248.990636] mac80211 with out of date seq number: 2551 2551 2552
>
>
> `previous seq number` `current seq number` `head seq num`.
>
>
> when `head seq number` - `current seq num` > 200 . Iperf3 will block.
