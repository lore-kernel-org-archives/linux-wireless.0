Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A4DC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7706217D7
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeLRNFQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:05:16 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40774 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbeLRNFQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:05:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZF3i-0006M5-Lp; Tue, 18 Dec 2018 14:05:14 +0100
Message-ID: <898d521150250b33b9c1efa42e63efc4bf608e06.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Allow drivers to advertise supported AKM
 suites
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Veerendranath Jakkam <vjakkam@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 18 Dec 2018 14:05:13 +0100
In-Reply-To: <1542368582-3153-1-git-send-email-vjakkam@codeaurora.org>
References: <1542368582-3153-1-git-send-email-vjakkam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-16 at 17:13 +0530, Veerendranath Jakkam wrote:
> There was no such capability advertisement from the driver and thus the
> current user space has to assume the driver to support all the AKMs. While
> that may be the case with some drivers (e.g., mac80211-based ones), there
> are cfg80211-based drivers that have constraints on which AKMs can be used.
> Allow such drivers to advertise the exact set of supported AKMs so that
> user space tools can determine what network profile options should be
> allowed to be configured.

I think you need to explain here (and probably also in the docs) where
this actually matters. Clearly with drivers that do it all in userspace
it doesn't matter - so I guess it's intended for the offload cases?

Also, it'd be good to know which driver needs/implements this.

Finally,

> +		if (rdev->wiphy.akm_suites)
> +			if (nla_put(msg, NL80211_ATTR_AKM_SUITES,
> +				    sizeof(u32) * rdev->wiphy.n_akm_suites,
> +				    rdev->wiphy.akm_suites))
> +				goto nla_put_failure;

That's probably better written as a single if statement.

johannes

