Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36927 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2HHOWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:22:45 -0400
Message-ID: <5022762F.3000308@openwrt.org> (sfid-20120808_162250_530895_754696E9)
Date: Wed, 08 Aug 2012 16:22:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Subject: Re: [PATCH 3.6] ath9k: fix interrupt storms on queued hardware reset
References: <1344431106-69500-1-git-send-email-nbd@openwrt.org> <20514.29811.833113.509573@gargle.gargle.HOWL>
In-Reply-To: <20514.29811.833113.509573@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-08 4:15 PM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> commit 124b979baeb2d7a0593be8d392f43725578478c1
>> "ath9k: Fix race in reset-work usage" introduced a race condition, where
>> IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
>> while the reset is still queued without addressing the IRQ cause.
>> This leads to an IRQ storm that prevents the system from even getting to
>> the reset code.
> 
> I think commit b74713d04effbacd3d126ce94cec18742187b6ce is what you should
> be referring to.
Right, thanks.

- Felix

