Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51282 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbCNARU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 20:17:20 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21763.32496.935954.70693@gargle.gargle.HOWL> (sfid-20150314_012116_698894_3122ADFC)
Date: Sat, 14 Mar 2015 05:51:04 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] ath9k patches
In-Reply-To: <87wq2lqb1d.fsf@kamboji.qca.qualcomm.com>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
	<87wq2lqb1d.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> With these patches I got a new warning:
> 
> drivers/net/wireless/ath/ath9k/ar9003_aic.c: In function 'ar9003_aic_cal_post_process':
> drivers/net/wireless/ath/ath9k/ar9003_aic.c:431:1: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> Is it a valid warning?

When CONFIG_FRAME_WARN is set to 1024, this will be hit.
On my machine, the value is 2048, so the stack doesn't overflow.

But, 1024 could be a valid limit in some architectures, so I'll
rework ar9003_aic_cal_post_process() to avoid using the stack
excessively and post another series.

Sujith
