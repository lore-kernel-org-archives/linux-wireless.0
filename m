Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:41338 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbZHLQvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:51:54 -0400
Received: by vws2 with SMTP id 2so136724vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:51:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908120945l14f6590ev38f7083a1b1dae8@mail.gmail.com>
References: <43e72e890908120945l14f6590ev38f7083a1b1dae8@mail.gmail.com>
Date: Wed, 12 Aug 2009 12:51:55 -0400
Message-ID: <b6c5339f0908120951u76c9ac9amfb006ba4960a07c9@mail.gmail.com>
Subject: Re: ath5k warning on bitrate
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 12:45 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> I have some patches on top of this for ath5k but I doubt they were the
> culprit. The warning comes from the second check:

>        rix = sc->rate_idx[sc->curband->band][hw_rix];
>        if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
>                rix = 0;

Just another case of sc->curband being wrong when processing this.

> [  402.717626] ath5k phy0: noise floor calibration timeout (2462MHz)

Because of a scan.  Did we break the thing that flushed rx processing
on channel changes?

-- 
Bob Copeland %% www.bobcopeland.com
