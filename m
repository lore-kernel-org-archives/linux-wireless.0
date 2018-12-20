Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA35AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978E820869
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gfAVWFz4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VrApz1ZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbeLTQvl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:51:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42598 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbeLTQvl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 11:51:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A410960767; Thu, 20 Dec 2018 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324699;
        bh=O7EtM6poeZLRBR24FIWvb3D0I76DgPNLJkEesdxKfow=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gfAVWFz4GMierFPwTs0VRyEOiKmrZsJ2F0K+qVRj/71IOHoLTLVaCKVVWSmEtvHt4
         B0jq5iHl+A3NC7gEsjj9HcjsJyU08QQp/AmJwX6iln4W9VbVwrhu0YhPB4vSAF7PLG
         FBnzp72e+Cu6jbJ7mwcboe1sqpvhOQ1Ex8QOi1jc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3643C6053B;
        Thu, 20 Dec 2018 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324699;
        bh=O7EtM6poeZLRBR24FIWvb3D0I76DgPNLJkEesdxKfow=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VrApz1ZM8bDIfzB4/k0caOCOEtbOJgWsYtRPP58/agvaKohhqCElStzfZJ2KmnBPm
         ZvrvX206prmOmsOGzbP6aACWLj5BIRluwfKsPB+YBS+UzUu2cbKLcOVWpD82rvoRBH
         O9xaBJGlDwxfS1psIbVj9bk3De46Uq9Lk0QhC3Ss=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3643C6053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix kernel panic due to use after free
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1541753646-11533-1-git-send-email-periyasa@codeaurora.org>
References: <1541753646-11533-1-git-send-email-periyasa@codeaurora.org>
To:     Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220165139.A410960767@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 16:51:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Karthikeyan Periyasamy <periyasa@codeaurora.org> wrote:

> This issue arise in a race condition between ath10k_sta_state() and
> ath10k_htt_fetch_peer_stats(), explained in below scenario
> 
> Steps:
> 1. In ath10k_sta_state(), arsta->tx_stats get deallocated before peer deletion
>    when the station moves from IEEE80211_STA_NONE to IEEE80211_STA_NOTEXIST
>    state.
> 2. Meanwhile ath10k receive HTT_T2H_MSG_TYPE_PEER_STATS message.
>    In ath10k_htt_fetch_peer_stats(), arsta->tx_stats get accessed after
>    the peer validation check.
> 
> Since arsta->tx_stats get freed before the peer deletion [1].
> ath10k_htt_fetch_peer_stats() ended up in "use after free" situation.
> 
> Fixed this issue by moving the arsta->tx_stats free handling after the
> peer deletion. so that ath10k_htt_fetch_peer_stats() will not end up in
> "use after free" situation.
> 
> Kernel Panic:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000286
> pgd = d8754000
> [00000286] *pgd=00000000
> Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> ...
> CPU: 0 PID: 6245 Comm: hostapd Not tainted
> task: dc44cac0 ti: d4a38000 task.ti: d4a38000
> PC is at kmem_cache_alloc+0x7c/0x114
> LR is at ath10k_sta_state+0x190/0xd58 [ath10k_core]
> pc : [<c02bdc50>]    lr : [<bf916b78>]    psr: 20000013
> sp : d4a39b88  ip : 00000000  fp : 00000001
> r10: 00000000  r9 : 1d3bc000  r8 : 00000dc0
> r7 : 000080d0  r6 : d4a38000  r5 : dd401b00  r4 : 00000286
> r3 : 00000000  r2 : d4a39ba0  r1 : 000080d0  r0 : dd401b00
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c5787d  Table: 5a75406a  DAC: 00000015
> Process hostapd (pid: 6245, stack limit = 0xd4a38238)
> Stack: (0xd4a39b88 to 0xd4a3a000)
> ...
> [<c02bdc50>] (kmem_cache_alloc) from [<bf916b78>] (ath10k_sta_state+0x190/0xd58 [ath10k_core])
> [<bf916b78>] (ath10k_sta_state [ath10k_core]) from [<bf870d4c>] (sta_info_insert_rcu+0x418/0x61c [mac80211])
> [<bf870d4c>] (sta_info_insert_rcu [mac80211]) from [<bf88634c>] (ieee80211_add_station+0xf0/0x134 [mac80211])
> [<bf88634c>] (ieee80211_add_station [mac80211]) from [<bf83f3c4>] (nl80211_new_station+0x330/0x36c [cfg80211])
> [<bf83f3c4>] (nl80211_new_station [cfg80211]) from [<bf6c4040>] (extack_doit+0x2c/0x74 [compat])
> [<bf6c4040>] (extack_doit [compat]) from [<c05c285c>] (genl_rcv_msg+0x274/0x30c)
> [<c05c285c>] (genl_rcv_msg) from [<c05c1d98>] (netlink_rcv_skb+0x58/0xac)
> [<c05c1d98>] (netlink_rcv_skb) from [<c05c25d4>] (genl_rcv+0x20/0x34)
> [<c05c25d4>] (genl_rcv) from [<c05c1750>] (netlink_unicast+0x11c/0x204)
> [<c05c1750>] (netlink_unicast) from [<c05c1be0>] (netlink_sendmsg+0x30c/0x370)
> [<c05c1be0>] (netlink_sendmsg) from [<c0587e90>] (sock_sendmsg+0x70/0x84)
> [<c0587e90>] (sock_sendmsg) from [<c058970c>] (___sys_sendmsg.part.3+0x188/0x228)
> [<c058970c>] (___sys_sendmsg.part.3) from [<c058a594>] (__sys_sendmsg+0x4c/0x70)
> [<c058a594>] (__sys_sendmsg) from [<c0208c80>] (ret_fast_syscall+0x0/0x44)
> Code: ebfffec1 e1a04000 ea00001b e5953014 (e7940003)
> ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
> 
> Hardware tested: QCA9984
> Firmware tested: 10.4-3.6.0.1-00004
> 
> Fixes: a904417fc ("ath10k: add extended per sta tx statistics support")
> Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

553a7cca769d ath10k: fix kernel panic due to use after free

-- 
https://patchwork.kernel.org/patch/10675533/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

