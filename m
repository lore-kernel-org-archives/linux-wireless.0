Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688AFC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3217C20879
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UzyiEEeL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3217C20879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbeLKTOL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:14:11 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39091 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeLKTOK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:14:10 -0500
Received: by mail-wm1-f53.google.com with SMTP id f81so3444114wmd.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 11:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8VRbGAeUQJ8CiFWlkSMBhKqw+Mm8j1QNixQS8Ews0YA=;
        b=UzyiEEeL0p/vYpVfwEoa7mD2MaEwv4yBxAwRrbNsQKyzmM26OmYFxPDZDzEm8S1WZ0
         LvFfGthbubkP6lgnKcDllex16r93WS+PxYy+pm50QBBoaNFl4IYxKsLqkR6A0jCMxq95
         eBTGHLTRoKN+4TD6dDHB9+ZQcTHZNtEvqBDOM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VRbGAeUQJ8CiFWlkSMBhKqw+Mm8j1QNixQS8Ews0YA=;
        b=QlzCqP+ku2yy9PxgbnlfHChJWH7iEzskSziUDUF3MXmduCCM0MtMsvUME1rE1cvPtr
         vrZz9tsElZluaoOB6yt0/x7IQzSjV5MNfYsA05P7S96kGMQtHTa1yC44D9JEzgMN43x6
         uGTQgjUd2SAB6+LsVWCcrKSvD1GUeJ6UQYFKfUij1zzAzdt0RBUSGJw12gz7B4iOTEMn
         2Smugsv2SnnbKPUFAeDFckYzDQyR4mLhUejyioaNZS/4QmmjRNwOqBZMAbnOjRs3918K
         mDEEHmP8/1nnlPtVJNSllXnqu9U2xv8SvmTi92P7kIPOh04HF0QwddTD3AUkw2Wryq4U
         N19A==
X-Gm-Message-State: AA+aEWahhzTTMFjiaRUDg8zDcQje+IOSnG92NrMVbeVo/V4ALv+1vDqB
        nHPk0P5IilQzpNKJk9WPBS+Fcqw4TrtmpL9hYX3juA==
X-Google-Smtp-Source: AFSGD/WJUzpbObbxOwH5ITpx6jsU1BDgxj15zA6Ln5/Tl/zT0DbN6Qoy6D8ekTcAtasY0Spi9TGxDJyFS8p4clG2xzk=
X-Received: by 2002:a1c:1f81:: with SMTP id f123mr3262090wmf.64.1544555648624;
 Tue, 11 Dec 2018 11:14:08 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
In-Reply-To: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 11 Dec 2018 11:13:56 -0800
Message-ID: <CALAqxLW7q=1JLe4RiDxAyeGZ36KDp93dPcj6ny9EW6ZSJe2hjw@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     rsalveti@rsalveti.net
Cc:     linux-wireless@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 10:06 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
>
> Hey Tony and John,
>
> I just got to test an OpenEmbedded-based rootfs with kernel
> 4.19/4.20-rc6 on a HiKey board and wlcore is constantly getting stuck
> right after boot (via NetworkManager).
>
> As this works just fine with 4.18, I did a quick bisect and found that
> the patch that enables runtime PM autosuspend support (9b71578de0) is
> the one that made the hang to happen.
>
> The hang trace with 4.20-rc6:
> [  484.321030] INFO: task NetworkManager:599 blocked for more than 120 seconds.
> [  484.328324]       Not tainted 4.20.0-rc6 #1
> [  484.334057] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  484.342182] NetworkManager  D    0   599      1 0x00000008
> [  484.347724] Call trace:
> [  484.350200]  __switch_to+0xa0/0xf8
> [  484.353647]  __schedule+0x2ac/0x948
> [  484.357158]  schedule+0x38/0x98
> [  484.360318]  schedule_timeout+0x288/0x458
> [  484.364368]  wait_for_common+0x148/0x170
> [  484.368310]  wait_for_completion+0x28/0x38
> [  484.372430]  mmc_wait_for_req_done+0x38/0x198
> [  484.376806]  mmc_wait_for_req+0xb0/0xf0
> [  484.380664]  mmc_io_rw_extended+0x1d0/0x2c0
> [  484.384866]  sdio_io_rw_ext_helper+0x180/0x1f8
> [  484.389356]  sdio_memcpy_toio+0x44/0x58
> [  484.393216]  wl12xx_sdio_raw_write+0xe0/0x1b0
> [  484.397596]  wlcore_boot_upload_firmware+0x1a8/0x4c0
> [  484.402582]  wl18xx_boot+0x7dc/0xbc0
> [  484.406181]  wl1271_op_add_interface+0x558/0x910
> [  484.410842]  drv_add_interface+0x5c/0x1e8
> [  484.414876]  ieee80211_do_open+0x220/0x7f8
> [  484.418992]  ieee80211_open+0x4c/0x68
> [  484.422697]  __dev_open+0xdc/0x158
> [  484.426119]  __dev_change_flags+0x15c/0x1c0
> [  484.430326]  dev_change_flags+0x34/0x70
> [  484.434198]  do_setlink+0x28c/0xba8
> [  484.437709]  rtnl_newlink+0x408/0x768
> [  484.441392]  rtnetlink_rcv_msg+0x12c/0x338
> [  484.445510]  netlink_rcv_skb+0x60/0x120
> [  484.449365]  rtnetlink_rcv+0x28/0x38
> [  484.452961]  netlink_unicast+0x194/0x210
> [  484.456902]  netlink_sendmsg+0x1a0/0x348
> [  484.460847]  sock_sendmsg+0x34/0x50
> [  484.464354]  ___sys_sendmsg+0x288/0x2c8
> [  484.468234]  __sys_sendmsg+0x7c/0xd0
> [  484.471814]  __arm64_sys_sendmsg+0x2c/0x38
> [  484.475932]  el0_svc_common+0x94/0xe8
> [  484.479635]  el0_svc_handler+0x74/0x90
> [  484.483405]  el0_svc+0x8/0xc
>
> Since it seems the same driver and board combination is working fine
> for John (with Android), I decided to take a look at what could be
> causing this from the NetworkManager side and found that the MAC
> address randomization during scan is what triggers the hang. If I
> disable MAC address randomization in NetworkManager
> (wifi.scan-rand-mac-address=no) it works fine, so I wonder if there is
> a possible suspend/resume logic issue with the if up -> change mac ->
> scan flow.
>
> John, did you have any similar issue on your test environment with
> kernel >= 4.19?
>
> I'm still trying to isolate this issue without NetworkManager to see
> what exactly is causing the hang, but wanted to report this first in
> case you guys have any idea about what could be causing the hang.

So this sounds very much like an issue Anders (cc'ed) was seeing in
the lab but not elsewhere. I think he had narrowed down to a similar
commit (my memory is foggy), but I think he hadn't isolated the
behavior to send details to the list.

I've not come across it myself, as the Android environment doesn't
seem to tickle this.

thanks
-john
