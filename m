Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43401 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab1EHRwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 13:52:53 -0400
Received: by eyx24 with SMTP id 24so1358556eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 May 2011 10:52:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 0/3] ssb/b43(legacy): clean dangling cores workarounds
Date: Sun,  8 May 2011 20:30:30 +0200
Message-Id: <1304879433-7096-1-git-send-email-zajec5@gmail.com> (sfid-20110508_195256_643191_0C73B6D4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no perfect place for this workarounds, but keeping it in ssb sounds
more reasonable.
1) We already have in ssb similar workarounds for different cores
2) We do not register inactive devices in system
3) We do not duplicate code in b43 and b43legacy

V2: Updated commit messages. Larry, should we add yours Acked-by or
Reviewed-by?

I just changed "Many" to "Some" in Larry's message.

Rafał Miłecki (3):
  ssb: update list of devices supporting multiple 80211 cores
  b43: drop ssb-duplicated workaround for dangling cores
  b43legacy: drop ssb-duplicated workaround for dangling cores

 drivers/net/wireless/b43/main.c       |   17 -----------------
 drivers/net/wireless/b43legacy/main.c |   18 ------------------
 drivers/ssb/scan.c                    |    5 ++++-
 3 files changed, 4 insertions(+), 36 deletions(-)

-- 
1.7.3.4

