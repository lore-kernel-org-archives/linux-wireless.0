Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46250 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaLETbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 14:31:01 -0500
Received: by mail-ob0-f174.google.com with SMTP id nt9so1112404obb.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2014 11:31:01 -0800 (PST)
Date: Fri, 5 Dec 2014 13:30:39 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] crda: Trust regulatory.bin from Seth Forshee
Message-ID: <20141205193039.GB53560@ubuntu-hedt> (sfid-20141205_203106_613133_72D2D1D5)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have taken over maintenance of the regulatory database from
linville. Add my key so that regulatory.bin files signed by me
will be trusted, but also keep John's key so that existing files
will continue to be trusted. Update the makefile to point to the
new wireless-regdb repository location, and update the readme and
man page to reflect the change in maintainership.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile                     |  2 +-
 README                       | 16 +++++++++-------
 crda.8                       |  6 ++++--
 pubkeys/sforshee.key.pub.pem |  9 +++++++++
 4 files changed, 23 insertions(+), 10 deletions(-)
 create mode 100644 pubkeys/sforshee.key.pub.pem

diff --git a/Makefile b/Makefile
index 1f25509..a3ead30 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # Modify as you see fit, note this is built into crda,
 # so if you change it here you will have to change crda.c
 REG_BIN?=3D/usr/lib/crda/regulatory.bin
-REG_GIT?=3Dgit://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless=
-regdb.git
+REG_GIT?=3Dgit://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless=
-regdb.git
=20
 PREFIX ?=3D /usr/
 MANDIR ?=3D $(PREFIX)/share/man/
diff --git a/README b/README
index f3ead48..5d89b83 100644
--- a/README
+++ b/README
@@ -23,12 +23,13 @@ The package build requirements currently are:
  * libgcrypt or libssl (openssl) header files
  * nl library and header files (libnl1 and libnl-dev)
    available at git://git.kernel.org/pub/scm/libs/netlink/libnl.git
- * RSA public key of John Linville, we include this as part of this package
-   so you do not need to install it. This RSA public key comes
-   from the wireless-regdb.git tree and we keep it up to date here.
+ * RSA public key of John Linville and Seth Forshee, we include these
+   as part of this package so you do not need to install it. The RSA
+   public keys comes from the wireless-regdb.git tree and we keep them
+   up to date here.
  * regulatory database, clone this tree:
=20
-   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.g=
it
+   git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.g=
it
=20
    and then stuff regulatory.bin (no need to build) provided there in
    REG_BIN location specified in this Makefile. This regulatory.bin file
@@ -62,13 +63,14 @@ user reboots or all the wireless modules get unloaded a=
nd reloaded.
=20
 Under certain circumstances it may be desirable to have the regulatory
 agent accept multiple keys, this can be achieved by stuffing all the keys
-desired into pubkeys. Right now we only use John Linville's public key.
+desired into pubkeys. Right now we use John Linville's and Seth Forshee's
+public keys.
=20
  REGDB AUTHORS
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-Authors of regulatory.bin (John Linville) first need a private key, which =
can
-be generated with something like this:
+Authors of regulatory.bin first need a private key, which can be generated
+with something like this:
=20
 	openssl genrsa -out your.key.priv.pem 2048
=20
diff --git a/crda.8 b/crda.8
index d45af30..d934228 100644
--- a/crda.8
+++ b/crda.8
@@ -49,11 +49,13 @@ files. Authorship is respected by the RSA public key pa=
cked into
 .I This
 specific
 .B crda
-package has been built with an RSA public key from
+package has been built with RSA public keys from
 .I John Linville (the Linux wireless kernel maintainer)
+and
+.I Seth Forshee (the wireless regulatory databse maintainer)
 and as such will only read
 .B regulatory.bin
-files signed by him. For further information see the
+files signed by one of them. For further information see the
 .B regulatory.bin
 man page.
=20
diff --git a/pubkeys/sforshee.key.pub.pem b/pubkeys/sforshee.key.pub.pem
new file mode 100644
index 0000000..73d580e
--- /dev/null
+++ b/pubkeys/sforshee.key.pub.pem
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
--=20
1.9.1

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUggffAAoJEKtIAKYtufc65+QQAIsLYN+NGzfMYW7Y9d85O+X3
n8FxBo4NkFPVaeI4K6zglGxvlUQ9Ct8NrqnyFk2dL6qH0LBlKb36XDkbqoygg6WJ
YuM/+gxT4fScOLKpUsLdmSRZE5Y4XwbbGOOa/MxLgPUo1NlN1aKkrPpR0hUtErg+
MEK1vC3Uy8bhYOF9cpiGEh6lgG1/h+z/R7EKXd6vrNfo16DIksbhw8TM+2mGJWga
ZMrwu3qXiXbpw1yUi49RqcL6Cq4hPfg33k/kAh0N4Rcy3F6y4d2Z9mDQkKI9Q0Lu
nEgUUSaZxIYyoT0eqZeauKEuNWom6jE7q1bTYQvAoaa1o4sy2BVGl9CD8QFF5DRn
HhviTHpQFEHbE6/h8o6KHUUm+9e2qJ9/vsjJ4wWbtZs4usWYcAMTt3cYMNovzJHC
mThOvMYDkrUDj1+lvTVmOP6IMEvdBfu2CnFtbdyFDt4oRrhKqllDC9nse7D3XhbZ
EZJNViqL+X+MXUlIsRD6pBWqkxocRwQYmX76JEYqpkP5L/5Nr35iZazSReX9CRjp
PlWWV6AxRHtdZObDos3x+IlNqod4Zt5tOg02ziDxW81VsVBkpjBUKW47HmfJQ9Sa
OVQJDe2lilAcsWWLbjkkb5QGPXputY7EiLtv8YNvbWKGyBS4mdp8PAfOit4t9xgB
5cop8kG7uaTPfxWeuIPG
=rG5V
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
