Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49014 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1FKS7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 14:59:37 -0400
Date: Sat, 11 Jun 2011 20:59:30 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Connor Hansen <cmdkhh@gmail.com>, linux-wireless@vger.kernel.org
Subject: [PATCH] drivers/ssb/driver_chipcommon_pmu.c: uninitilized warning
Message-ID: <20110611205930.28418623@maggie> (sfid-20110611_205944_631879_48E8D517)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Connor Hansen <cmdkhh@gmail.com>

warning message
drivers/ssb/driver_chipcommon_pmu.c: In function ssb_pmu_resources_init
drivers/ssb/driver_chipcommon_pmu.c:420:15: warning: updown_tab_size may
be used uninitilized in this function.

updown_tab_size and depend_tab_size may not be set in the bus->chip_id
switch statement, so set to 0 by default to avoid using uninitialized
stack space.

Signed-off-by: Connor Hansen <cmdkhh@gmail.com>
Signed-off-by: Michael Buesch <m@bues.ch>

---

John, can you take care of this one, please? It's purely cosmetical, so not CCing stable.


 drivers/ssb/driver_chipcommon_pmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 305ade7..a7aef47 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -417,9 +417,9 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
 	u32 min_msk = 0, max_msk = 0;
 	unsigned int i;
 	const struct pmu_res_updown_tab_entry *updown_tab = NULL;
-	unsigned int updown_tab_size;
+	unsigned int updown_tab_size = 0;
 	const struct pmu_res_depend_tab_entry *depend_tab = NULL;
-	unsigned int depend_tab_size;
+	unsigned int depend_tab_size = 0;
 
 	switch (bus->chip_id) {
 	case 0x4312:
-- 
1.7.4.4


