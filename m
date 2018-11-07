Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78982C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 06:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367BD20827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 06:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rxcddNvQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 367BD20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbeKGQ0w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 11:26:52 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:41923 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeKGQ0w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 11:26:52 -0500
Received: by mail-io1-f47.google.com with SMTP id a5-v6so11169878ioq.8
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 22:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0IELcT49IvFHItm+t6x6Tq+Sn3Rcfv/Kp8UndQ/mgE=;
        b=rxcddNvQBBhfnfdWhCbD6HbDyhj8GKqtheDpI/kqJbTz15EkJucuRih5EJzxGk8R+C
         spa8gVlE/SAQTU/xfIxzaHHigl9LkQGTQ0QFlPGbExVR1cyq08XUUG9Axw4oHDMVY+Mn
         8xLQ/BAT7ZPhwTK8Ki5aRuV2f35MxMFh1MtINo1+LrP4THQEKsD5Douqa22GxAqY0EXb
         UkRSMfaDGGj+yU7d8OvRK3uBgbhmYvxOUrS46+ay/68Zyw+P7AvT5Ea+8C0rwdOLcH5I
         jHhB2pUGbhcAQuBUZSL6/pWgyunMXAhp6iT47h6RKrMEDh/M66HAgxpobFHDS5wAxtiZ
         XIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0IELcT49IvFHItm+t6x6Tq+Sn3Rcfv/Kp8UndQ/mgE=;
        b=TQqjO6uxQx6BSE3/ByuJSXblkivwqSX+tIMlBsGd8eYleh70bsZHoMhyH5ZKRnEDeN
         tNl+3mu8YsmxTfCzpWRpC6J4y1DBbAA7zaUgdVnmWVaiyYbXBhfaWh31H7v2uoizBB51
         8YsgJlLUgqEEAG5hVqoAUsswt42Mll06UAL92Me1a7E7nIKZp8FKbE5S5lnyOMYEYISb
         IGookMURMZdv8KA38MfcGcyz+f2iamwiv2OfczeOJ3HvIdW6FqduS2VKcXc7Dx+E58PK
         fJPCBoZJkHJDq/oEQmO+mHSgLBMB3i7rldKGIAgdCbDBHtLiQdgkU8QERa2CpKpND5br
         Iodg==
X-Gm-Message-State: AGRZ1gJ6c/zQwW3kmTp3rgCTbMu/NJqNc3fCHQSyH602AMRbtgS9bm2O
        4gbvNaE6FGhVpzrPOn3MNtNLya67X5w0GYftzARmZCOO
X-Google-Smtp-Source: AJdET5e+foYeJB7KQ1iqzSbgkaat3TlJSFC08CK8ObWgtit+VMU7m5UkfJWrxEJQrSuJwmhNlQ/4T6NLXB28V6cWbWM=
X-Received: by 2002:a5e:dc06:: with SMTP id b6-v6mr461107iok.237.1541573871705;
 Tue, 06 Nov 2018 22:57:51 -0800 (PST)
MIME-Version: 1.0
References: <20181107053439.GA2730@ping.localdomain>
In-Reply-To: <20181107053439.GA2730@ping.localdomain>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Wed, 7 Nov 2018 08:57:40 +0200
Message-ID: <CANUX_P12CoQtT8RzawXSC+VwzgHVuPTbrqyyEJYuX48PCJFMxg@mail.gmail.com>
Subject: Re: Intel 8265 iwlwifi broken recent linux-firmware
To:     petri@digip.org
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 7, 2018 at 7:36 AM Petri Lehtinen <petri@digip.org> wrote:
>
> Loading iwlwifi produces the following messages to dmesg. Trying to
> bring the wifi interface up also fails.
>
> [Tue Oct 23 07:17:12 2018] iwlwifi 0000:3a:00.0: loaded firmware version 36.7596afd4.0 op_mode iwlmvm
> [Tue Oct 23 07:17:12 2018] iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
> [Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: SecBoot CPU1 Status: 0x3040001, CPU2 Status: 0x0
> [Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: Failed to start INIT ucode: -110
> [Tue Oct 23 07:17:13 2018] iwlwifi 0000:3a:00.0: Failed to run INIT ucode: -110
>
> I'm on Arch Linux, and linux-firmware is built from commit d877533.
> With older firmware (commit f1b95fe), it works with this in dmesg
> output:
>
> [Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: enabling device (0000 -> 0002)
> [Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: loaded firmware version 36.e91976c0.0 op_mode iwlmvm
> [Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: Detected Intel(R) Dual Band Wireless AC 8265, REV=0x230
> [Tue Oct 23 07:28:51 2018] iwlwifi 0000:3a:00.0: base HW address: 00:28:f8:87:a2:e9
>

I checked the diff between e91976c0 and 7596afd4 and it is very very small.
Is your machine dual boot?
A few users have reported a race between BT firmware load and Wifi
firmware load. They also reported that booting in Windows, and then
shutting down in Windows helps to boot Linux properly.
If the above is not applicable, please open a bug in
bugzilla.kernel.org and add linuxwifi@intel.com to the bug.
Thank you.
