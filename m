Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7DBC07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8E4220851
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 18:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="MqgnFa8Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8E4220851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbeLKSGl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 13:06:41 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:45158 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeLKSGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 13:06:41 -0500
Received: by mail-lj1-f169.google.com with SMTP id s5-v6so13785282ljd.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 10:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aBRR6MBvyG2lR5ouAla33iKBy8Zt0HmxTq1ZBaO3rrM=;
        b=MqgnFa8Yn0UgUonMQXjyioYalOfshw+XeV+45fY6jsjYQzagqIG9TAIANqa1FE5u5P
         HSBInEfjKuqsM2Qg/GmQRYrHASq5Y2Vb2Oj5knCVZ6XcRkvIhE/zMfIA6VjjM9X9Kg28
         Mp7A49XywfMr8wyQbymQk2fZF2TZxul0kugMedKBEgD8XfqZCQGwoXRP8JCbumOWQSmc
         PQqGug6WiFnTCDNHY7r7sU9JWjEGFyWxQs+fHiZuh2gIg+QZI3+SDCY0PiiUtcTHTHUu
         MMc6WdveviljeWUG/EhjPnwTYpSXFm17O9NTtivI/a0aHcxI+N3R0usTWyt9ozY3PYGr
         E8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aBRR6MBvyG2lR5ouAla33iKBy8Zt0HmxTq1ZBaO3rrM=;
        b=rN1xSXlRw4xmdf4fqJN9VTF83/47dXsbtj0DkM81HhMyNAwE8DqzrNH+QZWgjveGZ1
         ZD9tK6MvhnIAlG4Fh9MWR1ZrGS12uvJKpU73rXhFpnAtbAiW9qn+q4Rc4JUHnA5Ui3/7
         X95i9MMqgK5g4q5fwRKkWI/oUlNTv9RhbI4c4ZYCsYhVSSwrUUSH6b7l0I64Yb4xmyr1
         qNvsNg+J3DEInpSfRfAR88NsgME0519YFRVQm1wtlRrVJo1RA+fmx+ttphrVBrxuSdPv
         oJCOe/B0fA2kwSFBG0YeOAy9GquS5iuTG9dTsTv5jEfI3StjootyHEkzc5p240/7Txt5
         rWzA==
X-Gm-Message-State: AA+aEWafLQkm0pgai6UjN634bmYigSBNV3TW/StoYKHol7LjfMUyP+Vd
        uj9nF7FNurdsiqHOOISgHp77gr2bhWYrrIbAgd4phCJEKIA=
X-Google-Smtp-Source: AFSGD/UHpTKgjGVWQBVxr30OlZNgEm2oYMf1yUej+Rf6eT6uyfKxNwmkMDAq/wqP9MZtsIlBY1Lh+n4T6w3mOwnXAqY=
X-Received: by 2002:a2e:9a56:: with SMTP id k22-v6mr10330753ljj.17.1544551598635;
 Tue, 11 Dec 2018 10:06:38 -0800 (PST)
MIME-Version: 1.0
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 16:06:01 -0200
Message-ID: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
Subject: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     linux-wireless@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, john.stultz@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hey Tony and John,

I just got to test an OpenEmbedded-based rootfs with kernel
4.19/4.20-rc6 on a HiKey board and wlcore is constantly getting stuck
right after boot (via NetworkManager).

As this works just fine with 4.18, I did a quick bisect and found that
the patch that enables runtime PM autosuspend support (9b71578de0) is
the one that made the hang to happen.

The hang trace with 4.20-rc6:
[  484.321030] INFO: task NetworkManager:599 blocked for more than 120 seconds.
[  484.328324]       Not tainted 4.20.0-rc6 #1
[  484.334057] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  484.342182] NetworkManager  D    0   599      1 0x00000008
[  484.347724] Call trace:
[  484.350200]  __switch_to+0xa0/0xf8
[  484.353647]  __schedule+0x2ac/0x948
[  484.357158]  schedule+0x38/0x98
[  484.360318]  schedule_timeout+0x288/0x458
[  484.364368]  wait_for_common+0x148/0x170
[  484.368310]  wait_for_completion+0x28/0x38
[  484.372430]  mmc_wait_for_req_done+0x38/0x198
[  484.376806]  mmc_wait_for_req+0xb0/0xf0
[  484.380664]  mmc_io_rw_extended+0x1d0/0x2c0
[  484.384866]  sdio_io_rw_ext_helper+0x180/0x1f8
[  484.389356]  sdio_memcpy_toio+0x44/0x58
[  484.393216]  wl12xx_sdio_raw_write+0xe0/0x1b0
[  484.397596]  wlcore_boot_upload_firmware+0x1a8/0x4c0
[  484.402582]  wl18xx_boot+0x7dc/0xbc0
[  484.406181]  wl1271_op_add_interface+0x558/0x910
[  484.410842]  drv_add_interface+0x5c/0x1e8
[  484.414876]  ieee80211_do_open+0x220/0x7f8
[  484.418992]  ieee80211_open+0x4c/0x68
[  484.422697]  __dev_open+0xdc/0x158
[  484.426119]  __dev_change_flags+0x15c/0x1c0
[  484.430326]  dev_change_flags+0x34/0x70
[  484.434198]  do_setlink+0x28c/0xba8
[  484.437709]  rtnl_newlink+0x408/0x768
[  484.441392]  rtnetlink_rcv_msg+0x12c/0x338
[  484.445510]  netlink_rcv_skb+0x60/0x120
[  484.449365]  rtnetlink_rcv+0x28/0x38
[  484.452961]  netlink_unicast+0x194/0x210
[  484.456902]  netlink_sendmsg+0x1a0/0x348
[  484.460847]  sock_sendmsg+0x34/0x50
[  484.464354]  ___sys_sendmsg+0x288/0x2c8
[  484.468234]  __sys_sendmsg+0x7c/0xd0
[  484.471814]  __arm64_sys_sendmsg+0x2c/0x38
[  484.475932]  el0_svc_common+0x94/0xe8
[  484.479635]  el0_svc_handler+0x74/0x90
[  484.483405]  el0_svc+0x8/0xc

Since it seems the same driver and board combination is working fine
for John (with Android), I decided to take a look at what could be
causing this from the NetworkManager side and found that the MAC
address randomization during scan is what triggers the hang. If I
disable MAC address randomization in NetworkManager
(wifi.scan-rand-mac-address=no) it works fine, so I wonder if there is
a possible suspend/resume logic issue with the if up -> change mac ->
scan flow.

John, did you have any similar issue on your test environment with
kernel >= 4.19?

I'm still trying to isolate this issue without NetworkManager to see
what exactly is causing the hang, but wanted to report this first in
case you guys have any idea about what could be causing the hang.

Thanks,
-- 
Ricardo Salveti de Araujo
