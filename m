Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23500 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2LLRcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 12:32:17 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: fix Atheros drivers compilation
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<3215021.3tS1djxBu1@lx-vladimir> <50C8B9F6.8010906@qca.qualcomm.com>
	<9038958.vZIvzVgBXq@lx-vladimir>
Date: Wed, 12 Dec 2012 19:32:13 +0200
In-Reply-To: <9038958.vZIvzVgBXq@lx-vladimir> (Vladimir Kondratiev's message
	of "Wed, 12 Dec 2012 19:25:16 +0200")
Message-ID: <87sj7bmb1e.fsf@qca.qualcomm.com> (sfid-20121212_183221_721915_33E70947)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:

> OK, below same patch with explanation added. Good now?

Yup.

> From bb80d009b31c2b0751d156d6a653547107d490fa Mon Sep 17 00:00:00 2001
> From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Date: Wed, 12 Dec 2012 10:56:09 +0200
> Subject: [PATCH v2] wireless: fix Atheros drivers compilation
>
> Bug introduced in commit:
> wireless: allow Atheros card to not depend on ath.ko
>
> Commit in question changed CONFIG_ATH_COMMON to CONFIG_ATH_CARDS as
> "Atheros card" indication in drivers/net/wireless/ath/Kconfig but it
> is used also by drivers/net/wireless/Makefile
>
> If there are only Atheros cards that do not require ATH_COMMON, whole
> Makefile for Atheros cards was not executed; and as result, driver
> won't compile in this case.
>
> Change in CONFIG_ option name should be reflected in the
> drivers/net/wireless/Makefile
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>

John, so this patch should go to 3.8 as it's a regression.

Kalle
