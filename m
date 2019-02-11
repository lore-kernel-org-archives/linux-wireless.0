Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40940C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C1F7222A7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388432AbfBKPfj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:35:39 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44508 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388400AbfBKOwT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:52:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtCwS-0007w3-NT; Mon, 11 Feb 2019 15:52:16 +0100
Message-ID: <8409e5d470926c650e37062f4063976989096280.camel@sipsolutions.net>
Subject: Re: [PATCH 12/15] mac80211: shorten debug print to avoid warning
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Adiel Aloni <adiel.aloni@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 11 Feb 2019 15:52:15 +0100
In-Reply-To: <20190206111721.29283-13-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
         <20190206111721.29283-13-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-06 at 13:17 +0200, Luca Coelho wrote:
> From: Adiel Aloni <adiel.aloni@intel.com>
> 
> Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  net/mac80211/mlme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 6d1e7e6f1c21..0b27e52daf43 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -184,7 +184,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
>  		 * it should be OK.
>  		 */
>  		sdata_info(sdata,
> -			   "Wrong control channel: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
> +			   "mismatch: center-freq: %d ht-cfreq: %d ht->primary_chan: %d band: %d - Disable HT\n",
> 

I know you also have a patch in the pipeline that just extends the
buffer, so I'm dropping this :)

johannes

