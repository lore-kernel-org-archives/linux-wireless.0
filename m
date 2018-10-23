Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBE9C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF9620665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AF9620665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbeJWRzf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:55:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36470 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbeJWRzf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 13:55:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gEt3a-0000Ws-HV; Tue, 23 Oct 2018 11:32:58 +0200
Message-ID: <7ac1d7a5f25ebcd44107c3a19e0d8140f37227c6.camel@sipsolutions.net>
Subject: Re: Should we check netif_running in cfg80211_calculate_bi_data?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Tue, 23 Oct 2018 11:32:40 +0200
In-Reply-To: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com> (sfid-20181022_222758_799406_E8076EAF)
References: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com>
         (sfid-20181022_222758_799406_E8076EAF)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-22 at 13:27 -0700, Ben Greear wrote:
> I was testing on my 4.16 kernel with a bunch of VAPs and I had two configured
> for 100 beacon interval, and more at 240.  This failed for reasons I figured out
> (gcd logic), but even once I tried to configure the vaps for 240 interval they
> could not come up.  I am thinking maybe it was because I could only re-configure
> admin-up interfaces, and they couldn't come up due the gcd thing?
> 
> Anyway, while poking, I thought maybe the patch below would be helpful since
> we shouldn't care about admin-down interfaces in this case?
> 
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index fbc880e..56d7583 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -1541,6 +1541,9 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
>                  if (wdev->beacon_interval == *beacon_int_gcd)
>                          continue;
> 
> +               if (!netif_running(wdev->netdev))
> +                       continue;
> +

I don't think we'd ever get to this check, since those interfaces will
always have wdev->beacon_interval == 0, checked a few lines before this
code at the beginning of the loop? At least they should have, but a
quick check suggests that is true.

johannes

