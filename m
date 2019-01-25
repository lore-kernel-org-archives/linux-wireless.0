Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26652C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD6DA218D0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 13:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfAYNZy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:25:54 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57734 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfAYNZx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 08:25:53 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn1UV-0001qW-Lg; Fri, 25 Jan 2019 14:25:51 +0100
Message-ID: <4f4eab34a995000d230c8b99cb6cff3f9dfd5c64.camel@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] mac80211: Expose ieee80211_schedule_txq()
 function
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Date:   Fri, 25 Jan 2019 14:25:50 +0100
In-Reply-To: <20190122142019.21417-2-toke@redhat.com> (sfid-20190122_152134_612942_99BDC416)
References: <20190122142019.21417-1-toke@redhat.com>
         <20190122142019.21417-2-toke@redhat.com>
         (sfid-20190122_152134_612942_99BDC416)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			    struct ieee80211_txq *txq)
> +	__acquires(txq_lock) __releases(txq_lock)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +
> +	spin_lock_bh(&local->active_txq_lock[txq->ac]);
> +	ieee80211_return_txq(hw, txq);
> +	spin_unlock_bh(&local->active_txq_lock[ac]);
> 
Maybe v6 had txq->ac here instead of just ac which doesn't compile ;-)

I fixed it up, but I hope you tested a compiling version :P

johannes

