Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47268 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab2BWV3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 16:29:18 -0500
Received: by pbcun15 with SMTP id un15so1852030pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 13:29:18 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: Use IW_HANDLER macro from linux/wireless.h
Date: Thu, 23 Feb 2012 17:31:24 -0500
Message-Id: <1330036284-7572-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120223_222924_508086_163EA040)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use IW_HANDLER macro in ipw2100.c to declare wireless handlers.

Note: ipw2200.c already uses it.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |   90 ++++++++++++-------------------
 1 files changed, 35 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index a0e5c21..da41b8c 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -8108,61 +8108,41 @@ static int ipw2100_wx_get_crc_check(struct net_device *dev,
 #endif				/* CONFIG_IPW2100_MONITOR */
 
 static iw_handler ipw2100_wx_handlers[] = {
-	NULL,			/* SIOCSIWCOMMIT */
-	ipw2100_wx_get_name,	/* SIOCGIWNAME */
-	NULL,			/* SIOCSIWNWID */
-	NULL,			/* SIOCGIWNWID */
-	ipw2100_wx_set_freq,	/* SIOCSIWFREQ */
-	ipw2100_wx_get_freq,	/* SIOCGIWFREQ */
-	ipw2100_wx_set_mode,	/* SIOCSIWMODE */
-	ipw2100_wx_get_mode,	/* SIOCGIWMODE */
-	NULL,			/* SIOCSIWSENS */
-	NULL,			/* SIOCGIWSENS */
-	NULL,			/* SIOCSIWRANGE */
-	ipw2100_wx_get_range,	/* SIOCGIWRANGE */
-	NULL,			/* SIOCSIWPRIV */
-	NULL,			/* SIOCGIWPRIV */
-	NULL,			/* SIOCSIWSTATS */
-	NULL,			/* SIOCGIWSTATS */
-	NULL,			/* SIOCSIWSPY */
-	NULL,			/* SIOCGIWSPY */
-	NULL,			/* SIOCGIWTHRSPY */
-	NULL,			/* SIOCWIWTHRSPY */
-	ipw2100_wx_set_wap,	/* SIOCSIWAP */
-	ipw2100_wx_get_wap,	/* SIOCGIWAP */
-	ipw2100_wx_set_mlme,	/* SIOCSIWMLME */
-	NULL,			/* SIOCGIWAPLIST -- deprecated */
-	ipw2100_wx_set_scan,	/* SIOCSIWSCAN */
-	ipw2100_wx_get_scan,	/* SIOCGIWSCAN */
-	ipw2100_wx_set_essid,	/* SIOCSIWESSID */
-	ipw2100_wx_get_essid,	/* SIOCGIWESSID */
-	ipw2100_wx_set_nick,	/* SIOCSIWNICKN */
-	ipw2100_wx_get_nick,	/* SIOCGIWNICKN */
-	NULL,			/* -- hole -- */
-	NULL,			/* -- hole -- */
-	ipw2100_wx_set_rate,	/* SIOCSIWRATE */
-	ipw2100_wx_get_rate,	/* SIOCGIWRATE */
-	ipw2100_wx_set_rts,	/* SIOCSIWRTS */
-	ipw2100_wx_get_rts,	/* SIOCGIWRTS */
-	ipw2100_wx_set_frag,	/* SIOCSIWFRAG */
-	ipw2100_wx_get_frag,	/* SIOCGIWFRAG */
-	ipw2100_wx_set_txpow,	/* SIOCSIWTXPOW */
-	ipw2100_wx_get_txpow,	/* SIOCGIWTXPOW */
-	ipw2100_wx_set_retry,	/* SIOCSIWRETRY */
-	ipw2100_wx_get_retry,	/* SIOCGIWRETRY */
-	ipw2100_wx_set_encode,	/* SIOCSIWENCODE */
-	ipw2100_wx_get_encode,	/* SIOCGIWENCODE */
-	ipw2100_wx_set_power,	/* SIOCSIWPOWER */
-	ipw2100_wx_get_power,	/* SIOCGIWPOWER */
-	NULL,			/* -- hole -- */
-	NULL,			/* -- hole -- */
-	ipw2100_wx_set_genie,	/* SIOCSIWGENIE */
-	ipw2100_wx_get_genie,	/* SIOCGIWGENIE */
-	ipw2100_wx_set_auth,	/* SIOCSIWAUTH */
-	ipw2100_wx_get_auth,	/* SIOCGIWAUTH */
-	ipw2100_wx_set_encodeext,	/* SIOCSIWENCODEEXT */
-	ipw2100_wx_get_encodeext,	/* SIOCGIWENCODEEXT */
-	NULL,			/* SIOCSIWPMKSA */
+	IW_HANDLER(SIOCGIWNAME, ipw2100_wx_get_name),
+	IW_HANDLER(SIOCSIWFREQ, ipw2100_wx_set_freq),
+	IW_HANDLER(SIOCGIWFREQ, ipw2100_wx_get_freq),
+	IW_HANDLER(SIOCSIWMODE, ipw2100_wx_set_mode),
+	IW_HANDLER(SIOCGIWMODE, ipw2100_wx_get_mode),
+	IW_HANDLER(SIOCGIWRANGE, ipw2100_wx_get_range),
+	IW_HANDLER(SIOCSIWAP, ipw2100_wx_set_wap),
+	IW_HANDLER(SIOCGIWAP, ipw2100_wx_get_wap),
+	IW_HANDLER(SIOCSIWMLME, ipw2100_wx_set_mlme),
+	IW_HANDLER(SIOCSIWSCAN, ipw2100_wx_set_scan),
+	IW_HANDLER(SIOCGIWSCAN, ipw2100_wx_get_scan),
+	IW_HANDLER(SIOCSIWESSID, ipw2100_wx_set_essid),
+	IW_HANDLER(SIOCGIWESSID, ipw2100_wx_get_essid),
+	IW_HANDLER(SIOCSIWNICKN, ipw2100_wx_set_nick),
+	IW_HANDLER(SIOCGIWNICKN, ipw2100_wx_get_nick),
+	IW_HANDLER(SIOCSIWRATE, ipw2100_wx_set_rate),
+	IW_HANDLER(SIOCGIWRATE, ipw2100_wx_get_rate),
+	IW_HANDLER(SIOCSIWRTS, ipw2100_wx_set_rts),
+	IW_HANDLER(SIOCGIWRTS, ipw2100_wx_get_rts),
+	IW_HANDLER(SIOCSIWFRAG, ipw2100_wx_set_frag),
+	IW_HANDLER(SIOCGIWFRAG, ipw2100_wx_get_frag),
+	IW_HANDLER(SIOCSIWTXPOW, ipw2100_wx_set_txpow),
+	IW_HANDLER(SIOCGIWTXPOW, ipw2100_wx_get_txpow),
+	IW_HANDLER(SIOCSIWRETRY, ipw2100_wx_set_retry),
+	IW_HANDLER(SIOCGIWRETRY, ipw2100_wx_get_retry),
+	IW_HANDLER(SIOCSIWENCODE, ipw2100_wx_set_encode),
+	IW_HANDLER(SIOCGIWENCODE, ipw2100_wx_get_encode),
+	IW_HANDLER(SIOCSIWPOWER, ipw2100_wx_set_power),
+	IW_HANDLER(SIOCGIWPOWER, ipw2100_wx_get_power),
+	IW_HANDLER(SIOCSIWGENIE, ipw2100_wx_set_genie),
+	IW_HANDLER(SIOCGIWGENIE, ipw2100_wx_get_genie),
+	IW_HANDLER(SIOCSIWAUTH, ipw2100_wx_set_auth),
+	IW_HANDLER(SIOCGIWAUTH, ipw2100_wx_get_auth),
+	IW_HANDLER(SIOCSIWENCODEEXT, ipw2100_wx_set_encodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT, ipw2100_wx_get_encodeext),
 };
 
 #define IPW2100_PRIV_SET_MONITOR	SIOCIWFIRSTPRIV
-- 
1.7.2.5

