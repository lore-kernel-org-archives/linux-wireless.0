Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DCAC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294332172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 294332172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbeI1Pax (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbeI1Pax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:30:53 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8723C81DF7;
        Fri, 28 Sep 2018 09:08:05 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD66C2010DA2;
        Fri, 28 Sep 2018 09:08:04 +0000 (UTC)
Date:   Fri, 28 Sep 2018 11:08:03 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     yhchuang@realtek.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20180928090803.GB8323@redhat.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <a6b6803e-fd18-81f4-6465-d573aa5c9e2a@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b6803e-fd18-81f4-6465-d573aa5c9e2a@lwfinger.net>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 28 Sep 2018 09:08:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 10:40:44AM -0500, Larry Finger wrote:
> On 9/27/18 8:50 AM, Stanislaw Gruszka wrote:
> --snip
> 
> > 
> > > +#define BIT_LEN_MASK_32(__bitlen) (0xFFFFFFFF >> (32 - (__bitlen)))
> > > +#define BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)                          \
> > > +	(BIT_LEN_MASK_32(__bitlen) << (__bitoffset))
> > > +#define LE_P4BYTE_TO_HOST_4BYTE(__start) (le32_to_cpu(*((__le32 *)(__start))))
> > > +#define LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen)               \
> > > +	(LE_P4BYTE_TO_HOST_4BYTE(__start) &                                    \
> > > +	 (~BIT_OFFSET_LEN_MASK_32(__bitoffset, __bitlen)))
> > > +#define LE_BITS_TO_4BYTE(__start, __bitoffset, __bitlen)                       \
> > > +	((LE_P4BYTE_TO_HOST_4BYTE(__start) >> (__bitoffset)) &                 \
> > > +	 BIT_LEN_MASK_32(__bitlen))
> > > +#define SET_BITS_TO_LE_4BYTE(__start, __bitoffset, __bitlen, __value)          \
> > > +	do {                                                                   \
> > > +		*((__le32 *)(__start)) = \
> > > +		cpu_to_le32( \
> > > +		LE_BITS_CLEARED_TO_4BYTE(__start, __bitoffset, __bitlen) |     \
> > > +		((((u32)__value) & BIT_LEN_MASK_32(__bitlen)) << (__bitoffset))\
> > > +		);                                                             \
> > > +	} while (0)
> 
> Stanislaw,
> 
> I have never loved these macros, and it took a lot of time to get them to be
> endian correct. Could you point me to a method that would overwrite a
> portion of a 32-bit little-endian word that would be correct for both
> little- and big-endian machines? Keep in mind that Kalle hates the use of
> compile tests on __LITTLE_ENDIAN.

Maybe something like this (not tested)

#define SET_LE32(reg, off, len, val) \
	((reg & cpu_to_le32(~GENMASK(off + len - 1, off))) | cpu_to_le32(val << off))

?

There are plenty of bitops and endian primitives in kernel, it's
very very unlikly you need custom macros for handle that.

Thanks
Stanislaw
