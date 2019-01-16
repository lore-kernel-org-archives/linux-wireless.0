Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA00C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F36720651
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfAPQU5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:20:57 -0500
Received: from shell.v3.sk ([90.176.6.54]:57295 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728673AbfAPQU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:20:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 5E4AD5463E;
        Wed, 16 Jan 2019 17:20:54 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id N7cuLZZXUFEn; Wed, 16 Jan 2019 17:20:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 1A764546E7;
        Wed, 16 Jan 2019 17:20:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id m436mE0HnzWB; Wed, 16 Jan 2019 17:20:51 +0100 (CET)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 2FFF65463E;
        Wed, 16 Jan 2019 17:20:51 +0100 (CET)
Message-ID: <a82a40694727e90b851789d5a0a8334fd526c4c7.camel@v3.sk>
Subject: Re: [PATCH] libertas: remove ifdef OLPC noise
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Jan 2019 17:20:50 +0100
In-Reply-To: <87zhs04mhr.fsf@codeaurora.org>
References: <20190116151618.1972197-1-lkundrak@v3.sk>
         <87zhs04mhr.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-01-16 at 18:04 +0200, Kalle Valo wrote:
> Lubomir Rintel <lkundrak@v3.sk> writes:
> 
> > <asm/olpc.h> provides machine_is_olpc() stub for CONFIG_OLPC=n,
> > compiler should just optimize the unneeded bits away.
> > 
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > ---
> >  drivers/net/wireless/marvell/libertas/if_usb.c | 10 ----------
> >  1 file changed, 10 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
> > index 220dcdee8d2b..7b61c599948e 100644
> > --- a/drivers/net/wireless/marvell/libertas/if_usb.c
> > +++ b/drivers/net/wireless/marvell/libertas/if_usb.c
> > @@ -12,9 +12,7 @@
> >  #include <linux/usb.h>
> >  #include <linux/olpc-ec.h>
> >  
> > -#ifdef CONFIG_OLPC
> >  #include <asm/olpc.h>
> > -#endif
> 
> Using asm directory looked odd to me so I did some investigation:
> 
> $ find -name olpc.h
> ./arch/x86/include/asm/olpc.h
> 
> Did you build this on something else than x86? For example, will the
> compiler find olpc.h when building for arm?

Uh, no. You're right, this indeed breaks on non-x86.

Perhaps olpc-ec.h should provide something that could tell whether the
EC is available that could be used instead of machine_is_olpc(), or the
olpc.h moved outside arch/x86.

For now, please just ignore the patch..

Lubo

