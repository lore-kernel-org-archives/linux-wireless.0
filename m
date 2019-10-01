Return-Path: <SRS0=KFxB=X2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8479C388F3
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 08:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B75162133F
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Oct 2019 08:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbfJAIqd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 04:46:33 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfJAIqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 04:46:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFDnj-0002fZ-AY; Tue, 01 Oct 2019 10:46:31 +0200
Message-ID: <2518c49c96b8b5233fabcb8bafccba6b8f3155bf.camel@sipsolutions.net>
Subject: Re: [PATCH RFC/RFT 2/4] mac80211: Add API function to set the last
 TX bitrate for a station
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net,
        John Crispin <john@phrozen.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Date:   Tue, 01 Oct 2019 10:46:30 +0200
In-Reply-To: <156889576646.191202.14461472477971784776.stgit@alrua-x1>
References: <156889576422.191202.5906619710809654631.stgit@alrua-x1>
         <156889576646.191202.14461472477971784776.stgit@alrua-x1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-09-19 at 14:22 +0200, Toke Høiland-Jørgensen wrote:

Given a ULL constant:

> +/* constants for calculating reciprocals to avoid division in fast path */
> +#define IEEE80211_RECIPROCAL_DIVISOR 0x100000000ULL

[...]

> +void ieee80211_sta_set_last_tx_bitrate(struct ieee80211_sta *pubsta,
> +				       u32 rate)
> +{
> +	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
> +
> +	sta->last_tx_bitrate = rate;
> +	sta->last_tx_bitrate_reciprocal = ((u64)IEEE80211_RECIPROCAL_DIVISOR / rate);

that cast seems unnecessary?

johannes

