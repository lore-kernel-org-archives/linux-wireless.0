Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36223 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731174AbeGYX0o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 19:26:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9-v6so8803576wro.3
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2018 15:13:02 -0700 (PDT)
From: bkil <b.K.il.h.u+tigbuh@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3] wireless-regdb: update rules for Hungary (HU) on 2.4/5/60G, 5725-5875MHz
Date: Thu, 26 Jul 2018 00:12:53 +0200
Message-Id: <8307609c48bf9a1755c5933e186dc8938cb6dc79.1532556773.git.b.K.il.h.u+tigbuh@gmail.com> (sfid-20180726_001306_094616_C2C8845C)
In-Reply-To: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
References: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* 2400-2483.5M: extend bounds
* 5150-5250M: extend bounds, add NO-OUTDOOR, no TPC so +3dB
* 5250-5350M: extend bounds, add NO-OUTDOOR
* 5470-5725M: extend bounds
* 5725-5875M: introduce, as EU SRD provisions have been implemented
* 57-66G: add NO-OUTDOOR

Freely available online references have been added hosted by the regulatory
body in Hungary, the National Media and Infocommunications Authority.

To refer to a specific section, you can grep for the frequency in question.

Translation key:
"Csak belt=C3=A9ri" / "=C3=89p=C3=BCleten bel=C3=BCli haszn=C3=A1latra korl=
=C3=A1tozott" =3D indoor only;
"K=C3=BClt=C3=A9ri =C3=A9s belt=C3=A9ri" =3D both indoor and outdoor;
"Nem m=C5=B1k=C3=B6d=C5=91 TPC eset=C3=A9n a maxim=C3=A1lis teljes=C3=ADtm=
=C3=A9nyjellemz=C5=91k 3 dB-lel
cs=C3=B6kkennek." =3D reduce max power specs by 3dB in case of no TPC;
"R=C3=B6gz=C3=ADtett k=C3=BClt=C3=A9ri telep=C3=ADt=C3=A9s nem megengedett"=
 =3D no fixed outdoor install

Signed-off-by: bkil <b.K.il.h.u+tigbuh@gmail.com>
---
 db.txt | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 8963c01..8cf7dee 100644
--- a/db.txt
+++ b/db.txt
@@ -581,13 +581,25 @@ country HT: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
=20
+# http://stir.nmhh.hu/?oldal=3DdokumentumGeneralo&root_rendeletelem_id=3D3=
&hatalyos=3D1
+# http://english.nmhh.hu/cikk/297/Eljarasi_tajekoztato_a_24_GHzes_es_az_5_=
GHzes_savban_mukodo_berendezesek_engedelyezeserol
+# http://nmhh.hu/dokumentum/319/kis_hatotavolsagu_eszkozok_srdk.pdf
 country HU: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=3DETSI
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=3DETSI
-	(5490 - 5710 @ 160), (27), DFS, wmmrule=3DETSI
-	# 60 GHz band channels 1-4, ref: Etsi En 302 567
-	(57000 - 66000 @ 2160), (40)
+	# ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 300 328
+	# additionally: 100mW @ 10MHz channels, 50mW @ 5MHz (max. 10mW/MHz)
+	(2400 - 2483.5 @ 40), (20)
+	# ref: 2005/513/EK
+	# note: TPC not needed @ 5150-5250
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=3DETSI
+	# note: max would be +3dB with TPC @ 5250-5725
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=3DETSI
+	(5470 - 5725 @ 160), (27), DFS, wmmrule=3DETSI
+	# "Short Range Devices (SRD)"
+	# ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 300 440, MSZ EN 302 064
+	(5725 - 5875 @ 80), (25 mW)
+	# 60 GHz band channels 1-4, "Fixed outdoor installation not allowed"
+	# ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 302 567
+	(57000 - 66000 @ 2160), (40), NO-OUTDOOR
=20
 country ID: DFS-JP
 	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/b=
wa%205,8%20ghz.pdf
