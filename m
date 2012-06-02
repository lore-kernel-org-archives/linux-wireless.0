Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760372Ab2FBLyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 07:54:15 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20425.65188.119582.835490@gargle.gargle.HOWL> (sfid-20120602_135455_396287_9A7B9264)
Date: Sat, 2 Jun 2012 17:23:08 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 09/22] ath9k: Handle fatal interrupts properly
In-Reply-To: <4FC4C47A.50006@openwrt.org>
References: <20413.45797.72462.431840@gargle.gargle.HOWL>
	<4FC4C12A.1050804@openwrt.org>
	<1338294968.4342.32.camel@jlt3.sipsolutions.net>
	<4FC4C47A.50006@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Hm, good point. Maybe use u32 then. Either way, the lock in this patch
> does almost nothing to protect against race conditions, since it doesn't
> apply to other places in the code that change sc->sc_flags.
> Maybe we should change that entire thing to just use set_bit/test_bit
> instead.

That's a good idea. I'll convert the flags to atomic ops.

Sujith
