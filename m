Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48781 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761379Ab2FVHXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 03:23:45 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	dan.carpenter@oracle.com
Subject: Re: [PATCH 2/3] ath9k_hw: fix smatch warnings in spur_mitigate
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com>
Date: Fri, 22 Jun 2012 10:23:44 +0300
In-Reply-To: <1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 22 Jun 2012 00:01:31 +0530")
Message-ID: <87bokb4xof.fsf@purkki.adurom.net> (sfid-20120622_092348_758598_F9E6EC81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qca.qualcomm.com> writes:

> This patch fixes below smatch warnings
>
> drivers/net/wireless/ath/ath9k/ar9002_phy.c:275
> ar9002_hw_spur_mitigate() Error invalid range 576717 to 471859
> drivers/net/wireless/ath/ath9k/ar5008_phy.c:323
> ar5008_hw_spur_mitigate() Error invalid range 555746 to 492830
> drivers/net/wireless/ath/ath9k/ar5008_phy.c:326
> ar5008_hw_spur_mitigate() Error invalid range 587 to 481
> drivers/net/wireless/ath/ath9k/ar9003_calib.c:272
> ar9003_hw_iqcalibrate() Error invalid range 65 to 63
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

[...]

> -			qCoff = qCoff & 0x7f;
> +			qCoff &= 0x7f;

I'm curious, how does a change like this fix anything? To me it just
looks same functionality, just a different operator is used. Am I
missing something?

-- 
Kalle Valo
