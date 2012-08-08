Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26163 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470Ab2HHOmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:42:20 -0400
Date: Wed, 8 Aug 2012 20:13:42 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH v2 3.6] ath9k: fix interrupt storms on queued hardware
 reset
Message-ID: <20120808144340.GA2041@vmraj-lnx.qualcomm.com> (sfid-20120808_164225_547561_FEE4218E)
References: <1344435903-70536-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1344435903-70536-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2012 at 04:25:03PM +0200, Felix Fietkau wrote:
> commit b74713d04effbacd3d126ce94cec18742187b6ce
> "ath9k: Handle fatal interrupts properly" introduced a race condition, where
> IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
> while the reset is still queued without addressing the IRQ cause.
> This leads to an IRQ storm that prevents the system from even getting to
> the reset code.
> 
> Fix this by disabling IRQs in the handler without touching intr_ref_cnt.
>
It is safer not to re-enable interrupts on FATAL errors rather than enabling
it and then checking it on irq for bailing out. It would be better if you kill
the interrupts on processing fatal interrupts.

-Rajkumar
