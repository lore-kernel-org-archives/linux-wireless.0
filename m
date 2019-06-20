Return-Path: <SRS0=u1b0=UT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C93AC43613
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jun 2019 06:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED77A2085A
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jun 2019 06:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfFTG6w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Jun 2019 02:58:52 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59172 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfFTG6w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jun 2019 02:58:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdr22-0005gM-Ow; Thu, 20 Jun 2019 08:58:50 +0200
Message-ID: <ec1ca95a5789f9001e89e603633b20316d687721.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] nl80211: Include wiphy address setup in NEW_WIPHY
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 20 Jun 2019 08:58:49 +0200
In-Reply-To: <20190619223606.4575-3-denkenz@gmail.com> (sfid-20190620_003639_356445_BEE1812F)
References: <20190619223606.4575-1-denkenz@gmail.com>
         <20190619223606.4575-3-denkenz@gmail.com>
         (sfid-20190620_003639_356445_BEE1812F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Didn't really review all of this yet, but 

 	switch (state->split_start) {
>  	case 0:
> +		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN,
> +			    rdev->wiphy.perm_addr))
> +			goto nla_put_failure;

We generally can't add anything to any of the cases before the split was
allowed, for compatibility with old userspace.

johannes

