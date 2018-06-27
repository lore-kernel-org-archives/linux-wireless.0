Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:39372 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965734AbeF0UrF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 16:47:05 -0400
Received: by mail-ot0-f193.google.com with SMTP id l15-v6so3680668oth.6
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2018 13:47:05 -0700 (PDT)
MIME-Version: 1.0
From: bkil <bkil.hu+Aq@gmail.com>
Date: Wed, 27 Jun 2018 22:46:44 +0200
Message-ID: <CAPuHQ=Hix9aSE77EHAwEzrc10==BT3KNv3-CqR0ehRwLNrH_2w@mail.gmail.com> (sfid-20180627_224709_666558_62A334D2)
Subject: [PATCH] wireless-regdb: update HU rules for 2400-2483.5, 5150-5725, 5725-5875MHz
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* 2400-2483.5M: extend bounds
* 5150-5350M: extend bounds, restrict to NO-OUTDOOR
* 5470-5725M: extend bounds
* 5725-5875M: introduce, as EU SRD provisions have been implemented

Freely available online references have been added hosted by the regulatory
body in Hungary, the National Media and Infocommunications Authority.

To refer to a specific section, you can grep for the frequency in question.

Translation key:
"Csak belt=C3=A9ri" / "=C3=89p=C3=BCleten bel=C3=BCli haszn=C3=A1latra korl=
=C3=A1tozott" =3D indoor only;
"K=C3=BClt=C3=A9ri =C3=A9s belt=C3=A9ri" =3D both indoor and outdoor;
"Nem m=C5=B1k=C3=B6d=C5=91 TPC eset=C3=A9n a maxim=C3=A1lis teljes=C3=ADtm=
=C3=A9nyjellemz=C5=91k 3 dB-lel
cs=C3=B6kkennek." =3D reduce max power specs by 3dB in case of no TPC.

Signed-off-by: bkil <b.K.il.h.u+tigbuh@gmail.com>
---
 db.txt | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index 8963c01..7bc62c6 100644
--- a/db.txt
+++ b/db.txt
@@ -581,12 +581,23 @@ country HT: DFS-FCC
  (5490 - 5730 @ 160), (24), DFS
  (5735 - 5835 @ 80), (30)

+# http://stir.nmhh.hu/?oldal=3DdokumentumGeneralo&root_rendeletelem_id=3D3=
&hatalyos=3D1
+# http://english.nmhh.hu/cikk/297/Eljarasi_tajekoztato_a_24_GHzes_es_az_5_=
GHzes_savban_mukodo_berendezesek_engedelyezeserol
+# http://nmhh.hu/dokumentum/319/kis_hatotavolsagu_eszkozok_srdk.pdf
 country HU: DFS-ETSI
- (2402 - 2482 @ 40), (20)
- (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=3DETSI
- (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=3DETSI
- (5490 - 5710 @ 160), (27), DFS, wmmrule=3DETSI
- # 60 GHz band channels 1-4, ref: Etsi En 302 567
+ # ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 300 328
+ # additionally: 100mW @ 10MHz channels, 50mW @ 5MHz (max. 10mW/MHz)
+ (2400 - 2483.5 @ 40), (20)
+ # ref: 2005/513/EK
+ # note: TPC not needed @ 5150-5250
+ (5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=3DETSI
+ # note: max would be +3dB with TPC @ 5250-5725
+ (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=3DETSI
+ (5470 - 5725 @ 160), (27), DFS, wmmrule=3DETSI
+ # ref: Short Range Devices (SRD) - 2006/771/EK, (EU) 2017/1483, MSZ
EN 300 440, MSZ EN 302 064
+ (5725 - 5875 @ 80), (25 mW)
+ # 60 GHz band channels 1-4
+ # ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 302 567
  (57000 - 66000 @ 2160), (40)

 country ID: DFS-JP
--=20
2.7.4
