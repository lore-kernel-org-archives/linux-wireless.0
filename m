Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34409 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab1HVUUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 16:20:06 -0400
Received: by bkat8 with SMTP id t8so5373435bka.41
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 13:19:57 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ido@wizery.com
Subject: [PATCH RESEND 3.1 0/2] wl12xx: a couple of serious bug fixes for 3.1
Date: Mon, 22 Aug 2011 23:19:47 +0300
Message-Id: <1314044389-30649-1-git-send-email-coelho@ti.com> (sfid-20110822_222010_668536_2E116853)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are the two patches that I'd like to have applied in 3.1.  The first
removes a potentially dangerous (and rather broken) NL80211 TESTMODE command,
which we don't really use anymore anyway.  The second fixes a PM related issue
whose API has apparently changed recently and would cause a regression that
breaks wl12xx and may even cause a kernel panic.

Thanks!

Cheers,
Luca.


Ido Yariv (2):
  wl12xx: Remove obsolete testmode NVS push command
  wl12xx: Fix validation of pm_runtime_get_sync return value

 drivers/net/wireless/wl12xx/sdio.c     |    2 +-
 drivers/net/wireless/wl12xx/testmode.c |   45 --------------------------------
 2 files changed, 1 insertions(+), 46 deletions(-)

