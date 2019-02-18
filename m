Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0EAC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 08:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C93E218C3
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 08:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="G+CQ1d97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbfBRIKI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 03:10:08 -0500
Received: from mail.skyhub.de ([5.9.137.197]:40574 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfBRIKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 03:10:07 -0500
Received: from zn.tnic (p200300EC2BC7C70041AEC7F500F46BD2.dip0.t-ipconnect.de [IPv6:2003:ec:2bc7:c700:41ae:c7f5:f4:6bd2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CBD2F1EC03D8;
        Mon, 18 Feb 2019 09:10:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1550477406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9a6fjGS1nnOT3qGqL3lsM6PvXgQzae+pAQOqUgOc4Yg=;
        b=G+CQ1d97BYbTIdAX4LHo7po9bHF7pqBMcV8hLvpqh49CelC6zZwa2op8J7ogUROkvABEDk
        SNNuqCMsjQJWRnFpERqnSYY97UaPYebNXM+wpNuu/0Ar80FtfzMBxRgQS8cpt+Xu3/mi58
        qclD6qBE9j0ENd1vGU/UJrSkG2tV77c=
Date:   Mon, 18 Feb 2019 09:09:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: disable CONFIG_GENERIC_HWEIGHT and remove
 __HAVE_ARCH_SW_HWEIGHT
Message-ID: <20190218080949.GA4265@zn.tnic>
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
 <1550469571-25933-3-git-send-email-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1550469571-25933-3-git-send-email-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 02:59:31PM +0900, Masahiro Yamada wrote:
> arch/x86/include/asm/arch_hweight.h uses __sw_hweight{32,64} as
> alternatives, but they are implemented in arch/x86/lib/hweight.S
> 
> x86 does not rely on the generic C implementation lib/hweight.c
> at all, so CONFIG_GENERIC_HWEIGHT should be disabled.
> 
> __HAVE_ARCH_SW_HWEIGHT was unneeded in the first place.

Well, it was needed because I didn't think of removing the selection of
GENERIC_HWEIGHT in arch/x86/ at the time:

ld: lib/built-in.o:/dev/shm/bpetkov/kernel/linux/lib/hweight.c:27: multiple definition of `__ksymtab___sw_hweight32'; arch/x86/built-in.o:/dev/shm/bpetkov/kernel/linux/arch/x86/kernel/x8664_ksyms_64.c:47: first defined here
ld: lib/built-in.o:/dev/shm/bpetkov/kernel/linux/lib/hweight.c:67: multiple definition of `__ksymtab___sw_hweight64'; arch/x86/built-in.o:/dev/shm/bpetkov/kernel/linux/arch/x86/kernel/x8664_ksyms_64.c:48: first defined here
ld: arch/x86/lib/built-in.o: in function `__sw_hweight32':
/dev/shm/bpetkov/kernel/linux/arch/x86/lib/hweight.S:12: multiple definition of `__sw_hweight32'; lib/built-in.o:/dev/shm/bpetkov/kernel/linux/lib/hweight.c:15: first defined here
ld: arch/x86/lib/built-in.o: in function `__sw_hweight64':
/dev/shm/bpetkov/kernel/linux/arch/x86/lib/hweight.S:38: multiple definition of `__sw_hweight64'; lib/built-in.o:/dev/shm/bpetkov/kernel/linux/lib/hweight.c:53: first defined here
make: *** [vmlinux] Error 1

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
