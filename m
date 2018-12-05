Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5C2C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D06020878
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D06020878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbeLEOmk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:42:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41578 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeLEOmk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 09:42:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUYNq-0000gN-Jj; Wed, 05 Dec 2018 15:42:38 +0100
Message-ID: <6102d09bb53a59b2789e31d84ffdda45165a895c.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 0/2] Extended Key ID support for linux
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 05 Dec 2018 15:42:36 +0100
In-Reply-To: <20181111110235.14213-1-alexander@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry for the delay.

On Sun, 2018-11-11 at 12:02 +0100, Alexander Wetzel wrote:
> IEEE 802.11-2012 added support for Extended Key ID, allowing pairwise
> keys to also use keyID 1 and moving group keys to IDs 2 and 3.

Where do you read this? I've always been under the impression that
individually and group addressed frames use key IDs from different
"namespaces", so to speak, where PTK/STK can use 0 (0 or 1 with
"Extended Key ID" support) and GTK can use 0-3.

In fact, the per-frame pseudocode in 802.11-2016 12.9.2.6 clearly
states:

if MPDU has individual RA then
	lookup pairwise key using Key ID from MPDU
else
	lookup group key using Key ID from MPDU
endif

If it weren't different namespaces, you'd not have to differentiate
here.

> Support for Extended Key ID is basically completed and confirmed working
> with both hwsim and "on the air" with ath9k/iwldvm using software
> encryption and those patches here.

:)

> Prior to propose this patch for merging I would like to get Extended
> Key ID working with HW encryption for at least some devices, but after
> experimenting with ath9k and to a lesser extend with ath10k it's now
> clear that this will be an per-driver effort and it may well turn out to
> be impossible without firmware updates.

Indeed. I think there might be some support with iwlwifi firmware, at
least newer versions? I can check later.

> So I've decided to continue working on the HW support for now but also
> ask you for feedback for what I got so far. 

Sounds good.

> Any feedback is welcome and I especially like to learn what you think of
> the API extensions and what has to be changed to get it merged.

I'll look over the individual patches.

johannes

