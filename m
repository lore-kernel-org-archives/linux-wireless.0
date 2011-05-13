Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3386 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/32] staging: brcm80211: make function definitions and
 prototype consistent
Date: Fri, 13 May 2011 11:59:28 +0200
Message-ID: <1305280792-9475-8-git-send-email-arend@broadcom.com> (sfid-20110513_120125_312235_BCC0F827)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of functions that are only used within wlc_channel.c have been
prototyped with static keyword. For the function definition itself this
has been added when missing.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index d6b1dcd..e31e392 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -107,7 +107,7 @@ static void wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *
 								 *txpwr,
 								 u8
 								 local_constraint_qdbm);
-void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels);
+static void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels);
 static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx);
 static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx);
 
@@ -397,7 +397,7 @@ static const chanvec_t *g_table_locale_base[] = {
 	&locale_5g_HIGH4
 };
 
-void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels)
+static void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels)
 {
 	u8 i;
 	for (i = 0; i < sizeof(chanvec_t); i++) {
@@ -608,7 +608,7 @@ static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 	return g_locale_5g_table[locale_idx];
 }
 
-const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
+static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
 		return NULL;
@@ -616,7 +616,7 @@ const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 	return g_mimo_2g_table[locale_idx];
 }
 
-const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
+static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
 		return NULL;
-- 
1.7.4.1


