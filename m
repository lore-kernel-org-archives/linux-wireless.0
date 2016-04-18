Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 15/16] rtl8xxxu: Rename rtl8723bu_simularity_compare()
Date: Mon, 18 Apr 2016 11:49:35 -0400
Message-Id: <1460994576-24091-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_180721_985158_8B9FD265)
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This renames rtl8723bu_simularity_compare() to
rtl8xxxu_gen2_simularity_compare() to reflect it is used for all gen2
parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index bec2c4d..240b361 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4591,8 +4591,8 @@ static bool rtl8xxxu_simularity_compare(struct rtl8xxxu_priv *priv,
 	return false;
 }
 
-static bool rtl8723bu_simularity_compare(struct rtl8xxxu_priv *priv,
-					 int result[][8], int c1, int c2)
+static bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
+					     int result[][8], int c1, int c2)
 {
 	u32 i, j, diff, simubitmap, bound = 0;
 	int candidate[2] = {-1, -1};	/* for path A and path B */
@@ -6233,7 +6233,8 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		rtl8723bu_phy_iqcalibrate(priv, result, i);
 
 		if (i == 1) {
-			simu = rtl8723bu_simularity_compare(priv, result, 0, 1);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 0, 1);
 			if (simu) {
 				candidate = 0;
 				break;
@@ -6241,13 +6242,15 @@ static void rtl8723bu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		}
 
 		if (i == 2) {
-			simu = rtl8723bu_simularity_compare(priv, result, 0, 2);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 0, 2);
 			if (simu) {
 				candidate = 0;
 				break;
 			}
 
-			simu = rtl8723bu_simularity_compare(priv, result, 1, 2);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 1, 2);
 			if (simu) {
 				candidate = 1;
 			} else {
@@ -6348,7 +6351,8 @@ static void rtl8192eu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		rtl8192eu_phy_iqcalibrate(priv, result, i);
 
 		if (i == 1) {
-			simu = rtl8723bu_simularity_compare(priv, result, 0, 1);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 0, 1);
 			if (simu) {
 				candidate = 0;
 				break;
@@ -6356,13 +6360,15 @@ static void rtl8192eu_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 		}
 
 		if (i == 2) {
-			simu = rtl8723bu_simularity_compare(priv, result, 0, 2);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 0, 2);
 			if (simu) {
 				candidate = 0;
 				break;
 			}
 
-			simu = rtl8723bu_simularity_compare(priv, result, 1, 2);
+			simu = rtl8xxxu_gen2_simularity_compare(priv,
+								result, 1, 2);
 			if (simu)
 				candidate = 1;
 			else
-- 
2.5.5

