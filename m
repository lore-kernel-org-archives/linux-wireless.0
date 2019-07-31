Return-Path: <SRS0=Y9Fe=V4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5968C32751
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 08:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937A120693
	for <linux-wireless@archiver.kernel.org>; Wed, 31 Jul 2019 08:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfGaIyK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:54:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54878 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaIyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jul 2019 04:54:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hskN6-00041O-0W; Wed, 31 Jul 2019 10:54:08 +0200
Message-ID: <5957aa7cc7dcd1cf24bd81bcdff419a27c7782aa.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: HE STA disassoc due to QOS NULL not sent
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shay Bar <shay.bar@celeno.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 31 Jul 2019 10:54:07 +0200
In-Reply-To: <20190703131848.22879-1-shay.bar@celeno.com> (sfid-20190703_151855_846208_5223FFC3)
References: <20190703131848.22879-1-shay.bar@celeno.com>
         (sfid-20190703_151855_846208_5223FFC3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-07-03 at 16:18 +0300, Shay Bar wrote:
> In case of HE AP-STA link, ieee80211_send_nullfunc() will not send the QOS NULL packet to check if AP is still associated.
> In this case, probe_send_count will be non zero and ieee80211_sta_work() will later disassociate the AP.
> (although it didn't really send a test QOS NULL packet).
> Fix is to decrement probe_send_count and not call ieee80211_send_nullfunc() in case of HE link.
> 
> Signed-off-by: Shay Bar <shay.bar@celeno.com>
> ---
> Hope I solved all the SMTP server problems and patch is better now :)

Yep, thanks.
 
>  	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
>  		ifmgd->nullfunc_failed = false;
> -		ieee80211_send_nullfunc(sdata->local, sdata, false);
> +		if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
> +			ifmgd->probe_send_count--;
> +		else
> +			ieee80211_send_nullfunc(sdata->local, sdata, false);

Not sure that makes sense though.

Why go through all the motions of doing the counting and all, and the
run_again() etc. when all that will happen is that we'll disconnect
anyway?

johannes

