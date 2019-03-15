Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71881C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 431CD21872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbfCOJrr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:47:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58940 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfCOJrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 05:47:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h4jRJ-0006Km-E3; Fri, 15 Mar 2019 10:47:45 +0100
Message-ID: <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
Subject: Re: preparing for 802.11ah channels
From:   Johannes Berg <johannes@sipsolutions.net>
To:     thomas pedersen <thomas@ibsgaard.io>,
        linux-wireless@vger.kernel.org
Date:   Fri, 15 Mar 2019 10:47:44 +0100
In-Reply-To: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com> (sfid-20190217_004534_756976_DFBF3123)
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
         (sfid-20190217_004534_756976_DFBF3123)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-02-16 at 15:45 -0800, thomas pedersen wrote:
> Hello,
> 
> I'm working on defining new channels for S1G PHYs in mac80211. These
> are in the 900MHz range and center frequency for the 1MHz channels are
> on a half MHz, while the existing channel definitions are in units of
> MHz.

Yay... :)

> In order to support the new channels we could change the internal
> center frequency units to KHz and extend the nl80211 API so
> NL80211_FREQUENCY_ATTR_FREQ and NL80211_ATTR_WIPHY_FREQ get _KHZ
> variants while renaming the original attributes to _MHZ to reflect the
> units.

The nl80211 API seems straightforward, yeah.

> From looking at the code it looks like this should be fairly
> straightforward, if involving a lot of changes since the driver
> declarations would have to change too. Am I missing something
> obviously wrong, or does this sound reasonable?

I'm not sure I agree about all the driver changes being straightforward.
In theory yes, but ... ;-)

I guess you'd define a new band (NL80211_BAND_S1G or something?), so
perhaps there's a way we can get away with doing it only on that band?

OTOH, I guess if you change center_freq1 to center_freq1_khz or
something then you compile-fail everywhere ...

johanne

