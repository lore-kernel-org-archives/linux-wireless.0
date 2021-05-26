Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFA7C2B9F7
	for <linux-wireless@archiver.kernel.org>; Wed, 26 May 2021 04:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F6E46138C
	for <linux-wireless@archiver.kernel.org>; Wed, 26 May 2021 04:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhEZEsz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 May 2021 00:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhEZEsy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 May 2021 00:48:54 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15EEC061756
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2021 21:47:23 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id q1so544509lfo.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2021 21:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=b+UKXW+uMbZ8Cq5lcKhckVzL4YdYbMAUykQFsJ80oRc=;
        b=ioe/HFBB+kmYFwMWKpM83oAu+OoXCYlC8FKvbMQqkh5k77+gXJH70uUXKApVzRU1wh
         LLFo+nOcROBcrlsHRm8i8b3bsIWudX0sd9/BqK5YzWu26nuP4gE0e3iSGEd0ze34Wzfj
         0h7/dFso/XIlNxJk0qGAQxaXwsa2gen9xs0g8KdigGb3SEGBIbt/fK3676JnZXaciD8M
         lEQduVnZXqgPcW+ktr3AArLJXLATQgOfjMgaYY5WD0I1SwYMGlJ0xkwdwDwkg8ZFsXFH
         k9mg2ihbmVFxK9ViaVELYtxw/pa7khwP/ymCGb81M5O4LpvooyHTWj7vg+/Ns1xqi4Ww
         3PvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=b+UKXW+uMbZ8Cq5lcKhckVzL4YdYbMAUykQFsJ80oRc=;
        b=Q0BdOmeCyU+80C0QVHp3EbIp8IvPwY8CRqjQpw1l+lRoK+4XB3QDnBnGY4HyvxtPS/
         UQTu9KS1kPfZSfDsmdqJfV8NCJZXc23HQlPWo8FaUY8Hf9zds44oBnhAk7i6XVHBAi8b
         xdJKnxUzKQ2SRLWLNNirwiBnJekf2XDFKi56ZD65X3ARTJEwR7yZFsiieoq+6vPNi5Ss
         h1Pl/GY+7xbPuIHFfczfnjAlH0LwNrO5hFgeCgi5X5HeIYlzTHlITw5dtOOo3k+kM6w4
         i7hWDbeR0cr59jvc7f6yaHwaML3jpvZswqNH4sgItXnlLO/Gxr0M4J6UDyHgM2uEmG3O
         Fftg==
X-Gm-Message-State: AOAM530K2c8Qi7AA3MA5XFIA6O9C3E0mSh0ee/Gxb/mzt4+OxMVi/kW6
        sSiP6nDnPqmlzOLWSFC2ytAIbKIhjMU2Bqg/UjmwbVXjLNc=
X-Google-Smtp-Source: ABdhPJx/UCVokLttU+3rcYlZaXtNlGiq+WfLQlbWtKjWvIAgSZFZMavvdjCNAXxi8ZqWVdZeMRFxp50gdDXCZcH0fuU=
X-Received: by 2002:ac2:4e8f:: with SMTP id o15mr805915lfr.527.1622004441872;
 Tue, 25 May 2021 21:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <CACrnO3trnUTj+vsi3BGtR_HqR98ppod8thY76XFLzdc5SaXJ8Q@mail.gmail.com>
In-Reply-To: <CACrnO3trnUTj+vsi3BGtR_HqR98ppod8thY76XFLzdc5SaXJ8Q@mail.gmail.com>
From:   Bhavesh Kamani <bhavesh.kamani.wireless@gmail.com>
Date:   Wed, 26 May 2021 10:17:15 +0530
Message-ID: <CACrnO3sRZYYYZthyErNQyhOwpMcuFo5qb_XyBJeu6K6f-R_k2Q@mail.gmail.com>
Subject: Re: Ath9k : Frag attacks
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Team,

Any thoughts/opinion on this?

Regards,
Bhavesh

On Mon, May 24, 2021 at 5:40 PM Bhavesh Kamani
<bhavesh.kamani.wireless@gmail.com> wrote:
>
> Hi All,
>
> I was going through the patches listed here :
> https://lore.kernel.org/linux-wireless/20210511180259.159598-1-johannes@sipsolutions.net/
> From the patch names it is clear that patches are for ath10k and ath11k.
> Do we need separate patches for ath9k driver or same set of
> patches(available in above link) will work?
>
> Regards,
> Bhavesh
