Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AAAC3A5A1
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 19:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2951922DA7
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 19:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfH1T7K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Aug 2019 15:59:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:41286 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1T7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Aug 2019 15:59:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i345v-0007Sp-CX; Wed, 28 Aug 2019 21:59:03 +0200
Message-ID: <a15716609a2c88e1591581539fd637f7385571e4.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: add local BSS receive time to survey
 information
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date:   Wed, 28 Aug 2019 21:59:01 +0200
In-Reply-To: <F29BC537-AED5-4BFA-915F-ED8E749124FC@holtmann.org>
References: <20190828102042.58016-1-nbd@nbd.name>
         <9189B2C1-6E5B-4457-9354-A010F946EE33@holtmann.org>
         <18c4232675c7b4f13fbfe9e5d8e9364a0908f316.camel@sipsolutions.net>
         <F29BC537-AED5-4BFA-915F-ED8E749124FC@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marcel,

> > No, as usual, that would break ABI. PAD is a regular attribute, just
> > empty and ignored for aligning 64-bit values.
> 
> then I do not grok on how the nla_put_u64_64bit works, but that is
> fine.
> 
> I assumed these are similar to the NL80211_SURVEY_INFO_MAX which we
> also always move, but also not expected to be part of the API as a
> fixed value.

No no, the _MAX is just the token we use for knowing what we want as the
maximum when parsing etc.

The _PAD is actually a real attribute, basically nla_put_u64_64bit()
will do "nla_put_flag(_PAD)" if and only if "offset % 8 == 0", in order
to actually 64-bit align the 64-bit value in the following attribute.

(Note that offset % 8 can only be 0 or 4, due to the way netlink
attributes work.)

johannes

