Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F7AC433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 17:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA52920714
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 17:52:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bteO1XAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgG0Rwl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Jul 2020 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgG0Rwk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Jul 2020 13:52:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85B5C061794
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2020 10:52:40 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id e64so17867122iof.12
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2020 10:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ZIBKd7Fu2spZ3xzL1XVsi2vrVh94b5wl6i6UoRYMUL4=;
        b=bteO1XAUh/VGzI/XQNP0m92BYse0uZMT1/4HdNJFk6p4tvqOpZUzy+2yeVN66rFXHK
         q3r5Fnjs4N7QLD809TrY4k9jsnxzie02/DqSZl+PUkyuJfd0Azp/BUyJckQZXFsPBNOI
         JHc8tnZZ4Z5Xi0ykuLMtOtvhbNPDmVIJt3dx3ho/zrcmKWPBXTIBbni/lDP3YpwQPc1n
         0p+QGuJ/zaCNmKFIlzjlP5O0A4Zja1YWIw9P+OzcLylV9G7yzWEIdeUwDt8GCt02yMvp
         1DEqXznaNb4TLul2bnXg/tN+cPxrmcABKkeREWKk0SY5IJ3NmUpDOEm+OR4zvs9E1+Jb
         dD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ZIBKd7Fu2spZ3xzL1XVsi2vrVh94b5wl6i6UoRYMUL4=;
        b=hoMbMSBQ7MuIQ8YS49PDrakqXIgtOWnF1EURRq3zmAQH0ccR1IxB2LmjAYM2oTcTPm
         Zh6Tmh5AAf0cLqiE89OZdO5tWnxRzvl61iBSaMgpTNnvhh9BM0lfWP0r7QZVIy86veaC
         hHtHPCnxajqL/iPjD3NVhMpMbhRN5LLi58t5oIf2t1oxzbDX7eVnc7k/DfIYDxw67OVS
         EybbC9qbIcEviyEW+7pz3Ot5k1EMZlqH8bhSwq3r8vyGMOkQbBc13/oNcsb3NH/P2mbz
         Bx9C8kJ8mypaBa/dkUyxjGQAHZ8SDJrZO+txh28BCOt/c0ofjgnf3gp6mFNKKR2FJlxU
         0LBQ==
X-Gm-Message-State: AOAM53155r3Z/1qf2Cmy/Ir2G2gw5ghNVYyoJ5bedhgW/smLDLEKjpc6
        90+l1EbE0L8xwLWOh1YE59xx8gTyKxDDH3ogwwFy+hkDUp4=
X-Google-Smtp-Source: ABdhPJza60sILMrGoiX+XUmWDDyPvRMUf6POugh7TthHVJS5uCkZM7vjGy52Me6ftjfgLGbkix2UjnTTJH5h0Tf3GBc=
X-Received: by 2002:a6b:b38a:: with SMTP id c132mr7548583iof.75.1595872360143;
 Mon, 27 Jul 2020 10:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUWoycCvAAs5H0sigHTB+GGhX5NRVonYqKg7BRLB97dGkA@mail.gmail.com>
 <87mu3magfp.fsf@tynnyri.adurom.net> <80afa796cefcc78f8a56059b279d6d424bc00d5e.camel@intel.com>
In-Reply-To: <80afa796cefcc78f8a56059b279d6d424bc00d5e.camel@intel.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 27 Jul 2020 19:52:36 +0200
Message-ID: <CA+icZUWAPsuPqWds9f95ZetbR1+CsK_rA36201bLy-JZfVM7EA@mail.gmail.com>
Subject: Re: iwlwifi: Direct firmware load for iwl-debug-yoyo.bin failed with
 error -2
To:     Luciano Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jul 27, 2020 at 8:22 AM Luciano Coelho <luciano.coelho@intel.com> wrote:
>
> On Sun, 2020-07-26 at 10:22 +0300, Kalle Valo wrote:
> > Sedat Dilek <sedat.dilek@gmail.com> writes:
> >
> > > Hi,
> > >
> > > I am seeing this failed/error message for a long time:
> > >
> > > [Sat Jul 25 13:03:28 2020] iwlwifi 0000:01:00.0: Direct firmware load
> > > for iwl-debug-yoyo.bin failed with error -2
> > >
> > > So, I started to look for the file "iwl-debug-yoyo.bin" in [1], but failed.
> > > AFAICS this is a file for debugging purposes?
> > >
> > > Why do I see such a message as an end-user w/o iwlwifi-debugging enabled?
> > > For some end-users I can imagine this looks scary and they will look
> > > into their cupboards and below their beds but will not find any
> > > monsters.
> > >
> > > I found a rename from an ini file to bin here:
> > > commit 8d9e982bf9bf ("iwlwifi: dbg_ini: rename external debug
> > > configuration file")
> > >
> > > Is "iwl-debug-yoyo.bin" a binary or as before an ini (text) file I
> > > have to configure somehow.
> > >
> > > Does this need to be guarded by some "ifdef CONFIG_IWLWIFI_DEBUG" in
> > > "drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c"?
> > >
> > > Or does drivers/net/wireless/intel/iwlwifi/Makefile needs some tuning
> > > - as said I have no iwlwifi debugging enabled via Kconfig?
> > > ...
> > > iwlwifi-objs            += iwl-dbg-tlv.o
> > >
> > > Please enlighten me/us?
> > >
> > > Thanks.
> > >
> > > Regards,
> > > - Sedat -
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/
> > > [2] https://git.kernel.org/linus/e8d9e982bf9bf0e6f99099f1f09a37563b2b95b5
> > >
> > > > From my dmesg-output:
> > >
> > > [Sa Jul 25 13:03:28 2020] iwlwifi 0000:01:00.0: can't disable ASPM; OS
> > > doesn't have ASPM control
> > > [Sa Jul 25 13:03:28 2020] iwlwifi 0000:01:00.0: loaded firmware
> > > version 18.168.6.1 6000g2b-6.ucode op_mode iwldvm
> > > [Sa Jul 25 13:03:28 2020] iwlwifi 0000:01:00.0: Direct firmware load
> > > for iwl-debug-yoyo.bin failed with error -2
> >
> > There's an RFC patch about this:
> >
> > https://patchwork.kernel.org/patch/11625759/
> >
> > I think that should be applied. Intel folks, should I take that directly
> > to wireless-drivers-next?
>
> As I wrote in the other thread, yes, please.  Go ahead and merge it.
>

Hey cool!

Thanks for taking care.

I have included this one into my Linux v5.8-rc7 patch-series.

Sorry, if I was a bit rude in my report.

Happy Monster hunting,
- Sedat -
