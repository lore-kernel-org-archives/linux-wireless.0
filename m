Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2E2Mvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 08:51:46 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20420.50737.885895.629888@gargle.gargle.HOWL> (sfid-20120529_145150_870155_12D298BC)
Date: Tue, 29 May 2012 18:20:57 +0530
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

That is because the locking for all the other flags has to be cleaned up.
Especially the powersave/beacon flags, and the usage of other locks
are hazy (sc_pcu_lock etc.). We can clean all of them, but I think it
will be an involved process - and the watchdog race is a crippling issue
as far as general usage is concerned. Disconnects occur in regular usage
quite frequently, breaking stress tests.

Sujith
