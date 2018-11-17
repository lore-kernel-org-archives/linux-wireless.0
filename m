Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E65C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 02:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5985C2086B
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 02:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPKnr7XQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5985C2086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbeKQNLY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 08:11:24 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:40513 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbeKQNLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 08:11:23 -0500
Received: by mail-lj1-f170.google.com with SMTP id n18-v6so1003390lji.7
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2018 18:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JlLigIEsNMRUbimounGdcBvoKQ3Y4lYmA+4W42YllJA=;
        b=FPKnr7XQhU7XCNexQgM4ZNi7xSWi5QXvDt6CQ6cDcr8JlXvBGLEGPeyo3hqjWtytST
         kgT/lM89kBxuygszfRrXCm8WXxn5kRvpmjQyQQLf0TjIY1gAgFj4leX9Tlpy7lei1Mcd
         qb9qdy0ls4fSVyF2PmE+ypeT52zzXgPaDgXMzx2KsfuaccyPubb7jgzG39MnF7JAajrz
         Pesk/kiFQIZHnggXWIcJ1houeR9NkwQu2iq/hwBcGBk89PNay0MIo6IYPkTnIvgvoT5D
         bZs6Svic9nXraNOZKmJU87IKtrfNSC9HsQ9g3SgVpUOJq/MdAbo2z3BjqwTjzrPj/O3U
         kjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JlLigIEsNMRUbimounGdcBvoKQ3Y4lYmA+4W42YllJA=;
        b=K3DxO87LTL6PzLopkTmcS/1TMRbnHKqvv28xlOEgzlY/05IwYd3Ok8FrFHuoZe9fQo
         bYfHQKXaPybU/ceLYBn1uIjOaJJa07Udo6RrszLpYyoILK+nGKP1WZ/CGPckSawU9Tmh
         C8nwcJ1VaA0PU03LyaA1M1S/GHqmb+wP9Ssuj8HI+4MSe/rF6QBDsANGbrl+N+zVgNfh
         j1fq1KQXA/I2+N2K9+O1bKsT6Fz8wuJBKXetTlVgH6sebltwOzQIC1N4QeVfCciykknn
         vrIuM64EqUMb7c2tccTTSlXNB93bjD36w/CqvB9N2aG2aZ6xj/udIhtymw/ahmzY8U2j
         Y2XA==
X-Gm-Message-State: AGRZ1gITINzWKklXuaCHBNAaDwiIrVhVje2W2PBllMAkYGAJLKbAgmx0
        aNd1YyRP52X5X65USvEMojzUQhV2kOcvUJVYp9A91Ug5
X-Google-Smtp-Source: AJdET5d/hwNlcMY0J2Do8j1+2GLKHfVXqu1jvwpDNvAaydjDVE0aVGczIoLtgduImXysp09liWHVZu6vLrk5IdHmz80=
X-Received: by 2002:a2e:45d:: with SMTP id 90-v6mr7378391lje.110.1542423379180;
 Fri, 16 Nov 2018 18:56:19 -0800 (PST)
MIME-Version: 1.0
From:   Tom Gutteridge <thomas.gutteridge@gmail.com>
Date:   Sat, 17 Nov 2018 15:55:42 +1300
Message-ID: <CAHU9UF16g4ygW+mdfTBAchUYNhCa5x=vOXVRUh2+6xS5i8+9xg@mail.gmail.com>
Subject: Intel 8260 Firmware Init Failure
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

What can I do about this? My wireless card is unusable. Seems to be a
spontaneous failure. This is the output of dmesg | grep iwlwifi:

[    7.206387] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
[    7.215066] iwlwifi 0000:02:00.0: loaded firmware version
36.7596afd4.0 op_mode iwlmvm
[    7.686950] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
Wireless AC 8260, REV=0x208
[    7.769839] iwlwifi 0000:02:00.0: base HW address: 14:ab:c5:7c:5e:a2
[    7.770427] iwlwifi 0000:02:00.0: Microcode SW error detected.
Restarting 0x2000000.
[    7.770555] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[    7.770557] iwlwifi 0000:02:00.0: Status: 0x00000100, count: 6
[    7.770559] iwlwifi 0000:02:00.0: Loaded firmware version: 36.7596afd4.0
[    7.770561] iwlwifi 0000:02:00.0: 0x00001392 | ADVANCED_SYSASSERT
[    7.770562] iwlwifi 0000:02:00.0: 0x000002F2 | trm_hw_status0
[    7.770564] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
[    7.770565] iwlwifi 0000:02:00.0: 0x000124BE | branchlink2
[    7.770566] iwlwifi 0000:02:00.0: 0x0001C1E2 | interruptlink1
[    7.770568] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
[    7.770569] iwlwifi 0000:02:00.0: 0x0000010B | data1
[    7.770570] iwlwifi 0000:02:00.0: 0x00000000 | data2
[    7.770572] iwlwifi 0000:02:00.0: 0xDEADBEEF | data3
[    7.770573] iwlwifi 0000:02:00.0: 0x00000000 | beacon time
[    7.770574] iwlwifi 0000:02:00.0: 0x0000169F | tsf low
[    7.770576] iwlwifi 0000:02:00.0: 0x00000000 | tsf hi
[    7.770577] iwlwifi 0000:02:00.0: 0x00000000 | time gp1
[    7.770578] iwlwifi 0000:02:00.0: 0x0000169F | time gp2
[    7.770580] iwlwifi 0000:02:00.0: 0x00000009 | uCode revision type
[    7.770581] iwlwifi 0000:02:00.0: 0x00000024 | uCode version major
[    7.770583] iwlwifi 0000:02:00.0: 0x7596AFD4 | uCode version minor
[    7.770584] iwlwifi 0000:02:00.0: 0x00000201 | hw version
[    7.770585] iwlwifi 0000:02:00.0: 0x00489008 | board version
[    7.770587] iwlwifi 0000:02:00.0: 0x0010016A | hcmd
[    7.770588] iwlwifi 0000:02:00.0: 0x02322080 | isr0
[    7.770589] iwlwifi 0000:02:00.0: 0x00000000 | isr1
[    7.770591] iwlwifi 0000:02:00.0: 0x28201802 | isr2
[    7.770592] iwlwifi 0000:02:00.0: 0x004000C0 | isr3
[    7.770593] iwlwifi 0000:02:00.0: 0x00000000 | isr4
[    7.770595] iwlwifi 0000:02:00.0: 0x0010016A | last cmd Id
[    7.770596] iwlwifi 0000:02:00.0: 0x00000000 | wait_event
[    7.770598] iwlwifi 0000:02:00.0: 0x0000E45C | l2p_control
[    7.770599] iwlwifi 0000:02:00.0: 0x00001420 | l2p_duration
[    7.770600] iwlwifi 0000:02:00.0: 0x00000000 | l2p_mhvalid
[    7.770602] iwlwifi 0000:02:00.0: 0x00000000 | l2p_addr_match
[    7.770603] iwlwifi 0000:02:00.0: 0x0000000D | lmpm_pmg_sel
[    7.770604] iwlwifi 0000:02:00.0: 0x22040707 | timestamp
[    7.770606] iwlwifi 0000:02:00.0: 0x00000818 | flow_handler
[    7.770669] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
[    7.770670] iwlwifi 0000:02:00.0: Status: 0x00000100, count: 7
[    7.770672] iwlwifi 0000:02:00.0: 0x00000070 | ADVANCED_SYSASSERT
[    7.770673] iwlwifi 0000:02:00.0: 0x00000000 | umac branchlink1
[    7.770674] iwlwifi 0000:02:00.0: 0xC0086AA4 | umac branchlink2
[    7.770675] iwlwifi 0000:02:00.0: 0xC0083CB0 | umac interruptlink1
[    7.770677] iwlwifi 0000:02:00.0: 0xC0083C90 | umac interruptlink2
[    7.770678] iwlwifi 0000:02:00.0: 0x00000800 | umac data1
[    7.770679] iwlwifi 0000:02:00.0: 0xC0083C90 | umac data2
[    7.770682] iwlwifi 0000:02:00.0: 0xDEADBEEF | umac data3
[    7.770683] iwlwifi 0000:02:00.0: 0x00000024 | umac major
[    7.770684] iwlwifi 0000:02:00.0: 0x7596AFD4 | umac minor
[    7.770686] iwlwifi 0000:02:00.0: 0xC088628C | frame pointer
[    7.770687] iwlwifi 0000:02:00.0: 0xC088628C | stack pointer
[    7.770688] iwlwifi 0000:02:00.0: 0x0010016A | last host cmd
[    7.770690] iwlwifi 0000:02:00.0: 0x00000000 | isr status reg
[    7.770697] iwlwifi 0000:02:00.0: Failed to run INIT calibrations: -5
[    7.770699] iwlwifi 0000:02:00.0: Failed to run INIT ucode: -5

uname -a gives:
Linux tomg-p5510 4.19.1-1-MANJARO #1 SMP PREEMPT Sun Nov 4 16:05:34
UTC 2018 x86_64 GNU/Linux

This happened once before, about a year ago. It resolved itself when I
tried installing Windows 10 and running an update. Now when I try a
clean install of Windows 10 it bluescreens on startup with probable
cause Netwtw06.sys.

Thanks,
Tom.
