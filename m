Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:53778 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaLEQbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 11:31:35 -0500
Received: by mail-oi0-f46.google.com with SMTP id h136so673559oig.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2014 08:31:35 -0800 (PST)
Date: Fri, 5 Dec 2014 10:31:34 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Update keys and maintainer information
Message-ID: <20141205163134.GC13629@ubuntu-mba51> (sfid-20141205_173140_379774_E746DADD)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

As announced by John [1], I'm taking over maintaintership of the
wireless regulatory databse. Make it official by adding my key,
removing John's, and updating the Makefile and documentation to
reflect the change in maintainer.

[1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/131573

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile               | 3 +--
 debian-example/control | 2 +-
 linville.key.pub.pem   | 9 ---------
 sforshee.key.pub.pem   | 9 +++++++++
 wireless-regdb.spec    | 2 +-
 5 files changed, 12 insertions(+), 13 deletions(-)
 delete mode 100644 linville.key.pub.pem
 create mode 100644 sforshee.key.pub.pem

diff --git a/Makefile b/Makefile
index 3d5040d..907ff28 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,7 @@ REGDB_AUTHOR ?=3D $(shell if [ -f $(DISTRO_PRIVKEY) ]; th=
en \
 REGDB_PRIVKEY ?=3D ~/.wireless-regdb-$(REGDB_AUTHOR).key.priv.pem
 REGDB_PUBKEY ?=3D $(REGDB_AUTHOR).key.pub.pem
=20
-REGDB_UPSTREAM_PUBKEY ?=3D linville.key.pub.pem
+REGDB_UPSTREAM_PUBKEY ?=3D sforshee.key.pub.pem
=20
 REGDB_CHANGED =3D $(shell $(SHA1SUM) -c --status sha1sum.txt >/dev/null 2>=
&1; \
         if [ $$? -ne 0 ]; then \
@@ -103,7 +103,6 @@ install: regulatory.bin.5.gz
 	if [ -f .custom ]; then \
 		install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(shell cat .custom); \
 	fi
-	@# In linville we trust
 	install -m 644 -t $(DESTDIR)/$(CRDA_KEY_PATH)/ $(REGDB_UPSTREAM_PUBKEY)
 	install -m 644 -t $(DESTDIR)/$(CRDA_PATH)/ regulatory.bin
 	install -m 755 -d $(DESTDIR)/$(MANDIR)/man5/
diff --git a/debian-example/control b/debian-example/control
index a5b518b..e6e7161 100644
--- a/debian-example/control
+++ b/debian-example/control
@@ -12,4 +12,4 @@ Suggests: crda
 Description: The Linux wireless regulatory database
  This package contains the wireless regulatory database used by all
  cfg80211 based Linux wireless drivers. The wireless database being
- used is maintained by John Linville, the Linux wireless kernel maintainer.
+ used is maintained by Seth Forshee.
diff --git a/linville.key.pub.pem b/linville.key.pub.pem
deleted file mode 100644
index 3a2e8d0..0000000
--- a/linville.key.pub.pem
+++ /dev/null
@@ -1,9 +0,0 @@
------BEGIN PUBLIC KEY-----
-MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1leZcYjTXc4qLq1oN2Ak
-8vLP85P5cFTrCpqdSI5W4VOwdaJB4TtaxU2fATcH/A2EsE3h1rOfzI0+fBV9DcOO
-qyID+zdILBMb8xK5Zv+78OkBGls/WzvDDVhdmn1TRHvRvmJy7cX1mCT56cnHrZM/
-ZBaFwVfiD9TcqqisyF1sqE5+cMHTWRbxc1+rtojr0eGYrNfK20awlD5KVj6Ejzot
-r9EDWAsL1bH/kGfMdnputcyMapLQpRVruO/jEdjSmhAE/sj1tmHcAXBT6j5al4Oa
-LiBaWnP++rune7rjimwfzp0549/rupQUM7nAZRDLyzXj3J/KEci6dXtjonBUFqDY
-4QIDAQAB
------END PUBLIC KEY-----
diff --git a/sforshee.key.pub.pem b/sforshee.key.pub.pem
new file mode 100644
index 0000000..73d580e
--- /dev/null
+++ b/sforshee.key.pub.pem
@@ -0,0 +1,9 @@
+-----BEGIN PUBLIC KEY-----
+MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtUDjnCiEOQPyOddmLEE4
+Fax+pYNxJX6QfGjdbz/Z11k4n3xqUsIDKi1+ZvQesxJwIFvUlzI9cYs7GwgXFGth
+xFeLlhYc/STVCwn5aBGE+8pRDNFFGdoQRIrZ/nap/WAtGAsolbIt6oiYuNFWIfBT
+H/ECb+lGm5NfKJAPrDb6aCNxV1b2zNPffSrZG3NF67onhe96f6XLgMcwNtJT7uys
+Hucx8TainGPGZVt/JXVooerTfgBcml7YIBgydwcpEmYeNnPnlwRBN7Gxciv0oSkg
+fJZ5CyvQ2N7IbD+T+8XueFIRFRt69uJomef7RhaE48eh5uDSRtXhxF+gZvTaxP+V
+HQIDAQAB
+-----END PUBLIC KEY-----
diff --git a/wireless-regdb.spec b/wireless-regdb.spec
index b76d391..bb648ca 100644
--- a/wireless-regdb.spec
+++ b/wireless-regdb.spec
@@ -16,7 +16,7 @@ BuildArch: noarch
 %description
 This package contains the wireless regulatory database used by all
 cfg80211 based Linux wireless drivers. The wireless database being
-used is maintained by John Linville, the Linux wireless kernel maintainer
+used is maintained by Seth Forshee.
 http://wireless.kernel.org/en/developers/Regulatory/
=20
 %prep
--=20
1.9.1

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUgd3mAAoJEKtIAKYtufc65MMQAKj0uTfsTS8haN//lUqLabJu
XxHGV74u1qQi80wKKYsgkeYSJOyLfuj4XTRougzaicCpNX4lkW6HXn6HNoDmsOIj
pDmKqHJVLgwE2q774Au8jmT1s84tddz/IeOl6olvvGr/k/n5QdycwHNPJexXdsbf
v83zG/rxsPlEbKzOiYwh54ptz53432aT/RELXieq/KnIOkgQzvtGlrHcKmOBYkEb
G0LZZXV2P7Y45Z1KESOChBP5vRdjCEUgclXtNuX2K4qKSFEcnv4pLBhAL0Dll8bo
VzeWk7cANCoY30CdN0tNHDY5SpHmOwM02CCuURw+7ViZpe53fvM2K1j1vx+SNqtg
ZcYQtM/AiMjv/2BuVPmkr6AHc8kBKzzcLmmYnbxArX1kYPP6yOgY2fWoK9mU0Cvt
05G8tQ+K9fd4LUIvcoOg3lPSMIK4WOkuKmShcBGMlBpuD164GK5vArXha6a71AtH
fFcSs6YZk1J4A7A0r1BhtKJZgwf0qI1ksOuCH6VHsUlJJxJYkD9ijM3HT9wlGdiK
6dWatgNNPsjuaUMawJn2HANNIT3hJGJyxpz5f/F7fbAJYVOjYObm2ChgsbB1vZYN
iyWTae7PknZLwSSijq6F7vkZtV8fOUt32XB3T3FTnZ62ZBL5wtDY3pAuIiDg7LfO
Mt5twUO3TYX4m6nAu/KB
=0xOf
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
