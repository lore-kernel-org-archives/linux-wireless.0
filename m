Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63460 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2LLIIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 03:08:05 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: allow Atheros card to not depend on ath.ko
Date: Wed, 12 Dec 2012 10:07:59 +0200
Message-ID: <1400620.sjR9nVGjfL@lx-vladimir> (sfid-20121212_090809_729301_C75760FA)
In-Reply-To: <87wqwov15r.fsf@purkki.adurom.net>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1967408.WlU5HIbjCs@lx-vladimir> <87wqwov15r.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 11, 2012 09:28:32 PM Kalle Valo wrote:
> Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:
> 
> > There are 2 different things:
> > - sub-menu for "Atheros Wireless cards" family
> > - module ath.ko with common Atheros code
> >
> > Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
> > Thus, being "Atheros card" and "depending on ath.ko" was the same.
> >
> > To allow module to belong to the
> > "Atheros Wireless cards" family but not use ath.ko,
> > 2 conditions above need to be separated.
> >
> > So, this patch introduce new Kconfig variable ATH_CARDS for belonging
> > to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
> > variable to express dependency on common Atheros code in ath.ko. Modules
> > that depend on this common code now express it by setting ATH_COMMON.
> >
> > Right now, ath6kl do not depend on common code and thus do not set ATH_COMMON.
> >
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> This broke ath6kl, it get compiled unless I enable ath9k or some other
> atheros driver.
> 
> Reverting 23c1d7f6597 or adding "select ATH_COMMON" to ath6kl fixes
> this. Any ideas what's wrong? It's not obvious to me from looking at
> Kconfig files.
> 

Interesting. I just compiled with ath6kl only, have no ATH_COMMON in .config.
Compiles with no problem.

Maybe something with your setup? Can you elaborate what error do you see?

Thanks, Vladimir
