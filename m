Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C84C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD404217D7
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfAYMs6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:48:58 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56778 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYMs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:48:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0um-0000q3-1Q; Fri, 25 Jan 2019 13:48:56 +0100
Message-ID: <5d479aabc632550097f67ded37a32a9d61685098.camel@sipsolutions.net>
Subject: Re: [PATCH v2] nl80211/cfg80211: Add support to send tx packet
 specific params
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsi krishna <vamsin@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Fri, 25 Jan 2019 13:48:54 +0100
In-Reply-To: <1546968122-4204-1-git-send-email-vamsin@codeaurora.org>
References: <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
         <1546968122-4204-1-git-send-email-vamsin@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-08 at 22:52 +0530, vamsi krishna wrote:
> Add support to transmit the frames at a rate specified by userspace
> when needed in NL80211_CMD_FRAME command. This commit adds support to
> specify tx rate, number of retries and tx power.
> 
> Tx rate at which packet shall be transmitted can be specified in
> %NL80211_ATTR_RATE_INFO, number of retries can be specified in
> %NL80211_ATTR_WIPHY_RETRY_SHORT and %NL80211_ATTR_WIPHY_RETRY_LONG,
> tx power can be specified in %NL80211_ATTR_WIPHY_TX_POWER_LEVEL.
> 
> The drivers shall indicate the support to send frames at rate specified
> by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
> wiphy capabilities. The userspace can specify the rate within
> %NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
> NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
> attributes defined in &enum nl80211_rate_info.

I don't usually strongly enforce that we'd like to see upstream users
for upstream cfg80211 functionality, but in this case I feel that we
don't even have the *ability* to implement this in most/any upstream
driver(s), so there's no point.

Perhaps also a mac80211 implementation would make sense to some extent.

I also feel that to some extent this overlaps with the per-station TX
power control?

I'd like you to come back with this when there's more upstream support
in general, and when you've fleshed out the exact use cases and whether
or not this fine-grained control is actually needed/desired, or if
something like what Ben had suggested earlier would make sense (IIRC he
suggested limiting to a certain preamble type and similar - i.e. classes
of rates rather than a single very precisely defined rate).


Also, some nitpicks since I'm looking anyway:
 * don't support RATE_INFO_BITRATE - RATE_INFO_BITRATE32 is for new
   applications and by definition there can be no old application for a
   new feature
 * NL80211_ATTR_WIPHY_TX_POWER_LEVEL has a small indentation problem in
   the docs
 * would make sense to capitalize "TX" throughout, rather than writing
   "tx power"

johannes

