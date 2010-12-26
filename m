Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:39654 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0LZLYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:24:20 -0500
Subject: [RFC PATCH 1/6] zd1211rw: fix beacon interval setup
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 26 Dec 2010 13:24:14 +0200
Message-ID: <20101226112414.31775.62053.stgit@fate.lan>
In-Reply-To: <20101226112404.31775.77854.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vendor driver uses CR_BNC_INTERVAL at various places, one is HW_EnableBeacon()
that combinies beacon interval with BSS-type flag and DTIM value in upper
16bit of u32. The other one is HW_UpdateBcnInterval() that set_aw_pt_bi()
appears to be based on. HW_UpdateBcnInterval() takes interval argument as u16
and uses that for calculations, set_aw_pt_bi() uses u32 value that has flags
and dtim in upper part. This clearly seems wrong. Also HW_UpdateBcnInterval()
updates only lower 16bit part of CR_BNC_INTERVAL.

So make set_aw_pt_bi() do calculations on only lower u16 part of
s->beacon_interval.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 30f8d40..f21cd7e 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -849,10 +849,12 @@ static int set_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 {
 	struct zd_ioreq32 reqs[3];
 
-	if (s->beacon_interval <= 5)
-		s->beacon_interval = 5;
+	if ((s->beacon_interval & 0xffff) <= 5) {
+		s->beacon_interval &= ~0xffff;
+		s->beacon_interval |= 5;
+	}
 	if (s->pre_tbtt < 4 || s->pre_tbtt >= s->beacon_interval)
-		s->pre_tbtt = s->beacon_interval - 1;
+		s->pre_tbtt = (s->beacon_interval & 0xffff) - 1;
 	if (s->atim_wnd_period >= s->pre_tbtt)
 		s->atim_wnd_period = s->pre_tbtt - 1;
 

