Return-Path: <SRS0=MKuk=4M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF792C38BFA
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 21:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC82D20838
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Feb 2020 21:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgBXVfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Feb 2020 16:35:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47388 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXVfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Feb 2020 16:35:51 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6LOE-007mWS-Pi; Mon, 24 Feb 2020 22:35:46 +0100
Message-ID: <685a6b65ed480fc6edc151eafb4445f5d1884bd0.camel@sipsolutions.net>
Subject: Re: [PATCH v4 6/7] rtw88: Add wowlan pattern match support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Chris Chiu <chiu@endlessm.com>
Date:   Mon, 24 Feb 2020 22:35:45 +0100
In-Reply-To: <CA+ASDXPP31bXpjvYz=hbR_WmwbXb77NRodgSThcxnDgME5vFJg@mail.gmail.com> (sfid-20200224_223408_581404_6B6EE4CF)
References: <20191219085816.20709-1-yhchuang@realtek.com>
         <20191219085816.20709-7-yhchuang@realtek.com>
         <20200222005242.GA100360@google.com>
         <d7c4c85ca707118a612a34607b4980b2448f2059.camel@sipsolutions.net>
         <CA+ASDXPP31bXpjvYz=hbR_WmwbXb77NRodgSThcxnDgME5vFJg@mail.gmail.com>
         (sfid-20200224_223408_581404_6B6EE4CF)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-02-24 at 13:33 -0800, Brian Norris wrote:
> 
> > if not, IMHO better to add some
> > advertisement bits, but if not then we can surely add some kind of
> > filter callback that's invoked at config time, rather than only at
> > suspend time when it's way too late to do anything about it.
> 
> Yeah, I'd have to see what sort of restrictions we're working with --
> sufficiently complex rules might not make for good "advertisement"
> bits.

Agree. And we've certainly gotten better at spelling out what exactly
when wrong since all this started - the "extended ACK" bits I wrote that
can include an error message and can point to the bad attribute still
feel sort of new to me, even if we've had them for a few years :)

So if we end up going with a callback, we should probably include an
extack pointer for the driver to fill up ...

johannes

