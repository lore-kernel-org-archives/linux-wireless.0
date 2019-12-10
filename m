Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA3C00454
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 20:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFD720652
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 20:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfLJUew (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 15:34:52 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53710 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJUew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 15:34:52 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iemDa-0020w8-GF; Tue, 10 Dec 2019 21:34:50 +0100
Message-ID: <9e544414b0d0a2fad00628a757460ae2c9535dbe.camel@sipsolutions.net>
Subject: Re: intel ax200 not properly reinitialized on reboot
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Tue, 10 Dec 2019 21:34:48 +0100
In-Reply-To: <CAHmME9oykQsOXVeKdhToFjaHfPV6Ms6C450FYjUGh4nrOFBbtw@mail.gmail.com> (sfid-20191210_120515_139711_4C90489C)
References: <CAHmME9oykQsOXVeKdhToFjaHfPV6Ms6C450FYjUGh4nrOFBbtw@mail.gmail.com>
         (sfid-20191210_120515_139711_4C90489C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-12-10 at 12:05 +0100, Jason A. Donenfeld wrote:
> Hi,
> 
> I have a Thinkpad P1 gen 2 (same as X1 extreme gen 2), which has an
> AX200 -- 52:00.0 0280: 8086:2723 (rev 1a). Things mostly work, but
> I've noticed that after a reboot, the card stops working.
> Specifically, wpa_supplicant can't talk to it anymore. Or, sometimes
> it appears to drop off the bus completely. After doing a full
> poweroff+poweron (not a reboot), it works again.

How frequent is this for you? We had a bug report like this on some
other platform where it happens like ... 2-3% of the time?

[snip]

> I assume this is something to do with the bios not powercycling the
> pcie bus during reboot, leaving the card in some kind of inconsistent
> state. Perhaps it's possible to add a quirk to always powercycle it
> before initializing and loading firmware?

Good question, yeah.

Can you stick this info into a bug at bugzilla.kernel.org and add 
linuxwifi@intel.com to it? Or even add me personally since I've dealt
with the other report before.

I can't check the progress of the other report right now, but then I can
track it.

johannes

