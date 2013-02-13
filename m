Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57827 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310Ab3BMXxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:53:33 -0500
Received: by mail-wg0-f48.google.com with SMTP id 16so1447843wgi.27
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 15:53:32 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: change Max_EIRP in 5150-5250 for ES (Spain)
Date: Thu, 14 Feb 2013 00:52:53 +0100
Message-Id: <1360799573-4665-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130214_005341_862499_43C7EBD0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did cut&paste from DE rules, but DE lowers the limit
in 5150-5250 to 100mW for "neighborhood reasons" [1].
Even when 200mW is completely legal in DE.

put 200mW, as Spanish law says:

Banda 5150 – 5350 MHz: En esta banda el uso por el servicio móvil en sistemas de
acceso inalámbrico incluyendo comunicaciones electrónicas y redes de área local, se
restringe para su utilización únicamente en el interior de recintos. La potencia isotrópica
radiada equivalente máxima será de 200 mW (p.i.r.e.), siendo la densidad máxima de
p.i.r.e. media de 10 mW/MHz en cualquier banda de 1 MHz. Este valor se refiere a la
potencia promediada sobre una ráfaga de transmisión ajustada a la máxima potencia

Orden ITC/332/2010, de 12 de febrero, por la que se aprueba el cuadro
nacional de atribución de frecuencias (CNAF):
https://www.boe.es/diario_boe/txt.php?id=BOE-A-2010-2719
https://www.boe.es/boe/dias/2010/02/19/pdfs/BOE-A-2010-2719.pdf

search for:
 UN - 85 RLANs y datos en 2400 a 2483,5 MHz (pag. 213)
 UN - 128 RLANs en 5 GHz (pag. 232)

more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx

[1] http://marc.info/?l=linux-wireless&m=127429049514439

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Luis R. Rodriguez <mcgrof@frijolero.org>
Cc: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index c5861b8..6f618c0 100644
--- a/db.txt
+++ b/db.txt
@@ -269,7 +269,7 @@ country EG:
 
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
-	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
+	(5150 - 5250 @ 40), (N/A, 200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-- 
1.7.11.7

