Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6994BECE58D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 06:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C05E218AC
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 06:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJIGpi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 02:45:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60560 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJIGpi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 02:45:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iI5iz-0005vw-Ew; Wed, 09 Oct 2019 08:45:29 +0200
Message-ID: <25d120fc154eb3da4185a3e82399cae97ba274f1.camel@sipsolutions.net>
Subject: Re: Potential uninitialized variables in cfg80211
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yizhuo Zhai <yzhai003@ucr.edu>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 09 Oct 2019 08:45:28 +0200
In-Reply-To: <CABvMjLQ0Qgzk74yg4quZG4CMKy8pb6pV3XGm_cg4NRkTiCHaKA@mail.gmail.com>
References: <CABvMjLQ0Qgzk74yg4quZG4CMKy8pb6pV3XGm_cg4NRkTiCHaKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-10-08 at 14:19 -0700, Yizhuo Zhai wrote:
> Hi All:
> net/wireless/chan.c:
> Inside function cfg80211_chandef_compatible(), variable "c1_pri40",
> " c2_pri40", "c1_pri80" and "c2_pri80" could be uninitialized if
> chandef_primary_freqs() fails. However, they are used later in the if
> statement to decide the control flow, which is potentially unsafe.

I guess theoretically this is right, but the function should only be
called with valid chandefs, and if chandef_primary_freqs() hit the
warning then the chandef certainly wasn't valid.

johannes

