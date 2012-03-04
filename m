Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40715 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2CDI4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:56:03 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm2so1368116wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:56:02 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/11] wl12xx: configure the correct beacon_interval
Date: Sun,  4 Mar 2012 10:55:53 +0200
Message-Id: <1330851355-24459-10-git-send-email-eliad@wizery.com> (sfid-20120304_095632_088237_25F4DBCA)
In-Reply-To: <1330851355-24459-1-git-send-email-eliad@wizery.com>
References: <1330851355-24459-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We didn't update the beacon interval on association
(or on a change notification when working as sta),
so the default interval (100ms) was always used.

Update the beacon interval according to the bss_conf
before starting the sta role (on association).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1d5f2d5..89bf9ea 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3723,6 +3723,7 @@ sta_not_found:
 			u32 rates;
 			int ieoffset;
 			wlvif->aid = bss_conf->aid;
+			wlvif->beacon_int = bss_conf->beacon_int;
 			set_assoc = true;
 
 			/*
-- 
1.7.6.401.g6a319

