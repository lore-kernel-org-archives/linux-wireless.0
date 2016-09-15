Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:36194 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbcIOKtr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 06:49:47 -0400
Received: by mail-lf0-f51.google.com with SMTP id g62so30071415lfe.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2016 03:49:46 -0700 (PDT)
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite
 WARNINGs
To: Hante Meuleman <hante.meuleman@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <20160915081135.24477-1-zajec5@gmail.com>
 <b4df2418354fdf7eb585a898bf12b19f@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <0f7765be-5a27-f5f6-3361-cfb976d674bc@gmail.com> (sfid-20160915_124954_605906_BE2F6FC2)
Date: Thu, 15 Sep 2016 12:49:37 +0200
MIME-Version: 1.0
In-Reply-To: <b4df2418354fdf7eb585a898bf12b19f@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 September 2016 at 11:20, Hante Meuleman <hante.meuleman@broadcom.com> wrote:
 > Thank you for the extensive debugging. We are looking into this. Arend wrote
 > yesterday to ask for detailed timing on wen eapol is inserted. We want this
 > so we can increase the timeout. This is not a "nice" way to solve the
 > problem, and it should be solved in firmware, but in the meanwhile we do
 > want to increase timer, because we think that ampdu issues can rise at any
 > given moment and even with changes/updates in firmware it might be necessary
 > to increase timeout.

I'm kindly asking to keep replies in related threads :) I'm pretty sure above is
about problem described in "AMPDU stalls with brcmfmac4366b-pcie.bin triggering
WARNINGs".


 > Second problem is harder, it is good to see that the frame gets returned to
 > driver at some point. Our biggest worry is that a frame remains indefinitely
 > in the firmware, but that appears not to be the case. Now why could this
 > fail. There is one possible reason I found, and that is when a flowring is
 > deleted while it holds the eapol, see flowring.c. It does not call the
 > brcmf_txfinalize, but frees the packet directly. I think this is wrong but
 > need to investigate this in more detail. In the meanwhile, if you keep doing
 > tests I would like to ask you to add a WARN_ON() call to the function
 > __brcmu_pkt_buf_free_skb where you print ***BUG*** so we know where the
 > packet got freed from.

Please take a look at my e-mail & log (& maybe diff) once again. You really
quite missed the point.

The function brcmf_txfinalize *was* called. I was describing it in my e-mail
and there is a log:
[ 1440.414653] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c72e7c80] ***BUG*** skb:c70ddc00 skb->dev:c72e7800 skb->dev->name:wlan1-1
Above means that brcmf_txfinalize was called for skb c70ddc00 and it called
brcmu_pkt_buf_free_skb.

My debugging code noticed that it wasn't alright as this packet was still
pending and pend_8021x_cnt wasn't decreased for him. Please note it was
brcmf_txfinalize's fault (which was called for 100% sure). For some reason it
didn't pass if (type == ETH_P_PAE) condition. I already described it and I
shared my guess of firmware corrupting skb data. I'm now using debugging patch
which prints copied and current content of skb data in case of fault.

You're right I should have used WARN in my ***BUG*** place. It's a stupid habit
from MIPS devices where backtraces aren't reliable. I printed mini call chain
on my own instead. I mean this part:
[__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb]

So please take a look at my e-mail again and let me know if it makes more sense
now.
What do you think about my guess of firmware corrupting skb data?
