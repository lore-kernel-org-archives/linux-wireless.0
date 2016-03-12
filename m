Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34401 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcCLH3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2016 02:29:14 -0500
Received: by mail-wm0-f51.google.com with SMTP id p65so43118461wmp.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2016 23:29:13 -0800 (PST)
Subject: Re: Probelm on (brcmfmac: use pre-allocated scatter-gather table for
 txglomming)
To: Michael Trimarchi <michael@amarulasolutions.com>,
	Arend van Spriel <arend@broadcom.com>
References: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56E3C548.5070000@broadcom.com> (sfid-20160312_083244_285944_D46EE1C0)
Date: Sat, 12 Mar 2016 08:29:12 +0100
MIME-Version: 1.0
In-Reply-To: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11-03-16 16:23, Michael Trimarchi wrote:
> Hi
> 
> I have a kernel panic on the brcmf_sdiod_sgtable_alloc just because
> the function is called before brcmf_sdio_probe.
> 
> I think that
>  nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
>                       sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
> 
> drvr is null. Can you explain how it can work or do you have already a
> fix for this?

What kernel version are you using? This has been fixed already in
4.5-rc2 or rc3.

Regards,
Arend
