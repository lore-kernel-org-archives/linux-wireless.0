Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B379DC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 20:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72F922080D
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 20:15:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sc3T4Eyf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72F922080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbeKRGdb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Nov 2018 01:33:31 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:56309 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725732AbeKRGdb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Nov 2018 01:33:31 -0500
Received: by mail-it1-f194.google.com with SMTP id o19so2864891itg.5
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2018 12:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0dOivDaUuur9wC1ER7awNHOGf++CwsX7INSQEbaC9U=;
        b=sc3T4EyfZ4XZSJ6lplfQ6qhgfnIBbw/bAtDIvBrrz7/ESgQTps2nzKfiqhA5L8bClz
         5TZ5Ci3PMt+O4iQMoFb06M3CAhlZlMPOcxs/EXvQLYk6XL25n8YdC4rSJmYZqFpLOhAu
         5udkcgKEB67VWav3mc3CASyZef+ErnU6s7H98nTN3NT7yZ/qk9faEv2kZd0zlUZJGHHV
         yj0hyxZn7YIbVLhR3bD/Vhrk9g/5OAOy9DTc7cToX8xA8rmkSS3HmYh5vHLpmAIvVSXW
         C2BsjYv5rJS7qVmgrB8LFv+lOEvuoxq61Uz/I3N2QZ0jehnt0FVZaK4PqAmJvuuGJIyV
         JrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0dOivDaUuur9wC1ER7awNHOGf++CwsX7INSQEbaC9U=;
        b=bO0EMiBpGv2NszKcqi5n2rtFVz0w73EW5L3EQQ9hQBiup5vFTJqYytu+tuUOxTusQm
         NuHvzgcKnAYZlqGxUwTYF0EMUtCnt6RF5n0Oz5Dp3nJulvR5JErxb7G66PuueFMcTMgm
         Ojq6+BBhaWOeGL+xsNMTDsugeDF4KdhroloSIaEaQkOTgoKevU4RbnH0bwuUE33ry0iy
         qsGyMnW+lL+eJjES/TaumdvBnkxXG3bxAGLamfMaiqMnyCYecWbR/Fqzm2HO6X4D2pkl
         jlDo5M3Taz1j/d62tUdd7FGC8Jtg58imN/diYuOpsUSjTH3+Kc1OIdASs4Xmq8cn+9WW
         7ViQ==
X-Gm-Message-State: AGRZ1gKmzAr7Pw1fv7ajw2Kwb0BJvUBkVXM6jJjoVkqlUps/gMzqrklN
        VU7ws71hjjF/xvI9ErvEKvXBYjETZsm0exXZHwo=
X-Google-Smtp-Source: AJdET5fdo/noWXyCncL5ltTFj696x8cZpyqSBs9gn3nN7xyR9AhYt0lJhkosj+4Cdz5fVXmlGTIuM7TRdJg2jlIiFws=
X-Received: by 2002:a02:d2:: with SMTP id 201-v6mr13967676jaa.19.1542485742104;
 Sat, 17 Nov 2018 12:15:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHU9UF16g4ygW+mdfTBAchUYNhCa5x=vOXVRUh2+6xS5i8+9xg@mail.gmail.com>
In-Reply-To: <CAHU9UF16g4ygW+mdfTBAchUYNhCa5x=vOXVRUh2+6xS5i8+9xg@mail.gmail.com>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Sat, 17 Nov 2018 22:15:28 +0200
Message-ID: <CANUX_P0a+Tw1tUh_Bbk6H5zY3Lusa7R0W568+yajeLUEKO=jZA@mail.gmail.com>
Subject: Re: Intel 8260 Firmware Init Failure
To:     thomas.gutteridge@gmail.com
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> What can I do about this? My wireless card is unusable. Seems to be a
> spontaneous failure. This is the output of dmesg | grep iwlwifi:
>
> [    7.206387] iwlwifi 0000:02:00.0: enabling device (0000 -> 0002)
> [    7.215066] iwlwifi 0000:02:00.0: loaded firmware version
> 36.7596afd4.0 op_mode iwlmvm
> [    7.686950] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band
> Wireless AC 8260, REV=0x208
> [    7.769839] iwlwifi 0000:02:00.0: base HW address: 14:ab:c5:7c:5e:a2
> [    7.770427] iwlwifi 0000:02:00.0: Microcode SW error detected.
> Restarting 0x2000000.
> [    7.770555] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> [    7.770557] iwlwifi 0000:02:00.0: Status: 0x00000100, count: 6
> [    7.770559] iwlwifi 0000:02:00.0: Loaded firmware version: 36.7596afd4.0
> [    7.770561] iwlwifi 0000:02:00.0: 0x00001392 | ADVANCED_SYSASSERT
> [    7.770562] iwlwifi 0000:02:00.0: 0x000002F2 | trm_hw_status0
> [    7.770564] iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
> [    7.770565] iwlwifi 0000:02:00.0: 0x000124BE | branchlink2
> [    7.770566] iwlwifi 0000:02:00.0: 0x0001C1E2 | interruptlink1
> [    7.770568] iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
> [    7.770569] iwlwifi 0000:02:00.0: 0x0000010B | data1
> [    7.770570] iwlwifi 0000:02:00.0: 0x00000000 | data2
> [    7.770572] iwlwifi 0000:02:00.0: 0xDEADBEEF | data3

Report of bug on bugzilla.kernel.org as explained here:
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

From what I see this is a bug in calibrations. Not fun.

>
> This happened once before, about a year ago. It resolved itself when I
> tried installing Windows 10 and running an update. Now when I try a
> clean install of Windows 10 it bluescreens on startup with probable
> cause Netwtw06.sys.
>

Even less fun. When you want to compare this to any other problem you have seen,
please check the ASSERT number. In this case, you have ASSERT 1392.
