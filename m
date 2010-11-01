Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45272 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0KAQ2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 12:28:35 -0400
Received: by yxk8 with SMTP id 8so2959786yxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 09:28:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8762whrqvm.fsf@gmail.com>
References: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
	<8762whrqvm.fsf@gmail.com>
Date: Mon, 1 Nov 2010 17:20:28 +0100
Message-ID: <AANLkTiniZRi506LeRp2U89n+npnky5rtq5da745ukWJc@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Ben Gamari <bgamari@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 4:43 PM, Ben Gamari <bgamari@gmail.com> wrote:
> On Mon, 1 Nov 2010 16:17:23 +0100, Björn Smedman <bjorn.smedman@venatech.se> wrote:
>> Hi all,
>>
>> I have an application that creates and destroys a lot of ap vifs and
>> does a lot of monitor frame injection. The recent ath9k rx locking
>> fixes have helped with stability in this use-case but there still
>> seems to be some tx/beacon related race condition(s). These manifests
>> themselves as follows on an AR913x based router running
>> compat-wireless-2010-10-19 (with locking fixes etc from openwrt):
>>
>> 1. TX DMA hangs under simultaneous high RX and TX load
>> 2. TX is completely hung but chip is never reset
>
> I have also observed both of these behaviors with just a standard
> hostapd single VIF configuration. Quite annoying. It seems to be better
> with recent wireless-testing trees.
>
> - Ben

Looking at the code here is the first passage that triggers a bad
fuzzy feeling for me (beacon.c):

        skb = ieee80211_get_buffered_bc(hw, vif);

        /*
         * if the CABQ traffic from previous DTIM is pending and the current
         *  beacon is also a DTIM.
         *  1) if there is only one vif let the cab traffic continue.
         *  2) if there are more than one vif and we are using staggered
         *     beacons, then drain the cabq by dropping all the frames in
         *     the cabq so that the current vifs cab traffic can be scheduled.
         */
        spin_lock_bh(&cabq->axq_lock);
        cabq_depth = cabq->axq_depth;
        spin_unlock_bh(&cabq->axq_lock);

        if (skb && cabq_depth) {
                if (sc->nvifs > 1) {
                        ath_print(common, ATH_DBG_BEACON,
                                  "Flushing previous cabq traffic\n");
                        ath_draintxq(sc, cabq, false);
                }
        }

        ath_beacon_setup(sc, avp, bf, info->control.rates[0].idx);

        while (skb) {
                ath_tx_cabq(hw, skb);
                skb = ieee80211_get_buffered_bc(hw, vif);
        }

>From what I can tell there is no guarantee that CABQ TX DMA is stopped
when ath_draintxq() is called. From ath_draintxq() point of view that
looks like a bad idea (race between CPU and DMA).

Also, that looking around "cabq_depth = cabq->axq_depth;" looks very
peculiar. I believe it's correct (because nobody else puts anything
into this queue and we don't care if it's shorter later on when we
drain it) but I think it would be nice with a comment.

Any thoughts? I can whip up and test a patch if there are no objections.

/Björn
