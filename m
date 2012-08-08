Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48459 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758073Ab2HHPAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 11:00:45 -0400
Message-ID: <50227F17.7070702@openwrt.org> (sfid-20120808_170057_083766_7B13599A)
Date: Wed, 08 Aug 2012 17:00:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, c_manoha@qca.qualcomm.com
Subject: Re: [PATCH v2 3.6] ath9k: fix interrupt storms on queued hardware
 reset
References: <1344435903-70536-1-git-send-email-nbd@openwrt.org> <20120808144340.GA2041@vmraj-lnx.qualcomm.com>
In-Reply-To: <20120808144340.GA2041@vmraj-lnx.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-08 4:43 PM, Rajkumar Manoharan wrote:
> On Wed, Aug 08, 2012 at 04:25:03PM +0200, Felix Fietkau wrote:
>> commit b74713d04effbacd3d126ce94cec18742187b6ce
>> "ath9k: Handle fatal interrupts properly" introduced a race condition, where
>> IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
>> while the reset is still queued without addressing the IRQ cause.
>> This leads to an IRQ storm that prevents the system from even getting to
>> the reset code.
>> 
>> Fix this by disabling IRQs in the handler without touching intr_ref_cnt.
>>
> It is safer not to re-enable interrupts on FATAL errors rather than enabling
> it and then checking it on irq for bailing out. It would be better if you kill
> the interrupts on processing fatal interrupts.
A fatal interrupt isn't the only place where this is race shows up.
Anything that queues a reset is affected, so skipping the interrupt
enable in the IRQ handler is not enough (aside from the fact that it
would mess up irq disable refcounting).

Also, how is it safer? It's not like the interrupt handler does any real
processing before running into that check.

- Felix
