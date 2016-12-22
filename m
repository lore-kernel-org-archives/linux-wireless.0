Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34390 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940879AbcLVMeg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 07:34:36 -0500
Received: by mail-wm0-f52.google.com with SMTP id u144so46818472wmu.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2016 04:34:35 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Ferran Quer i Guerrero <ferran.quer@i2cat.net>
Subject: Question: Packet drop criterion
Message-ID: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net> (sfid-20161222_133444_304501_B0F88031)
Date: Thu, 22 Dec 2016 13:34:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I would like to modify the retry threshold for dropping a packet using
mesh mode. I tried with iw

    iw phy <phyname> set retry [short <limit>] [long <limit>]

with short and long limits equal to 10 first and later 5, but I couldn't
tell any effect. I'm checking by adding a printk in `status.c` and
manually shutting down (ifdown) the mesh-peered interface to cause
packet retries. It turns out that the tx report only appears when
`retry_count` is 28 (after many continued drops, it also appears at 23,
24, 25 or retries).=20

    void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb=
)
    {
        /* ... */
                if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
                        ieee80211_handle_filtered_frame(local, sta, skb);=

                        rcu_read_unlock();
                        return;
                } else {
                        if (!acked)
                                sta->tx_retry_failed++;
                        sta->tx_retry_count +=3D retry_count;
                        /* Dirty debugging */
                        printk("Packet dropped. Retry count: %d",
retry_count);
                }

                rate_control_tx_status(local, sband, sta, skb);
                if (ieee80211_vif_is_mesh(&sta->sdata->vif))
                        ieee80211s_update_metric(local, sta, skb);
        /* ... */
    }

I'm using linux backports v3.12.8, ath9k wifi dongles, and interfaces on
mesh point mode.

Did I get wrong the iw command?
Is it Minstrel who decides the retry trheshold?
Is it Atheros driver?
Does it have anything to do with mesh mode?

I'm trying to find the responsible at the source code, but haven't
succeeded yet, so I decided to write to yo.

Thank you very much
Ferran Quer
