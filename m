Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60394 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761794Ab3EDRu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 13:50:27 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm14so1484098wib.11
        for <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 10:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5184EE0B.1030605@openwrt.org>
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de>
	<1367482308-9882-2-git-send-email-linux@rempel-privat.de>
	<CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com>
	<5182A341.8050704@rempel-privat.de>
	<5182A9DC.6030203@openwrt.org>
	<CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com>
	<5184AFC2.8060101@rempel-privat.de>
	<5184DCCF.9010009@openwrt.org>
	<5184EC19.9060206@rempel-privat.de>
	<5184EE0B.1030605@openwrt.org>
Date: Sat, 4 May 2013 10:50:25 -0700
Message-ID: <CAJ-Vmok_kAfoO0DEwGCsmiqeokEnURNoaLU-860X1EgENGMogQ@mail.gmail.com> (sfid-20130504_195043_038940_D11581A6)
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've just reviewed it myself:

* oan->stbc is enabled only if the hardware itself supports STBC; so
it's an extra sanity check in case the firmware is told to enable STBC
in the WMI capflag field.
* is oan->htinfo used anywhere that may involve STBC?
* .. we should check whether ath9k_htc ever set the STBC flags on
AR9271, or we'd end up confusing the hardware.
* .. I don't think that is important though, as we weren't _doing_ STBC, right?
* Why are the ATH_RC_* flags used in newassoc_11n? This comes from the
WMI WMI_RC_STATE_CHANGE_CMDID capflag field; where are _those_
defined?

Grr, so many things to tidy up.



Adrian
