Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9845C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57F3218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 12:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfCWMei (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 08:34:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfCWMei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 08:34:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h7fr9-0008Hy-0u; Sat, 23 Mar 2019 13:34:35 +0100
Message-ID: <35f813d89f2d0eed572fe9ceb6530ab42d081aa2.camel@sipsolutions.net>
Subject: Re: [PATCH 03/11] nl80211: copy the length of dst of src in
 nl80211_notify_radar_detection()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 23 Mar 2019 13:34:31 +0100
In-Reply-To: <20190315153907.16192-4-luca@coelho.fi> (sfid-20190315_163933_061932_F931FD25)
References: <20190315153907.16192-1-luca@coelho.fi>
         <20190315153907.16192-4-luca@coelho.fi>
         (sfid-20190315_163933_061932_F931FD25)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-03-15 at 17:38 +0200, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> It is generally safer to copy the length of the destination instead of
> the length of the source, because if the sizes don't match, it's
> usually better to leak some data from the source than to write data
> out of bounds in the destination.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  net/wireless/nl80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 25a9e3b5c154..239be0e2f9e1 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -8061,7 +8061,7 @@ static int nl80211_notify_radar_detection(struct sk_buff *skb,
>  
>  	cfg80211_sched_dfs_chan_update(rdev);
>  
> -	memcpy(&rdev->radar_chandef, &chandef, sizeof(chandef));
> +	memcpy(&rdev->radar_chandef, &chandef, sizeof(rdev->radar_chandef));

I think we're better off doing a struct assignment here.

johannes

