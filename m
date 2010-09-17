Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43761 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0IQXHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 19:07:08 -0400
Received: by bwz11 with SMTP id 11so3127680bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 16:07:07 -0700 (PDT)
Message-Id: <7f496409cb8a2783bffd18bcd85964dc6a97fafa.1284763835.git.chunkeey@googlemail.com>
In-Reply-To: <cover.1284763834.git.chunkeey@googlemail.com>
References: <cover.1284763834.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 17 Sep 2010 22:47:28 +0200
Subject: [PATCH 4/7] carl9170: abort tasklet during usb reset
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch prevents the tasklet code from
interfering while the firmware is down for
an unscheduled maintenance.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/usb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index fde918d..1e7c274 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -367,6 +367,9 @@ static void carl9170_usb_tasklet(unsigned long data)
 {
 	struct ar9170 *ar = (struct ar9170 *) data;
 
+	if (!IS_INITIALIZED(ar))
+		return;
+
 	carl9170_usb_rx_work(ar);
 
 	/*
-- 
1.7.1

