Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2BDB0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:11 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:10 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 06/11] crda: add dfs_region to the ieee80211_regdomain data structure
Date: Fri,  3 Feb 2012 17:25:43 -0800
Message-Id: <1328318748-21044-7-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022620_824310_006359BC)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used later once crda.c starts using the
ieee80211_regdomain data structure passed on from reglib
instead of using the mmap()'d regulatory file directly.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 reglib.c |    1 +
 reglib.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/reglib.c b/reglib.c
index 642f907..759c676 100644
--- a/reglib.c
+++ b/reglib.c
@@ -212,6 +212,7 @@ struct ieee80211_regdomain *country2rd(uint8_t *db, int dblen,
 
 	rd->alpha2[0] = country->alpha2[0];
 	rd->alpha2[1] = country->alpha2[1];
+	rd->dfs_region = country->creqs & 0x3;
 	rd->n_reg_rules = num_rules;
 
 	for (i = 0; i < num_rules; i++) {
diff --git a/reglib.h b/reglib.h
index d76ec52..bec6359 100644
--- a/reglib.h
+++ b/reglib.h
@@ -29,6 +29,7 @@ struct ieee80211_reg_rule {
 struct ieee80211_regdomain {
 	uint32_t n_reg_rules;
 	char alpha2[2];
+	uint8_t dfs_region;
 	struct ieee80211_reg_rule reg_rules[];
 };
 
-- 
1.7.4.15.g7811d

