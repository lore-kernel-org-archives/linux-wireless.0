Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:3053 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbZJVNfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:47 -0400
Message-Id: <20091022133423.233671310@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:59 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 16/19] libertas: remove some references to IW_MODE_abc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... in pursue to quaff the wide-spread references to WEXT constants.

When setting SNMP_MIB_OID_BSS_TYPE, wext.c can directly calculate the value
the firmware wants.

Reading of SNMP_MIB_OID_BSS_TYPE doesn't happen anywhere, so no need to
convert the firmware value into WEXT values anyway.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -390,7 +390,7 @@
 	switch (oid) {
 	case SNMP_MIB_OID_BSS_TYPE:
 		cmd.bufsize = cpu_to_le16(sizeof(u8));
-		cmd.value[0] = (val == IW_MODE_ADHOC) ? 2 : 1;
+		cmd.value[0] = val;
 		break;
 	case SNMP_MIB_OID_11D_ENABLE:
 	case SNMP_MIB_OID_FRAG_THRESHOLD:
@@ -443,13 +443,7 @@
 
 	switch (le16_to_cpu(cmd.bufsize)) {
 	case sizeof(u8):
-		if (oid == SNMP_MIB_OID_BSS_TYPE) {
-			if (cmd.value[0] == 2)
-				*out_val = IW_MODE_ADHOC;
-			else
-				*out_val = IW_MODE_INFRA;
-		} else
-			*out_val = cmd.value[0];
+		*out_val = cmd.value[0];
 		break;
 	case sizeof(u16):
 		*out_val = le16_to_cpu(*((__le16 *)(&cmd.value)));
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -1567,7 +1567,8 @@
 	}
 
 	priv->mode = assoc_req->mode;
-	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, assoc_req->mode);
+	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE,
+		assoc_req->mode == IW_MODE_ADHOC ? 2 : 1);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);

-- 
