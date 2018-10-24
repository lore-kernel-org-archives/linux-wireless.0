Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9974AC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A5DF2081B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTXptoFu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A5DF2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeJXRy1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:54:27 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33275 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbeJXRy1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:54:27 -0400
Received: by mail-yb1-f193.google.com with SMTP id i78-v6so66301ybg.0;
        Wed, 24 Oct 2018 02:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/QvYbsC94QTCRQkkAok9mKAYmgf3aC2DUiLVcms5vo=;
        b=LTXptoFuiZJOwwGV/9B5xNqzKY9VGugIkGsNPh5r1juuu89KVxctaimigzX1LGInfo
         Nupr8bO3CLHxsWXb6RCGNsSTeu2naw3E7OtiFAWQd60myCeqQSf2x+EaPsd4hhCV7ilt
         sgLJs8sUFAdw6fG9CQt4/j7oZ76h9B9mRp5pkod69gGGQIzz6PfjeV3QnjGkJ97Spk+t
         gkecXiuaTfd+Q4pANmmJEqlP9a4FP/K2ADUCYs9YYV/J6M4hORiyB1cFM/VZAtiK62iy
         8PEKYBcsB3eSELzgxCeMgsUWuTE5EHW+tMYRwfwmWlEwIyOpDHiRmDR7+CHEjdb1fLRe
         dUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/QvYbsC94QTCRQkkAok9mKAYmgf3aC2DUiLVcms5vo=;
        b=nI2aY/Uyx7O95oBYlC8S714irE/Wkns5FwXg1gH0AcgX3MNDdSLWdXXllOHT3MsLXJ
         OU8rdJ+ZOq1J/gBSSNGurG/kVhJVO0Rzy2spaXz3a1w8sFMoOX9foYDUFSWO6zdZ+/em
         aZkHewFy6f3q9kAY/6e34wEC3ckWrMNMx5SOrgHTzxJcq7OxGXm10ftL1abmZ6Eu1iFT
         qIHZk/SIdp6hLNF6UF38DyisbyyGdlWTurT8YL4Ns0Bwn4M80GnXSVsCXr8AhGK8gf3h
         pUyFTjpY/lgkSyk1ivlf03j5bUNL2sGDvWiVrb5Bx98vl/ai71MVYBVVg0AUNj8oY8j+
         n2bA==
X-Gm-Message-State: AGRZ1gKVWA6g0MVnPt/1QVCJgc/azsJtqsGs+PdLe4ww6mcjoMfyKlah
        8rPE1Ge8D6MbFSgeSlETCsyBnv1ZDD7kDxBAj80=
X-Google-Smtp-Source: AJdET5ecJCvwWdE80oUOA/VEdcVcr5doDU4O2k0OvIjNT4q7IJ1zwqeSD1iUT6pA/Dcbtn/MGCoLTrjtEe363zQbCr0=
X-Received: by 2002:a25:5555:: with SMTP id j82-v6mr1432293ybb.337.1540373225831;
 Wed, 24 Oct 2018 02:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181024083334.a6pxsifew3iztuun@kili.mountain>
 <87sh0vsox6.fsf@codeaurora.org> <20181024090721.uxgwo6h6p3h6u5vp@mwanda> <87o9bjsno8.fsf@codeaurora.org>
In-Reply-To: <87o9bjsno8.fsf@codeaurora.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 24 Oct 2018 12:26:54 +0300
Message-ID: <CAOQ4uxiZ9bee_s+4=C1w03Jn475KZ=qJszvM+dnAP4kWwNJKRA@mail.gmail.com>
Subject: Re: [PATCH] wireless: airo: potential buffer overflow in sprintf()
To:     kvalo@codeaurora.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 12:23 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
> > On Wed, Oct 24, 2018 at 11:56:53AM +0300, Kalle Valo wrote:
> >> Dan Carpenter <dan.carpenter@oracle.com> writes:
> >>
> >> > It looks like we wanted to print a maximum of BSSList_rid.ssidLen bytes
> >> > of the ssid, but we accidentally use "%*s" (width) instead of "%.*s"
> >> > (precision) so if the ssid doesn't have a NUL terminator this could lead
> >> > to an overflow.
> >> >
> >> > Fixes: e174961ca1a0 ("net: convert print_mac to %pM")
> >> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> > ---
> >> > Static analsysis.  Not tested.
> >>
> >> IMHO this part (after "---" line) is important information and should be
> >> part of commit log. I can fix that.
> >>
> >
> > In my experience most maintainers disagree (with varying degrees of
> > intensity).
>
> Heh, why would adding four words explaining the background of the patch
> to a commit log would be a bad thing? :) Well, I guess I just view
> things differently.
>

By the time a maintainer applies a patch and requests to merge it upstream
the patch should be tested. Right?
So how would a comment "Not tested" make any sense in an upstream
merged patch?

Thanks,
Amir.
