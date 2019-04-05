Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB23C10F0F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 11:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0965D2186A
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 11:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfDELrO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 07:47:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58966 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfDELrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 07:47:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hCNJM-0001IY-Tf; Fri, 05 Apr 2019 13:47:09 +0200
Message-ID: <d423d283c91a48f75a509ee74255327cfe92fe97.camel@sipsolutions.net>
Subject: Re: [PATCH 0/6] stricter netlink validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, dsa@cumulusnetworks.com
Date:   Fri, 05 Apr 2019 13:47:07 +0200
In-Reply-To: <20190404.102850.631122626573856353.davem@davemloft.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
         <20190404.102850.631122626573856353.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-04 at 10:28 -0700, David Miller wrote:

> > Here's a version that has passed build testing ;-)

Umm, I sent out the wrong branch!
(Didn't even realize I had two ... oops)

The generic netlink bits are completely broken here, I was passing a
stack pointer to dump control, which obviously doesn't work

I've pushed out the right version to mac80211-next netlink-validation
branch as David Ahern requested I don't resend for now.

I've also pushed some very much WIP code to the netlink-policy-export
branch there that exposes the policies to userspace, there at least for
generic netlink now.

johannes

