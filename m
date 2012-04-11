Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3441 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab2DKJxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 8/9] brcm80211: smac: only provide valid regulatory hint
Date: Wed, 11 Apr 2012 11:52:50 +0200
Message-ID: <1334137971-3972-9-git-send-email-arend@broadcom.com> (sfid-20120411_115341_143812_48269214)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver provides a regulatory hint to cfg80211 as obtained from the
SPROM. Mostly, this will be a two-letter ISO country code. However, it
may obtain special country code similar to the world regulatory domain
as used in cfg80211. This patch avoids setting these special codes as
the hint is lost to cfg80211.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |   36 ++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 55e9f45..0efe88e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -628,6 +628,40 @@ brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 	return false;
 }
 
+/*
+ * Indicates whether the country provided is valid to pass
+ * to cfg80211 or not.
+ *
+ * returns true if valid; false if not.
+ */
+static bool brcms_c_country_valid(const char *ccode)
+{
+	/*
+	 * only allow ascii alpha uppercase for the first 2
+	 * chars.
+	 */
+	if (!((0x80 & ccode[0]) == 0 && ccode[0] >= 0x41 && ccode[0] <= 0x5A &&
+	      (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A &&
+	      ccode[2] == '\0'))
+		return false;
+
+	/*
+	 * do not match ISO 3166-1 user assigned country codes
+	 * that may be in the driver table
+	 */
+	if (!strcmp("AA", ccode) ||        /* AA */
+	    !strcmp("ZZ", ccode) ||        /* ZZ */
+	    ccode[0] == 'X' ||             /* XA - XZ */
+	    (ccode[0] == 'Q' &&            /* QM - QZ */
+	     (ccode[1] >= 'M' && ccode[1] <= 'Z')))
+		return false;
+
+	if (!strcmp("NA", ccode))
+		return false;
+
+	return true;
+}
+
 /* Lookup a country info structure from a null terminated country
  * abbreviation and regrev directly with no translation.
  */
@@ -1089,7 +1123,7 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 
 	/* store the country code for passing up as a regulatory hint */
 	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
-	if (ccode)
+	if (ccode && brcms_c_country_valid(ccode))
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
 	/*
-- 
1.7.5.4


