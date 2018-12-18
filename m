Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D02CC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3683F217D8
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbeLRNMa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:12:30 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40834 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbeLRNM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:12:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZFAg-0006Wx-SB; Tue, 18 Dec 2018 14:12:27 +0100
Message-ID: <89e6532daf4011de2ad0df3dcb8accc42334f31e.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211/cfg80211: Add support to send tx frames at
 specified rate
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsi krishna <vamsin@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Tue, 18 Dec 2018 14:12:23 +0100
In-Reply-To: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
References: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-12-03 at 17:34 +0530, vamsi krishna wrote:
> NL80211_CMD_FRAME is used to send frames from userspace. Add support to
> transmit the frames at a rate specified by userspace when needed.
> The drivers shall indicate the support to send frames at rate specified
> by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
> wiphy capabilities. The userspace can specify the rate within
> %NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
> 
> NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
> attributes defined in &enum nl80211_rate_info.

It'd be good if you were to repost this with a driver that uses it.

Also, please explain why you think userspace needs this? It's not like
it can make better rate decisions than the rate control algorithm,
right?

>  	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
> +	[NL80211_ATTR_RATE_INFO] = { .type = NLA_NESTED },

This should use NLA_POLICY_NESTED(nl80211_rate_info_policy)

johannes

