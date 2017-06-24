Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:32961 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdFXRV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Jun 2017 13:21:27 -0400
Received: by mail-qt0-f169.google.com with SMTP id r30so6229522qtc.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jun 2017 10:21:27 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Sun, 25 Jun 2017 01:21:26 +0800
Message-ID: <CABWe71xWAruWUurYeLV=+G=tagnSmohS3KG0m-M+G9eBjrG_Ow@mail.gmail.com> (sfid-20170624_192132_495901_82945114)
Subject: mac80211: out of date seq number cause network stall
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I first find this bug in wds ath9k mode.

When use iperf3, so many out of date seq number, in mac80211 function
ieee80211_sta_manage_reorder_buf:

[ 1248.968407] mac80211 with out of date seq number: 2551 2547 2552
[ 1248.972972] mac80211 with out of date seq number: 2551 2548 2552
[ 1248.978800] mac80211 with out of date seq number: 2551 2549 2552
[ 1248.984760] mac80211 with out of date seq number: 2551 2550 2552
[ 1248.990636] mac80211 with out of date seq number: 2551 2551 2552


`previous seq number` `current seq number` `head seq num`.


when `head seq number` - `current seq num` > 200 . Iperf3 will block.
