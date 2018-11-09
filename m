Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F678C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 207122081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 207122081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbeKIVot (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:44:49 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57076 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbeKIVot (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:44:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5WW-0004AA-AA; Fri, 09 Nov 2018 13:04:28 +0100
Message-ID: <0322ee25650343fffdcf3fef19cda9090af117fc.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: Add support to notify radar event info
 received from STA
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 13:04:27 +0100
In-Reply-To: <1539940356-1335-1-git-send-email-srirrama@codeaurora.org>
References: <1539940356-1335-1-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-19 at 14:42 +0530, Sriram R wrote:
[...]

This looks fine, but I think it would be nice to have some extended
netlink error reporting for at least some of these errors:

> +	dfs_region = reg_get_dfs_region(wiphy);
> +	if (dfs_region == NL80211_DFS_UNSET)
> +		return -EINVAL;
> +
> +	err = nl80211_parse_chandef(rdev, info, &chandef);
> +	if (err)
> +		return err;
> +
> +	err = cfg80211_chandef_dfs_required(wiphy, &chandef, wdev->iftype);
> +	if (err < 0)
> +		return err;
> +
> +	if (err == 0)
> +		return -EINVAL;
> +
> +	/* Do not process this notification if radar is already detected
> +	 * by kernel on this channel
> +	 */
> +	if (chandef.chan->dfs_state == NL80211_DFS_UNAVAILABLE)
> +		return -EINVAL;

And maybe that last one should just return 0?

johannes

