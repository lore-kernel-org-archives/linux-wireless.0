Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8A4C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46F42175B
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lwD8PEF9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QLjEFl5H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46F42175B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbeKLPm0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:42:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbeKLPm0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:42:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1A93C60881; Mon, 12 Nov 2018 05:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542001845;
        bh=fEzGA5j7wWwfxY0zBInZfZfIiupiLosxUttLXtacg34=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lwD8PEF9aKiW7Hnb01/lOml3XomONgSbtCibYYZ6Xi/j3Xa82JEks8zRQPyPnFLsz
         VTlSagCqKPC7gpx0v253vqa9usxFiGP6dzTjjAIa1IqugIUYo22HM6KrWgdYOzlvl5
         fK2J5iGZ2pVZycQCSdybDr1XGy2cUvD4yzHndhNE=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B1B9960795;
        Mon, 12 Nov 2018 05:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542001844;
        bh=fEzGA5j7wWwfxY0zBInZfZfIiupiLosxUttLXtacg34=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QLjEFl5Hq/G8FFk4GAdVSvwcp8a5+eN70y8BvkkA2HH2MRUQ1o6Ebh/WHYyKecHhW
         YN74C4Zmwd1c4g7FA7VimF4HywnY8b0MmkeDgFGhjBe1AJEi9TgYiHjeli7khGw4Re
         QlaII7SuqANLcTMq6QFKxk3HHw+dndPFZEcQr3zA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B1B9960795
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mt76: fix uninitialized mutex access setting rts threshold
References: <cover.1541847014.git.lorenzo.bianconi@redhat.com>
        <1cfa6dca73f1d81595f061ded6275293c6e96b75.1541847014.git.lorenzo.bianconi@redhat.com>
Date:   Mon, 12 Nov 2018 07:50:41 +0200
In-Reply-To: <1cfa6dca73f1d81595f061ded6275293c6e96b75.1541847014.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Sat, 10 Nov 2018 12:03:09 +0100")
Message-ID: <87tvkmalou.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Fix following crash due to a leftover uninitialized mutex access
> in mt76x2_set_rts_threshold routine.
>
> [   31.018059] Call Trace:
> [   31.018341]  register_lock_class+0x51f/0x530
> [   31.018828]  __lock_acquire+0x6c/0x1580
> [   31.019247]  lock_acquire+0x88/0x120
> [   31.021089]  __mutex_lock+0x4a/0x4f0
> [   31.023343]  mt76x2_set_rts_threshold+0x28/0x50
> [   31.023831]  ieee80211_set_wiphy_params+0x16d/0x4e0
> [   31.024344]  nl80211_set_wiphy+0x72b/0xbc0
> [   31.024781]  genl_family_rcv_msg+0x192/0x3a0
> [   31.025233]  genl_rcv_msg+0x42/0x89
> [   31.026079]  netlink_rcv_skb+0x38/0x100
> [   31.026475]  genl_rcv+0x1f/0x30
> [   31.026804]  netlink_unicast+0x19c/0x250
> [   31.027212]  netlink_sendmsg+0x1ed/0x390
> [   31.027615]  sock_sendmsg+0x31/0x40
> [   31.027973]  ___sys_sendmsg+0x23c/0x280
> [   31.030414]  __sys_sendmsg+0x42/0x80
> [   31.030783]  do_syscall_64+0x4a/0x170
> [   31.031160]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   31.031677] RIP: 0033:0x7f3498b39ba7
> [   31.033953] RSP: 002b:00007fffe19675b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [   31.034883] RAX: ffffffffffffffda RBX: 00000000012d5350 RCX: 00007f3498b39ba7
> [   31.035756] RDX: 0000000000000000 RSI: 00007fffe19675f0 RDI: 0000000000000003
> [   31.036587] RBP: 00000000012da740 R08: 0000000000000002 R09: 0000000000000000
> [   31.037422] R10: 0000000000000006 R11: 0000000000000246 R12: 00000000012da880
> [   31.038252] R13: 00007fffe19675f0 R14: 00007fffe19678c0 R15: 00000000012da880
>
> Fixes: 108a4861ef19 ("mt76: create new mt76x02-lib module for common
> mt76x{0,2} code")
> Reported-by: lorenzo.trisolini@fluidmesh.com
> Reported-by: luca.bisti@fluidmesh.com
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

This should be v2, but no need to resend.

> This patch is for 4.20

Ok, I'll queue this for that release.

-- 
Kalle Valo
