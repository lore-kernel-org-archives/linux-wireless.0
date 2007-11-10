Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:38264 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXKJTti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 14:49:38 -0500
Received: by fk-out-0910.google.com with SMTP id z23so954814fkz
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2007 11:49:36 -0800 (PST)
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: Remove unnecessary code in iwl3945 and iwl4965 drivers
Date: Sat, 10 Nov 2007 20:49:32 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200711102049.32921.mboton.lkml@gmail.com> (sfid-20071110_194944_024961_6E64A1A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecesary code in iwl3945 and iwl4965 drivers.

"final_mode" variable is already initialized with the value of the "mod=
e" variable.

Signed-off-by: Miguel Boton <mboton@gmail.com>

Index: linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl3945-base.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24-rc2.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2377,9 +2377,6 @@
 	case IWL_POWER_AC:
 		final_mode =3D IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode =3D mode;
-		break;
 	}
=20
 	iwl_update_power_cmd(priv, &cmd, final_mode);
Index: linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl4965-base.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.24-rc2.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ linux-2.6.24-rc2/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2233,9 +2233,6 @@
 	case IWL_POWER_AC:
 		final_mode =3D IWL_POWER_MODE_CAM;
 		break;
-	default:
-		final_mode =3D mode;
-		break;
 	}
=20
 	cmd.keep_alive_beacons =3D 0;

--=20
	Miguel Bot=F3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
