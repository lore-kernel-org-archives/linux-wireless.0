Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21979 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2LLI6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 03:58:38 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: fix Atheros drivers compilation
Date: Wed, 12 Dec 2012 10:58:34 +0200
Message-ID: <3215021.3tS1djxBu1@lx-vladimir> (sfid-20121212_095842_275432_264E4050)
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
 
I found what is the problem. Patch follows

>From bb80d009b31c2b0751d156d6a653547107d490fa Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 12 Dec 2012 10:56:09 +0200
Subject: [PATCH] wireless: fix Atheros drivers compilation

Bug introduced in commit:
wireless: allow Atheros card to not depend on ath.ko

Change in CONFIG_ option name should be reflected in top level Makefile

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 062dfdf..2ba8cb8 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_P54_COMMON)	+= p54/
 
-obj-$(CONFIG_ATH_COMMON)	+= ath/
+obj-$(CONFIG_ATH_CARDS)	+= ath/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
 
-- 
1.7.10.4


