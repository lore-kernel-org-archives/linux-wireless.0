Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D98CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB5D82082F
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MRFz6fwV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfCYVfL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:35:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33066 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbfCYVfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 17:35:10 -0400
Received: by mail-qt1-f193.google.com with SMTP id k14so12254094qtb.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 14:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lJY6q+ONTrUeLO1p6TiIr6TlYMWEq3oTPlOX02efMLw=;
        b=MRFz6fwVMH43qzkcqMqc109ELhRye0dOVqQ3XbP6/b0/RxTxWvWrC0b5l0Eo+ed/Cm
         cos9ucIjN5biR8u1+xcLp59SFfGHJk5fGOkGjRAprNFfFSFi6ogcNO/B2kIb4tdbAzSf
         z/2QxyLK/2cUF/aBFHPL4el0CsE6hqGnWI9YBygyNf9I5A8dhEgkENEJGSpreWaMM4b8
         FGzJa3CAeAFmW1DMT6XQJVpsnZchaWbZhuNBIhz+UPd7XjCFc2fEO+u/EjgttVydb5Wu
         ZBlhuTBroVw2mO1H2pyffmjp0WoJzuYjN15HPBknjeNtFb1WLlkY38bYgdtfzZXBwi0v
         9cFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lJY6q+ONTrUeLO1p6TiIr6TlYMWEq3oTPlOX02efMLw=;
        b=YCWsbd94ohmxgOM3n6LAPRm+I5p3OvOvYfN6Y1SxOKeaKLeyiD8UlsbcTK1EE5+oGI
         LOCLRFi8Vh6mjVd61C1P+G+QSyVZP63/Z4R15AD5V5yKxm9oRvLKq+XLoNe3eAtqh37Z
         EB5ovG7jyc6W4NaAQEVyxSjwFxGEXMUy8RYkpNSncAayWVQqkOdvujkwQDpLWHHPUFBE
         qwhzcx3hjHeMvM/eZL5wiwWJEcdrirL8DUs057RxHD1NGYIOdpxjv2IBiUULuUlaLAWR
         TpLOR5bIl7rsW8I+JSro0yx+zx+BGFT2WrzupX6T/U7CeFTg0gkDlK0TBL6vk4wJRBg+
         vw+Q==
X-Gm-Message-State: APjAAAXLUN0qWrAVh+X+dfqK0gp852VSR+qnYe/39kS84P2+pDQf3Tsg
        s99E2wzW5RqtNXiNPTmm5Hx++fYnyCghwO0AyJY=
X-Google-Smtp-Source: APXvYqxAaGhHR9Qv1s37O4OSbKsOVdM04HgnleU6gNUjv4rDd0rXX41XUUAFN8gXQTBSdh2WXemVZtdJPfbVk5Cjvt8=
X-Received: by 2002:ac8:1738:: with SMTP id w53mr23345008qtj.201.1553549709729;
 Mon, 25 Mar 2019 14:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64> <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
 <edc38f32-977a-53f5-babd-605775326a20@broadcom.com> <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com>
 <c13da25c-9116-9388-8e40-96bac8dca087@candelatech.com> <CABvG-CWP4y4MU1pJB8ZSpLPPYMkQ+=kQt1zRoUJW=0dMLbD5WQ@mail.gmail.com>
 <f3763b33-7944-81f8-98e1-053e51474a38@candelatech.com>
In-Reply-To: <f3763b33-7944-81f8-98e1-053e51474a38@candelatech.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 25 Mar 2019 22:34:58 +0100
Message-ID: <CABvG-CW2WNpi6Wcan3UMOWKfZLDTgmEzif63Peemnyk+4VtW3Q@mail.gmail.com>
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

On Mon, 25 Mar 2019 at 21:23, Ben Greear <greearb@candelatech.com> wrote:
>
> On 3/25/19 1:08 PM, Micha=C5=82 Kazior wrote:
> > On Mon, 25 Mar 2019 at 16:55, Ben Greear <greearb@candelatech.com> wrot=
e:
> >> On 3/25/19 5:14 AM, Micha=C5=82 Kazior wrote:
> >>> On Sat, 23 Mar 2019 at 08:20, Arend Van Spriel
> >>> <arend.vanspriel@broadcom.com> wrote:
> >>>>
> >>>> * resending with corrected email address from Kalle
> >>>> --------------------------------------------------------------------
> >>>> + Micha=C5=82
> >>>
> >>> Thanks!
> >>>
> >>>
> >>>> On 3/22/2019 8:25 PM, Christian Lamparter wrote:
> >>>>    > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Po=C5=BEega w=
rote:
> >>>>    >> When chip reset is done before the chip is checked if supporte=
d
> >>>>    >> there will be crash. Previous behaviour caused bootloops on
> >>>>    >> Archer C7 v1 units, this patch allows clean device boot withou=
t
> >>>>    >> excluding ath10k driver.
> >>>
> >>> Can you elaborate more a bit? What kind of crashes are you seeing?
> >>> What does the bootloop look like? Do you have uart connected to
> >>> diagnose?
> >>>
> >>> Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
> >>> by ath10k? I recall the v1 chip was really buggy and required
> >>> hammering registers sometimes to get things working.
> >>
> >> The crash is related to the v1 chip.  Is there a good way to detect
> >> that this is the chip in question and only apply this work-around
> >> for the problem chip?
> >
> > I don't know of any good way to do that.
> >
> > You could consider device-tree but that would be no different from
> > having a module blacklist in the C7v1 build recipe, or to not build
> > the module at all. That is unless you actually want to make v1 chip
> > work with ath10k at which point there's more fun to be had before it
> > can actually work.
>
> I remember v1, and I have no interest in trying to make it work :)
>
> If we could blacklist certain pci slots in the ath10k driver, I guess
> that would work?
>
> I think the goal is to not use the v1 chip, but allow users to add a
> v2 NIC to the platform, so driver still needs to load.

That makes sense, but I don't see how blacklisting pci slots would
help someone putting v2 nic into C7v1 mobo? Won't the slot be the same
regardless what nic is put?

The best thing I can come up with is something like this:

--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3629,6 +3629,19 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
                goto err_deinit_irq;
        }

+       if (hw_rev =3D=3D ATH10K_HW_QCA988X) {
+               /* v1 can crash the system on chip_reset()
+                * so all we can do is keep our fingers
+                * crossed v2 never reports 0 without a
+                * chip_reset()
+                */
+               if (ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS) =3D=3D 0=
) {
+                       ath10k_err(ar, "qca9880 v1 is chip not supported");
+                       ret =3D -ENOTSUP;
+                       goto err_free_irq;
+               }
+       }
+
        ret =3D ath10k_pci_chip_reset(ar);
        if (ret) {
                ath10k_err(ar, "failed to reset chip: %d\n", ret);

I didn't test it. Someone needs to compile and test and make sure v2
doesn't regress when fw hangs and cold & warm host cpu resets are
mixed in.


Micha=C5=82
