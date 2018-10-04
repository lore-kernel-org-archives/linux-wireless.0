Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181BFC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03B921470
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:32:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WZ2bYXrq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WZ2bYXrq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D03B921470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbeJDTZk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:25:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37352 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeJDTZk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:25:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 894236043F; Thu,  4 Oct 2018 12:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656354;
        bh=fkZgPKUx85va0qO9cHeCcrrXL1SWssODtSCLBa1xMmA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WZ2bYXrqaBUQsSoYlZYqu7QnbM/gxYAljseBQcsDuugivcp1P3oa4f7VujXBukAAI
         NSyfMMCOVZQiTCVe2EJs/mzdz7o7uIWvGdjGzANvZuHGYrRXKK9zd/tP4j2hikvcYk
         Sy/MCycZ9jAam/Zn4Oz8h9yfLAfeZ/cWPiaZVnoA=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90D1660C6A;
        Thu,  4 Oct 2018 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656354;
        bh=fkZgPKUx85va0qO9cHeCcrrXL1SWssODtSCLBa1xMmA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WZ2bYXrqaBUQsSoYlZYqu7QnbM/gxYAljseBQcsDuugivcp1P3oa4f7VujXBukAAI
         NSyfMMCOVZQiTCVe2EJs/mzdz7o7uIWvGdjGzANvZuHGYrRXKK9zd/tP4j2hikvcYk
         Sy/MCycZ9jAam/Zn4Oz8h9yfLAfeZ/cWPiaZVnoA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 90D1660C6A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH 01/12] rtwlan: main files
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
        <20180927135040.GA4712@redhat.com>
        <a6b6803e-fd18-81f4-6465-d573aa5c9e2a@lwfinger.net>
        <20180928090803.GB8323@redhat.com>
Date:   Thu, 04 Oct 2018 15:32:30 +0300
In-Reply-To: <20180928090803.GB8323@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 28 Sep 2018 11:08:03 +0200")
Message-ID: <87sh1l28pt.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Sep 27, 2018 at 10:40:44AM -0500, Larry Finger wrote:
>> On 9/27/18 8:50 AM, Stanislaw Gruszka wrote:
>> --snip
>> 
>> > 
>> > > +#define BIT_LEN_MASK_32(__bitlen) (0xFFFFFFFF >> (32 - (__bitlen)))
>> > > +#define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)                          \
>> > > +	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
>> > > +#define LE_P4BYTE_TO_HOST_4BYTE(__start) (le32_to_cpu(*((__le32 *)(__start))))
>> > > +#define LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen)               \
>> > > +	(LE_P4BYTE_TO_HOST_4BYTE(__start) &                                    \
>> > > +	 (~BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)))
>> > > +#define LE_BITS_TO_4BYTE(__start, __bitoffset, __bitlen)                       \
>> > > +	((LE_P4BYTE_TO_HOST_4BYTE(__start) >> (__bitoffset)) &                 \
>> > > +	 BIT_LEN_MASK_32(__bitlen))
>> > > +#define SET_BITS_TO_LE_4BYTE(__start, __bitoffset, __bitlen, __value)          \
>> > > +	do {                                                                   \
>> > > +		*((__le32 *)(__start)) = \
>> > > +		cpu_to_le32( \
>> > > +		LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen) |     \
>> > > +		((((u32)__value) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset))\
>> > > +		);                                                             \
>> > > +	} while (0)

This is horrible.

>> Stanislaw,
>> 
>> I have never loved these macros, and it took a lot of time to get them to be
>> endian correct. Could you point me to a method that would overwrite a
>> portion of a 32-bit little-endian word that would be correct for both
>> little- and big-endian machines? Keep in mind that Kalle hates the use of
>> compile tests on __LITTLE_ENDIAN.
>
> Maybe something like this (not tested)
>
> #define SET_LE32(reg, off, len, val) \
> 	((reg & cpu_to_le32(~GENMASK(off + len - 1, off))) | cpu_to_le32(val << off))
>
> ?
>
> There are plenty of bitops and endian primitives in kernel, it's
> very very unlikly you need custom macros for handle that.

Indeed, try avoiding reinventing wheel as much as possible.

-- 
Kalle Valo
