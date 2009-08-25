Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:49993 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZHYSpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 14:45:11 -0400
Received: by vws2 with SMTP id 2so2888399vws.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 11:45:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
Date: Tue, 25 Aug 2009 14:45:12 -0400
Message-ID: <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 25, 2009 at 2:25 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> This was printing the wrong value on the warning. While at it
> lets expand this warning to provide a little more useful
> information for debugging such as the band and hardware rate
> index when possible and clarify what the warning is actually
> printing.

>        rix = sc->rate_idx[sc->curband->band][hw_rix];
> -       if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
> +       if (WARN(rix < 0, "invalid driver rate index: %x "
> +                "(hw_rix: %x band: %s)\n", rix, hw_rix,
> +                sc->curband->band ? "5 GHz" : "2.4 GHz"))

rix will always be -1 here so no real need to print it.

I'm pretty sure band is going to be "the wrong one," because all
instances of this warning I've seen have been valid rate indexes,
like 1 mbit rates when scanning 5 ghz, which could indicate some
race condition with flushing the rx queue on channel changes.  I
haven't yet seen a hw rate we didn't know about.

-- 
Bob Copeland %% www.bobcopeland.com
