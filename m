Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D953C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4758E20652
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 12:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="bnj8yrPU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDLMLa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:11:30 -0400
Received: from nbd.name ([46.4.11.11]:36190 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfDLMLa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 08:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4YOWJV9dR01R2LFimUkcoI9jJiXhhcOzu9VPX1VOVsY=; b=bnj8yrPUpO91lQ3mcuMrwz4qYa
        Rxu5sckXxFh9llW1VQmuUni413irA47ua5ec8BTFdeKL36mZHKFmFEnJN8xu/LjfGlZuXWdn5hyBb
        bnVKWhOZ8T5btosnXXDVsIGh1XMSeFLlp+CzQiVpx0capXc+fPu5n/qzY1oulgnte5To=;
Received: from p4ff13bac.dip0.t-ipconnect.de ([79.241.59.172] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hEv1k-00069l-9A; Fri, 12 Apr 2019 14:11:28 +0200
Subject: Re: [PATCH 5.1] mt76x02: avoid status_list.lock and
 sta->rate_ctrl_lock dependency
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20190405114256.6416-1-sgruszka@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <3870b591-26b9-44f9-3896-6c268b68512a@nbd.name>
Date:   Fri, 12 Apr 2019 14:11:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190405114256.6416-1-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-05 13:42, Stanislaw Gruszka wrote:
> Move ieee80211_tx_status_ext() outside of status_list lock section
> in order to avoid locking dependency and possible deadlock reposed by
> LOCKDEP in below warning.
> 
> Also do mt76_tx_status_lock() just before it's needed.
> 
> [  440.224832] WARNING: possible circular locking dependency detected
> [  440.224833] 5.1.0-rc2+ #22 Not tainted
> [  440.224834] ------------------------------------------------------
> [  440.224835] kworker/u16:28/2362 is trying to acquire lock:
> [  440.224836] 0000000089b8cacf (&(&q->lock)->rlock#2){+.-.}, at: mt76_wake_tx_queue+0x4c/0xb0 [mt76]
> [  440.224842]
>                but task is already holding lock:
> [  440.224842] 000000002cfedc59 (&(&sta->lock)->rlock){+.-.}, at: ieee80211_stop_tx_ba_cb+0x32/0x1f0 [mac80211]
> [  440.224863]
>                which lock already depends on the new lock.
> 
> [  440.224863]
>                the existing dependency chain (in reverse order) is:
> [  440.224864]
>                -> #3 (&(&sta->lock)->rlock){+.-.}:
> [  440.224869]        _raw_spin_lock_bh+0x34/0x40
> [  440.224880]        ieee80211_start_tx_ba_session+0xe4/0x3d0 [mac80211]
> [  440.224894]        minstrel_ht_get_rate+0x45c/0x510 [mac80211]
> [  440.224906]        rate_control_get_rate+0xc1/0x140 [mac80211]
> [  440.224918]        ieee80211_tx_h_rate_ctrl+0x195/0x3c0 [mac80211]
> [  440.224930]        ieee80211_xmit_fast+0x26d/0xa50 [mac80211]
> [  440.224942]        __ieee80211_subif_start_xmit+0xfc/0x310 [mac80211]
> [  440.224954]        ieee80211_subif_start_xmit+0x38/0x390 [mac80211]
> [  440.224956]        dev_hard_start_xmit+0xb8/0x300
> [  440.224957]        __dev_queue_xmit+0x7d4/0xbb0
> [  440.224968]        ip6_finish_output2+0x246/0x860 [ipv6]
> [  440.224978]        mld_sendpack+0x1bd/0x360 [ipv6]
> [  440.224987]        mld_ifc_timer_expire+0x1a4/0x2f0 [ipv6]
> [  440.224989]        call_timer_fn+0x89/0x2a0
> [  440.224990]        run_timer_softirq+0x1bd/0x4d0
> [  440.224992]        __do_softirq+0xdb/0x47c
> [  440.224994]        irq_exit+0xfa/0x100
> [  440.224996]        smp_apic_timer_interrupt+0x9a/0x220
> [  440.224997]        apic_timer_interrupt+0xf/0x20
> [  440.224999]        cpuidle_enter_state+0xc1/0x470
> [  440.225000]        do_idle+0x21a/0x260
> [  440.225001]        cpu_startup_entry+0x19/0x20
> [  440.225004]        start_secondary+0x135/0x170
> [  440.225006]        secondary_startup_64+0xa4/0xb0
> [  440.225007]
>                -> #2 (&(&sta->rate_ctrl_lock)->rlock){+.-.}:
> [  440.225009]        _raw_spin_lock_bh+0x34/0x40
> [  440.225022]        rate_control_tx_status+0x4f/0xb0 [mac80211]
> [  440.225031]        ieee80211_tx_status_ext+0x142/0x1a0 [mac80211]
> [  440.225035]        mt76x02_send_tx_status+0x2e4/0x340 [mt76x02_lib]
> [  440.225037]        mt76x02_tx_status_data+0x31/0x40 [mt76x02_lib]
> [  440.225040]        mt76u_tx_status_data+0x51/0xa0 [mt76_usb]
> [  440.225042]        process_one_work+0x237/0x5d0
> [  440.225043]        worker_thread+0x3c/0x390
> [  440.225045]        kthread+0x11d/0x140
> [  440.225046]        ret_from_fork+0x3a/0x50
> [  440.225047]
>                -> #1 (&(&list->lock)->rlock#8){+.-.}:
> [  440.225049]        _raw_spin_lock_bh+0x34/0x40
> [  440.225052]        mt76_tx_status_skb_add+0x51/0x100 [mt76]
> [  440.225054]        mt76x02u_tx_prepare_skb+0xbd/0x116 [mt76x02_usb]
> [  440.225056]        mt76u_tx_queue_skb+0x5f/0x180 [mt76_usb]
> [  440.225058]        mt76_tx+0x93/0x190 [mt76]
> [  440.225070]        ieee80211_tx_frags+0x148/0x210 [mac80211]
> [  440.225081]        __ieee80211_tx+0x75/0x1b0 [mac80211]
> [  440.225092]        ieee80211_tx+0xde/0x110 [mac80211]
> [  440.225105]        __ieee80211_tx_skb_tid_band+0x72/0x90 [mac80211]
> [  440.225122]        ieee80211_send_auth+0x1f3/0x360 [mac80211]
> [  440.225141]        ieee80211_auth.cold.40+0x6c/0x100 [mac80211]
> [  440.225156]        ieee80211_mgd_auth.cold.50+0x132/0x15f [mac80211]
> [  440.225171]        cfg80211_mlme_auth+0x149/0x360 [cfg80211]
> [  440.225181]        nl80211_authenticate+0x273/0x2e0 [cfg80211]
> [  440.225183]        genl_family_rcv_msg+0x196/0x3a0
> [  440.225184]        genl_rcv_msg+0x47/0x8e
> [  440.225185]        netlink_rcv_skb+0x3a/0xf0
> [  440.225187]        genl_rcv+0x24/0x40
> [  440.225188]        netlink_unicast+0x16d/0x210
> [  440.225189]        netlink_sendmsg+0x204/0x3b0
> [  440.225191]        sock_sendmsg+0x36/0x40
> [  440.225193]        ___sys_sendmsg+0x259/0x2b0
> [  440.225194]        __sys_sendmsg+0x47/0x80
> [  440.225196]        do_syscall_64+0x60/0x1f0
> [  440.225197]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  440.225198]
>                -> #0 (&(&q->lock)->rlock#2){+.-.}:
> [  440.225200]        lock_acquire+0xb9/0x1a0
> [  440.225202]        _raw_spin_lock_bh+0x34/0x40
> [  440.225204]        mt76_wake_tx_queue+0x4c/0xb0 [mt76]
> [  440.225215]        ieee80211_agg_start_txq+0xe8/0x2b0 [mac80211]
> [  440.225225]        ieee80211_stop_tx_ba_cb+0xb8/0x1f0 [mac80211]
> [  440.225235]        ieee80211_ba_session_work+0x1c1/0x2f0 [mac80211]
> [  440.225236]        process_one_work+0x237/0x5d0
> [  440.225237]        worker_thread+0x3c/0x390
> [  440.225239]        kthread+0x11d/0x140
> [  440.225240]        ret_from_fork+0x3a/0x50
> [  440.225240]
>                other info that might help us debug this:
> 
> [  440.225241] Chain exists of:
>                  &(&q->lock)->rlock#2 --> &(&sta->rate_ctrl_lock)->rlock --> &(&sta->lock)->rlock
> 
> [  440.225243]  Possible unsafe locking scenario:
> 
> [  440.225244]        CPU0                    CPU1
> [  440.225244]        ----                    ----
> [  440.225245]   lock(&(&sta->lock)->rlock);
> [  440.225245]                                lock(&(&sta->rate_ctrl_lock)->rlock);
> [  440.225246]                                lock(&(&sta->lock)->rlock);
> [  440.225247]   lock(&(&q->lock)->rlock#2);
> [  440.225248]
>                 *** DEADLOCK ***
> 
> [  440.225249] 5 locks held by kworker/u16:28/2362:
> [  440.225250]  #0: 0000000048fcd291 ((wq_completion)phy0){+.+.}, at: process_one_work+0x1b5/0x5d0
> [  440.225252]  #1: 00000000f1c6828f ((work_completion)(&sta->ampdu_mlme.work)){+.+.}, at: process_one_work+0x1b5/0x5d0
> [  440.225254]  #2: 00000000433d2b2c (&sta->ampdu_mlme.mtx){+.+.}, at: ieee80211_ba_session_work+0x5c/0x2f0 [mac80211]
> [  440.225265]  #3: 000000002cfedc59 (&(&sta->lock)->rlock){+.-.}, at: ieee80211_stop_tx_ba_cb+0x32/0x1f0 [mac80211]
> [  440.225276]  #4: 000000009d7b9a44 (rcu_read_lock){....}, at: ieee80211_agg_start_txq+0x33/0x2b0 [mac80211]
> [  440.225286]
>                stack backtrace:
> [  440.225288] CPU: 2 PID: 2362 Comm: kworker/u16:28 Not tainted 5.1.0-rc2+ #22
> [  440.225289] Hardware name: LENOVO 20KGS23S0P/20KGS23S0P, BIOS N23ET55W (1.30 ) 08/31/2018
> [  440.225300] Workqueue: phy0 ieee80211_ba_session_work [mac80211]
> [  440.225301] Call Trace:
> [  440.225304]  dump_stack+0x85/0xc0
> [  440.225306]  print_circular_bug.isra.38.cold.58+0x15c/0x195
> [  440.225307]  check_prev_add.constprop.48+0x5f0/0xc00
> [  440.225309]  ? check_prev_add.constprop.48+0x39d/0xc00
> [  440.225311]  ? __lock_acquire+0x41d/0x1100
> [  440.225312]  __lock_acquire+0xd98/0x1100
> [  440.225313]  ? __lock_acquire+0x41d/0x1100
> [  440.225315]  lock_acquire+0xb9/0x1a0
> [  440.225317]  ? mt76_wake_tx_queue+0x4c/0xb0 [mt76]
> [  440.225319]  _raw_spin_lock_bh+0x34/0x40
> [  440.225321]  ? mt76_wake_tx_queue+0x4c/0xb0 [mt76]
> [  440.225323]  mt76_wake_tx_queue+0x4c/0xb0 [mt76]
> [  440.225334]  ieee80211_agg_start_txq+0xe8/0x2b0 [mac80211]
> [  440.225344]  ieee80211_stop_tx_ba_cb+0xb8/0x1f0 [mac80211]
> [  440.225354]  ieee80211_ba_session_work+0x1c1/0x2f0 [mac80211]
> [  440.225356]  process_one_work+0x237/0x5d0
> [  440.225358]  worker_thread+0x3c/0x390
> [  440.225359]  ? wq_calc_node_cpumask+0x70/0x70
> [  440.225360]  kthread+0x11d/0x140
> [  440.225362]  ? kthread_create_on_node+0x40/0x40
> [  440.225363]  ret_from_fork+0x3a/0x50
> 
> Cc: stable@vger.kernel.org
> Fixes: 88046b2c9f6d ("mt76: add support for reporting tx status with skb")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Felix Fietkau <nbd@nbd.name>

- Felix
