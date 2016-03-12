Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34178 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbcCLI51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2016 03:57:27 -0500
Received: by mail-io0-f173.google.com with SMTP id m184so172563505iof.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Mar 2016 00:57:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E3C548.5070000@broadcom.com>
References: <CAOf5uwkT=Z2V3JadZeFKKU6m1sTozcC+ObEPzwR_qPuzv6X7Xw@mail.gmail.com>
	<56E3C548.5070000@broadcom.com>
Date: Sat, 12 Mar 2016 09:57:25 +0100
Message-ID: <CAOf5uwniA8=nsNC=paSTLARxMKpjsnuGko1r+iLdrXgsWR5Ufg@mail.gmail.com> (sfid-20160312_095730_915951_FA874D61)
Subject: Re: Probelm on (brcmfmac: use pre-allocated scatter-gather table for txglomming)
From: Michael Trimarchi <michael@amarulasolutions.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi


On Sat, Mar 12, 2016 at 8:29 AM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
> On 11-03-16 16:23, Michael Trimarchi wrote:
>> Hi
>>
>> I have a kernel panic on the brcmf_sdiod_sgtable_alloc just because
>> the function is called before brcmf_sdio_probe.
>>
>> I think that
>>  nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
>>                       sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
>>
>> drvr is null. Can you explain how it can work or do you have already a
>> fix for this?
>
> What kernel version are you using? This has been fixed already in
> 4.5-rc2 or rc3.

Ok, I see it I was using rockchip for-next and I have seen now the fix
in newest tree.

Thank you
Michael

>
> Regards,
> Arend



-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
