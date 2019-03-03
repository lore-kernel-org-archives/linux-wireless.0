Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87600C43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 03:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 602DA20857
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 03:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfCCDCH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 22:02:07 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:45671 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbfCCDCH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 22:02:07 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 5458818029210;
        Sun,  3 Mar 2019 03:02:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bite38_1203ef1e0f701
X-Filterd-Recvd-Size: 2321
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun,  3 Mar 2019 03:02:03 +0000 (UTC)
Message-ID: <241f8d27d05a21873342c971080e245f9333d12e.camel@perches.com>
Subject: Re: [PATCH] rsi: Fix NULL pointer dereference in kmalloc
From:   Joe Perches <joe@perches.com>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 02 Mar 2019 19:02:02 -0800
In-Reply-To: <20190302203123.9182-1-pakki001@umn.edu>
References: <20190302203123.9182-1-pakki001@umn.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-03-02 at 14:31 -0600, Aditya Pakki wrote:
> kmalloc can fail in rsi_register_rates_channels but memcpy still attempts
> to write to channels. The patch checks and avoids such a situation.
[]
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
[]
> @@ -197,6 +197,11 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)

It'd be better to make this return -ENOMEM on failure
and test in the caller and push the failure up-stack.

>  
>  	if (band == NL80211_BAND_2GHZ) {
>  		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
> +		if (!channels) {
> +			rsi_dbg(ERR_ZONE, "Failed to allocate memory\n");

Allocation error messages aren't really useful
as there's a generic OOM message.

> +			return;
> +		}
> +
>  		memcpy(channels,
>  		       rsi_2ghz_channels,
>  		       sizeof(rsi_2ghz_channels));
> @@ -206,6 +211,11 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
>  		sbands->n_bitrates = ARRAY_SIZE(rsi_rates);
>  	} else {
>  		channels = kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);
> +		if (!channels) {
> +			rsi_dbg(ERR_ZONE, "Failed to allocate memory\n");
> +			return;
> +		}
> +
>  		memcpy(channels,
>  		       rsi_5ghz_channels,
>  		       sizeof(rsi_5ghz_channels));

