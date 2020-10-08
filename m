Return-Path: <SRS0=Edxh=DP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BD4C433DF
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 16:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF5D221F1
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 16:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbgJHQHO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Oct 2020 12:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHQHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Oct 2020 12:07:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74976C061755;
        Thu,  8 Oct 2020 09:07:14 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQYRW-001jFe-JI; Thu, 08 Oct 2020 18:06:58 +0200
Message-ID: <e385f0c4d37812d9e69369645082baf4a352b6c3.camel@sipsolutions.net>
Subject: Re: [PATCH net 001/117] mac80211: set .owner to THIS_MODULE in
 debugfs_netdev.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org
Date:   Thu, 08 Oct 2020 18:06:56 +0200
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com> (sfid-20201008_175239_508186_DB541C11)
References: <20201008155209.18025-1-ap420073@gmail.com>
         (sfid-20201008_175239_508186_DB541C11)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-10-08 at 15:50 +0000, Taehee Yoo wrote:
> If THIS_MODULE is not set, the module would be removed while debugfs is
> being used.
> It eventually makes kernel panic.
> 
Wow, 117 practically identical patches? No thanks ...

Can you merge the ones that belong to a single driver?

net/mac80211/ -> mac80211
net/wireless/ -> cfg80211

etc.

I don't think we need more than one patch for each driver/subsystem.

johannes

