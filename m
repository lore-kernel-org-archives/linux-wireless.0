Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36799 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932896AbcL0ORf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 09:17:35 -0500
Received: by mail-wm0-f44.google.com with SMTP id c85so77035599wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2016 06:17:34 -0800 (PST)
Received: from [192.168.10.185] ([147.83.206.88])
        by smtp.gmail.com with ESMTPSA id x140sm56244919wme.19.2016.12.27.06.17.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Dec 2016 06:17:27 -0800 (PST)
Subject: Re: Question: Packet drop criterion
To: linux-wireless@vger.kernel.org
References: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>
From: Ferran Quer i Guerrero <ferran.quer@i2cat.net>
Message-ID: <074f2c2c-02f0-0520-2326-a845beb2974d@i2cat.net> (sfid-20161227_151827_562607_4A8FF358)
Date: Tue, 27 Dec 2016 15:17:01 +0100
MIME-Version: 1.0
In-Reply-To: <f4e6b348-fafb-1546-57cd-4623299b0abb@i2cat.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have browsed further the code and have some conclusions that it would
be nice to check with you


El 22/12/16 a les 13:34, Ferran Quer i Guerrero ha escrit:

> Did I get wrong the iw command?

Probably not, but minstrel is interferring. If I fixed the tx bitrates,
this would possibly set the retry limits.

> Is it Minstrel who decides the retry trheshold?

Yes, but...

> Is it Atheros driver?

Based on decisions of the Atheros (it sets the #rates to 4 and the
max_rate_retry to 10

> Does it have anything to do with mesh mode?

Not that I have noticed. However, I would like to ask for the meaning of
this params:

    # iw dev wlan0 get mesh_param
    mesh_retry_timeout = 100 milliseconds
    [...]
    mesh_max_retries = 3
    [...]

What packets do they apply to?

Thank you in advance,
Ferran


El 22/12/16 a les 13:34, Ferran Quer i Guerrero ha escrit:
> Hello everyone,
>
> I would like to modify the retry threshold for dropping a packet using
> mesh mode. I tried with iw
>
>     iw phy <phyname> set retry [short <limit>] [long <limit>]
>
> with short and long limits equal to 10 first and later 5, but I couldn't
> tell any effect. I'm checking by adding a printk in `status.c` and
> manually shutting down (ifdown) the mesh-peered interface to cause
> packet retries. It turns out that the tx report only appears when
> `retry_count` is 28 (after many continued drops, it also appears at 23,
> 24, 25 or retries). 
>
>     void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>     {
>         /* ... */
>                 if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
>                         ieee80211_handle_filtered_frame(local, sta, skb);
>                         rcu_read_unlock();
>                         return;
>                 } else {
>                         if (!acked)
>                                 sta->tx_retry_failed++;
>                         sta->tx_retry_count += retry_count;
>                         /* Dirty debugging */
>                         printk("Packet dropped. Retry count: %d",
> retry_count);
>                 }
>
>                 rate_control_tx_status(local, sband, sta, skb);
>                 if (ieee80211_vif_is_mesh(&sta->sdata->vif))
>                         ieee80211s_update_metric(local, sta, skb);
>         /* ... */
>     }
>
> I'm using linux backports v3.12.8, ath9k wifi dongles, and interfaces on
> mesh point mode.
>
> Did I get wrong the iw command?
> Is it Minstrel who decides the retry trheshold?
> Is it Atheros driver?
> Does it have anything to do with mesh mode?
>
> I'm trying to find the responsible at the source code, but haven't
> succeeded yet, so I decided to write to yo.
>
> Thank you very much
> Ferran Quer
>
>
