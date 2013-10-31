Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:55478 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3JaPHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 11:07:43 -0400
Received: by mail-we0-f181.google.com with SMTP id t60so2795914wes.40
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 08:07:42 -0700 (PDT)
Message-ID: <5272723B.4090006@gmail.com> (sfid-20131031_160747_350939_AFACB8F8)
Date: Thu, 31 Oct 2013 16:07:39 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: wireless-regdb@lists.infradead.org
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/7] wireless-regdb: optimize two of ES's rules
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luis,

This patch is incompatible with my ("pending")patch:
http://lists.infradead.org/pipermail/wireless-regdb/2013-February/000136.html

thanks,

---cortamorena---
Subject: [PATCH] wireless-regdb: change Max_EIRP in 5150-5250 for ES (Spain)

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
---end---

