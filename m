Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54694 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904Ab1CIIQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 03:16:21 -0500
Received: by wwj40 with SMTP id 40so217993wwj.32
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 00:16:19 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fixes for 1281/1283 support - New boot sequence
From: Luciano Coelho <coelho@ti.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=hswVxfrn-E9gLORiAqBA=2B3dBC77mtBe6W_J@mail.gmail.com>
References: <1299421940-26292-7-git-send-email-shahar_levi@ti.com>
	 <1299591449-14741-1-git-send-email-coelho@ti.com>
	 <AANLkTi=hswVxfrn-E9gLORiAqBA=2B3dBC77mtBe6W_J@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 10:16:21 +0200
Message-ID: <1299658581.1816.92.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 20:15 +0200, Levi, Shahar wrote:
> On Tue, Mar 8, 2011 at 3:37 PM, Luciano Coelho <coelho@ti.com> wrote:
> > diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
> > index e0d60ab..ffdcb7e 100644
> > --- a/drivers/net/wireless/wl12xx/boot.c
> > +++ b/drivers/net/wireless/wl12xx/boot.c
> > @@ -533,46 +533,42 @@ static int wl128x_switch_fref(struct wl1271 *wl, bool *is_ref_clk)
> >
> >        /* if working on XTAL-only mode go directly to TCXO TO FREF SWITCH */
> >        if ((wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL) ||
> > -           (wl->ref_clock == CONF_REF_CLK_26_M_XTAL)) {
> > -               wl1271_debug(DEBUG_BOOT, "XTAL-only mode go directly to"
> > -                                        " TCXO TO FREF SWITCH");
> I believe that debug should be say in that function that check the ref value.

Sorry, I disagree.  This debug message is actually saying what is
happening when the ref_clock value is *_XTAL and what happens cannot be
seen in this part of the code, only in the part that calls this
function.

In fact, I almost removed this debug message completely, because there
are way too many debug messages that are good during implementation, but
shouldn't go out when the implementation is working.

I'll keep it (for now) after the function is called.


> > @@ -788,18 +778,8 @@ int wl1271_load_firmware(struct wl1271 *wl)
> >        /* WL1271: The reference driver skips steps 7 to 10 (jumps directly
> >         * to upload_fw) */
> >
> > -       if (wl->chip.id == CHIP_ID_1283_PG20) {
> > -               /*
> > -                * Configure SDIO/wSPI DS according to the following table:
> > -                * 00   8mA.
> > -                * 01   4mA (default).
> > -                * 10   6mA.
> > -                * 11   2mA.
> > -                * Write bits [1:0] of Register 0xd14
> > -                * data is in pWlanParams->PlatformConfiguration bits [2:1]
> Those two lines above is redundant. however I believe the comment
> should be stay.

This comment is useless in this part of the code.  If it should be
somewhere, it should be where the macros are defined.  But even there, I
think it doesn't add any value, because it's so obvious.


> > diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
> > index daaf0e7..429c926 100644
> > --- a/drivers/net/wireless/wl12xx/boot.h
> > +++ b/drivers/net/wireless/wl12xx/boot.h
> > @@ -125,7 +125,12 @@ struct wl1271_static_data {
> >  #define MCS_PLL_N_REG_VAL            0x07
> >
> >  #define SDIO_IO_DS                   0xd14
> > +
> > +/* SDIO/wSPI DS configuration values */
> > +#define HCI_IO_DS_8MA                0
> > +#define HCI_IO_DS_4MA                1 /* default */
> >  #define HCI_IO_DS_6MA                2
> > +#define HCI_IO_DS_2MA                4
> This value should be 3.

Ooops! Good that you noticed, thanks! I'll fix it.


-- 
Cheers,
Luca.

