Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab0G3EOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:14:34 -0400
Subject: [wt PATCH 4/5] libertas: fix association with some APs by using
 extended rates
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:16:01 -0700
Message-ID: <1280470561.14523.13.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs get pissy if you don't send the firmware the extended rates
in the association request's rates TLV.  Found this on a Linksys
WRT54G v2; it denies association with status code 18 unless you
add the extended rates too.  The old driver did this, but it got
lost in the cfg80211 conversion.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c |   56 +++++++++++++++++++++++++----------
 1 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index a9647e6..a8c0126 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -257,6 +257,29 @@ static int lbs_add_supported_rates_tlv(u8 *tlv)
 	return sizeof(rate_tlv->header) + i;
 }
 
+/* Add common rates from a TLV and return the new end of the TLV */
+static u8 *
+add_ie_rates(u8 *tlv, const u8 *ie, int *nrates)
+{
+	int hw, ap, ap_max = ie[1];
+	u8 hw_rate;
+
+	/* Advance past IE header */
+	ie += 2;
+
+	lbs_deb_hex(LBS_DEB_ASSOC, "AP IE Rates", (u8 *) ie, ap_max);
+
+	for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
+		hw_rate = lbs_rates[hw].bitrate / 5;
+		for (ap = 0; ap < ap_max; ap++) {
+			if (hw_rate == (ie[ap] & 0x7f)) {
+				*tlv++ = ie[ap];
+				*nrates = *nrates + 1;
+			}
+		}
+	}
+	return tlv;
+}
 
 /*
  * Adds a TLV with all rates the hardware *and* BSS supports.
@@ -264,8 +287,11 @@ static int lbs_add_supported_rates_tlv(u8 *tlv)
 static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
 {
 	struct mrvl_ie_rates_param_set *rate_tlv = (void *)tlv;
-	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
-	int n;
+	const u8 *rates_eid, *ext_rates_eid;
+	int n = 0;
+
+	rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	ext_rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_EXT_SUPP_RATES);
 
 	/*
 	 * 01 00                   TLV_TYPE_RATES
@@ -275,26 +301,21 @@ static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
 	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	tlv += sizeof(rate_tlv->header);
 
-	if (!rates_eid) {
+	/* Add basic rates */
+	if (rates_eid) {
+		tlv = add_ie_rates(tlv, rates_eid, &n);
+
+		/* Add extended rates, if any */
+		if (ext_rates_eid)
+			tlv = add_ie_rates(tlv, ext_rates_eid, &n);
+	} else {
+		lbs_deb_assoc("assoc: bss had no basic rate IE\n");
 		/* Fallback: add basic 802.11b rates */
 		*tlv++ = 0x82;
 		*tlv++ = 0x84;
 		*tlv++ = 0x8b;
 		*tlv++ = 0x96;
 		n = 4;
-	} else {
-		int hw, ap;
-		u8 ap_max = rates_eid[1];
-		n = 0;
-		for (hw = 0; hw < ARRAY_SIZE(lbs_rates); hw++) {
-			u8 hw_rate = lbs_rates[hw].bitrate / 5;
-			for (ap = 0; ap < ap_max; ap++) {
-				if (hw_rate == (rates_eid[ap+2] & 0x7f)) {
-					*tlv++ = rates_eid[ap+2];
-					n++;
-				}
-			}
-		}
 	}
 
 	rate_tlv->header.len = cpu_to_le16(n);
@@ -1024,6 +1045,7 @@ static int lbs_associate(struct lbs_private *priv,
 	int status;
 	int ret;
 	u8 *pos = &(cmd->iebuf[0]);
+	u8 *tmp;
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
@@ -1068,7 +1090,9 @@ static int lbs_associate(struct lbs_private *priv,
 	pos += lbs_add_cf_param_tlv(pos);
 
 	/* add rates TLV */
+	tmp = pos + 4; /* skip Marvell IE header */
 	pos += lbs_add_common_rates_tlv(pos, bss);
+	lbs_deb_hex(LBS_DEB_ASSOC, "Common Rates", tmp, pos - tmp);
 
 	/* add auth type TLV */
 	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 9)
-- 
1.7.2


