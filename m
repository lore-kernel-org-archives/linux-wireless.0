Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7649C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1209218D3
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfCVUqr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 16:46:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33790 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfCVUqq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 16:46:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h7R3s-0006HA-Vv; Fri, 22 Mar 2019 21:46:45 +0100
Message-ID: <3ae333867edab6cc30e8154cce47ce3b4555fa43.camel@sipsolutions.net>
Subject: Re: preparing for 802.11ah channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     thomas <thomas@ibsgaard.io>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Mar 2019 21:46:43 +0100
In-Reply-To: <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com> (sfid-20190322_214016_716142_79489C2C)
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
         <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
         <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com>
         (sfid-20190322_214016_716142_79489C2C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-22 at 13:40 -0700, thomas wrote:
> 
> > OTOH, I guess if you change center_freq1 to center_freq1_khz or
> > something then you compile-fail everywhere ...
> 
> Yeah it gets ugly quick to have additional freq_khz members,
> especially when doing comparisons etc.
> 
> The kernel part was not too bad, there are only 3 structs or so to
> worry about. hostap on the other hand is incredibly hairy :)

We/I thought about this some more now at the wifi summit, and I think
the better choice would be to just add a "u32 fractional;" part where
needed.

In effect, an existing

	u32 freq;

would become

	u32 freq, freq_fractional;

and we'd just treat the two as a 32.32 fixed point integer. Maybe even
just do "u8 freq_fractional" since a 32.8 fixed point integer would be
sufficient (we do need >64k MHz for WiGig, so doing 16.16 or 16.8 won't
work).

That would have the advantage of not requiring any changes from drivers
that don't need to support it. It would also cover some of the 4.9 GHz
stuff Jouni looked up - it as fractional center frequencies too (at
least expressed in MHz).

For userspace API I'm not really sure, maybe we should just move to KHz?
Or maybe just do the same thing? On the one hand, moving to KHz would be
cleaner in a sense, but on the other hand it would require doing things
like checking that the KHz and MHz attributes agree if both are given,
etc., so similarly adding a "fractional MHz" attribute might be nicer
since we can also assume it to be 0 if not present (in fact, we could
*reject* it if it's 0, thereby ensuring that it'll only ever be nonzero)

johannes

