Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20193ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA95F204EC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MA1q9lWT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA95F204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbeJQVVl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:21:41 -0400
Received: from mail-ot1-f44.google.com ([209.85.210.44]:46458 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbeJQVVl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 17:21:41 -0400
Received: by mail-ot1-f44.google.com with SMTP id o21so26107868otb.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 06:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=snZitsOo5W5DOCgL0WkHMMnw02R1IrbgQSu5nD6+60I=;
        b=MA1q9lWTSRkL7kTcoY8UtLCev7e1Z2LHV6ywH9wCdERvQIQJmPPH26LKe9A5TZzoeA
         LUf69Krvi+oniVmR1ONgwnYn0M5zUKkcz5UndVCX/ercB4E842tqPwvApZUR7Fo3eH+e
         R8xKEsFPfCGQKQTXzh1BaATvBcLEV9/G8O9Req9sT4ykP5JKRm9jVR9SZGVbJjdvZ1gb
         mK9ZEoX+NkCBrWyE8Mrmkyz+mKmlpn9wnms0PR50bFQAbdFJtMMlvYpInxhliGXhd7yn
         /1q+Hd0zEGnxn+/NaWHtSqP6GBsjIDnoJCzfUovZ/auBc2RHv69E0JcT8cUR+05dxIPA
         ja9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=snZitsOo5W5DOCgL0WkHMMnw02R1IrbgQSu5nD6+60I=;
        b=p7QSfcAWvoA06ccw/4WrkK1Uk6PDUNZjLnm17AdeJWQGWdAhuxS3/pAKfD2QCvKMJ5
         ue6GKcVovIKneNqP7r+0BU/mog99C6Df+6QO/vXrf88M/7Is0cYfvR8fw6ArvKpHN7aE
         G9pIvuZcZcfhekECgYilgeZ1kbN0K7lgWvxBNoOKpi25E+GKvaKCDyJk69gI8KD/H0Hs
         NoJQL7F7o2URS0bh4wGVP7t4u0/oPA5Zy6+bzBkyxWUyFbc2Chdgg/xImVkgi1WMfyno
         FVfOWJdwUwoBqDCyDEtJKKImFVxuar6wn/OcKu2fsWJgoXFYXGqq0dHYEBqisDfeLJnJ
         KjSw==
X-Gm-Message-State: ABuFfogyXwc7wotuoOpXXhzrkKYF0B9NdKN6ee6oE2NenHf0v29FPktw
        HNgM8bLjPxDHtv4nBqq4poQKuKlvEHOGUkMEaQM=
X-Google-Smtp-Source: ACcGV62HNo8wfHUQ6gL8861X2hTvCwW9KLocpO4L1Turkp7UqZzpjPv86/tuz6JckbI3cRgwlS0jqin9jF9w5DRWAYA=
X-Received: by 2002:a9d:4d0a:: with SMTP id n10mr15514422otf.95.1539782759621;
 Wed, 17 Oct 2018 06:25:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 17 Oct 2018 06:25:58
 -0700 (PDT)
In-Reply-To: <20181016154957.GA8730@redhat.com>
References: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com> <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com> <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com> <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
 <20181016154957.GA8730@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 17 Oct 2018 15:25:58 +0200
Message-ID: <CAKR_QV+p_BP+xvqc65gHjm8t6fRNwfTRwKixCn7DN9+LjG-n3A@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hello
>
> On Tue, Oct 16, 2018 at 01:32:18PM +0200, Tom Psyborg wrote:
>> I am sending you two builds privately so please check if there are any
>> differences between the two builds and report back. Thanks.
>
> I extracted rt2800lib.ko module from provided images, did disassembly via:
>
> ./staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-objdump
> \
>  -d -r --prefix-addresses ~/rt2800lib-BUILDn.ko  > ~/BUILDn.dump.txt
>
> command and compered disassembled code. Here is difference:
>
> $ diff -up  BUILD1.dump.txt BUILD2.dump.txt
> --- BUILD1.dump.txt	2018-10-16 16:40:34.834220838 +0200
> +++ BUILD2.dump.txt	2018-10-16 16:40:40.187219211 +0200
> @@ -1,5 +1,5 @@
>
> -/home/stasiu/rt2800lib-BUILD1.ko:     file format elf32-tradlittlemips
> +/home/stasiu/rt2800lib-BUILD2.ko:     file format elf32-tradlittlemips
>
>
>  Disassembly of section .text:
> @@ -9374,7 +9374,7 @@ Disassembly of section .text:
>  00007f80 <rt2800_clear_beacon+0x224> jalr	v0
>  00007f84 <rt2800_clear_beacon+0x228> move	a0,s0
>  00007f88 <rt2800_clear_beacon+0x22c> lhu	v1,732(s0)
> -00007f8c <rt2800_clear_beacon+0x230> li	v0,21392
> +00007f8c <rt2800_clear_beacon+0x230> li	v0,25426
>  00007f90 <rt2800_clear_beacon+0x234> bne	v1,v0,0000810c
> <rt2800_clear_beacon+0x3b0>
>  00007f94 <rt2800_clear_beacon+0x238> li	a2,1025
>  00007f98 <rt2800_clear_beacon+0x23c> lw	v0,4(s0)
>
> There is no difference in init_registers (which is inlined in
> rt2800_enable_radio). The only difference is in some number
> rt2800_clear_beacon() function.
>
> Regards
> Stanislaw
>

i meant you try it on your nexx device. and post dmesg if you can boot them
