Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE70C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 01:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5A4F206C2
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544925188;
	bh=X3oqi7XGqDnCKrhOJvOThUel+yEZo3hQSMRh4pDoRUY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=o9/mcmljNlMh6b/fjlvsDp7sL8+iv35HlwklkDsWR4vIGaL4XCez+du+UYL/7SCdy
	 oe3CblQ9ZE4MSB43s+KOdpgbQt09zG9A/0bQW1fIERprDuFWVI32Yo4QaNbRWNQ8/j
	 WBk+Ng2MAO6ctZjrxFSY1a4sGrQfaXWXUaw8OZqg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbeLPBxH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 20:53:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbeLPBxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 20:53:06 -0500
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BD1206C2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Dec 2018 01:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544925186;
        bh=X3oqi7XGqDnCKrhOJvOThUel+yEZo3hQSMRh4pDoRUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KUzlk55qv/noqe7H0ckk9FaVVpi5it5RSMHfHiJs9ALYeu5jz6bDlNn4XkG7HcHrb
         q3xEG/OIBRF+BHEQPAZa3UeORz8WyOv2oksgUr861aOWt/Y4tJNbSij2bAKyx/Mw+T
         OLvoWZU94f4QT0/IKuY3pH5cpJk0q26hHKF55WAU=
Received: by mail-qk1-f179.google.com with SMTP id r71so5497959qkr.10
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2018 17:53:05 -0800 (PST)
X-Gm-Message-State: AA+aEWZUJhdDDmOF90NjxM/IwkI8JJoEGwsHVBhd8hMwMN3Tl9CtuUGq
        0yAl7HBdNjaFpwVHaRlCGT2zEjZz2N2F8F3fVvo=
X-Google-Smtp-Source: AFSGD/XMxSqAStw7uSM5dKwCuQNz3ar13zNeHNUbcuzuiPn2AI1/ZqglOm572jrymm+PPL4ryLOlZ2eNs/3XaI4aV+k=
X-Received: by 2002:a37:bb82:: with SMTP id l124mr7099859qkf.188.1544925185220;
 Sat, 15 Dec 2018 17:53:05 -0800 (PST)
MIME-Version: 1.0
References: <1541622996-16181-1-git-send-email-arend.vanspriel@broadcom.com>
 <CA+5PVA4Q4gscG45dfz_Kk0ihuuG9FPuxNFHozNt5eVAU2EChAw@mail.gmail.com> <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
In-Reply-To: <1151c860-f01b-7689-bae7-3a7869b7f356@broadcom.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Sat, 15 Dec 2018 20:52:54 -0500
X-Gmail-Original-Message-ID: <CA+5PVA4h3tVm9X_Qh4H1E_8KAVpZiRLL+v7LnfXGHZJqXwyDow@mail.gmail.com>
Message-ID: <CA+5PVA4h3tVm9X_Qh4H1E_8KAVpZiRLL+v7LnfXGHZJqXwyDow@mail.gmail.com>
Subject: Re: [PATCH] brcm: provide new firmwares for BCM4366 chipset
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Dec 15, 2018 at 6:02 AM Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
>
> On 12/14/2018 2:02 PM, Josh Boyer wrote:
> > On Wed, Nov 7, 2018 at 3:45 PM Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >>
> >> These firmwares are for the BCM4366 3x3 802.11 ac chipsets, which also comprise of BCM4366E or BCM43664 devices. Signed-off-by: Arend van Spriel
> >
> > This didn't add brcm/brcmfmac4366c-pcie.bin to WHENCE.  I'm assuming
> > it's under the same license as the rest of the brcmfmac files?  If so,
> > I can just amend the patch.
>
> Hi Josh,
>
> I was not sure this patch ever made it through. It did not appear on
> linux-wireless list probably due to exceeding a size limit. So I resend
> it as two patches on December 10th. However, I indeed forgot to update
> the WHENCE file in that series as well. Indeed there is no license change.

OK.  Amended and pushed out.

josh
