Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43977 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2ESIO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:14:59 -0400
Received: by yenm10 with SMTP id m10so3477466yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 May 2012 01:14:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120518162158.GE22418@yumi.tdiedrich.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d_Yz=-UWO+PiJkRQ7ZSBgh_fdcwsPz6FCig2VjOOoMQOg@mail.gmail.com>
	<20120518162158.GE22418@yumi.tdiedrich.de>
Date: Sat, 19 May 2012 10:14:57 +0200
Message-ID: <CAGXE3d8e+hYo_MT30XUW+r4-Dq6AgqLTJxD_oGnRuR94zjZ7_Q@mail.gmail.com> (sfid-20120519_101524_886939_910FA265)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tobias Diedrich <ranma@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2012 at 6:21 PM, Tobias Diedrich <ranma@tdiedrich.de> wrote:
>> So, maybe we should do it the safe way and just register a safe default
>> of 20dBm for all channels?
>
> AFAIU that would cap you to 20dBm even if you are in a country that
> has higher limits (e.g. 27dBm in the US?).

Not necessarily because the driver won't allow tx power adjustments at all
if EEPROM_EIRP_MAX_TX_POWER is unused.

For these devices we cannot rely on the tx power output at all and maybe
it makes sense to register a max power of 0 just to tell mac80211/cfg80211
that no tx power adjustments are possible on these devices?

Helmut
