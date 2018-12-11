Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E02C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 21:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D379520672
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 21:51:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="oA8FYuCp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D379520672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbeLKVvH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 16:51:07 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36468 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbeLKVvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 16:51:06 -0500
Received: by mail-lf1-f68.google.com with SMTP id a16so11968883lfg.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 13:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdAdSJgDr5uxmkD2l2wOiBT8n2Xsft79duS0hn5Tteo=;
        b=oA8FYuCpeEwyi2D/k5hlMPrSspGlykP2Vd8byBTmUzuiDqgPgWQaFzD3isjicY8W4O
         a8zgCaiVOZRy32WBrZfsGud3IdlIrPFc51fA3o2BS+h6JTUB9VOAyo0OLF38+TKP+Tlo
         j2P6Pskcd2wW5Z0Fnz3RpZUJt8N5sYrvydWsvwiEZIJF115MLlzjKmpeTRS8VP00eVWE
         FwbXkP3O2Y6jAnuYGWUZM+lNjM4oR0e5ojzeYqUbe6XSQaXiQb72tpzRGF9OvevMHQH4
         4FFxV3gZHvW6HAkix+RvIKAt8SFHYzgs7hcq54dSQ+YFB3GQlASbEsrlrOQUxZlGzNq9
         5ZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdAdSJgDr5uxmkD2l2wOiBT8n2Xsft79duS0hn5Tteo=;
        b=FnPT9cMbQ70cQkj7d0J5pIXeB97GznZy/Tj0GKDpqZxcKnJxCGKmgq26yQEg2sjFA5
         2lKNzhwVZhYNDU7PmN5QWydOBpMft+onkGp0Gnm46dqvr3OutGbtPv5RnL7GfOC+GVOo
         tsPu1t4a/KVR2QlsA4wt8rZyg0yt2Dr77gZ4CM3HZPDX+lhAxKD2J6nL6HvmMBmVdOQZ
         8SI535qedA6eKlQyDlIRZEJbXlYf3xVnDUssy5Gcmafm52cBq4h4aYUD459jeVVcr7fp
         ICzWbr/eNb3PUBPJ8MM24IUCiIBT2ICFz1SWUjAHxhz5lyXuxZtmR7lVSjLVER5/7BLp
         JzHA==
X-Gm-Message-State: AA+aEWb4Uo224kHbNzIUdLFiI0pi7ytRwFZD+r7496c1NN2QlbrfKfG2
        btBgr2/T96FxL7TvxUP2fhVIGAeVGZSdqsIPwSFFSA==
X-Google-Smtp-Source: AFSGD/VENKxaGK8xJWegDn97m67UQdrlDrd8IEsRnbBBrPI62NOmM38kL5IESakiuc57sTDdkjBcfrdjf8DjjmzpRQg=
X-Received: by 2002:a19:ced3:: with SMTP id e202mr10234856lfg.13.1544565063426;
 Tue, 11 Dec 2018 13:51:03 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
In-Reply-To: <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 19:50:26 -0200
Message-ID: <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 6:23 PM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> And now with while true:
> Dec 11 20:18:13 hikey kernel: wlcore: mac80211 configure filter
> changed 0 total 80000000
> Dec 11 20:18:13 hikey kernel: wlcore: waking up chip from elp
> Dec 11 20:18:13 hikey kernel: wlcore: wakeup time: 8 ms
> Dec 11 20:18:13 hikey kernel: wlcore: acx group address tbl
> Dec 11 20:18:13 hikey kernel: wlcore: cmd configure (63)
> Dec 11 20:18:13 hikey kernel: wlcore: mac80211 remove interface
> Dec 11 20:18:13 hikey kernel: wlcore: down
> Dec 11 20:18:13 hikey kernel: wlcore: cmd role disable
> Dec 11 20:18:13 hikey kernel: wlcore: IRQ work
> Dec 11 20:18:13 hikey kernel: wlcore: mac80211 stop
> Dec 11 20:18:13 hikey kernel: wlcore: intr: 0x20 (fw_rx_counter = 0,
> drv_rx_counter = 0, tx_results_counter = 0)
> Dec 11 20:18:13 hikey kernel: wlcore: WL1271_ACX_INTR_HW_AVAILABLE
>
> Dec 11 20:18:13 hikey kernel: wlcore: mac80211 start
> Dec 11 20:18:13 hikey kernel: wlcore: mac80211 add interface type 2
> mac 84:dd:20:92:54:5b
> Dec 11 20:18:13 hikey kernel: wlcore: allocating hw queue base: 0
> Dec 11 20:18:13 hikey kernel: wlcore: clock freq 5 (13, 120, 0, 0, spit)
> Dec 11 20:18:13 hikey kernel: wlcore: chip id 0x6030111
> Dec 11 20:18:13 hikey kernel: wlcore: firmware chunks to be uploaded: 15
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 14 addr 0x0 len 120432
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 120432 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x000000002d8a6a40 to 0x0
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x0000000048dff62f to 0x4000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000f9372750 to 0x8000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000f2685ee4 to 0xc000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000c4fc484d to 0x10000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000a6d3c9bf to 0x14000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x000000007404dc0f to 0x18000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (5744 B)
> 0x00000000d7beb1f6 to 0x1c000
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 13 addr 0x100000 len 131072
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 131072 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000c3cad69f to 0x100000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000a9e4f338 to 0x104000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x000000003169e0a1 to 0x108000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000cc5b7549 to 0x10c000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x000000009c0bb98a to 0x110000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000f4d0b2c2 to 0x114000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x0000000026e1d203 to 0x118000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000a3905e9c to 0x11c000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (0 B)
> 0x00000000f0c022b6 to 0x120000
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 12 addr 0x20400000 len 52600
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 52600 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x000000004f52801e to 0x20400000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x0000000066503358 to 0x20404000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000433fff1b to 0x20408000
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (3448 B)
> 0x00000000a38c9bd9 to 0x2040c000
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 11 addr 0xb00000 len 536
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 536 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (536 B)
> 0x00000000ced82f93 to 0xb00000
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 10 addr 0xb0ae40 len 28120
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 28120 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x00000000d6832925 to 0xb0ae40
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw last chunk (11736
> B) 0x0000000037ae96d5 to 0xb0ee40
> Dec 11 20:18:13 hikey kernel: wlcore: chunk 9 addr 0x80900000 len 61140
> Dec 11 20:18:13 hikey kernel: wlcore: starting firmware upload
> Dec 11 20:18:13 hikey kernel: wlcore: fw_data_len 61140 chunk_size 16384
> Dec 11 20:18:13 hikey kernel: wlcore: uploading fw chunk
> 0x0000000096b9ba67 to 0x80900000 -------> hangs
>
> See the missing 'mmc_host mmc2' messages, which probably indicates
> that mmc_host wasn't properly set after the down/up sequence, causing
> the hang when uploading the firmware.

Tried to change back wl12xx_sdio_power_off to use pm_runtime_put_sync
as a test, and noticed I always get -EBUSY when reproducing the hang,
so it looks like this could be a race between pm_runtime_put/get when
doing if down/up (and the side effect on the mmc controller).

Cheers,
-- 
Ricardo Salveti de Araujo
