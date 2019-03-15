Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C009C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F2F921872
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 09:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfCOJiy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:38:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbfCOJiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 05:38:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1h4jIg-00069N-5X; Fri, 15 Mar 2019 10:38:50 +0100
Message-ID: <13392e1203be4ddd97c4e0e6b6a6c48ce97aae6f.camel@sipsolutions.net>
Subject: Re: [PATCH v2] fq: fix fq_tin tx bytes overflow
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yibo Zhao <yiboz@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Date:   Fri, 15 Mar 2019 10:38:48 +0100
In-Reply-To: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org> (sfid-20190313_040846_202389_4E584F4C)
References: <1552446505-15444-1-git-send-email-yiboz@codeaurora.org>
         (sfid-20190313_040846_202389_4E584F4C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-03-13 at 11:08 +0800, Yibo Zhao wrote:
> Currently, we are using u32 for tx_bytes in fq_tin.
> If the throughput stays more than 1.2Gbps, tx_bytes
> statistics overflow in about 1 min.
> 
> In order to allow us to trace the tx_bytes statistics
> for longer time in high throughput, change its type
> from u32 to u64.

Hmm. 64-bit values are kinda expensive on 32-bit architectures. How
badly do you need this? I mean ... worst case you just have to capture
every 30 seconds or so if you're doing really high throughput with HE or
something?

johannes

