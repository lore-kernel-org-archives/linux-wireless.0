Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:56417 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbZALQk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 11:40:57 -0500
Received: by yw-out-2324.google.com with SMTP id 9so3445516ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 08:40:54 -0800 (PST)
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: discard 11g caps if reported by an ar5211 eeprom
Date: Mon, 12 Jan 2009 17:46:22 +0100
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
References: <200901121304.07360.helmut.schaa@gmail.com> <40f31dec0901120825i6ec6af4bq39e7e1be8459e846@mail.gmail.com>
In-Reply-To: <40f31dec0901120825i6ec6af4bq39e7e1be8459e846@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901121746.23260.helmut.schaa@gmail.com> (sfid-20090112_174102_123342_0E2750CB)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 12. Januar 2009 schrieb Nick Kossifidis:
> 2009/1/12 Helmut Schaa <helmut.schaa@googlemail.com>:
> > At least one ar5211 card (GIGABYTE GN-WLMA101, 168c:0012 subsystem
> > 1458:e800) reports itself as 11g capable which seems to be a bug in the
> > eeprom. initvals.c assumes that ar5211 is only 11b capable and thus refuses
> > to initialize this card. Hence this patch changes the probing for 11g
> > capabilities to discard 11g capabilities for ar5211 cards which allows this
> > specific card to work fine in 11b and 11a modes.
> >
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> >
> > Is anybody aware of 11g-capable ar5211 cards which would be limited by
> > this patch?

[...]

> This should be O.K. for now but i think AR5211 supports the so called
> "pureg" mode which means ofdm only g (no cck headers etc).

Sounds reasonable, yes.

> It seems 
> radio (RF5111) supports g mode (it can be found on AR5212 abg cards)

I guess you mean RF2111, right? RF5111 should be 11a.

I've just found a product sheet at [1] that states that the RF2111
supports "802.11g draft standard". I guess that's exactly what you've
described as "pureg" mode.

Thanks,
Helmut

[1] ftp://ftp.riss-telecom.ru/pub/wireless/doc/atheros/AR5001X.pdf
