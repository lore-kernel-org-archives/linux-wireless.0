Return-Path: <SRS0=kz8S=WR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A7FC3A59E
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 17:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1119E216F4
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 17:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d0p3F5o/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d0p3F5o/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfHURKj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Aug 2019 13:10:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHURKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Aug 2019 13:10:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D97AE6053B; Wed, 21 Aug 2019 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566407438;
        bh=BPG+50GEihZMgIjrDRDUOTuJxXQViNocmnGH9RAx9e0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0p3F5o/8rWI9YZ4rdK6/3b3B+iNyAP9QWNzCASZSZuE43KA29LFseXojIDLaaQFJ
         TyABWqyL+nMR/FeFyVUepJrsCmn6IfYmghSq6dc1AbS9PgjlkVj9caHHRxhmRQfvWr
         WzByFYNhJtA2fAKsnqKPVNBjloSNvsHRbT8BLN0w=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 41367607DE;
        Wed, 21 Aug 2019 17:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1566407438;
        bh=BPG+50GEihZMgIjrDRDUOTuJxXQViNocmnGH9RAx9e0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0p3F5o/8rWI9YZ4rdK6/3b3B+iNyAP9QWNzCASZSZuE43KA29LFseXojIDLaaQFJ
         TyABWqyL+nMR/FeFyVUepJrsCmn6IfYmghSq6dc1AbS9PgjlkVj9caHHRxhmRQfvWr
         WzByFYNhJtA2fAKsnqKPVNBjloSNvsHRbT8BLN0w=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 21 Aug 2019 22:40:38 +0530
From:   Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, devicetree@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 04/49] ath11k: add ahb.c
In-Reply-To: <e0cbf7b86b275f87c0a69bd9a31e5b9fa8691d3a.camel@sipsolutions.net>
References: <1566316095-27507-1-git-send-email-kvalo@codeaurora.org>
 <1566316095-27507-5-git-send-email-kvalo@codeaurora.org>
 (sfid-20190820_175156_108502_D7159DB2)
 <8c791df54a831f32fddd634e71e5e91342532535.camel@sipsolutions.net>
 <e53ddcaa11d069fbe9d083b9b0105d19@codeaurora.org>
 <e0cbf7b86b275f87c0a69bd9a31e5b9fa8691d3a.camel@sipsolutions.net>
Message-ID: <c35138041d9a3431594fda8afe8c354e@codeaurora.org>
X-Sender: vthiagar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-08-21 15:10, Johannes Berg wrote:
> On Wed, 2019-08-21 at 14:59 +0530, Vasanthakumar Thiagarajan wrote:
> 
>> > > +#define ATH11K_TX_RING_MASK_3 0x0
>> >
>> > You have a LOT of masks here that are 0, that seems odd?
>> 
>> We'll remove them.
> 
> I'm not sure you should just *remove* them, that might very well be
> valid and what you need here, I'm just saying it looks odd since you
> usually expect masks to, well, not really mask *everything*?

Right, we'll try to clean that up wherever possible.

> 
>> > > +inline u32 ath11k_ahb_read32(struct ath11k_base *ab, u32 offset)
>> > > +{
>> > > +	return ioread32(ab->mem + offset);
>> > > +}
>> > > +
>> > > +inline void ath11k_ahb_write32(struct ath11k_base *ab, u32 offset,
>> > > u32 value)
>> > > +{
>> > > +	iowrite32(value, ab->mem + offset);
>> > > +}
>> >
>> > Just "inline" doesn't seem to make that much sense? If it's only used
>> > here then I guess it should be static, otherwise not inline? Or maybe
>> > you want it to be inlined *in this file* but available out-of-line
>> > otherwise? I'm not sure that actually is guaranteed to work right in C?
>> 
>> Yes, these read/write functions are used from other files as well. May
>> be define them as static inline in ahb.c will be fine.
> 
> No, if they're static they cannot be used from other files, but if
> they're declared and used elsewhere they can't really be inline ...
> 
> You could declare them static inline in ahb.h I guess, instead.

My bad, I wanted to mean the same, moving those function to ahb.h as 
static inline.

Vasanth
