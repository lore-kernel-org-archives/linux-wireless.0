Return-Path: <SRS0=s5sB=ZA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799DDC5DF60
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 10:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57460214DB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Nov 2019 10:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfKHKJ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Nov 2019 05:09:56 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53562 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728513AbfKHKJ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Nov 2019 05:09:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iT1DG-0007Yb-CK; Fri, 08 Nov 2019 11:09:54 +0100
Message-ID: <1a2eb096119c9029e67caf797564d6511c8803a7.camel@sipsolutions.net>
Subject: Re: [PATCH v6 3/4] mac80211: Implement Airtime-based Queue Limit
 (AQL)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath10k@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kevin Hayes <kevinhayes@google.com>
Date:   Fri, 08 Nov 2019 11:09:53 +0100
In-Reply-To: <157182474287.150713.12867638269538730397.stgit@toke.dk>
References: <157182473951.150713.7978051149956899705.stgit@toke.dk>
         <157182474287.150713.12867638269538730397.stgit@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-10-23 at 11:59 +0200, Toke Høiland-Jørgensen wrote:
> 
>  
> +void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
> +					  struct sta_info *sta, u8 ac,
> +					  u16 tx_airtime, bool tx_completed)
> +{
> +	spin_lock_bh(&local->active_txq_lock[ac]);
> +	if (tx_completed) {
> +		if (sta) {
> +			if (WARN_ONCE(sta->airtime[ac].aql_tx_pending < tx_airtime,
> +				      "TXQ pending airtime underflow: %u, %u",
> +				      sta->airtime[ac].aql_tx_pending, tx_airtime))

Maybe add the STA/AC to the message?

johannes

