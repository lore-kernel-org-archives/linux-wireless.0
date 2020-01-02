Return-Path: <SRS0=AjYM=2X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7228CC3276C
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 13:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51A3C21734
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Jan 2020 13:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgABNlr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Jan 2020 08:41:47 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57642 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgABNlq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Jan 2020 08:41:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1in0jR-005SkG-Mg; Thu, 02 Jan 2020 14:41:45 +0100
Message-ID: <6d2d94e01552f5713266add9e4909c85266e53ab.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Enhance the AKM advertizement to support per
 interface.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Veerendranath Jakkam <vjakkam@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 02 Jan 2020 14:41:44 +0100
In-Reply-To: <20191223185255.1009-1-vjakkam@codeaurora.org>
References: <20191223185255.1009-1-vjakkam@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-12-24 at 00:22 +0530, Veerendranath Jakkam wrote:
> 
> @@ -2437,10 +2472,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>  		state->split_start++;
>  		break;
>  	case 15:
> -		if (rdev->wiphy.akm_suites &&
> -		    nla_put(msg, NL80211_ATTR_AKM_SUITES,
> -			    sizeof(u32) * rdev->wiphy.n_akm_suites,
> -			    rdev->wiphy.akm_suites))

I don't think you should break this for all existing cases.

johannes

