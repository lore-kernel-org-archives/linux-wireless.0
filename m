Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45931 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab1CHSI1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 13:08:27 -0500
Received: by mail-iy0-f176.google.com with SMTP id 12so6435979iyj.7
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 10:08:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299589876.1816.67.camel@cumari>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	<1299421940-26292-7-git-send-email-shahar_levi@ti.com>
	<1299589876.1816.67.camel@cumari>
Date: Tue, 8 Mar 2011 20:08:26 +0200
Message-ID: <AANLkTikrbys_9d5_ojHupM1U3eKsRi69O+tAReQpsOAn@mail.gmail.com>
Subject: Re: [PATCH 06/15] wl12xx: 1281/1283 support - New boot sequence
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 8, 2011 at 3:11 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-03-06 at 16:32 +0200, Shahar Levi wrote:
>> -       clk |= (wl->ref_clock << 1) << 4;
>> +       if (wl->chip.id == CHIP_ID_1283_PG20) {
>> +               if (is_ref_clk == false)
>> +                       clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
>> +               else
>> +                       clk |= ((wl->ref_clock & 0x3) << 1) << 4;
>> +       } else
>> +               clk |= ((wl->ref_clock & 0x3) << 1) << 4;
>> +
>>         wl1271_write32(wl, DRPW_SCRATCH_START, clk);
>
> Can you explain why you changed the wl127x part as well? For wl127x
> you're essentially changing:
>
> clk |= (wl->ref_clock << 1) << 4;
>
> to:
>
> clk |= ((wl->ref_clock & 0x3) << 1) << 4;
>
> This means that CONF_REF_CLK_38_4_M_XTAL will be treated in the same way
> as CONF_REF_CLK_19_2_E.  Is that right? If it is, it must be addressed
> in a separate patch and not as part of the Quattro series.
This implantation is due to the fact only those two bits is valid for
clk setting (from MCP).
CONF_REF_CLK_38_4_M_XTAL should be set as 19M.
I will address is as separate patch.

> --
> Cheers,
> Luca.
-- 
All the best,
Shahar
