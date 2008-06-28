Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:21779 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYF1Sjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so259538nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:35 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 15/19] orinoco: Use a macro to define wireless handlers
Date: Sat, 28 Jun 2008 19:38:21 +0100
Message-Id: <1214678305-7057-16-git-send-email-kilroyd@gmail.com> (sfid-20080628_210814_411022_569F5072)
In-Reply-To: <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro identifiers for the various ioctls required for WPA support
are longer than those currently used by the driver. This makes it messy
to keep line length below 80 character.

By defining a macro to initialise the handler table, we recover the
common text.

Signed-off-by: David Kilroy <kilroyd@gmail>
---
 drivers/net/wireless/orinoco.c |   66 ++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 1ae78b0..951d0f7 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -5036,39 +5036,41 @@ static const struct iw_priv_args orinoco_privtab[] = {
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
1.5.4.5

