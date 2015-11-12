Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35183 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbbKLNQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:19 -0500
Received: by lbbsy6 with SMTP id sy6so6136596lbb.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:18 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 07/12] ath9k: MCC enable Opportunistic Power Save
Date: Thu, 12 Nov 2015 14:15:44 +0100
Message-Id: <1447334149-15507-7-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141624_849232_A27AF424)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When adding NOA attr enable Opportunistiv Power Save.
Before we calculate ctwindow but didn't enable oppps.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 4f60ddb..2615392 100644
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

