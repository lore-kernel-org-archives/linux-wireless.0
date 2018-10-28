Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90854C6786F
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 14:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582D720664
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 14:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXVwfsbp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 582D720664
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbeJ1XTv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Oct 2018 19:19:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34561 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbeJ1XTv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Oct 2018 19:19:51 -0400
Received: by mail-lf1-f66.google.com with SMTP id n26-v6so4149500lfl.1;
        Sun, 28 Oct 2018 07:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ogbCnzOS1qu3JW+CgfkkNaNgtD3s6w3fPHUt0d9V0ag=;
        b=LXVwfsbp2g9MLTM5ZHiuDYyMw2lIS/iru962c+V4xtEGAf9eYHeVQuYDv7AP7uKKzz
         e23TojkA0J4Vh7ZwqrxHC8uw3eIPDtaE5FGv+4GSkk9LSIa9DgtMHGd8z9qAgVg/kqBB
         FjNm4thp3ijGdTzPTWUm3WKclCZEHERqBV0fslfj6tjs0W1s1xo2z4X7slYoBmlUqvdw
         2czjuisC3zZlXFOWVYpbcrEouSvG6OnggJRgvr+HXGrP8GsHPlJQRumcx00UXUK28wKg
         L86+ZTUe4+GrcupOJhJOBQYajJFZobLapdmUBxDQLd6ExElh0pUBvRCdPyOsU4INrhsx
         ISnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ogbCnzOS1qu3JW+CgfkkNaNgtD3s6w3fPHUt0d9V0ag=;
        b=oiv9e3nbRxoJS4Dy+FxvRNuOFwu1ZlMQdf+kmXsunPwZ/CJ0ZZ5MAD3YB+AMz3zYHz
         tC3p4OZnKjh+eUWYYJH9cBpCADo5pRKQaCb5v6sC1EAaciDoeAFCU0+B74FFbbhvwOYK
         KmIPMHarKBnQVLXNO18wKYbQaQzIqJNqMjtiqv1tvmH7BOfcZoGY7OTyAHxsOlO+FIoq
         Zx10l+kbIC8ZtGjAWFENTB5/goAAqJthNUAgPzkJXATxSsd8/s1YYhhuh1YNkZchr7qy
         mx1vcSL22Bo2+TtNOHC58x0tOWsZF9tPqGpDxnCTRfKTUaNLObBLGDDaHGDGo0yylsHA
         SOOQ==
X-Gm-Message-State: AGRZ1gIhrXXpCBkXvJqFTMt+fLGeVUckoJ0zBt9QXwjDejqnRDPXkN+u
        Rc7ZJCPmv5kMgEl+NfNZoU4=
X-Google-Smtp-Source: AJdET5eB9O2m0E8jmvjV2VYdcdZAszA6JsArIXdXWnTQX2rgE+zgjo//9nrd52O3j5pcq6bigJ8tBA==
X-Received: by 2002:a19:24c6:: with SMTP id k189mr6386816lfk.77.1540737302128;
        Sun, 28 Oct 2018 07:35:02 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id t77-v6sm2795272lfi.63.2018.10.28.07.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 07:35:01 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gGm9h-0005Ok-DL; Sun, 28 Oct 2018 15:35:05 +0100
Date:   Sun, 28 Oct 2018 15:35:05 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        devicetree <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181028143505.GM27852@localhost>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
 <9494A12C-C53A-4F6E-B6F3-BABB09867677@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9494A12C-C53A-4F6E-B6F3-BABB09867677@holtmann.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Oct 28, 2018 at 02:46:24PM +0100, Marcel Holtmann wrote:

> >> +#define VERSION "0.1"
> > 
> > We don't version kernel drivers individually, so please drop this here
> > and below.
> 
> if we don’t then maybe send patches to remove MODULE_VERSION first.
> Otherwise this is totally fine to do.
> 
> There are currently 670 usages of MODULE_VERSION and I have not heard
> anybody looking at removing this.

Should have phrased that differently; versioning modules individually
does not make much sense when we already have a kernel version which is
tied to the driver code in question and which *does* get updated as new
kernels are released (unlike these module version defines, which tend to
stay unchanged).

For USB, we've dropped module versioning entirely and push back whenever
someone proposes to add it back. Other subsystems and particularly old
drivers may still have these macros of course.

In this case, the pn533 driver (and its interface drivers) is one of only
three NFC drivers which have MODULE_VERSION, but maybe it makes sense to
keep it in, if only for consistency with the other pn533 components.

Thanks,
Johan
