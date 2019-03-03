Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4A0C10F00
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 14:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ABF320857
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 14:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfCCOOz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 09:14:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58288 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfCCOOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 09:14:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h0Rt7-0003ml-Kd; Sun, 03 Mar 2019 15:14:45 +0100
Message-ID: <2cfc6bc5170f9e4191fa0ad6fd13d7e88418b2c3.camel@sipsolutions.net>
Subject: Re: [PATCH] rsi: Fix NULL pointer dereference in kmalloc
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 03 Mar 2019 15:14:43 +0100
In-Reply-To: <20190302203123.9182-1-pakki001@umn.edu> (sfid-20190302_213904_982056_54C36803)
References: <20190302203123.9182-1-pakki001@umn.edu>
         (sfid-20190302_213904_982056_54C36803)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-03-02 at 14:31 -0600, Aditya Pakki wrote:
> kmalloc can fail in rsi_register_rates_channels but memcpy still attempts
> to write to channels. The patch checks and avoids such a situation.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index e56fc83faf0e..59eb1f533d0e 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -197,6 +197,11 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
>  
>  	if (band == NL80211_BAND_2GHZ) {
>  		channels = kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);
> +		if (!channels) {
> +			rsi_dbg(ERR_ZONE, "Failed to allocate memory\n");
> +			return;
> +		}
> +
>  		memcpy(channels,
>  		       rsi_2ghz_channels,
>  		       sizeof(rsi_2ghz_channels));

Should probably be kmemdup() anyway though.

johannes

