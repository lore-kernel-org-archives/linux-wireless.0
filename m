Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61617 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab3EDOtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 10:49:25 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so2479445wgh.24
        for <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 07:49:24 -0700 (PDT)
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
Date: Sat, 4 May 2013 07:49:24 -0700
Message-ID: <CAJ-Vmok2SO3RKuqwvor=jz-pza_NzZugP6-4dfFo3w5NWcQqNw@mail.gmail.com> (sfid-20130504_164929_948392_3AAFB044)
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 May 2013 04:16, Felix Fietkau <nbd@openwrt.org> wrote:

>> So, should i remove ATH_RC_TX_STBC_FLAG from my patch?
> I extensively reviewed this part, and it's really crazy. Here's what
> happens:
>
> ath_rate_newassoc_11n takes ATH_RC_* flags, converts them to WLAN_RC_*.
> rcSibUpdate_11n interprets the WLAN_RC_* flags as ATH_RC_* and converts
> them to WLAN_RC_* again. For most flags this is pretty much a no-op
> because the definitions are identical.
> For STBC the result 'accidentally' still contains WLAN_RC_STBC_FLAG, but
> only because ath_rate_newassoc_11n converts ATH_RC_RX_STBC_FLAG to
> WLAN_RC_STBC_FLAG and WLAN_RC_STBC_FLAG overlaps with ATH_RC_TX_STBC_FLAG.
> In the end it doesn't matter anymore, because nothing in the code takes
> the STBC info from the capflags.
>
> STBC is used if ATH_NODE_ATHEROS(an)->stbc is non-zero, and this gets
> set by ath_rate_newassoc_11n before all of those incredibly moronic
> conversions happen.

It smells like left-over from the 7.x driver code this is based off of.



Adrian
