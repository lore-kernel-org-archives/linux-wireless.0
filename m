Return-Path: <SRS0=v6pW=XO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B5C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 14:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E548205F4
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 14:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbfISOrf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:47:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:43296 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389041AbfISOrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 10:47:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iAxiO-0005Fk-MS; Thu, 19 Sep 2019 16:47:24 +0200
Message-ID: <ac6cea459c697db7aec99b8c0c5c0b3bf76b5877.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: fix a potential NULL pointer dereference
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Allen <allen.pais@oracle.com>, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Sep 2019 16:47:23 +0200
In-Reply-To: <2380f108-54a6-0110-4e2b-e66dd54ae800@oracle.com>
References: <1568830262-5529-1-git-send-email-allen.pais@oracle.com>
         <fd8813c1c3c02734d60f494a3c8081d95550ec85.camel@sipsolutions.net>
         <2380f108-54a6-0110-4e2b-e66dd54ae800@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-09-19 at 19:37 +0530, Allen wrote:
> > 
> > +	trans_pcie->rba.alloc_wq = alloc_workqueue("rb_allocator",
> > +						   WQ_HIGHPRI | WQ_UNBOUND, 1);
> > +	if (!trans_pcie->rba.alloc_wq) {
> 
>    I would like to stick to if(unlikely(!trans_pcie->rba.alloc_wq) just 
> for consistency.

That's just clutter, this path gets called exactly once in the lifetime
of most systems ...

>    Let me know if I could add your SOB and send out V2.

No no, I've already sent the patch on the way internally :)

johannes

