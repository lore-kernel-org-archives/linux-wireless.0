Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C804CC71132
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 14:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AD802064A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 14:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AD802064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbeJOWkL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 18:40:11 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJOWkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 18:40:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gC4GL-0000W3-Sr; Mon, 15 Oct 2018 16:54:30 +0200
Message-ID: <644c72e8e967591cad8c32a13b358ed8b28d5285.camel@sipsolutions.net>
Subject: Re: [PATCH] bitfield: add constant field preparation macros
From:   Johannes Berg <johannes@sipsolutions.net>
To:     John Garry <john.garry@huawei.com>, linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, nbd@nbd.name
Date:   Mon, 15 Oct 2018 16:54:14 +0200
In-Reply-To: <d250e401-e939-c521-8e66-d9f6648db986@huawei.com>
References: <20181012194556.31004-1-johannes@sipsolutions.net>
         <d250e401-e939-c521-8e66-d9f6648db986@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-15 at 09:53 +0100, John Garry wrote:

> > +/**
> > + * __FIELD_PREP() - prepare a constant bitfield element
> 
> My impression is that the name prefix - '__' - tells little about the 
> function. If you agree, how about even CFIELD_PREP() or 
> FIELD_PREP_CONST() or similar? I preper the latter, but becomes rather long.

I was following the __cpu_to_{be,le}{16,32,64} playbook, but don't
really care much. I'd prefer FIELD_PREP_CONST() over CFIELD_PREP()
though, so we can change this.

> > + * @_mask: shifted mask defining the field's length and position
> > + * @_val:  value to put in the field
> > + *
> > + * __FIELD_PREP() masks and shifts up the value.  The result should
> > + * be combined with other fields of the bitfield using local OR.
> 
> should this be 'logical OR', or indeed 'bitwise OR'?

I'm not sure what happened there ... I copy/pasted the comment from
FIELD_PREP() but that says "logical OR" (which is in fact wrong, yes, it
should be say "bitwise OR").

johannes

