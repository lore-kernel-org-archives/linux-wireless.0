Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50959 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358Ab1CIIML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 03:12:11 -0500
Received: by mail-ww0-f46.google.com with SMTP id 28so285677wwb.27
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 00:12:06 -0800 (PST)
Subject: Re: [PATCH 06/15] wl12xx: 1281/1283 support - New boot sequence
From: Luciano Coelho <coelho@ti.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikrbys_9d5_ojHupM1U3eKsRi69O+tAReQpsOAn@mail.gmail.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	 <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
	 <1299589876.1816.67.camel@cumari>
	 <AANLkTikrbys_9d5_ojHupM1U3eKsRi69O+tAReQpsOAn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 10:12:08 +0200
Message-ID: <1299658328.1816.87.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 20:08 +0200, Levi, Shahar wrote:
> On Tue, Mar 8, 2011 at 3:11 PM, Luciano Coelho <coelho@ti.com> wrote:
> > On Sun, 2011-03-06 at 16:32 +0200, Shahar Levi wrote:
> >> -       clk |= (wl->ref_clock << 1) << 4;
> >> +       if (wl->chip.id == CHIP_ID_1283_PG20) {
> >> +               if (is_ref_clk == false)
> >> +                       clk |= ((wl->tcxo_clock & 0x3) << 1) << 4;
> >> +               else
> >> +                       clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> >> +       } else
> >> +               clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> >> +
> >>         wl1271_write32(wl, DRPW_SCRATCH_START, clk);
> >
> > Can you explain why you changed the wl127x part as well? For wl127x
> > you're essentially changing:
> >
> > clk |= (wl->ref_clock << 1) << 4;
> >
> > to:
> >
> > clk |= ((wl->ref_clock & 0x3) << 1) << 4;
> >
> > This means that CONF_REF_CLK_38_4_M_XTAL will be treated in the same way
> > as CONF_REF_CLK_19_2_E.  Is that right? If it is, it must be addressed
> > in a separate patch and not as part of the Quattro series.
> This implantation is due to the fact only those two bits is valid for
> clk setting (from MCP).
> CONF_REF_CLK_38_4_M_XTAL should be set as 19M.
> I will address is as separate patch.

Thanks! I think there should be a comment with an explanation that
CLK_38_4_M_XTAL should be set as CLK_19_2_E and why.


-- 
Cheers,
Luca.

