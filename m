Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59733 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2E2M3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:29:41 -0400
Message-ID: <4FC4C12A.1050804@openwrt.org> (sfid-20120529_142944_112351_CE560AC4)
Date: Tue, 29 May 2012 14:29:30 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 09/22] ath9k: Handle fatal interrupts properly
References: <20413.45797.72462.431840@gargle.gargle.HOWL>
In-Reply-To: <20413.45797.72462.431840@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-24 6:02 AM, Sujith Manoharan wrote:
> When a fatal interrupt is received or it is detected that the baseband
> has hung, the chip has to be reset immediately.  Otherwise, we end up
> processing spurious interrupts. Ensure that we bail out properly in
> the ISR when the reset work hasn't completed yet.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Wouldn't it be much easier to just use a bool variable instead of the
combination of lock+flag? A simple variable assignment is atomic...

- Felix
