Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F52EC433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22362230FC
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Jan 2021 12:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbhAVM6j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Jan 2021 07:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbhAVM6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jan 2021 07:58:38 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14B1C06174A;
        Fri, 22 Jan 2021 04:57:57 -0800 (PST)
Received: from zn.tnic (p200300ec2f0c15006a0f3bad299fee59.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1500:6a0f:3bad:299f:ee59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 73D101EC03E1;
        Fri, 22 Jan 2021 13:57:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611320275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0pY7e06EduD9wfMLJll3GyDKoPwVC4ON7p0l4ewku7k=;
        b=lX2Xi3xc/wQDEtcJpsAjPLPd9YveLEthCpvB0MUUPR+cAzgL8avh0eNpZZRKzFWsADcffk
        FBvQrJZXkfr2tx1A68xl9iT6IBwMWVIuUF9fZHJ6NfJ0j97eP7x7RJwHTyQ14SFXZOHVEL
        juIKXwV5mA7sKtYJBH7N6La7oXh69j4=
Date:   Fri, 22 Jan 2021 13:57:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: net/wireless/reg.c:144 suspicious rcu_dereference_check() usage!
Message-ID: <20210122125748.GH4867@zn.tnic>
References: <20210122101124.GE4867@zn.tnic>
 <20210122105034.GF4867@zn.tnic>
 <87v9bpb1t0.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87v9bpb1t0.fsf@codeaurora.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 22, 2021 at 02:20:43PM +0200, Kalle Valo wrote:
> Can you try this commit:
> 
> 51d62f2f2c50 cfg80211: Save the regulatory domain with a lock
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?id=51d62f2f2c50

Yap, that fixes both machines, thx!

Reported-by: Borislav Petkov <bp@suse.de>
Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
