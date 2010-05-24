Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0EXTs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 15:48:59 -0400
Received: by wyb29 with SMTP id 29so1832612wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 12:48:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/2] ssb: updates matching specs, fix for hangs?
Date: Mon, 24 May 2010 21:50:22 +0200
Message-Id: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, I don't really know w-t policy, so please decide where we should apply
these patches. I'll try to provide some description.

We got reports of some devices hanging with ssb module, it was around SPROM
reading. AFAIK two patches are needed to fix this issue. One was already
posted by Larry: "ssb: Handle alternate SSPROM location" (however I can not
find it in w-t). Second one is attached patch for fast powerup delay.

Not sure about PMU init patch, I think it is needed to get devices working
but not sure if it affects (fixes) handing issue.

Fix of hanging sounds important and thankfully patches are quite trivial. On
the other hand we are at the end of merge window already. So please, help with
taking a decision about this.

CC-ing b43, hope it's OK.

Rafał Miłecki (2):
  ssb: update PMU init to match specs
  ssb: fast powerup delay calculation for PMU capable devices

 drivers/ssb/driver_chipcommon.c     |   24 ++++++++++++++++++++++++
 drivers/ssb/driver_chipcommon_pmu.c |   17 +++++++----------
 2 files changed, 31 insertions(+), 10 deletions(-)

