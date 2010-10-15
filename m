Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37649 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0JOAA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 20:00:27 -0400
Received: by ewy20 with SMTP id 20so165287ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 17:00:26 -0700 (PDT)
Date: Fri, 15 Oct 2010 02:00:40 +0200 (CEST)
From: "=?ISO-8859-15?Q?Bj=F6rn_Smedman?=" <bjorn.smedman@venatech.se>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: avoid division-by-zero in ani
Message-ID: <alpine.DEB.2.00.1010150150110.20478@bigbill>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-928335126-1287100842=:20478"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-928335126-1287100842=:20478
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

The ath9k ANI code may under some circumstances do division-by-zero. This 
patch detects and avoids that case.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
---
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 3aa8fb1..50a7f89 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -713,6 +713,9 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	ath9k_hw_ani_read_counters(ah);
 
+	if (WARN_ON(aniState->listenTime == 0))
+		return;
+
 	ofdmPhyErrRate = aniState->ofdmPhyErrCount * 1000 /
 			 aniState->listenTime;
 	cckPhyErrRate =  aniState->cckPhyErrCount * 1000 /
--8323329-928335126-1287100842=:20478--
