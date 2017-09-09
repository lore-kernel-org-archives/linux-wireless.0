Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:37676 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdIIBfn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 21:35:43 -0400
Received: by mail-it0-f65.google.com with SMTP id d6so1848813itc.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 18:35:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABBOhL4UjgKHk_HBHr+rD_5CSqbXNX-52AQydKPBG1-KqeTOtw@mail.gmail.com>
References: <CABBOhL4UjgKHk_HBHr+rD_5CSqbXNX-52AQydKPBG1-KqeTOtw@mail.gmail.com>
From: "dztemplor ." <zdu.shanghai@gmail.com>
Date: Sat, 9 Sep 2017 09:35:41 +0800
Message-ID: <CABBOhL5PnALrDbEKRzZ2YiRvZCfn-yuSdw+G=r4kXS-fVTaBsA@mail.gmail.com> (sfid-20170909_033547_212110_26D4A1E0)
Subject: Re: synchronization question about sdata->skb_queue
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sorry, just realized skb_dequeue() will call spin_lock_irqsave() inside.
please ignore this question.

On Sat, Sep 9, 2017 at 9:28 AM, dztemplor . <zdu.shanghai@gmail.com> wrote:
> Hi, everyone.
> I'm a newbie in mac80211 and have a question about synchronization for
> sdata->skb_queue.
> sdata->skb_queue is shared between ieee80211_iface_work() and  rx
> handlers like ieee80211_rx_h_action()
> ieee80211_iface_work() runs in process context.
> ieee80211_rx_h_action() runs in softirq context.
> why there is no spin_lock_bh() in ieee80211_iface_work() when it
> dequeues from sdata->skb_queue?
> I know the question may sounds stupid, will appreciate if anyone can
> explain to me.
>
> Regards,
> Spike.
