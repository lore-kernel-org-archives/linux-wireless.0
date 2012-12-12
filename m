Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:59089 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2LLRZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 12:25:20 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wireless: fix Atheros drivers compilation
Date: Wed, 12 Dec 2012 19:25:16 +0200
Message-ID: <9038958.vZIvzVgBXq@lx-vladimir> (sfid-20121212_182524_877281_8782FA38)
In-Reply-To: <50C8B9F6.8010906@qca.qualcomm.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <3215021.3tS1djxBu1@lx-vladimir> <50C8B9F6.8010906@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 12, 2012 07:08:06 PM Kalle Valo wrote:
> Hi,
> 
> On 12/12/2012 10:58 AM, Vladimir Kondratiev wrote:
> 
> > Subject: [PATCH] wireless: fix Atheros drivers compilation
> > 
> > Bug introduced in commit:
> > wireless: allow Atheros card to not depend on ath.ko
> > 
> > Change in CONFIG_ option name should be reflected in top level Makefile
> 
> You should explain what the bug was (if ath6kl was the only enabled
> atheros driver it wasn't included in the compilation).
> 
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> Thanks, this fixed it.
> 
> Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> John, as this bug is in wireless-next and is on it's way to 3.8, we
> should get this fix also to 3.8.
> 
> Kalle
> 

OK, below same patch with explanation added. Good now?

>From bb80d009b31c2b0751d156d6a653547107d490fa Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Wed, 12 Dec 2012 10:56:09 +0200
Subject: [PATCH v2] wireless: fix Atheros drivers compilation

Bug introduced in commit:
wireless: allow Atheros card to not depend on ath.ko

Commit in question changed CONFIG_ATH_COMMON to CONFIG_ATH_CARDS as
"Atheros card" indication in drivers/net/wireless/ath/Kconfig but it
is used also by drivers/net/wireless/Makefile

If there are only Atheros cards that do not require ATH_COMMON, whole
Makefile for Atheros cards was not executed; and as result, driver
won't compile in this case.

Change in CONFIG_ option name should be reflected in the
drivers/net/wireless/Makefile

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 062dfdf..2ba8cb8 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_RT2X00)  += rt2x00/
 
 obj-$(CONFIG_P54_COMMON)       += p54/
 
-obj-$(CONFIG_ATH_COMMON)       += ath/
+obj-$(CONFIG_ATH_CARDS)        += ath/
 
 obj-$(CONFIG_MAC80211_HWSIM)   += mac80211_hwsim.o
 
-- 
1.7.10.4

