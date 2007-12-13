Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762656AbXLMG7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:42 -0500
Subject: [PATCH 80/48] libertas: allow setting channel on mshX device
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i33-0005tS-7x@shinybook.infradead.org> (sfid-20071213_070001_011029_74B28960)
Date: Thu, 13 Dec 2007 01:59:57 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 19:56:28 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/wext.c |   53 +++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 0a06072..262d4cc 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -959,6 +959,57 @@ out:
 	return ret;
 }
 
+static int lbs_mesh_set_freq(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_freq *fwrq, char *extra)
+{
+	struct lbs_private *priv = dev->priv;
+	struct chan_freq_power *cfp;
+	int ret = -EINVAL;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	/* If setting by frequency, convert to a channel */
+	if (fwrq->e == 1) {
+		long f = fwrq->m / 100000;
+
+		cfp = find_cfp_by_band_and_freq(priv, 0, f);
+		if (!cfp) {
+			lbs_deb_wext("invalid freq %ld\n", f);
+			goto out;
+		}
+
+		fwrq->e = 0;
+		fwrq->m = (int) cfp->channel;
+	}
+
+	/* Setting by channel number */
+	if (fwrq->m > 1000 || fwrq->e > 0) {
+		goto out;
+	}
+
+	cfp = lbs_find_cfp_by_band_and_channel(priv, 0, fwrq->m);
+	if (!cfp) {
+		goto out;
+	}
+
+	if (fwrq->m != priv->curbssparams.channel) {
+		lbs_deb_wext("mesh channel change forces eth disconnect\n");
+		if (priv->mode == IW_MODE_INFRA)
+			lbs_send_deauthentication(priv);
+		else if (priv->mode == IW_MODE_ADHOC)
+			lbs_stop_adhoc_network(priv);
+	}
+	priv->curbssparams.channel = fwrq->m;
+	lbs_mesh_config(priv, 0);
+	lbs_mesh_config(priv, 1);
+	ret = 0;
+
+out:
+	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+	return ret;
+}
+
 static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
@@ -2097,7 +2148,7 @@ static const iw_handler mesh_wlan_handler[] = {
 	(iw_handler) lbs_get_name,	/* SIOCGIWNAME */
 	(iw_handler) NULL,	/* SIOCSIWNWID */
 	(iw_handler) NULL,	/* SIOCGIWNWID */
-	(iw_handler) lbs_set_freq,	/* SIOCSIWFREQ */
+	(iw_handler) lbs_mesh_set_freq,	/* SIOCSIWFREQ */
 	(iw_handler) lbs_get_freq,	/* SIOCGIWFREQ */
 	(iw_handler) NULL,		/* SIOCSIWMODE */
 	(iw_handler) mesh_wlan_get_mode,	/* SIOCGIWMODE */
-- 
1.5.3.4

