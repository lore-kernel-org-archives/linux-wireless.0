Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24314 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZCIEGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 00:06:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 21:06:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18868.38073.487629.764071@gargle.gargle.HOWL> (sfid-20090309_050613_465066_CBAE1280)
Date: Mon, 9 Mar 2009 09:32:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/3] ath9k: Fix bug in reading debugfs file 'rcstat'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate table would not have been chosen before the interface
has been brought up. Reading 'rcstat' in this case would result
in an oops, fix this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index b0ff479..82573ca 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -322,6 +322,9 @@ static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 
+	if (sc->cur_rate_table == NULL)
+		return 0;
+
 	if (conf_is_ht(&sc->hw->conf))
 		return ath_read_file_stat_11n_rc(file, user_buf, count, ppos);
 	else
-- 
1.6.1

