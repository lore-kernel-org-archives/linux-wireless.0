Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7492C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF47F2146E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfAYMed (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:34:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56616 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbfAYMeZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:34:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0gh-0000P6-Mr; Fri, 25 Jan 2019 13:34:23 +0100
Message-ID: <ecef4536f2b9f08195e0da2d00f67f33ee66bdbd.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: store tx power value from user to station
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Balaji Pothunoori <bpothuno@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Date:   Fri, 25 Jan 2019 13:34:21 +0100
In-Reply-To: <1547724247-11481-1-git-send-email-bpothuno@codeaurora.org>
References: <1547724247-11481-1-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-17 at 16:54 +0530, Balaji Pothunoori wrote:
> 
> + * @txpwr: indicates the tx power, in mBm, to be used when sending data frames
> + *	to the STA.
> + * @type: In particular if TPC %type is NL80211_TX_POWER_LIMITED then txpwr will
> + *	be less than or equal to specified from userspace, whereas if TPC %type
> + *	is NL80211_TX_POWER_AUTOMATIC then it indicates default txpwr.
> + *	NL80211_TX_POWER_FIXED is not a valid configuration option for
> + *	per peer TPC.

Same comment here wrt. txpower_type or so.

> +TRACE_EVENT(drv_sta_set_txpwr,
> +	TP_PROTO(struct ieee80211_local *local,
> +		 struct ieee80211_sub_if_data *sdata,
> +		 struct ieee80211_sta *sta),
> +
> +	TP_ARGS(local, sdata, sta),
> +
> +	TP_STRUCT__entry(
> +		LOCAL_ENTRY
> +		VIF_ENTRY
> +		STA_ENTRY
> +		__field(s16, txpwr)
> +	),
> +
> +	TP_fast_assign(
> +		LOCAL_ASSIGN;
> +		VIF_ASSIGN;
> +		STA_ASSIGN;
> +		__entry->txpwr = sta->txpwr;
> +	),

Include the type as well?

OTOH, is this whole business with the type even needed everywhere?

johannes

