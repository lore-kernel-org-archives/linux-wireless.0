Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387884AbeGWHnV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 03:43:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Aditya Xavier <adityaxavier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: fix regression in parsing NVRAM for multiple devices
References: <20180722214625.12101-1-zajec5@gmail.com>
Date: Mon, 23 Jul 2018 09:43:33 +0300
In-Reply-To: <20180722214625.12101-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Sun, 22 Jul 2018 23:46:25 +0200")
Message-ID: <87y3e2xxii.fsf@codeaurora.org> (sfid-20180723_084343_544719_2FF3F499)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> NVRAM is designed to work with Broadcom's SDK Linux kernel which fakes
> PCI domain 0 for all internal MMIO devices. Since official Linux kernel
> uses platform devices for that purpose there is a mismatch in numbering
> PCI domains.
>
> There used to be a fix for that problem but it was accidentally dropped
> during the last firmware loading rework. That resulted in brcmfmac not
> being able to extract device specific NVRAM content and all kind of
> calibration problems.
>
> Reported-by: Aditya Xavier <adityaxavier@gmail.com>
> Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() functi=
on")
> Cc: stable@vger.kernel.org # v4.17+
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

I'll queue this to 4.18 (if there's still time). I just came from
vacation and have some catching up to do :)

--=20
Kalle Valo
