Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B614CC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E362054F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTUVVP/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCLQs1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 12:48:27 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46380 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfCLQs1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 12:48:27 -0400
Received: by mail-yw1-f68.google.com with SMTP id j189so2611208ywd.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 09:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Q75vxPoMRkyJP15NLGz7Ue61fap1z9XO+24OLZtjPU=;
        b=JTUVVP/pXtDRCVzGD7gsW+Oh7RiFbJ86X6fdYLuzRtJU016+ZfMXVqjaersvMVyaU9
         X3ELrOpmL6AkeXCY1bzbndocIObymA2RmobAOOFJpJyiGM/GXRfGjSb9VWZ4iSukXydi
         Ab5gEFEqAp9WRn3lRWm5mowU3d2CU/aLn2QXTzaB4IVj+5AvBhWt5s0qNyr/VoTnl4wa
         0OFv1PJ9KugjHEnDhou3MbRADppUKC5+JAPFSC/xmnAbIwRWIfcCAmZBkZZKbJ1fIaNZ
         iALORtMNbYiFNIY6hrtIBTwf5h5gg1aFqJYBtCQSue1ymr/CLVmjNgTPzb05rM/bp4C3
         +nUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Q75vxPoMRkyJP15NLGz7Ue61fap1z9XO+24OLZtjPU=;
        b=PHe7P3W+7p8d18LF0SaYElo7s1uPPegTQTymtxN+UoGg9ZxIaXfQl/Nh9kIsh049jl
         53Y3KbGyT1dRshS3k7vvq7G3ZHVbHv+TsXLOyRLgXg3w8gKANRZzQdPkFxD1ddnf520S
         N0zmRlY8mIjOE6Ro7Ejlz/4oyqWnbYfYuQ33TnDQq+IECAsBeSBE+hVYfpZaxL/Kp4jS
         NEPn8r/DPELuSIn1hd4oVDw6gX6GMyWRNBunbdGO2RU4GtnjhFyqGgWjFSYRx0iQOSJk
         uSyDfi6WPjzDFsmvNWMbsVoGMHGk1pwdL4DFBfcPEG9SCYvDHayUuWI3N6xt6Foif/1c
         9Ifw==
X-Gm-Message-State: APjAAAW83tieu6vu5CfETv4f/I2ZkUtMNmupr+ygkg8qgKcTDnhBAuZn
        77z0hBoCJ5WydHvIWf7OPv6vxjoS3tmGb+Q7GBSN399O
X-Google-Smtp-Source: APXvYqyHwJWMOu/HxUKFV1W/JcATh6OaXXo6/quX86OqHLselWJ/d5LaOqZ71Md8S+IrGHp/CcVj0jfVPkpg8Vx4GM8=
X-Received: by 2002:a25:d0a:: with SMTP id 10mr27616499ybn.84.1552409305991;
 Tue, 12 Mar 2019 09:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552309862.git.lorenzo@kernel.org> <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
 <20190312140339.GA5881@redhat.com>
In-Reply-To: <20190312140339.GA5881@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Tue, 12 Mar 2019 17:48:14 +0100
Message-ID: <CAA2SeNL+ejU2NmnqyoYJSgrM+KDWu+jvmzra-LqUab-pM1hgqg@mail.gmail.com>
Subject: Re: [PATCH v2] mt76: fix schedule while atomic in mt76x02_reset_state
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Mon, Mar 11, 2019 at 02:24:35PM +0100, Lorenzo Bianconi wrote:
> > Fix following schedule while atomic in mt76x02_reset_state
> > since synchronize_rcu is run inside a RCU section
> >
> > [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> > [44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
> > [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
> > [44036.944287] INFO: lockdep is turned off.
> > [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
> > [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
> > [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> > [44036.944308] Call Trace:
> > [44036.944317]  dump_stack+0x67/0x90
> > [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> > [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> > [44036.944330]  synchronize_rcu+0x17/0x80
> > [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> > [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> > [44036.944355]  process_one_work+0x2a5/0x620
> > [44036.944361]  worker_thread+0x35/0x3e0
> > [44036.944368]  kthread+0x11c/0x140
> > [44036.944376]  ret_from_fork+0x3a/0x50
> > [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
> > [44036.944387] INFO: lockdep is turned off.
> > [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi
>
> Does the patch fix the issue for you ? For me on my MT7612E device it
> make the BUG warning gone, but instead of that I have total system hung
> without any error message except information about hw restart.
>
Hi Stanislaw,

this patch just fixes the 'schedule while atomic' issue.

> [  174.425507] mt76x2e 0000:04:00.0: mac specific condition occurred
> [  176.590750] mt76x2e 0000:04:00.0: MCU message 31 (seq 13) timed out
> [  176.861345] mt76x2e 0000:04:00.0: Firmware Version: 0.0.00
> [  176.867214] mt76x2e 0000:04:00.0: Build: 1
> [  176.876563] mt76x2e 0000:04:00.0: Build Time: 201507311614____
> [  176.908095] mt76x2e 0000:04:00.0: Firmware running!
> [  176.920030] ieee80211 phy0: Hardware restart was requested
>
> ... hung at this point.
>
> This is with this fix and Felix's
> [PATCH] mac80211: do not call driver wake_tx_queue op during reconfig
> on latest nbd/wireless tree.
>
> Stanislaw
>

are you using U7612E-H1? I am still having issues on this card but I had no time
to look at it yet.

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
