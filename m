Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:55413 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1ADXsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:48:16 -0500
Subject: [RFC PATCH 03/17] zd1211rw: fix beacon interval setup
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:48:11 +0200
Message-ID: <20110104234811.25309.34778.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
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
updates only lower 16bit part of CR_BNC_INTERVAL. So make set_aw_pt_bi() do
calculations on only lower u16 part of s->beacon_interval.

Also set 32bit beacon interval register before reading values from device,
as HW_EnableBeacon() on vendor driver does. This is required to make beacon
work on AP-mode, simply reading and then writing updated values is not enough
at least with zd1211b.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 6effe18..8c05737 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -848,11 +848,12 @@ static int get_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 static int set_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 {
 	struct zd_ioreq32 reqs[3];
+	u16 b_interval = s->beacon_interval & 0xffff;
 
-	if (s->beacon_interval <= 5)
-		s->beacon_interval = 5;
-	if (s->pre_tbtt < 4 || s->pre_tbtt >= s->beacon_interval)
-		s->pre_tbtt = s->beacon_interval - 1;
+	if (b_interval <= 5)
+		b_interval = 5;
+	if (s->pre_tbtt < 4 || s->pre_tbtt >= b_interval)
+		s->pre_tbtt = b_interval - 1;
 	if (s->atim_wnd_period >= s->pre_tbtt)
 		s->atim_wnd_period = s->pre_tbtt - 1;
 
@@ -861,7 +862,7 @@ static int set_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 	reqs[1].addr = CR_PRE_TBTT;
 	reqs[1].value = s->pre_tbtt;
 	reqs[2].addr = CR_BCN_INTERVAL;
-	reqs[2].value = s->beacon_interval;
+	reqs[2].value = (s->beacon_interval & ~0xffff) | b_interval;
 
 	return zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
 }
@@ -873,10 +874,13 @@ static int set_beacon_interval(struct zd_chip *chip, u32 interval)
 	struct aw_pt_bi s;
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
+
+	r = zd_iowrite32_locked(chip, interval, CR_BCN_INTERVAL);
+	if (r)
+		return r;
 	r = get_aw_pt_bi(chip, &s);
 	if (r)
 		return r;
-	s.beacon_interval = interval;
 	return set_aw_pt_bi(chip, &s);
 }
 

