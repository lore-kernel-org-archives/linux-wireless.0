Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1BEC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94FE121929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436552AbfBOLwQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:52:16 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38968 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbfBOLwQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:52:16 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guc2Q-0006Cb-Kl; Fri, 15 Feb 2019 12:52:14 +0100
Message-ID: <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:52:13 +0100
In-Reply-To: <20190210210620.31181-8-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-8-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
> This is not ready for merge and has known issues.
> The patch is only for discussions to sort out how to handle it correctly!
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
> 
> iwlwifi intel cards had two big surprises:
> 
> Assuming I did not make some stupid errors it looks like my old
> "Intel Corporation Centrino Ultimate-N 6300 (rev 3e)" using ucode 
> 9.221.4.1 build 25532 is perfectly fine with two keys uploaded to
> harware and honoring the keyid in the MPDUs. For a card launched 2011
> that's a pleasant surprise:-)

:-)

> A much shorter test with a modern "Intel Corporation Wireless 8265 /
> 8175 (rev 78)" using ucode version 36.e91976c0.0 shows what seems to be
> MPDUs decoded with the wrong key at each rekey and therefore a candidate
> for the COMPAT support only..
> So the bad news seems to be, that the modern card dropped the support.

Probably just a firmware bug.

> It also seems to force us to add some per-card or per-firmware depending
> check to decide which card can use the Native Extended Key ID support
> and use the Compat mode for the rest.
> Is there any way to find out which cards/firmware can be used with
> Extended Key ID?

No, but if you have a good test case we can check out what the firmware
bug is and fix it. Perhaps not for all, but for the future at least.
Maybe we can still figure out where it was introduced and thus see where
it's good to use native mode.

> I also have tested patch for iwldvm using the Compat mode and I think
> mvm cards will also work with that.

No they don't, no firmware is available for that.

johannes

