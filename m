Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2HHOQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:16:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20514.29811.833113.509573@gargle.gargle.HOWL> (sfid-20120808_161645_277694_CFC3E387)
Date: Wed, 8 Aug 2012 19:45:15 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	<c_manoha@qca.qualcomm.com>
Subject: [PATCH 3.6] ath9k: fix interrupt storms on queued hardware reset
In-Reply-To: <1344431106-69500-1-git-send-email-nbd@openwrt.org>
References: <1344431106-69500-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> commit 124b979baeb2d7a0593be8d392f43725578478c1
> "ath9k: Fix race in reset-work usage" introduced a race condition, where
> IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
> while the reset is still queued without addressing the IRQ cause.
> This leads to an IRQ storm that prevents the system from even getting to
> the reset code.

I think commit b74713d04effbacd3d126ce94cec18742187b6ce is what you should
be referring to.

Sujith
