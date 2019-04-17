Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD3AC10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 03:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B874C20835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 03:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQQ8mtFd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfDQDwW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 23:52:22 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40965 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfDQDwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 23:52:21 -0400
Received: by mail-oi1-f194.google.com with SMTP id v7so18868093oie.8
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 20:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cRnmPF2KSnssJznjGw0h9BIy/gmtMEvHMD1jb6AT59k=;
        b=MQQ8mtFd67N35cs45aPMSXXRnDLOf485wBjLg8pXVPqhuCZc7+23UyN+Ef0MXd0noD
         7/Fbw3R+q7ocM7yCwlq6trPoqrqmRYuvpuMey9YBQwTsqvtrDbWSfrT/qsuO4KeGTJKt
         lUerO8kJ1OjNSjWIwZ/jMxq5GtbCTmX9hQltiZXD7HyZAEm8aRBYNWXCSgShD0PG57Hp
         hBXaaCqPYVxw7mfqvWvbhhb2lYeiKhyyF1MhVKOSBso2xqRgRfRVvg1pV6V2gFlwo1g6
         re5v81Urn314a6QaZZmVzOKVo3lvwnjBgZcD9y+3VKHBx8Ki5Sfb3LzHhIIQCHXwAS/B
         JHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cRnmPF2KSnssJznjGw0h9BIy/gmtMEvHMD1jb6AT59k=;
        b=e2iMMjU3taT3yJifLKx3uZfUxMpA+htG1dJ4/DVgLjY8X8iTbM/iySrFYaVSziv/dt
         75OKFtAeSQ3Nn5r0JXYPSDJvApdJ9+aFGW1ZVwsCyysL0rwz6QA9TldfJchEfWrq/F+Q
         ybHxLLhXIwu2Gk8AdmrOix5aPK7qBmk8BqBVtcV/Tb3whe5L4FZp7k/KD6ItqysUmkKU
         GSAyq36sTZgpriOf0BBKj74jnty39SknQi+VxxeGxHKU4NjBF/sskjJfnjmTPRyxdExa
         mBTNO+IGjmOdmdzdX/eQhs2lDIc5oO58VJH1/0ZpnntUoKAqhbi0EG/MVlljXUUjBmXY
         pNlw==
X-Gm-Message-State: APjAAAWhftp7W1kAK+0hHomfJUerKGto3DuJrE/DRHymeXv8ssutigh2
        iHTBjz35WsgQXijjREnr+zUIEmNO6rI/ilcYfJ03oH0V
X-Google-Smtp-Source: APXvYqzs8kNcupKDZjVFc0+VV/rnBbFuhe/bFzVfPKChNfsuLwwEMg4XNWiPHdJbFzuYfbysIYGy/XQa/K+JtTdhaFQ=
X-Received: by 2002:aca:5757:: with SMTP id l84mr1266282oib.155.1555473140889;
 Tue, 16 Apr 2019 20:52:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Tue, 16 Apr 2019 20:52:20
 -0700 (PDT)
In-Reply-To: <3337086.qEUs9xMCTV@debian64>
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com> <3337086.qEUs9xMCTV@debian64>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 17 Apr 2019 05:52:20 +0200
Message-ID: <CAKR_QVKvg3O19gz6zQRrcCjK=k=hvdmL4pys2KkQxAYAHs2qQQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: reset chip after supported check
To:     linux-wireless <linux-wireless@vger.kernel.org>
Cc:     openwrt-devel@lists.openwrt.org,
        Ben Greear <greearb@candelatech.com>,
        =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These replies never reached my inbox. Anyway scraped conversation off
the mailing list archive and CCing relevant people.

>> >>> Can you elaborate more a bit? What kind of crashes are you seeing?
>> >>> What does the bootloop look like? Do you have uart connected to
>> >>> diagnose?
>> >>>
>> >>> Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
>> >>> by ath10k? I recall the v1 chip was really buggy and required
>> >>> hammering registers sometimes to get things working.
>> >>
>> >> The crash is related to the v1 chip.  Is there a good way to detect
>> >> that this is the chip in question and only apply this work-around
>> >> for the problem chip?

yes there is. but the provided solution should be enough. which device
really depend on reset to probe sueccesfully? that device need other
fixes!

>> >
>> > I don't know of any good way to do that.
>> >
>> > You could consider device-tree but that would be no different from
>> > having a module blacklist in the C7v1 build recipe, or to not build
>> > the module at all. That is unless you actually want to make v1 chip
>> > work with ath10k at which point there's more fun to be had before it
>> > can actually work.

this is also intention. can it work with v2.0 fw?

>>
>> I remember v1, and I have no interest in trying to make it work :)
>>
>> If we could blacklist certain pci slots in the ath10k driver, I guess
>> that would work?
>>
>> I think the goal is to not use the v1 chip, but allow users to add a
>> v2 NIC to the platform, so driver still needs to load.
>
>That makes sense, but I don't see how blacklisting pci slots would
>help someone putting v2 nic into C7v1 mobo? Won't the slot be the same
>regardless what nic is put?
>
>The best thing I can come up with is something like this:
>
>--- a/drivers/net/wireless/ath/ath10k/pci.c
>+++ b/drivers/net/wireless/ath/ath10k/pci.c
>@@ -3629,6 +3629,19 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>                goto err_deinit_irq;
>        }
>
>+       if (hw_rev =3D=3D ATH10K_HW_QCA988X) {
>+               /* v1 can crash the system on chip_reset()
>+                * so all we can do is keep our fingers
>+                * crossed v2 never reports 0 without a
>+                * chip_reset()
>+                */
>+               if (ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS) =3D=3D =
0) {
>+                       ath10k_err(ar, "qca9880 v1 is chip not supported")=
;
>+                       ret =3D -ENOTSUP;
>+                       goto err_free_irq;
>+               }
>+       }
>+
>        ret =3D ath10k_pci_chip_reset(ar);
>        if (ret) {
>                ath10k_err(ar, "failed to reset chip: %d\n", ret);
>
>I didn't test it. Someone needs to compile and test and make sure v2
>doesn't regress when fw hangs and cold & warm host cpu resets are
>mixed in.
>
>
>Micha=C5=82

this doesn't even fix the bootloop with v1
