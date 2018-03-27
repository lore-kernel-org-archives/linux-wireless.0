Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeC0JNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:13:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix warning in ieee80211_get_key_rx_seq()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180317140139.24724-1-lorenzo.bianconi@redhat.com>
References: <20180317140139.24724-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180327091308.DE294607DD@smtp.codeaurora.org> (sfid-20180327_111313_609465_5AD5857D)
Date: Tue, 27 Mar 2018 09:13:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fall back to software encryption for hw unsupported ciphers in order
> to fix the following warning in ieee80211_get_key_rx_seq routine:
> 
> WARNING: CPU: 1 PID: 1277 at backports-2017-11-01/net/mac80211/key.c:
> 1010 mt76_wcid_key_setup+0x6c/0x138 [mt76]
> CPU: 1 PID: 1277 Comm: hostapd Tainted: G        W       4.9.86 #0
> Stack : 00000000 00000000 80527b4a 00000042 80523824 00000000 00000000 80520000
>         8fd79a9c 804bbda7 80454c84 00000001 000004fd 80523824 8f7e4ba0 8eceda12
>         00000010 8006af94 00000001 80520000 804c1f04 804c1f08 80459890 8ec999b4
>         00000003 800a7840 8f7e4ba0 8eceda12 8121de20 00000000 00000001 00c999b4
>         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>         ...
> Call Trace:
> [<8000f52c>] show_stack+0x70/0x8c
> [<801d8d04>] dump_stack+0x94/0xd0
> [<8002bcd4>] __warn+0x110/0x118
> [<8002bd70>] warn_slowpath_null+0x1c/0x2c
> [<8f0415cc>] mt76_wcid_key_setup+0x6c/0x138 [mt76]
> [<8f1311b4>] mt76x2_dma_cleanup+0xa38/0x1048 [mt76x2e]
> 
> Fixes: 30ce7f4456ae ("mt76: validate rx CCMP PN")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

c03a5aacde0c mt76x2: fix warning in ieee80211_get_key_rx_seq()

-- 
https://patchwork.kernel.org/patch/10290833/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
