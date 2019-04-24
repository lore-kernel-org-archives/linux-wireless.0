Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C60C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 18:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 210232183E
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 18:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfDXSzJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 14:55:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36574 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfDXSzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 14:55:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJN2v-00051f-69; Wed, 24 Apr 2019 20:55:05 +0200
Message-ID: <45ef6418002ddb01bc99a06a5c52e0dcd30afd4b.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Set CAN_REPLACE_PTK0 for SW crypto only
 drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 24 Apr 2019 20:55:04 +0200
In-Reply-To: <20190424173246.26421-1-alexander@wetzel-home.de>
References: <20190424173246.26421-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-24 at 19:32 +0200, Alexander Wetzel wrote:
> Mac80211 SW crypto handles replacing PTK keys correctly.
> 
> Don't trigger needless warnings or workarounds when the driver can only
> use the known good SW crypto provided by mac80211.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  net/mac80211/main.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index e56650a9838e..2b608044ae23 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1060,6 +1060,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		wiphy_ext_feature_set(local->hw.wiphy,
>  				      NL80211_EXT_FEATURE_EXT_KEY_ID);
>  
> +	/* Mac80211 and therefore all cards only using SW crypto are able to
> +	 * handle PTK rekeys correctly
> +	 */
> +	if (!local->ops->set_key)
> +		wiphy_ext_feature_set(local->hw.wiphy,
> +				      NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);

Now I wonder - shouldn't the same A-MPDU issue apply here? After all, if
you replace the PTK 0 surely you shouldn't use different ones for the
same frame in an A-MPDU?

johannes

