Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076E5C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 20:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDB6E20850
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 20:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nOuzr46+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfCYUIn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 16:08:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46249 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbfCYUIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 16:08:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id s81so6145553qke.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 13:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=May9l0YsDT4EYuAmCtsCD8nMkcQTR8KyyKtJCqApxTk=;
        b=nOuzr46+T5HKmW45hDPqwZtFLxuv6qBOvAc0Fx+OFW3gCPfmC/4a3Bz2jB34EQ7kdT
         1Nc+/p0ID4yKLjB44kJInJSUI7JUn/LbzOeVsyvoE6f1OOWkKHazemOeitdxp4TusthE
         uMuGgQOFUkmJv94PsmVWzLshbOyzHolH4txtHIMDnbCjXqAXZa9xbii3h+i20ijCyKc7
         NNMCJki/MOBgQ0JLK8eieoK6fC7ysEISWE0wuJ7ONd65SS5eMBC5KREudOkXmmxpaqrQ
         57WwLy7URrX7JyyJcF8S3f61NcYzq3rR4Z37+eldz+YROXUDKmyQtobHrdg43cyYCbkM
         PIOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=May9l0YsDT4EYuAmCtsCD8nMkcQTR8KyyKtJCqApxTk=;
        b=YDVGeBBPHBGRzSUe/YVsV6re9zkn6SK2y0jduu0tGuKD3pMM5nE+DHmgxMCp+G1N+8
         uKFJ0IiSPtajd5NYyLUBuPL+fvavGh9IVk2CGohDzzcfSlL445B70IasC9e/In0d5MkF
         koeT6gPe2QjrCCt3xwDj13rK/vT773b68GpFiYkdUco1RcnjcGjJCSyNYhZkV3OnKxjf
         6TJf3po1oTdDqRuYra5OPQKtB1CtW0GWeGyXtFl2MA5VB5R/5YyI59L1xd34y943nAcQ
         WzY4uOYAAvrBojA0pe7TCwTX6Q54RoXgcYhOfizrZw5BtRU8+nKQEtcr+CvIbNvGmnOs
         7Zcg==
X-Gm-Message-State: APjAAAUFPrA3KGhK8HCrSeZlfXjBnbCalIxlcBqFTxo+VD6/3TlFKOLe
        32Xlfb4XSxNeqVecFP/0567F0Xgbsk6oKBhpz0c=
X-Google-Smtp-Source: APXvYqyFUzQ2HDXV8CeyKkE1aH7AKdjjbGx/pfu8h2OOL+nGf3fNKHDP/53FXq5jjqaT2K9qXlIVJMAcvQ8em0aFbL8=
X-Received: by 2002:a37:b444:: with SMTP id d65mr20494029qkf.125.1553544521838;
 Mon, 25 Mar 2019 13:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64> <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
 <edc38f32-977a-53f5-babd-605775326a20@broadcom.com> <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com>
 <c13da25c-9116-9388-8e40-96bac8dca087@candelatech.com>
In-Reply-To: <c13da25c-9116-9388-8e40-96bac8dca087@candelatech.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 25 Mar 2019 21:08:30 +0100
Message-ID: <CABvG-CWP4y4MU1pJB8ZSpLPPYMkQ+=kQt1zRoUJW=0dMLbD5WQ@mail.gmail.com>
Subject: Re: [PATCH] ath10k: reset chip after supported check
To:     Ben Greear <greearb@candelatech.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?Q?Tomislav_Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 25 Mar 2019 at 16:55, Ben Greear <greearb@candelatech.com> wrote:
> On 3/25/19 5:14 AM, Micha=C5=82 Kazior wrote:
> > On Sat, 23 Mar 2019 at 08:20, Arend Van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >>
> >> * resending with corrected email address from Kalle
> >> --------------------------------------------------------------------
> >> + Micha=C5=82
> >
> > Thanks!
> >
> >
> >> On 3/22/2019 8:25 PM, Christian Lamparter wrote:
> >>   > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Po=C5=BEega wrot=
e:
> >>   >> When chip reset is done before the chip is checked if supported
> >>   >> there will be crash. Previous behaviour caused bootloops on
> >>   >> Archer C7 v1 units, this patch allows clean device boot without
> >>   >> excluding ath10k driver.
> >
> > Can you elaborate more a bit? What kind of crashes are you seeing?
> > What does the bootloop look like? Do you have uart connected to
> > diagnose?
> >
> > Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
> > by ath10k? I recall the v1 chip was really buggy and required
> > hammering registers sometimes to get things working.
>
> The crash is related to the v1 chip.  Is there a good way to detect
> that this is the chip in question and only apply this work-around
> for the problem chip?

I don't know of any good way to do that.

You could consider device-tree but that would be no different from
having a module blacklist in the C7v1 build recipe, or to not build
the module at all. That is unless you actually want to make v1 chip
work with ath10k at which point there's more fun to be had before it
can actually work.


Micha=C5=82
