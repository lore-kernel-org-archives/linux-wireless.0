Return-Path: <SRS0=Fjak=U3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339F2C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 10:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0693620656
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Jun 2019 10:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfF1Ktn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Jun 2019 06:49:43 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46932 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfF1Ktn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jun 2019 06:49:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hgoRo-00079l-SE; Fri, 28 Jun 2019 12:49:40 +0200
Message-ID: <ce0a3c9a6b2743dd49398f91a3b1404504ba7294.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] iwlwifi: Extended Key ID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, luca@coelho.fi
Date:   Fri, 28 Jun 2019 12:49:39 +0200
In-Reply-To: <7a173bac-37d2-b470-8cb6-0f7e41e26ca5@wetzel-home.de>
References: <20190506190149.3624-1-alexander@wetzel-home.de>
         <20190506190149.3624-2-alexander@wetzel-home.de>
         <7a173bac-37d2-b470-8cb6-0f7e41e26ca5@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, 2019-06-26 at 23:10 +0200, Alexander Wetzel wrote:
> > iwlwifi cards are all able to support Extended Key ID as long as
> > mac80211 stops A-MPDU aggregation when replacing the unicast key.
> > 
> > Enable Extended Key ID support and tell mac80211 that it has to tear
> > down any running Tx aggregation sessions during rekey when using
> > Extended Key ID.
> 
> With the merge of the A-MPDU handling patch 
> https://patchwork.kernel.org/patch/10931861/ we probably should simplify 
> the API for Extended Key ID and not merge the patch as it is:
> 
> 1) We can drop EXT_KEY_ID_NATIVE from mac80211 and let the drivers set
>     NL80211_EXT_FEATURE_EXT_KEY_ID instead of mac80211.
>     Without the COMPAT support the naming is off and the flag is simply
>     pointless. Assuming we want to pick up the COMPAT Extended Key ID we
>     still can just define a new flag, e.g.
>     SINGLE_STA_UNICAST_KEY_OFFLOAD_ONLY to tell mac80211 it can only
>     have one unicast key active in the HW per STA.

Yes, true, with the compat more or less off the table for now, we don't
really need this extra complexity.

> 2) Mac80211 would then enable Extended Key ID for all drivers using SW
>     crypto and just also set NO_AMPDU_KEYBORDER_SUPPORT when the driver
>     supports A-MPDU

Right (or not really set the flag, but get rid of it?), though maybe
some (rare) driver would actually support ampdu keyborder? Ath9k for
example could do that since it builds the aggregates in software, so I
guess we'd need some flag indicating the opposite then.

> 3) we then could undo (revert?) cfe7007a9b4c ("mac80211_hwsim: Extended
>     Key ID support") and let the more generic code in mac80211 handle it
> 
> If you agree I'll prepare and test a small patch series for that.
> And we better only merge a iteration of this patch here once we got the 
> API updated.

Sounds good to me!

johannes

