Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 844FDC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595AE2146E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfAYMcL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:32:11 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56596 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfAYMcL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:32:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0eX-0000EI-Qd; Fri, 25 Jan 2019 13:32:09 +0100
Message-ID: <5b2d0128ff33cdeb268a3954c4aab3ab7b1145c6.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] cfg80211: Add support to set tx power for a station
 associated
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Date:   Fri, 25 Jan 2019 13:32:08 +0100
In-Reply-To: <1547724167-11420-1-git-send-email-bpothuno@codeaurora.org>
References: <1547724167-11420-1-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 16:52 +0530, Balaji Pothunoori wrote:
> 
> +	s16 txpwr;
> +	enum nl80211_tx_power_setting type;

you should probably call this txpwr_type, or do something like

struct {
	s16 power;
	enum ... type;
} txpwr;


> +	[NL80211_ATTR_STA_TX_POWER_SETTING] = { .type = NLA_U8 },

That should use NLA_POLICY_RANGE()

> +	[NL80211_ATTR_STA_TX_POWER] = { .type = NLA_S16 },
 

> +		params->type = nla_get_u32(info->attrs[idx]);
> +
> +		if (params->type == NL80211_TX_POWER_LIMITED) {
> +			idx = NL80211_ATTR_STA_TX_POWER;
> +			params->txpwr = nla_get_u32(info->attrs[idx]);

You cannot use nla_get_u32 with U8/S16 attributes, use the correct
corresponding helper.

johannes

