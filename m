Return-Path: <SRS0=SQ8t=Z3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB41C2D0BF
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Dec 2019 16:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBAB321835
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Dec 2019 16:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfLEQv6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Dec 2019 11:51:58 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:58260 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729860AbfLEQv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Dec 2019 11:51:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1icuM6-004CRl-C5; Thu, 05 Dec 2019 17:51:54 +0100
Message-ID: <78d99dc334c880a12d15717c496a1b3c36b0c370.camel@sipsolutions.net>
Subject: Re: debugging TXQs being empty
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 05 Dec 2019 17:51:52 +0100
In-Reply-To: <2e01fb1d5b8ff3335220231251f893c01c6c22d3.camel@sipsolutions.net> (sfid-20191205_174955_112616_B3AB68D5)
References: <bbc516f28782175b27ac5e19dcdeac13cd6ee76a.camel@sipsolutions.net>
         <49288397-55b3-f49a-e277-5197d7c1bea3@candelatech.com>
         <2e01fb1d5b8ff3335220231251f893c01c6c22d3.camel@sipsolutions.net>
         (sfid-20191205_174955_112616_B3AB68D5)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-12-05 at 17:49 +0100, Johannes Berg wrote:
> On Thu, 2019-12-05 at 08:37 -0800, Ben Greear wrote:
> 
> > > All this seems to mean that the TCP stack isn't feeding us fast enough,
> > > but is that really possible?
> > 
> > Does UDP work better?
> 
> Somewhat, I get about 1020-1030 Mbps. But still a TON of "TXQ of STA ...
> is now empty" messages. Say this run got about 15 per second of those.

That actually pegged a CPU in the test tool, so not sure I'm doing that
correctly ...

johannes

