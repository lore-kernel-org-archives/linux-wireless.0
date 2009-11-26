Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:38370 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbZKZMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 07:25:59 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: simplyfy lbs_set_regiontable()
Date: Thu, 26 Nov 2009 13:25:49 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261325.49582.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a) it's only called once
b) it get's called with band == 0, but setting a field in priv to 0 is
   superfluous (priv is kzalloc'ed anyway), so parameter "band" can go
   away
c) memsetting priv->regiontable is not necessary, too
d) it get's called with both priv and priv->regioncode, so the former
   parameter is superfluous

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -174,7 +174,7 @@ int lbs_update_hw_spec(struct lbs_privat
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
-	if (lbs_set_regiontable(priv, priv->regioncode, 0)) {
+	if (lbs_set_regiontable(priv)) {
 		ret = -1;
 		goto out;
 	}
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -272,7 +272,7 @@ static struct chan_freq_power *lbs_get_r
 	return NULL;
 }
 
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band)
+int lbs_set_regiontable(struct lbs_private *priv)
 {
 	int ret = 0;
 	int i = 0;
@@ -282,21 +282,18 @@ int lbs_set_regiontable(struct lbs_priva
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	memset(priv->region_channel, 0, sizeof(priv->region_channel));
-
-	cfp = lbs_get_region_cfp_table(region, &cfp_no);
+	cfp = lbs_get_region_cfp_table(priv->regioncode, &cfp_no);
 	if (cfp != NULL) {
 		priv->region_channel[i].nrcfp = cfp_no;
 		priv->region_channel[i].CFP = cfp;
 	} else {
 		lbs_deb_main("wrong region code %#x in band B/G\n",
-		       region);
+		       priv->regioncode);
 		ret = -1;
 		goto out;
 	}
 	priv->region_channel[i].valid = 1;
-	priv->region_channel[i].region = region;
-	priv->region_channel[i].band = band;
+	priv->region_channel[i].region = priv->regioncode;
 	i++;
 out:
 	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h
+++ linux-wl/drivers/net/wireless/libertas/scan.h
@@ -46,7 +46,7 @@ struct region_channel {
 
 int lbs_ssid_cmp(u8 *ssid1, u8 ssid1_len, u8 *ssid2, u8 ssid2_len);
 
-int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
+int lbs_set_regiontable(struct lbs_private *priv);
 
 int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
 				u8 ssid_len);

-- 
http://www.holgerschurig.de
