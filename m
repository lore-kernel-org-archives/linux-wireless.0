Return-Path: <SRS0=Y9Fe=V4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A2EC433FF
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 09:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC26D20449
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 09:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGaJcT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Jul 2019 05:32:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55570 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfGaJcT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jul 2019 05:32:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hskxy-0004id-Ue; Wed, 31 Jul 2019 11:32:15 +0200
Message-ID: <3bb50da3442446a76f7ef59c4d53a7c349b87524.camel@sipsolutions.net>
Subject: Re: [PATCHv6 5/9] nl80211: Add netlink attribute to configure TID
 specific tx rate
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 31 Jul 2019 11:32:14 +0200
In-Reply-To: <1560835632-17405-6-git-send-email-tamizhr@codeaurora.org>
References: <1560835632-17405-1-git-send-email-tamizhr@codeaurora.org>
         <1560835632-17405-6-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


>  /**
> + * enum nl80211_tx_rate_setting - TX rate configuration type
> + * @NL80211_TX_RATE_AUTOMATIC: automatically determine TX rate
> + * @NL80211_TX_RATE_LIMITED: limit the TX rate by the TX rate parameter
> + * @NL80211_TX_RATE_FIXED: fix TX rate to the TX rate parameter
> + */
> +enum nl80211_tx_rate_setting {
> +	NL80211_TX_RATE_AUTOMATIC,
> +	NL80211_TX_RATE_LIMITED,
> +	NL80211_TX_RATE_FIXED,
> +};

I'm not really quite sure how LIMITED it supposed to work?

I mean, I could imagine all kinds of limits ...

 * limit to anything <= the given rate in kbps
 * limit to anything with long GI
 * limit to NSS <= given NSS
 * limit to MCS <= given MCS

etc.

I guess you could find a <= comparison for each dimension of the various
parameters, and then if you don't want that particular one limited you
give the maximum? Still not really clear to me how that should work.

Also, would it be allowed to pass an invalid rate? Like something like
"100Mbps legacy rate" when that's certainly not valid? You have no
validation on this, so for LIMITED that might still seem useful (per my
first bullet point above) but for anything else ... not so much?

johannes

