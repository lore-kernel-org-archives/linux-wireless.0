Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63233 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab0EYTHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 15:07:10 -0400
Received: by pxi18 with SMTP id 18so2111814pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 12:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100525132035.GA863@ee.oulu.fi>
References: <20100525132035.GA863@ee.oulu.fi>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 May 2010 12:06:49 -0700
Message-ID: <AANLkTikXyd47rhxpDktfEk89tnBlooXKMhKNisp3GcXd@mail.gmail.com>
Subject: Re: wireless-regdb: FI/CZ updates
To: Pekka Pietikainen <pp@ee.oulu.fi>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the patch, Michael, please review and let me know what you think.

  Luis

On Tue, May 25, 2010 at 6:20 AM, Pekka Pietikainen <pp@ee.oulu.fi> wrote:
> Was looking at the relevant local regulations and noticed the regdb allowed
> less power at 5GHz than is actually allowed. Until I found the "If you don't do TPC you have
> to reduce your power by 3dB sometimes" bit on the next page.
>
> And looks like someone that did the entry for CZ fell into the same trap, they have
>
> "stations in the c and d bands must employ automatic transmitter power
> control, which provides, on average, an interference mitigation factor at
> least 3 dB on the maximum permitted output power of the systems.  If
> automatic power control is not employed, the maximum permitted mean e.i.r.p.
> and the corresponding limit of the mean e.i.r.p.  density for bands c and d
> must be reduced by 3 dB;"
>
> Please sanity check, I became very confused while looking into this.
> (like some places starting their freq ranges at 2400, others at 2402. Didn't
> touch those, regs say 2400-2485,5, 5150-5250, 5250-5350 and 5470-5725)
>
> Signed-off-by: Pekka Pietikäinen <pp@ee.oulu.fi>
> diff -up ./db.txt.orig ./db.txt
> --- ./db.txt.orig       2010-05-25 15:03:48.812116854 +0300
> +++ ./db.txt    2010-05-25 15:58:43.947117884 +0300
> @@ -170,11 +170,13 @@ country CY:
>
>  # Data from http://www.ctu.eu/164/download/VOR/VOR-12-08-2005-34.pdf
>  # and http://www.ctu.eu/164/download/VOR/VOR-12-05-2007-6-AN.pdf
> +# Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is
> +# implemented.
>  country CZ:
>        (2400 - 2483.5 @ 40), (N/A, 100 mW)
>        (5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
> -       (5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> -       (5470 - 5725 @ 40), (N/A, 1000 mW), DFS
> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>
>  # Data from "Frequenznutzungsplan" (as published in April 2008),
>  # downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
> @@ -226,11 +228,15 @@ country ES:
>        (5250 - 5330 @ 40), (N/A, 20), DFS
>        (5490 - 5710 @ 40), (N/A, 27), DFS
>
> +# Data from FICORA Regulation 15Z / 2009 M
> +# http://www.ficora.fi/attachments/suomiry/5l1x1FIIk/Viestintavirasto15Z2009M.pdf
> +# Power at 5250 - 5350 MHz and 5470 - 5725 MHz can be doubled if TPC is
> +# implemented.
>  country FI:
> -       (2402 - 2482 @ 40), (N/A, 20)
> -       (5170 - 5250 @ 40), (N/A, 20)
> -       (5250 - 5330 @ 40), (N/A, 20), DFS
> -       (5490 - 5710 @ 40), (N/A, 27), DFS
> +       (2402 - 2482 @ 40), (N/A, 100mW)
> +       (5170 - 5250 @ 40), (N/A, 200mW), NO-OUTDOOR
> +       (5250 - 5330 @ 40), (N/A, 100mW), NO-OUTDOOR, DFS
> +       (5490 - 5710 @ 40), (N/A, 500mW), DFS
>
>  country FR:
>        (2402 - 2482 @ 40), (N/A, 20)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
