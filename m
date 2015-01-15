Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36250 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbAOJqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 04:46:32 -0500
Message-ID: <54B78C67.1030106@openwrt.org> (sfid-20150115_104636_720626_A40FE64E)
Date: Thu, 15 Jan 2015 10:46:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during
 hardware reset
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org> <21687.33741.794518.335502@gargle.gargle.HOWL>
In-Reply-To: <21687.33741.794518.335502@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-01-15 10:09, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> To fix invalid hardware accesses, the commit
>> "ath9k: do not access hardware on IRQs during reset" made the irq
>> handler ignore interrupts emitted after queueing a hardware reset (which
>> disables the IRQ). This left a small time window for the IRQ to get
>> re-enabled by the tasklet, which caused IRQ storms.
>> Instead of returning IRQ_NONE when ATH_OP_HW_RESET is set, disable the
>> IRQ entirely for the duration of the reset.
> 
> Doesn't this make the kill_interrupts() that was added in the earlier
> commit unnecessary now ?
I think it's still a good idea to try to silence interrupts between
queueing a reset and actually performing it.

- Felix
