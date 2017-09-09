Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35746 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdIIB2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 21:28:46 -0400
Received: by mail-io0-f196.google.com with SMTP id d16so23593ioj.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 18:28:46 -0700 (PDT)
MIME-Version: 1.0
From: "dztemplor ." <zdu.shanghai@gmail.com>
Date: Sat, 9 Sep 2017 09:28:45 +0800
Message-ID: <CABBOhL4UjgKHk_HBHr+rD_5CSqbXNX-52AQydKPBG1-KqeTOtw@mail.gmail.com> (sfid-20170909_032922_517215_C8357828)
Subject: synchronization question about sdata->skb_queue
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, everyone.
I'm a newbie in mac80211 and have a question about synchronization for
sdata->skb_queue.
sdata->skb_queue is shared between ieee80211_iface_work() and  rx
handlers like ieee80211_rx_h_action()
ieee80211_iface_work() runs in process context.
ieee80211_rx_h_action() runs in softirq context.
why there is no spin_lock_bh() in ieee80211_iface_work() when it
dequeues from sdata->skb_queue?
I know the question may sounds stupid, will appreciate if anyone can
explain to me.

Regards,
Spike.
