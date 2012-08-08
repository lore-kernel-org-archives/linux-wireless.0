Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34073 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HHP0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 11:26:25 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20514.33999.490474.57680@gargle.gargle.HOWL> (sfid-20120808_172628_949652_25E5C187)
Date: Wed, 8 Aug 2012 20:55:03 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Felix Fietkau <nbd@openwrt.org>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>, <rodrigue@qca.qualcomm.com>,
	<c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH v2 3.6] ath9k: fix interrupt storms on queued hardware
 reset
In-Reply-To: <20120808144340.GA2041@vmraj-lnx.qualcomm.com>
References: <1344435903-70536-1-git-send-email-nbd@openwrt.org>
	<20120808144340.GA2041@vmraj-lnx.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> It is safer not to re-enable interrupts on FATAL errors rather than enabling
> it and then checking it on irq for bailing out. It would be better if you kill
> the interrupts on processing fatal interrupts.

I am not sure I understand.

The original issue was the race between reset-work and the ISR which resulted in
frequent disconnects when a BB-WATCHDOG interrupt occurred or TX hung, which was
fixed by introducing the SC_OP_HW_RESET flag. Later, the work_pending() race was
fixed. Still, this is a race that can happen and I think fixing it by bypassing
the ref-count maintenance and disabling interrupts is okay.

Sujith
