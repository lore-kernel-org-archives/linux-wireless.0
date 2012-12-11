Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46537 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab2LKT2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:28:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: allow Atheros card to not depend on ath.ko
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1834420.jzvmO1yYKo@lx-vladimir> <20121128141319.GA9118@tuxdriver.com>
	<1967408.WlU5HIbjCs@lx-vladimir>
Date: Tue, 11 Dec 2012 21:28:32 +0200
In-Reply-To: <1967408.WlU5HIbjCs@lx-vladimir> (Vladimir Kondratiev's message
	of "Wed, 28 Nov 2012 18:57:19 +0200")
Message-ID: <87wqwov15r.fsf@purkki.adurom.net> (sfid-20121211_202839_229458_0D144296)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> There are 2 different things:
> - sub-menu for "Atheros Wireless cards" family
> - module ath.ko with common Atheros code
>
> Until now, they both used to depend on the same Kconfig variable ATH_COMMON.
> Thus, being "Atheros card" and "depending on ath.ko" was the same.
>
> To allow module to belong to the
> "Atheros Wireless cards" family but not use ath.ko,
> 2 conditions above need to be separated.
>
> So, this patch introduce new Kconfig variable ATH_CARDS for belonging
> to the "Atheros Wireless Cards" family; while ATH_COMMON becomes hidden
> variable to express dependency on common Atheros code in ath.ko. Modules
> that depend on this common code now express it by setting ATH_COMMON.
>
> Right now, ath6kl do not depend on common code and thus do not set ATH_COMMON.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

This broke ath6kl, it get compiled unless I enable ath9k or some other
atheros driver.

Reverting 23c1d7f6597 or adding "select ATH_COMMON" to ath6kl fixes
this. Any ideas what's wrong? It's not obvious to me from looking at
Kconfig files.

-- 
Kalle Valo
