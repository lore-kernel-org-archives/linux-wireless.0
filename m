Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D769BC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 09:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7925214AF
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 09:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qq62CN09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfBUJ2G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:28:06 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:32962 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfBUJ2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 04:28:06 -0500
Received: by mail-yw1-f66.google.com with SMTP id p17so10402305ywg.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 01:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lHw8NmRPUzP1Fxn6HThFfT9aSXYqBdEC1kjk1RDIdJ4=;
        b=qq62CN09IheYXntHB61NwuSZPHz0Ypexl97/XVVdOTmrKYGmfgJ0IFeCHmS5bad1Um
         JXFP2+GxobsZS70RSOaVOoErKyea0i0XNsEM/NkPiMf14/X/INa+8GojgxFJQEzi2UYN
         JiJRCAhsmMjZ8raGH6Lf0FyBDFKZ7q63r00aXnZgduYQJpr9ADa4TqGw+IO7cYvWSwb2
         /cdxKta8Vy4mu0VzU5fa8DUcw4mYElWFIq3fQ9N6jh1Gj7AlytKVfYwna6INIOqda+TQ
         wEmCxETTxY+ibFcBHj9pxzQ6hdch5IJTerru3J5PIjdOGeu15lDeHcYOTpWzZ67P0CFk
         nQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lHw8NmRPUzP1Fxn6HThFfT9aSXYqBdEC1kjk1RDIdJ4=;
        b=haal2+WyxEEi7JWhAsG6Ecax1ewo8J1AvMHBd7YbYCcWqUQ5+BQ7tym8VfV5CMC+Qb
         G3JSFR0m40PCclAwS3fACMbodsxRAahJc53exV7z+JsslncpRAeDBH/0Wc+wzoReNxoy
         w7mzp2VnuUTmHynZBZP1CV3XgepSca38CwrEkEwyfeVXBt56s3EZGlJskDo4ZofxInQv
         8UpRWmxHRtXHH9qPCVFsPAQ+WY0eehN5ys08RujeH69epOdoc2PRDg8MyN8OVmJne7Sb
         SzmtzC9E4tV28dmydzhrhg6g7ceq7i5JrWGjYREqp/JZfHB0k93SHV9wE+d/a2iL1iH/
         aTJQ==
X-Gm-Message-State: AHQUAuZvT7304tRudWk+jdhcgpnjoONuOPpsn7L8NWSGBklgPTSNTTou
        /vc6UbovXc/F+vqS0kAF9Yi9BZJSzZcCsbHOWuv3CzWJNPk=
X-Google-Smtp-Source: AHgI3IaKM94SbZXeL+BoQqiX0iv6Hegyj1Gb+83vBfmHCoPwWbHGaj69mDivwfrpqD9rGGXQDvtjTx72eZNrtR5XK18=
X-Received: by 2002:a81:25d7:: with SMTP id l206mr32152289ywl.253.1550741285153;
 Thu, 21 Feb 2019 01:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20190220103047.8960-1-zajec5@gmail.com> <CACna6rwwDN6svzWMGbxYXDp5CN8C=A=fV224QcfoLcACQQgLDA@mail.gmail.com>
 <92e8bf1e-3be9-96f2-93e9-ac504a609929@broadcom.com>
In-Reply-To: <92e8bf1e-3be9-96f2-93e9-ac504a609929@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Thu, 21 Feb 2019 10:27:53 +0100
Message-ID: <CACna6rxXJWwysJTauSKAb6rLeaXi1CBZSGcFNA5Nxn0ncQnG4Q@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 21 Feb 2019 at 09:59, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/21/2019 9:01 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > On Wed, 20 Feb 2019 at 11:31, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com=
> wrote:
> >> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >>
> >> While experimenting with firmware loading I ended up in a state of
> >> firmware reporting shared RAM address 0x04000001. It was causing:
> >> [   94.448015] Unable to handle kernel paging request at virtual addre=
ss cd680001
> >> due to reading out of the mapped memory.
> >>
> >> This patch adds some basic validation to avoid kernel crashes due to t=
he
> >> unexpected firmware behavior.
> >
> > For a reference for the further hackers. That has been caused by a
> > BCMA_CORE_SYS_MEM core on my BCM4366/4 not being up.
>
> Thanks, Rafa=C5=82
>
> Does that happen all the time or in some specific scenario. Anyway, it
> seems like we need to add a check in brcmf_chip_sysmem_ramsize() and
> bringup the core if needed. Although, I am curious in what the state the
> other cores are at that time. Might need a chip-wide reset.

It happens after brcmf_pcie_reset_device() which is probably a 100%
expected case ;)

Normally brcmfmac does not call brcmf_pcie_reset_device() between
brcmf_chip_sysmem_ramsize() and the brcmf_pcie_download_fw_nvram() so
it was only my hacking that caused that issue for me.

--=20
Rafa=C5=82
