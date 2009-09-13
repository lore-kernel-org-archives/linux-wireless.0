Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56950 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZIMKNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 06:13:05 -0400
Received: by ewy2 with SMTP id 2so2197250ewy.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 03:13:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAC240E.20104@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br>
Date: Sun, 13 Sep 2009 11:13:06 +0100
Message-ID: <3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 12, 2009 at 11:43 PM, Leonardo H. Souza Hamada
<leonardo.hamada@ufra.edu.br> wrote:
> Hi all,
>
> At this moment, after tweaking the zd1211rw code in kernel
> 2.6.31-gentoo, finally I am able to use the WLI-U2-KG54L wireless usb
> dongle on this old ibook.
>
> Browsing the source with a cross referencing tool
> (http://lxr.free-electrons.com) and making additional checking points, I
> could trace the issue as follow.
>
> The problem is that this device returns a regulatory region of 0x49,
> which is not defined in the zd1211rw tables. So the call
>
> r <http://lxr.free-electrons.com/ident?i=r> = zd_reg2alpha2 <http://lxr.free-electrons.com/ident?i=zd_reg2alpha2>(mac <http://lxr.free-electrons.com/ident?i=mac>->regdomain, alpha2);
>
> will fail the initialization process.
>
>
> Workaround:
>
> ----snip----
> int zd_mac_init_hw(struct ieee80211_hw *hw)
> {
> ...
>        r = zd_read_regdomain(chip, &default_regdomain);
>        /* A unknown regulatory of 0x49 will be set default to
> ZD_REGDOMAIN_FCC. */
>        if (0x49 == default_regdomain)
>                default_regdomain = ZD_REGDOMAIN_FCC;
> ...
> ----snip----
>
> The above code will force the default regulatry to be FCC code for this
> case. I think that this was the case in previous zd1211rw driver. What
> is the country code for 0x49 region? There is a better way?
>
>
> Thanks all,
>
> Phew!! Leonardo

The vendor driver has quite a lot more regdomain code defined, and
0x49 is apparently

ZD_Region_Japan_3           = 0x49,//G channel->ch1-13; A channel->8~16,34~46;

the rw driver code probably should set it to most restrictive than let
it fail...
