Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:40315 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab1KVOU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 09:20:26 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Robert =?utf-8?Q?Gr=C3=B8nning?= <slimg@iggu.org>
Subject: wireless-regdb: Update regulatory rules for Norway (NO)
Date: Tue, 22 Nov 2011 15:13:22 +0100
Message-ID: <87pqgkxn25.fsf@nemi.mork.no> (sfid-20111122_152030_577822_7DD9EBC5)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

As mentioned by Robert Gr=C3=B8nning <slimg at iggu.org> in June, Norway do=
es
allow a few more bands than what's currently in the database.  In
particular, the old ISM band at 5725 - 5875 MHz is and has "always" been
allowed.

The regulations [1] have some weird restrictions wrt power densities etc
which I have no idea how to describe in a format suitable for the db.
I've tried my best to make sure the entries are within the rules.

The regulations also allow up to 1 W eirp in the band 5470 - 5725 MHz,
and up to 4 W eirp in the bands 5725 - 5795 MHz and 5815 - 5850 MHz if
TPC is in use. The limits are reduced by 3dB without TPC.  As I don't
know how to express the TPC requirement, I've chosen to put the reduced
limits (500 mW and 2 W) in the db entries.  This also matches the German
(DE) entry for 5470 - 5725 MHz, so I guess it must make some sense...

I also have no idea which SI prefixes you allow in the database, so I've
used whatever was in the regulations.  Please adjust as needed if only
mW or dB is acceptable.  Or let me know and I'll provide an updated patch.


Patch attached.




References:

[1] Current Norwegian regulations:
  http://www.lovdata.no/cgi-wift/ldles?doc=3D/sf/sf/sf-20090602-0580.html

[2] The Norwegian Post and Telecommunications Authority provides an unoffic=
ial english translation of these regulations:
  http://www.npt.no/ikbViewer/Content/103810/Regulations_concerning_general=
_authorisations_for_the_use_of_radio_frequencies.pdf


[3] Appendix 1 of ERC/REC 70-03 provides generic information about licensing
  status for Short Range Devices (SRD) in most CEPT countries:
  http://www.ecodocdb.dk/doks/filedownload.aspx?fileid=3D1694&fileurl=3Dhtt=
p://www.erodocdb.dk/Docs/doc98/official/pdf/REC7003E.PDF




Bj=C3=B8rn

--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline; filename=no-db.diff
Content-Transfer-Encoding: quoted-printable

diff --git a/db.txt b/db.txt
index e63a43e..375187f 100644
--- a/db.txt
+++ b/db.txt
@@ -469,11 +469,20 @@ country NL:
 	(5250 - 5330 @ 40), (N/A, 20), DFS
 	(5490 - 5710 @ 40), (N/A, 27), DFS
=20
+# Data from http://www.lovdata.no/cgi-wift/ldles?doc=3D/sf/sf/sf-20090602-=
0580.html
 country NO:
-	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	# =C2=A7 7 (2)
+	(2400 - 2483.5 @ 40), (N/A, 100 mW)
+	# =C2=A7 7 (3)
+	(5150 - 5350 @ 40), (N/A, 200 mW)
+	# =C2=A7 7 (4)
+	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+	# =C2=A7 7 (5)
+	(5725 - 5795 @ 40), (N/A, 2 W), DFS
+	(5815 - 5850 @ 40), (N/A, 2 W), DFS
+	# =C2=A7 7 (6)
+	(5725 - 5795 @ 40), (23, 1 W), DFS, PTP-ONLY
+	(5815 - 5850 @ 40), (23, 1 W), DFS, PTP-ONLY
=20
 country NP:
 	(2402 - 2482 @ 40), (N/A, 20)

--=-=-=--
