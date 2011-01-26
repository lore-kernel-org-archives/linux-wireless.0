Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43937 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1AZRaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 12:30:19 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 09:30:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19776.23002.952371.103267@gargle.gargle.HOWL>
Date: Wed, 26 Jan 2011 22:58:58 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_hw: Fix INI fixup
In-Reply-To: <AANLkTi=881eHyZEHnjY_XkCGLnzNWz1iuUVoJQA_KkAB@mail.gmail.com>
References: <19776.19422.571177.795197@gargle.gargle.HOWL>
	<AANLkTi=881eHyZEHnjY_XkCGLnzNWz1iuUVoJQA_KkAB@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Wed, Jan 26, 2011 at 8:29 AM, Sujith <m.sujith@gmail.com> wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> >
> > Commit "ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c"
> > changed the behavior of INI overriding which is needed only
> > for PCI cards. Revert to the original check.
> >
> > Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> You leave me no option but to come out of e-mail reply slumber. What
> issues was this causing?

The INI fixup is required only for AR9280 PCI cards. Changing it to a SREV
check that includes all chipsets above AR9280 would mean changing the initvals
for other cards too. The couple of cards I have did not hit this check,
but that doesn't mean that there are no weirdly configured cards out there...

Sujith
