Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from miranda.se.axis.com ([193.13.178.8]:58082 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYF3Ghi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 02:37:38 -0400
From: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
To: <linux-wireless@vger.kernel.org>
Cc: "'Dan Williams'" <dcbw@redhat.com>,
	"'Johan Adolfsson'" <johan.adolfsson@axis.com>
Subject: [PATCH] Add module parameter to override regioncode on libertas
Date: Mon, 30 Jun 2008 08:36:56 +0200
Message-ID: <054201c8da7b$b12677e0$0137550a@se.axis.com> (sfid-20080630_083743_406500_6D839396)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0543_01C8DA8C.74AF47E0"
In-Reply-To: <1214580776.10355.16.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0543_01C8DA8C.74AF47E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit


Resending to linux-wireless after positive feedback on libertas-dev.

Attached is a patch against the 2.6.25 driver that adds a 
module parameter called "regioncode" to set the region code
in the libertas driver.

Hope the format is ok.
Signed-off-by: Johan.Adolfsson@axis.com

Best regards
/Johan

------=_NextPart_000_0543_01C8DA8C.74AF47E0
Content-Type: text/plain;
	name="regioncode_patch.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="regioncode_patch.txt"

Index: drivers/net/wireless/libertas/main.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/usr/local/cvs/linux/os/linux-2.6/drivers/net/wireless/libertas/main.c,v=0A=
retrieving revision 1.1.1.4=0A=
diff -u -r1.1.1.4 main.c=0A=
--- drivers/net/wireless/libertas/main.c	2 Jun 2008 15:08:37 -0000	=
1.1.1.4=0A=
+++ drivers/net/wireless/libertas/main.c	27 Jun 2008 13:08:19 -0000=0A=
@@ -36,6 +36,9 @@=0A=
 EXPORT_SYMBOL_GPL(lbs_debug);=0A=
 module_param_named(libertas_debug, lbs_debug, int, 0644);=0A=
 =0A=
+static int lbs_regioncode;=0A=
+module_param_named(regioncode, lbs_regioncode, int, 0644);=0A=
+=0A=
 =0A=
 #define LBS_TX_PWR_DEFAULT		20	/*100mW */=0A=
 #define LBS_TX_PWR_US_DEFAULT		20	/*100mW */=0A=
@@ -936,9 +939,11 @@=0A=
 	lbs_deb_enter(LBS_DEB_FW);=0A=
 =0A=
 	/*=0A=
-	 * Read MAC address from HW=0A=
+	 * Read MAC address and regioncode etc. from HW=0A=
 	 */=0A=
 	memset(priv->current_addr, 0xff, ETH_ALEN);=0A=
+	if (lbs_regioncode > 0)=0A=
+		priv->regioncode =3D lbs_regioncode;=0A=
 	ret =3D lbs_update_hw_spec(priv);=0A=
 	if (ret) {=0A=
 		ret =3D -1;=0A=
Index: drivers/net/wireless/libertas/cmd.c=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
RCS file: =
/usr/local/cvs/linux/os/linux-2.6/drivers/net/wireless/libertas/cmd.c,v=0A=
retrieving revision 1.1.1.4=0A=
diff -u -r1.1.1.4 cmd.c=0A=
--- drivers/net/wireless/libertas/cmd.c	2 Jun 2008 15:08:37 -0000	1.1.1.4=0A=
+++ drivers/net/wireless/libertas/cmd.c	27 Jun 2008 13:08:19 -0000=0A=
@@ -81,22 +81,34 @@=0A=
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec =
0x%04x\n",=0A=
 		    cmd.hwifversion, cmd.version);=0A=
 =0A=
-	/* Clamp region code to 8-bit since FW spec indicates that it should=0A=
-	 * only ever be 8-bit, even though the field size is 16-bit.  Some =
firmware=0A=
-	 * returns non-zero high 8 bits here.=0A=
-	 */=0A=
-	priv->regioncode =3D le16_to_cpu(cmd.regioncode) & 0xFF;=0A=
-=0A=
-	for (i =3D 0; i < MRVDRV_MAX_REGION_CODE; i++) {=0A=
-		/* use the region code to search for the index */=0A=
-		if (priv->regioncode =3D=3D lbs_region_code_to_index[i])=0A=
-			break;=0A=
+	/* First check if a regioncode already provided */=0A=
+	if (priv->regioncode) {=0A=
+		for (i =3D 0; i < MRVDRV_MAX_REGION_CODE; i++) {=0A=
+			/* use the region code to search for the index */=0A=
+			if (priv->regioncode =3D=3D lbs_region_code_to_index[i])=0A=
+				break;=0A=
+		}=0A=
+	} else {=0A=
+		i =3D MRVDRV_MAX_REGION_CODE; /* Check the from from cmd */=0A=
 	}=0A=
+	if (i >=3D MRVDRV_MAX_REGION_CODE) {=0A=
+		/* Clamp region code to 8-bit since FW spec indicates that it should=0A=
+		 * only ever be 8-bit, even though the field size is 16-bit.  Some =
firmware=0A=
+		 * returns non-zero high 8 bits here.=0A=
+		 */=0A=
+=0A=
+		priv->regioncode =3D le16_to_cpu(cmd.regioncode) & 0xFF;=0A=
 =0A=
+		for (i =3D 0; i < MRVDRV_MAX_REGION_CODE; i++) {=0A=
+			/* use the region code to search for the index */=0A=
+			if (priv->regioncode =3D=3D lbs_region_code_to_index[i])=0A=
+				break;=0A=
+		}=0A=
+	}=0A=
 	/* if it's unidentified region code, use the default (USA) */=0A=
 	if (i >=3D MRVDRV_MAX_REGION_CODE) {=0A=
+		lbs_pr_info("unidentified region code 0x%02x; using the default =
(USA)\n", priv->regioncode);=0A=
 		priv->regioncode =3D 0x10;=0A=
-		lbs_pr_info("unidentified region code; using the default (USA)\n");=0A=
 	}=0A=
 =0A=
 	if (priv->current_addr[0] =3D=3D 0xff)=0A=

------=_NextPart_000_0543_01C8DA8C.74AF47E0--

