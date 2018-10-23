Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6907C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD5B020665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD5B020665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbeJWR7K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:59:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36502 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbeJWR7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 13:59:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gEt72-0000aw-Qb; Tue, 23 Oct 2018 11:36:32 +0200
Message-ID: <67d0b8ec7d01ac452dfa5a1a8c2389adaa221d6b.camel@sipsolutions.net>
Subject: Re: Where to report mpdus tx vs failed?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Tue, 23 Oct 2018 11:36:12 +0200
In-Reply-To: <ae110050-1eec-25c4-57ba-86b42aae2930@candelatech.com>
References: <104c8823-e867-6244-a528-979482c7fccc@candelatech.com>
         <CALLGbRKOLVg0bLhezLkEA_MPCg_S1L-drJNy3fSWxPJXJV+ajQ@mail.gmail.com>
         <93888bdc-b27d-78db-7fde-e881fa74c99b@candelatech.com>
         <c46e9b859318574a3b5ce7e1dbdf48404892d101.camel@sipsolutions.net>
         <512247ba69be323b6cef3b17ccd6957343acebd1.camel@sipsolutions.net>
         <ae110050-1eec-25c4-57ba-86b42aae2930@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-22 at 10:16 -0700, Ben Greear wrote:

> > > We have NL80211_STA_INFO_TX_RETRIES, shouldn't you be able to capture it
> > > there?
> > 
> > Or, per TID, NL80211_TID_STATS_TX_MSDU_RETRIES
> 
> I added this code (rate is struct ieee80211_tx_rate)
> 
> 	if (tx_done->mpdus_failed) {
> 		/* Maybe there is a better way to report this tried vs failed stat up the stack? */
> 		rate->count = tx_done->mpdus_failed + 1;
> 	}
> 	else {
> 		rate->count = 1;
> 	}

Ah, you were asking about mac80211?

I guess if you have the statistic, you can override it in
get_sta_stats() instead of trying to make mac80211 keep them based on
the rate (control) information.

johannes

