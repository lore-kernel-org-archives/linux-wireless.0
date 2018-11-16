Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00A7C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC032086B
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 13:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o9NA9BDz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LTdGydBY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DC032086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbeKPX2r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:28:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54160 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbeKPX2r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 18:28:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 644276035F; Fri, 16 Nov 2018 13:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542374185;
        bh=iLwhaHilaKyk+7nwQ7aKOrZlIUKmLzNkvPA+UE6CYvo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o9NA9BDzb8XRY75yJfTvWvKUZ/YxsSIXdmnNkrYgvQASkiBSTypTxl2uFPTwW6Hwz
         V2dWxnNAkdDmsrgRWiWAWsHGRoUWvr6aeACSzW847OBGqiJGqRQe6rXcvLqXVS3uHz
         JOVFSZ8uZG66v0Tv9e8EFHpVlcuRfyd1lJeUrop8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0EFBD60398;
        Fri, 16 Nov 2018 13:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542374184;
        bh=iLwhaHilaKyk+7nwQ7aKOrZlIUKmLzNkvPA+UE6CYvo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LTdGydBYBMJaK5xvTrnqGTvy3g0Uwd91MfkcNrUvzMg/OtkXgEnYaSizx6jBTBYGR
         e+bqZqkt74tNDujbT5S4gRRtY7lJrriPgndEHMOK0PsafWYq2JBN2U4ugISmJS6tjH
         b5CvRghseHjdSYuTw6W/5ARuouToEKGrUCNEfhI8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0EFBD60398
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mt76: fix uninitialized mutex access setting rts threshold
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1cfa6dca73f1d81595f061ded6275293c6e96b75.1541847014.git.lorenzo.bianconi@redhat.com>
References: <1cfa6dca73f1d81595f061ded6275293c6e96b75.1541847014.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181116131625.644276035F@smtp.codeaurora.org>
Date:   Fri, 16 Nov 2018 13:16:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

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
> Fixes: 108a4861ef19 ("mt76: create new mt76x02-lib module for common mt76x{0,2} code")
> Reported-by: lorenzo.trisolini@fluidmesh.com
> Reported-by: luca.bisti@fluidmesh.com
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers.git, thanks.

1770f0fa978e mt76: fix uninitialized mutex access setting rts threshold

-- 
https://patchwork.kernel.org/patch/10677055/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

