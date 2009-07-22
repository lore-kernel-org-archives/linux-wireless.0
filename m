Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:45390 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZGVW4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 18:56:43 -0400
Received: by gxk9 with SMTP id 9so949179gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 15:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907230051.57201.rossi.f@inwind.it>
References: <200907230051.57201.rossi.f@inwind.it>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Jul 2009 15:56:23 -0700
Message-ID: <43e72e890907221556r75256f76yde07109d2af78e28@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:561
To: Fabio Rossi <rossi.f@inwind.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 3:51 PM, Fabio Rossi<rossi.f@inwind.it> wrote:
> I'm using the last wireless-testing.git and I have experienced the following
> WARNING:
>
>  WARNING: at net/mac80211/tx.c:561 ieee80211_tx_h_rate_ctrl+0x3d1/0x470
> [mac80211]()

Please try a git pull

  Luis
>  Hardware name: System Name
>  wlan0: Dropped data frame as no usable bitrate found while scanning and
> associated. Target station: 00:0c:f6:xx:xx:xx on 5 GHz band
>  Modules linked in: ath5k mac80211 ath cfg80211
>  Pid: 1270, comm: phy0 Tainted: G        W  2.6.31-rc3-wl #140
>  Call Trace:
>  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
>  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
>  [<c101d37c>] warn_slowpath_common+0x7c/0xa0
>  [<e1aaa0a1>] ? ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
>  [<c101d3e6>] warn_slowpath_fmt+0x26/0x30
>  [<e1aaa0a1>] ieee80211_tx_h_rate_ctrl+0x3d1/0x470 [mac80211]
>  [<e1af8afb>] ? ath5k_hw_reset_tx_queue+0x51b/0x830 [ath5k]
>  [<e1aa8aa5>] ? ieee80211_tx_prepare+0x105/0x320 [mac80211]
>  [<e1aaa489>] invoke_tx_handlers+0x69/0xf0 [mac80211]
>  [<e1aaa64f>] ieee80211_tx+0x5f/0x1f0 [mac80211]
>  [<c139f940>] ? skb_release_data+0x50/0x90
>  [<c139fa83>] ? pskb_expand_head+0x103/0x190
>  [<e1aaa8e5>] ieee80211_xmit+0x105/0x270 [mac80211]
>  [<e1aaaa9e>] ieee80211_tx_skb+0x4e/0x60 [mac80211]
>  [<e1aad7a2>] ieee80211_send_probe_req+0x112/0x180 [mac80211]
>  [<c1017168>] ? dequeue_task+0x48/0x90
>  [<c101e11b>] ? printk+0x1b/0x20
>  [<e1a9ea9a>] ieee80211_mgd_probe_ap+0x11a/0x150 [mac80211]
>  [<e1a9eb12>] ieee80211_beacon_loss_work+0x12/0x20 [mac80211]
>  [<c102c75c>] worker_thread+0xec/0x1c0
>  [<c1454b7d>] ? schedule+0x18d/0x370
>  [<e1a9eb00>] ? ieee80211_beacon_loss_work+0x0/0x20 [mac80211]
>  [<c102f740>] ? autoremove_wake_function+0x0/0x40
>  [<c102c670>] ? worker_thread+0x0/0x1c0
>  [<c102f494>] kthread+0x74/0x80
>  [<c102f420>] ? kthread+0x0/0x80
>  [<c10032d3>] kernel_thread_helper+0x7/0x14
>  ---[ end trace a5a80f7488aa4974 ]---
>
> I have a 802.11abg wireless NIC and I'm currently using a 802.11g access
> point.
>
> Fabio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
