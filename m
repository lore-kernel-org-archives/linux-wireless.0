Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0G3EKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:10:05 -0400
Subject: [wt PATCH 1/5] libertas: get the right # of scanned BSSes
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:11:30 -0700
Message-ID: <1280470290.14523.7.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's actually check the right field in the command response; and
if there aren't any reported BSSes, exit early with success.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 25f9027..b60f661 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -465,7 +465,15 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
-	nr_sets = le16_to_cpu(resp->size);
+	nr_sets = le16_to_cpu(scanresp->nr_sets);
+
+	lbs_deb_scan("scan response: %d BSSs (%d bytes); resp size %d bytes\n",
+			nr_sets, bsssize, le16_to_cpu(resp->size));
+
+	if (nr_sets == 0) {
+		ret = 0;
+		goto done;
+	}
 
 	/*
 	 * The general layout of the scan response is described in chapter
-- 
1.7.2


