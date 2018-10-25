Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4170DECDE47
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 20:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0C32054F
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 20:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQhQesyP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB0C32054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbeJZFHe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 01:07:34 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44730 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbeJZFHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 01:07:34 -0400
Received: by mail-oi1-f193.google.com with SMTP id k19-v6so1841042oic.11;
        Thu, 25 Oct 2018 13:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=9mc+cUu9+3kBOHiROgxNNx1QR01eTy6jVlFvG76VZMw=;
        b=IQhQesyP/W4Uob+B/LfIqZacUHeudtSd2A3P0no2k4Uqn3tksh23krLb49mpNMrbe6
         KijK4WTcUkesUrKR9jgcbYTr2aGXYYrg4WIogn/YJMSJ3AZUpyeSOtukkuCUUXFXkkj8
         mlH78zFRJor6A9r22Xbw7Aisjh+WOaT2luO5Oa3kURQpoZJYbv3x1owrdkQYeKVs69hs
         y38fEGlfN8L0pDa2GkVwbLmCgAiE8y5lt7GyiGEBKzuZJaX3Q7WfHKjbrSOj197bPSr2
         d2Myj/fqTrntlu/3EmSQrAIBx4MNw6XEa6F6CwmwWmERqSXn8520xcfH5BC7c9QPcDOy
         2xNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=9mc+cUu9+3kBOHiROgxNNx1QR01eTy6jVlFvG76VZMw=;
        b=TNH/AS36b88zrfxq71ziQ2hWjfHwLkxnjO6hQbsuDvd+casS2TRZZFD08M87L67Ha2
         dcGeGQ3AyafjrVIa96evdtGinfWyhXqj1nhlnSueEm6+RfrfHWX5GO+98j8mAd0wD223
         wnEAmzm3JAODlWDo+pXSm6OlA3PSdsxk4lNMmO3/j2ZGYL/9MOsnFrgvJA9264IjZ67D
         +mu8W4bOfEpRHaFOWLew+r5c3LwgocjPwaU8cBDw72v1+O8olyHmfrj1m8SMpj6CK6Lm
         AvTZJKPFHKlfuMKap4T+xrmJwPuYXuVpFsODT7m8NrPc1QRx6ab6e06pIIco68WDjwzS
         FsTQ==
X-Gm-Message-State: AGRZ1gKeNljSq/gKRb2+QY6JA9Qyh6Ukl6VOIy7lHhdhZQnHn+Hydwzf
        sz2jSPXWiEP+auut5x6BM+ezvEjNSFjolQr3B/Nahw==
X-Google-Smtp-Source: AJdET5c2IZQsNo2WeMggLGHJ5aeM8SDJ/DS5hUZcm89CuiV1gIdJiO/22XGIfuHqRzzDEOH7024quM7S9PxhC6hJX4Q=
X-Received: by 2002:aca:3c56:: with SMTP id j83-v6mr473490oia.155.1540499600305;
 Thu, 25 Oct 2018 13:33:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Thu, 25 Oct 2018 13:33:19
 -0700 (PDT)
In-Reply-To: <20181025141853.214051-13-sashal@kernel.org>
References: <20181025141853.214051-1-sashal@kernel.org> <20181025141853.214051-13-sashal@kernel.org>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 25 Oct 2018 22:33:19 +0200
Message-ID: <CAKR_QVJ56Ei_rq7bvRdt3KR1eLhhP8Uamf_-Rn=uDb-eEoGq1A@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 3.18 13/98] PCI: Mark Atheros AR9580 to avoid bus reset
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maik Broemme <mbroemme@libmpq.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 25/10/2018, Sasha Levin <sashal@kernel.org> wrote:
> From: Maik Broemme <mbroemme@libmpq.org>
>
> [ Upstream commit 8e2e03179923479ca0c0b6fdc7c93ecf89bce7a8 ]
>
> Similar to the AR93xx and the AR94xx series, the AR95xx also have the same
> quirk for the Bus Reset.  It will lead to instant system reset if the
> device is assigned via VFIO to a KVM VM.  I've been able reproduce this
> behavior with a MikroTik R11e-2HnD.
>
> Fixes: c3e59ee4e766 ("PCI: Mark Atheros AR93xx to avoid bus reset")
> Signed-off-by: Maik Broemme <mbroemme@libmpq.org>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: stable@vger.kernel.org	# v3.14+
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pci/quirks.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 9e86ace95832..0b75b47a5329 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3081,6 +3081,7 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030,
> quirk_no_bus_reset);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0032,
> quirk_no_bus_reset);
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c,
> quirk_no_bus_reset);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033,
> quirk_no_bus_reset);
>
>  #ifdef CONFIG_ACPI
>  /*
> --
> 2.17.1
>
>

Hi

You should CC this to linux-wireless list too
