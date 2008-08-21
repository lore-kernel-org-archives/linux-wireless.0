Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759631AbYHUW3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:20 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:20 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 15/19] orinoco: Use a macro to define wireless handlers
Date: Thu, 21 Aug 2008 23:28:01 +0100
Message-Id: <50585fbee314ce11734e09b9c342c94d2f84c8bc.1219352676.git.kilroyd@gmail.com> (sfid-20080822_005043_996892_B02FC702)
In-Reply-To: <bbb15e90927ee20492ec6d76000ee6b95ce69bd9.1219352676.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
 <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
 <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com>
 <09ee16c27766ca779c63a0e82df7e4aa723f4fdf.1219352676.git.kilroyd@gmail.com>
 <bbb15e90927ee20492ec6d76000ee6b95ce69bd9.1219352676.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro identifiers for the various ioctls required for WPA support
are longer than those currently used by the driver. This makes it messy
to keep line length below 80 character.

By defining a macro to initialise the handler table, we recover the
common text.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   66 ++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 21bed6c..e91e240 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -5043,39 +5043,41 @@ static const struct iw_priv_args orinoco_privtab[] = {
  * Structures to export the Wireless Handlers
  */
 
+#define STD_IW_HANDLER(id, func) \
+	[IW_IOCTL_IDX(id)] = (iw_handler) func
 static const iw_handler	orinoco_handler[] = {
-	[SIOCSIWCOMMIT-SIOCIWFIRST] = (iw_handler) orinoco_ioctl_commit,
-	[SIOCGIWNAME  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getname,
-	[SIOCSIWFREQ  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setfreq,
-	[SIOCGIWFREQ  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getfreq,
-	[SIOCSIWMODE  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setmode,
-	[SIOCGIWMODE  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getmode,
-	[SIOCSIWSENS  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setsens,
-	[SIOCGIWSENS  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getsens,
-	[SIOCGIWRANGE -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getiwrange,
-	[SIOCSIWSPY   -SIOCIWFIRST] = (iw_handler) iw_handler_set_spy,
-	[SIOCGIWSPY   -SIOCIWFIRST] = (iw_handler) iw_handler_get_spy,
-	[SIOCSIWTHRSPY-SIOCIWFIRST] = (iw_handler) iw_handler_set_thrspy,
-	[SIOCGIWTHRSPY-SIOCIWFIRST] = (iw_handler) iw_handler_get_thrspy,
-	[SIOCSIWAP    -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setwap,
-	[SIOCGIWAP    -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getwap,
-	[SIOCSIWSCAN  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setscan,
-	[SIOCGIWSCAN  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getscan,
-	[SIOCSIWESSID -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setessid,
-	[SIOCGIWESSID -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getessid,
-	[SIOCSIWNICKN -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setnick,
-	[SIOCGIWNICKN -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getnick,
-	[SIOCSIWRATE  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setrate,
-	[SIOCGIWRATE  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getrate,
-	[SIOCSIWRTS   -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setrts,
-	[SIOCGIWRTS   -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getrts,
-	[SIOCSIWFRAG  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setfrag,
-	[SIOCGIWFRAG  -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getfrag,
-	[SIOCGIWRETRY -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getretry,
-	[SIOCSIWENCODE-SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setiwencode,
-	[SIOCGIWENCODE-SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getiwencode,
-	[SIOCSIWPOWER -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_setpower,
-	[SIOCGIWPOWER -SIOCIWFIRST] = (iw_handler) orinoco_ioctl_getpower,
+	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
+	STD_IW_HANDLER(SIOCGIWNAME,	orinoco_ioctl_getname),
+	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
+	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
+	STD_IW_HANDLER(SIOCSIWMODE,	orinoco_ioctl_setmode),
+	STD_IW_HANDLER(SIOCGIWMODE,	orinoco_ioctl_getmode),
+	STD_IW_HANDLER(SIOCSIWSENS,	orinoco_ioctl_setsens),
+	STD_IW_HANDLER(SIOCGIWSENS,	orinoco_ioctl_getsens),
+	STD_IW_HANDLER(SIOCGIWRANGE,	orinoco_ioctl_getiwrange),
+	STD_IW_HANDLER(SIOCSIWSPY,	iw_handler_set_spy),
+	STD_IW_HANDLER(SIOCGIWSPY,	iw_handler_get_spy),
+	STD_IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
+	STD_IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
+	STD_IW_HANDLER(SIOCSIWAP,	orinoco_ioctl_setwap),
+	STD_IW_HANDLER(SIOCGIWAP,	orinoco_ioctl_getwap),
+	STD_IW_HANDLER(SIOCSIWSCAN,	orinoco_ioctl_setscan),
+	STD_IW_HANDLER(SIOCGIWSCAN,	orinoco_ioctl_getscan),
+	STD_IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
+	STD_IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
+	STD_IW_HANDLER(SIOCSIWNICKN,	orinoco_ioctl_setnick),
+	STD_IW_HANDLER(SIOCGIWNICKN,	orinoco_ioctl_getnick),
+	STD_IW_HANDLER(SIOCSIWRATE,	orinoco_ioctl_setrate),
+	STD_IW_HANDLER(SIOCGIWRATE,	orinoco_ioctl_getrate),
+	STD_IW_HANDLER(SIOCSIWRTS,	orinoco_ioctl_setrts),
+	STD_IW_HANDLER(SIOCGIWRTS,	orinoco_ioctl_getrts),
+	STD_IW_HANDLER(SIOCSIWFRAG,	orinoco_ioctl_setfrag),
+	STD_IW_HANDLER(SIOCGIWFRAG,	orinoco_ioctl_getfrag),
+	STD_IW_HANDLER(SIOCGIWRETRY,	orinoco_ioctl_getretry),
+	STD_IW_HANDLER(SIOCSIWENCODE,	orinoco_ioctl_setiwencode),
+	STD_IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
+	STD_IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
+	STD_IW_HANDLER(SIOCGIWPOWER,	orinoco_ioctl_getpower),
 };
 
 
-- 
1.5.6.4

