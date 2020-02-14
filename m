Return-Path: <SRS0=dpF5=4C=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BDDC3B195
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 09:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A6620873
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Feb 2020 09:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgBNJEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Feb 2020 04:04:38 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38998 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgBNJEi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Feb 2020 04:04:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j2Wto-00BD3D-Ss; Fri, 14 Feb 2020 10:04:37 +0100
Message-ID: <3f76962656e97793afd512c69d7836de417772ac.camel@sipsolutions.net>
Subject: Re: [PATCH V2 2/3] mac80211: add support for setting fixed HE
 rate/gi/ltf
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Crispin <john@phrozen.org>, Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Miles Hu <milehu@codeaurora.org>
Date:   Fri, 14 Feb 2020 10:04:35 +0100
In-Reply-To: <20200204103514.18111-2-john@phrozen.org>
References: <20200204103514.18111-1-john@phrozen.org>
         <20200204103514.18111-2-john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-02-04 at 11:35 +0100, John Crispin wrote:
> 
> +		for (j = 0; j < NL80211_HE_NSS_MAX; j++) {
> +			if (~sdata->rc_rateidx_he_mcs_mask[i][j]) {

Let's not copy-paste this weird ~ here, we can just ask if it's ! right?

johannes

