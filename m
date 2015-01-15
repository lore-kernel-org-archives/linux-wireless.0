Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49364 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbAOJG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 04:06:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21687.33741.794518.335502@gargle.gargle.HOWL> (sfid-20150115_100704_649572_135217E7)
Date: Thu, 15 Jan 2015 14:39:33 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during hardware reset
In-Reply-To: <1421241456-29085-1-git-send-email-nbd@openwrt.org>
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> To fix invalid hardware accesses, the commit
> "ath9k: do not access hardware on IRQs during reset" made the irq
> handler ignore interrupts emitted after queueing a hardware reset (which
> disables the IRQ). This left a small time window for the IRQ to get
> re-enabled by the tasklet, which caused IRQ storms.
> Instead of returning IRQ_NONE when ATH_OP_HW_RESET is set, disable the
> IRQ entirely for the duration of the reset.

Doesn't this make the kill_interrupts() that was added in the earlier
commit unnecessary now ?

Sujith
