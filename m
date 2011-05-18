Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab1ERM00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 08:26:26 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 05:25:55 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Rajkumar.Manoharan@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: use PS wakeup before REG_READ
Date: Wed, 18 May 2011 17:56:00 +0530
Message-ID: <1305721560-5806-1-git-send-email-mshajakhan@atheros.com> (sfid-20110518_142629_562528_FA4A3725)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

otherwise we will get deadbeef when the station is in idle state

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 7afe332..0021738 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -435,6 +435,7 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			conf->channel_type,
 			channel_type_str(conf->channel_type));
 
+	ath9k_ps_wakeup(sc);
 	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
@@ -443,7 +444,6 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addrmask: %pM\n", addr);
-	ath9k_ps_wakeup(sc);
 	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
 	ath9k_ps_restore(sc);
 	len += snprintf(buf + len, sizeof(buf) - len,
-- 
1.7.0.4

