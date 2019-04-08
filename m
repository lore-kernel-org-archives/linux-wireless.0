Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D20C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F5620880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfDHUBf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:01:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33842 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfDHUBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 16:01:34 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDaSN-0006u0-AC; Mon, 08 Apr 2019 22:01:27 +0200
Message-ID: <717acf1bde5507f73436ae7d45d114b34aee1c05.camel@sipsolutions.net>
Subject: Re: [PATCH v2] fq: fix fq_tin tx bytes overflow
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yibo Zhao <yiboz@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless-owner@vger.kernel.org
Date:   Mon, 08 Apr 2019 22:01:25 +0200
In-Reply-To: <fa575f93f3936aa3be1cf6b14f87e511@codeaurora.org>
References: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org>
         (sfid-20190313_040846_202389_4E584F4C) <13392e1203be4ddd97c4e0e6b6a6c48ce97aae6f.camel@sipsolutions.net>
         <fa575f93f3936aa3be1cf6b14f87e511@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-03-18 at 12:59 +0800, Yibo Zhao wrote:
> 
> I understand your concern. Yes, I am using high end AP for throughput 
> test. I'd say 1.2 Gbps is not the worst case since we can achieve max 
> 1.4Gbps according to our test. AFAIK, for most throughput cases, 1min is 
> the minimum requirement. And I think, with more and more high end 
> products(even higher throughput) on the ways to the market, it is highly 
> possible that 30s is not a safe time before overflow.

Well, 2 Gbps (goodput) would make it overflow every 16 seconds, so I'm
not sure where you take the 1 minute from :-) Maybe from 1.2Gbps PHY
rate.

But still, the only place we expose this is debugfs, so I'm not really
sure we want to spend that.

Note that I'm generally pushing back on statistics right now - I really
want to put some trace points or eBPF hooks in places that people can
use to keep their favourite statistics, instead of trying to cover each
and every use case in the stack itself.

johannes

