Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7117C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7913218AE
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfB1UaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 15:30:23 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:34586 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfB1UaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 15:30:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gzSJx-00009O-2X; Thu, 28 Feb 2019 21:30:21 +0100
Message-ID: <a68690ca1f18d7e0bb9baad928b7a45eb5e9a400.camel@sipsolutions.net>
Subject: Re: iw 5.0.1 broken when compiled with lto
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     linux-wireless@vger.kernel.org, stijn@linux-ipv6.be,
        fercerpav@gmail.com, Mantas Pucka <mantas@8devices.com>
Date:   Thu, 28 Feb 2019 21:30:18 +0100
In-Reply-To: <b398e5e4-45f7-e680-b43e-ae3440ba568f@hauke-m.de>
References: <c450c890-a2f6-d598-c81c-8428144cf41a@hauke-m.de>
         <b398e5e4-45f7-e680-b43e-ae3440ba568f@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-26 at 23:34 +0100, Hauke Mehrtens wrote:
> 
> 
> Paul Fertser did some further analysis of this problem and we can now
> reproduce it also on normal x86 systems when the binary is compiled like
> this:
> CFLAGS=" -Os -flto" LDFLAGS=" -flto" make
> 
> -O3 or -Os and link time optimization is needed to see this problem.
> 
> With LTO the compiler randomly reorders the __section_* variables
> including __section_set and __section_get and that leads to wrong offset
> used to traverse the __cmd section.

Yes, looks like stuff going into the __cmd section is no longer
guaranteed to be in the same order as in the files, which sort of makes
sense. Therefore, the trick I used to determine how densely the linker
packs this no longer works.

However, we can use the same trick with a different section, so I've
just committed a fix for this.

johannes

