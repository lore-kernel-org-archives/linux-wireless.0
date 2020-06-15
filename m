Return-Path: <SRS0=Zavp=74=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8980C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jun 2020 19:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86DF920739
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jun 2020 19:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgFOTIO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jun 2020 15:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgFOTIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jun 2020 15:08:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A49EC061A0E
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2020 12:08:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jkuSp-005rlT-Sh; Mon, 15 Jun 2020 21:08:12 +0200
Message-ID: <09f3b573ad96ca14e374a6f29c43998235081f3f.camel@sipsolutions.net>
Subject: Re: Regulatory Rule Matching for Adjacent Rules
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>,
        linux-wireless@vger.kernel.org
Date:   Mon, 15 Jun 2020 21:08:10 +0200
In-Reply-To: <36c2778e-d2bb-b048-8cc3-21cfa0643c23@tu-ilmenau.de> (sfid-20200611_155537_650478_4D96F99F)
References: <36c2778e-d2bb-b048-8cc3-21cfa0643c23@tu-ilmenau.de>
         (sfid-20200611_155537_650478_4D96F99F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> In the current implementation in net/wireless/reg.c a channel is only then
> allowed if it falls into a regulatory rule which allows it. Channel 144
> (5710–5730 MHz)
> in Germany could possibly be allowed, but lies in the union of the
> frequency ranges of two
> adjacent reg. rules.
> 
>         (5470 - 5725 @ 160), (N/A, 26), (0 ms), DFS
>         (5725 - 5875 @ 80), (N/A, 13), (N/A)
> 
> It would therefore be necessary, to combine two adjacent rules correctly. The resulting channel definition
> would therefore be limited to 13dBm, 80 MHz and has to use DFS. Should the regulatory code be altered to 
> allow for such checks or do I understand this completely wrong?

Hmm. Yeah. Somehow, I actually thought we did this?! How did this work?
Or did we just always hack around it by aligning the regdb with the
wireless channelisation?

No objection to fixing that in the reg code, I think.

johannes

