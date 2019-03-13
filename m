Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D95C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F67E2173C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SrbykV8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfCMJbX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:31:23 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45386 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfCMJbX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 05:31:23 -0400
Received: by mail-yw1-f67.google.com with SMTP id r188so847770ywb.12
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 02:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMSnpZiQikalYZrNrEml3by+HMZI4uM9QlOGTBV+Zfg=;
        b=SrbykV8yiVd3ZkUBHsdPmbmRDGdTCr1MVSWe8qFMqBpxW0Xx1irIbFYGlw5eLAdfuL
         1/zwPOMHREdzwxG2oJTftXSUECh4m4l8R4wojQw40f5EdtMI1Kgobr3zE3ykKiXRarlC
         foPkoZ8HfEIwurlZxP5zF4U0akXqeNQBgG+YSv2X1YiasPGZa85wW1yX1kx0hoQb3Pd7
         hNPte5I8y2bgwJR2pCRPdd+dgJoOBKDSRDU+OPr3NbXii2tMuQ7gMfoIHXpw1ovwT//c
         ZKHiRemp0Is9OaKyBNJBie+5hwqxYKGNaA074IdmXoNFlaW7Kav+IyPWDcyii0ilgKQY
         I3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMSnpZiQikalYZrNrEml3by+HMZI4uM9QlOGTBV+Zfg=;
        b=YF4Qup36GPxCiuQvO/gZ3VKsXL9BiWZY3RYD45ER3/+mhpYcPzBMRSGmzndughRigl
         jBKhipSKlojHp5wl2y/LXVrnVkPYJGJ5Iu8PuFp9jHqWLbou1IShUfwpfKwSjtfW0Tn+
         yTMMja3snSfKmujoHkEodif2zg+WRvK3KZ+4Wk9FaaElU9T4cityUdPcK/n6Y/GgxRrt
         tK3pFy9K2ozKzRbsjKd7CFcBuWVRppc4OmP2TRhgQWJyrHGLGtFpHAg+N/JCfK/Ylb62
         j3JfDwetI1/mPoXi5Ai85q+f2LjDQsdChLsiA5R+llcngTV8sP7NaurE18XrUR+PVhFi
         8XWA==
X-Gm-Message-State: APjAAAWQnKjoQ6NST3tnpHBdVH9qGEyMKsGQnyTymItyOMPoRzjhd0Xm
        LajouCLujPkQ2prWBblRLyykiURJykvFVg/xuLk=
X-Google-Smtp-Source: APXvYqyi91Ar6D7Fm8e51OwDlQEx3za+vzLTlAK4tfqnpAAC9fVFhIG7a7Lj98eGJFF4dDOUEqItZBVufOZclDpNCQY=
X-Received: by 2002:a81:6754:: with SMTP id b81mr34268136ywc.457.1552469482333;
 Wed, 13 Mar 2019 02:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552309862.git.lorenzo@kernel.org> <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
 <20190312140339.GA5881@redhat.com> <CAA2SeNL+ejU2NmnqyoYJSgrM+KDWu+jvmzra-LqUab-pM1hgqg@mail.gmail.com>
 <20190313092144.GC2663@redhat.com>
In-Reply-To: <20190313092144.GC2663@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Wed, 13 Mar 2019 10:31:11 +0100
Message-ID: <CAA2SeNKrW=apc964554xhrFJFFiqwx7yMa8dp2-17T1PbvPD4Q@mail.gmail.com>
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
> On Tue, Mar 12, 2019 at 05:48:14PM +0100, Lorenzo Bianconi wrote:
> > >
> > > On Mon, Mar 11, 2019 at 02:24:35PM +0100, Lorenzo Bianconi wrote:
> > > > Fix following schedule while atomic in mt76x02_reset_state
> > > > since synchronize_rcu is run inside a RCU section
> > > >
> > > > [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> > > > [44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
> > > > [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
> > > > [44036.944287] INFO: lockdep is turned off.
> > > > [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
> > > > [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
> > > > [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> > > > [44036.944308] Call Trace:
> > > > [44036.944317]  dump_stack+0x67/0x90
> > > > [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> > > > [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> > > > [44036.944330]  synchronize_rcu+0x17/0x80
> > > > [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> > > > [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> > > > [44036.944355]  process_one_work+0x2a5/0x620
> > > > [44036.944361]  worker_thread+0x35/0x3e0
> > > > [44036.944368]  kthread+0x11c/0x140
> > > > [44036.944376]  ret_from_fork+0x3a/0x50
> > > > [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
> > > > [44036.944387] INFO: lockdep is turned off.
> > > > [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi
> > >
> > > Does the patch fix the issue for you ? For me on my MT7612E device it
> > > make the BUG warning gone, but instead of that I have total system hung
> > > without any error message except information about hw restart.

The system hang is not related to the 'schedule while atomic'.
If you look at the code we run synchronize_rcu() inside a rcu section
and this is not allowed.
I just run it outside of the rcu section protecting it with the mutex,
the reset is performed even with
this patch (just look at syslog). The system hang is related to this
particular card since other devices
work properly.

Regards,
Lorenzo

> > >
> > Hi Stanislaw,
> >
> > this patch just fixes the 'schedule while atomic' issue.
>
> Well, if it exchange 'schedule while atomic' warning to system hung it's
> not good fix. Again, does the fix make restart work for you ? Have you
> tested it ?
>
> > > [  174.425507] mt76x2e 0000:04:00.0: mac specific condition occurred
> > > [  176.590750] mt76x2e 0000:04:00.0: MCU message 31 (seq 13) timed out
> > > [  176.861345] mt76x2e 0000:04:00.0: Firmware Version: 0.0.00
> > > [  176.867214] mt76x2e 0000:04:00.0: Build: 1
> > > [  176.876563] mt76x2e 0000:04:00.0: Build Time: 201507311614____
> > > [  176.908095] mt76x2e 0000:04:00.0: Firmware running!
> > > [  176.920030] ieee80211 phy0: Hardware restart was requested
> > >
> > > ... hung at this point.
> > >
> > > This is with this fix and Felix's
> > > [PATCH] mac80211: do not call driver wake_tx_queue op during reconfig
> > > on latest nbd/wireless tree.
> > >
> > > Stanislaw
> > >
> >
> > are you using U7612E-H1? I am still having issues on this card but I had no time
> > to look at it yet.
>
> Not sure if the number is correct, but yes, I don't have others MT7612E
> cards, only one card which mt76x2e driver does not handle well.
>
> Stanislaw



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
