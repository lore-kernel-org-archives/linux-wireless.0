Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35407 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbbK0Ihb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:31 -0500
Received: by lfdl133 with SMTP id l133so120689667lfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:30 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 07/13] ath9k: MCC enable Opportunistic Power Save
Date: Fri, 27 Nov 2015 09:37:12 +0100
Message-Id: <1448613438-5173-7-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093739_780527_C4D35B82)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding NOA attr enable Opportunistic Power Save.
Before we calculate ctwindow but didn't enable oppps.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2afb8da..31b4d0e 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1505,6 +1505,8 @@ void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 
 	noa->index = avp->noa_index;
 	noa->oppps_ctwindow = ath9k_get_ctwin(sc, avp);
+	if (noa->oppps_ctwindow)
+		noa->oppps_ctwindow |= BIT(7);
 
 	if (avp->noa_duration) {
 		if (avp->periodic_noa) {
-- 
1.9.1

