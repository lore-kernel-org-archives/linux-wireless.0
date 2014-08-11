Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35013 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHKNaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 09:30:17 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so8568339wgh.20
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 06:30:16 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH try2] wireless-regdb: change to 200mW Max_EIRP in 5150-5250 for ES (Spain)
Date: Mon, 11 Aug 2014 15:29:55 +0200
Message-Id: <1407763795-8571-1-git-send-email-xose.vazquez@gmail.com> (sfid-20140811_153022_789988_D3B5A182)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

http://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-4845
http://www.boe.es/boe/dias/2013/05/09/pdfs/BOE-A-2013-4845.pdf

--cut--
UN – 128 RLANs en 5 GHz

[...]
Banda 5150 – 5350 MHz: En esta banda el uso por el servicio móvil en sistemas de
acceso inalámbrico incluyendo comunicaciones electrónicas y redes de área local, se
restringe para su utilización únicamente en el interior de recintos. La potencia isotrópica
radiada equivalente máxima será de 200 mW (p.i.r.e.), siendo la densidad máxima de
p.i.r.e. media de 10 mW/MHz en cualquier banda de 1 MHz. Este valor se refiere a la
potencia promediada sobre una ráfaga de transmisión ajustada a la máxima potencia.

Adicionalmente, en la banda 5250-5350 MHz el transmisor deberá emplear técnicas de
control de potencia (TPC) que permitan como mínimo un factor de reducción de 3 dB de la
potencia de salida. En caso de no usar estas técnicas, la potencia isotrópica radiada
equivalente máxima deberá ser de 100 mW (p.i.r.e). Resto de características técnicas han
de ajustarse a las indicadas en la Decisión de la CEPT ECC/DEC(04)08.
Estas utilizaciones son de uso común, por lo que no se garantiza la protección frente a
otros servicios legalmente autorizados ni puede causar perturbaciones a los mismos.
[...]
--end--

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Luis R. Rodriguez <mcgrof@frijolero.org>
Cc: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 3d15930..92573d1 100644
--- a/db.txt
+++ b/db.txt
@@ -316,9 +316,16 @@ country EG: DFS-ETSI
 	(5170 - 5250 @ 80), (20)
 	(5250 - 5330 @ 80), (20), DFS
 
+# Orden IET/787/2013, de 25 de abril, por la que se aprueba
+# el cuadro nacional de atribución de frecuencias.
+# http://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-4845
+#
+# more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
+# http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
+
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
-	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 80), (500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
-- 
1.9.3

