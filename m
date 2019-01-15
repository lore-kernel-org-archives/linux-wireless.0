Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7619FC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4894220651
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfAONA0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:00:26 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbfAONA0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:00:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOKM-00079x-L1; Tue, 15 Jan 2019 14:00:22 +0100
Message-ID: <9a3f1cf7577caa808e42092c5fc69c54bf3abe36.camel@sipsolutions.net>
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Denis Kenzior <denkenz@gmail.com>, Jouni Malinen <j@w1.fi>,
        Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Tue, 15 Jan 2019 14:00:21 +0100
In-Reply-To: <d5599cf9-5fb4-a68d-dfd9-0d10a6758ae2@broadcom.com> (sfid-20190115_000428_971002_08CD2B9E)
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
         <20190103154921.GA25015@w1.fi>
         <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
         <1cefde13-3fcf-47b7-1c3a-e44a2901ddea@gmail.com>
         <0490b8fa-bf8c-c76c-1367-70d0f4e3845f@broadcom.com>
         <206b5ae1-7fcf-9078-8399-2a8f9ff6c211@gmail.com>
         <d5599cf9-5fb4-a68d-dfd9-0d10a6758ae2@broadcom.com>
         (sfid-20190115_000428_971002_08CD2B9E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> > Maybe this is a question for Johannes as well, but define 'user-space 
> > applications'?  If that includes wpa_s, wasn't the rule of thumb broken 
> > with that commit?
> 
> In my previous reply I wanted to add that it would be hard to proof that 
> no user-space applications are using the API. Not sure exactly when 
> things were added in wpa_s, but I suspect it was 
> post-commit-503c1fb98ba3 so it did not have support for the user-space 
> API before the commit.

I don't know about this really.

My thought at the time likely was that if there's no driver implementing
it, no userspace could've existed? Or maybe that just wasn't true, and I
got confused?

In any case, it certainly wasn't an intentional API break.

> > > > - What happens if userspace does send an EAPoL-Start in the middle of 
> > > > an offloaded 4-way handshake?
> > > 
> > > Probably those would be dropped.
> > > 
> > 
> > I would love to have something more definitive than 'Probably', and it 
> > might be worth mentioning this hint in the documentation somewhere.
> 
> I was hesitant to use that word, but decided to do so simply because I 
> can not speak for every driver and even for the brcmfmac driver that I 
> maintain I will need to look into the firmware to be sure. I agree that 
> a remark of that possibility is worth adding.

I don't really know if we should really cover all possible error
scenarios like that?

johannes

