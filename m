Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34210 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdHBF5k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 01:57:40 -0400
Received: by mail-qt0-f194.google.com with SMTP id i19so3714442qte.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 22:57:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801110449.5pddqqml32qqlvrn@mwanda>
References: <20170801110449.5pddqqml32qqlvrn@mwanda>
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Date: Wed, 2 Aug 2017 11:27:39 +0530
Message-ID: <CAC_mnDmNtiobgxuDENjh2kkc_TfMxg2Msc0jpJrSYKe5GrH0oQ@mail.gmail.com> (sfid-20170802_075744_133735_BD2E363A)
Subject: Re: [bug report] rsi: immediate wakeup bit and priority for TX
 command packets
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Sorry for the mistake. I will send a new patch to fix this issue and
make sure no such things happen again.

Thanks,
Prameela

On Tue, Aug 1, 2017 at 4:34 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Prameela Rani Garnepudi,
>
> The patch 9a629fafe7d8: "rsi: immediate wakeup bit and priority for
> TX command packets" from Jul 10, 2017, leads to the following static
> checker warning:
>
>         drivers/net/wireless/rsi/rsi_91x_mgmt.c:277 rsi_send_internal_mgmt_frame()
>         error: potentially dereferencing uninitialized 'desc'.
>
> drivers/net/wireless/rsi/rsi_91x_mgmt.c
>    267  static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
>    268                                          struct sk_buff *skb)
>    269  {
>    270          struct skb_info *tx_params;
>    271          struct rsi_cmd_desc *desc;
>                                      ^^^^
>    272
>    273          if (skb == NULL) {
>    274                  rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
>    275                  return -ENOMEM;
>    276          }
>    277          desc->desc_dword0.len_qno |= cpu_to_le16(DESC_IMMEDIATE_WAKEUP);
>                 ^^^^^^
>
>    278          skb->priority = MGMT_SOFT_Q;
>    279          tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
>    280          tx_params->flags |= INTERNAL_MGMT_PKT;
>    281          skb_queue_tail(&common->tx_queue[MGMT_SOFT_Q], skb);
>    282          rsi_set_event(&common->tx_thread.event);
>    283          return 0;
>    284  }
>
> regards,
> dan carpenter



-- 
G. Prameela Rani (M.Tech,CSE)
