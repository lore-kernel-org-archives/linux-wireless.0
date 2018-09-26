Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD68C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22A121480
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C22A121480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbeIZPfT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 11:35:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38782 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbeIZPfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 11:35:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g562O-00014H-9g; Wed, 26 Sep 2018 11:23:16 +0200
Message-ID: <1537953785.28767.7.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211: Fix possible Spectre-v1 for CQM RSSI
 thresholds
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Masashi Honma <masashi.honma@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 26 Sep 2018 11:23:05 +0200
In-Reply-To: <1537841701-3092-2-git-send-email-masashi.honma@gmail.com> (sfid-20180925_041523_318542_824D1A43)
References: <1537841701-3092-1-git-send-email-masashi.honma@gmail.com>
         <1537841701-3092-2-git-send-email-masashi.honma@gmail.com>
         (sfid-20180925_041523_318542_824D1A43)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-09-25 at 11:15 +0900, Masashi Honma wrote:
> Use array_index_nospec() to sanitize i with respect to speculation.

I applied the first patch in the seies, but I don't understand why this
patch should be necessary.

The value of i isn't controlled by the user, so it shouldn't need to be
sanitized?

The context was *just* missing, added by me:

        for (i = 0; i < n; i++)
>  		if (last < wdev->cqm_config->rssi_thresholds[i])
>  			break;

This loop determines i, and the user doesn't even control "last", but
even if they did, the possible values of i could only end up being in
the range 0..n-1, so no problems?

johannes
