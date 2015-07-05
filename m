Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52925 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbbGEK6u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 06:58:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 92888280631
	for <linux-wireless@vger.kernel.org>; Sun,  5 Jul 2015 12:58:32 +0200 (CEST)
Received: from mail-qk0-f173.google.com (mail-qk0-f173.google.com [209.85.220.173])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 3069628BCD1
	for <linux-wireless@vger.kernel.org>; Sun,  5 Jul 2015 12:57:54 +0200 (CEST)
Received: by qkeo142 with SMTP id o142so100638163qke.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jul 2015 03:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436092402.6268.0.camel@sipsolutions.net>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com> <1436092402.6268.0.camel@sipsolutions.net>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 5 Jul 2015 12:57:49 +0200
Message-ID: <CAOiHx=mRzPoGCXzoKbw2BK524iZAgXhBRM4jzqwmEZ6rv+ZdcQ@mail.gmail.com> (sfid-20150705_125853_848403_1CA72662)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lin <dlin@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 5, 2015 at 12:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I'm not so sure about the OF thing - at least in general this seems
> right and many drivers are selecting OF. If that causes issues on
> certain platforms then perhaps those platforms should fix the issues,
> or the whole OF should be changed to depends on?

At least in linus' current HEAD I don't see any drivers selecting OF;
only a few that select OF subsystems:

# grep -r --include=Kconfig "select OF" drivers/
drivers/of/Kconfig:     select OF_EARLY_FLATTREE
drivers/of/Kconfig:     select OF_RESOLVE
drivers/of/Kconfig:     select OF_FLATTREE
drivers/of/Kconfig:     select OF_ADDRESS_PCI if PCI
drivers/of/Kconfig:     select OF_DYNAMIC
drivers/of/Kconfig:     select OF_RESOLVE
drivers/gpio/Kconfig:   select OF_GPIO
drivers/pinctrl/mediatek/Kconfig:       select OF_GPIO
drivers/pinctrl/Kconfig:        select OF_GPIO
drivers/pinctrl/Kconfig:        select OF_GPIO
drivers/pinctrl/Kconfig:        select OF_GPIO
drivers/pinctrl/nomadik/Kconfig:        select OF_GPIO
drivers/net/ethernet/freescale/Kconfig: select OF_MDIO
drivers/gpu/drm/tilcdc/Kconfig: select OF_RESOLVE
drivers/gpu/drm/tilcdc/Kconfig: select OF_OVERLAY

There are plenty that depend on OF though:

# grep -r --include=Kconfig "depends on OF" drivers/ | wc -l
159

(I know this won't catch all and a few that it shouldn't ;)

Of course arches/platforms selecting OF is fine and expected:

# grep -r --include=Kconfig "select OF$" arch/ | wc -l
15


Regards
Jonas
