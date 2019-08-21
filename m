Return-Path: <SRS0=kz8S=WR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A16C3A59E
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 09:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2433D22DD3
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 09:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfHUJka (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:40:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58744 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfHUJka (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Aug 2019 05:40:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0N6Q-0007KZ-1y; Wed, 21 Aug 2019 11:40:26 +0200
Message-ID: <e0cbf7b86b275f87c0a69bd9a31e5b9fa8691d3a.camel@sipsolutions.net>
Subject: Re: [PATCH 04/49] ath11k: add ahb.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date:   Wed, 21 Aug 2019 11:40:25 +0200
In-Reply-To: <e53ddcaa11d069fbe9d083b9b0105d19@codeaurora.org>
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
         <1566316095-27507-5-git-send-email-kvalo@codeaurora.org>
         (sfid-20190820_175156_108502_D7159DB2) <8c791df54a831f32fddd634e71e5e91342532535.camel@sipsolutions.net>
         <e53ddcaa11d069fbe9d083b9b0105d19@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-08-21 at 14:59 +0530, Vasanthakumar Thiagarajan wrote:

> > > +#define ATH11K_TX_RING_MASK_3 0x0
> > 
> > You have a LOT of masks here that are 0, that seems odd?
> 
> We'll remove them.

I'm not sure you should just *remove* them, that might very well be
valid and what you need here, I'm just saying it looks odd since you
usually expect masks to, well, not really mask *everything*?

> > > +inline u32 ath11k_ahb_read32(struct ath11k_base *ab, u32 offset)
> > > +{
> > > +	return ioread32(ab->mem + offset);
> > > +}
> > > +
> > > +inline void ath11k_ahb_write32(struct ath11k_base *ab, u32 offset, 
> > > u32 value)
> > > +{
> > > +	iowrite32(value, ab->mem + offset);
> > > +}
> > 
> > Just "inline" doesn't seem to make that much sense? If it's only used
> > here then I guess it should be static, otherwise not inline? Or maybe
> > you want it to be inlined *in this file* but available out-of-line
> > otherwise? I'm not sure that actually is guaranteed to work right in C?
> 
> Yes, these read/write functions are used from other files as well. May 
> be define them as static inline in ahb.c will be fine.

No, if they're static they cannot be used from other files, but if
they're declared and used elsewhere they can't really be inline ...

You could declare them static inline in ahb.h I guess, instead.

johannes

