Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49092 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbCWSDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 14:03:41 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] hs20-ca:  Update key generation scripts and files.
Date: Mon, 23 Mar 2015 14:03:37 -0400
Message-Id: <1427133818-21480-1-git-send-email-greearb@candelatech.com> (sfid-20150323_190351_247267_DF64583E)
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets us properly over-ride the default w1.fi
related strings in order to properly generate keys
that can be used by the OCSP process.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 hs20/server/ca/openssl.cnf | 12 ++++++------
 hs20/server/ca/setup.sh    | 42 ++++++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/hs20/server/ca/openssl.cnf b/hs20/server/ca/openssl.cnf
index e29e737..c614479 100644
--- a/hs20/server/ca/openssl.cnf
+++ b/hs20/server/ca/openssl.cnf
@@ -95,7 +95,7 @@ localityName			= Locality Name (eg, city)
 localityName_default		= Tuusula
 
 0.organizationName		= Organization Name (eg, company)
-0.organizationName_default	= w1.fi
+0.organizationName_default	= @DOMAIN@
 
 ##organizationalUnitName		= Organizational Unit Name (eg, section)
 #organizationalUnitName_default	=
@@ -117,10 +117,10 @@ subjectKeyIdentifier=hash
 authorityKeyIdentifier=keyid:always,issuer
 basicConstraints = critical, CA:true, pathlen:0
 keyUsage = critical, cRLSign, keyCertSign
-authorityInfoAccess = OCSP;URI:http://osu.w1.fi:8888/
+authorityInfoAccess = OCSP;URI:@OCSP_URI@
 # For SP intermediate CA
 #subjectAltName=critical,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:engExample OSU
-#nameConstraints=permitted;DNS:.w1.fi
+#nameConstraints=permitted;DNS:.@DOMAIN@
 #1.3.6.1.5.5.7.1.12=ASN1:SEQUENCE:LogotypeExtn
 
 [ v3_osu_server ]
@@ -159,7 +159,7 @@ algorithm=OID:sha256
 [sha1_alg]
 algorithm=OID:sha1
 [URI]
-uri=IA5STRING:http://osu.w1.fi/w1fi_logo.png
+uri=IA5STRING:@LOGO_URI@
 [LogotypeImageInfo]
 # default value color(1), component optional
 #type=IMP:0,INTEGER:1
@@ -184,7 +184,7 @@ extendedKeyUsage = OCSPSigning
 basicConstraints=CA:FALSE
 subjectKeyIdentifier=hash
 authorityKeyIdentifier=keyid,issuer
-authorityInfoAccess = OCSP;URI:http://osu.w1.fi:8888/
+authorityInfoAccess = OCSP;@OCSP_URI@
 #@ALTNAME@
 extendedKeyUsage = clientAuth
 
@@ -194,7 +194,7 @@ extendedKeyUsage = clientAuth
 basicConstraints=critical, CA:FALSE
 subjectKeyIdentifier=hash
 authorityKeyIdentifier=keyid,issuer
-authorityInfoAccess = OCSP;URI:http://osu.w1.fi:8888/
+authorityInfoAccess = OCSP;URI:@OCSP_URI@
 #@ALTNAME@
 extendedKeyUsage = critical, serverAuth
 keyUsage = critical, keyEncipherment
diff --git a/hs20/server/ca/setup.sh b/hs20/server/ca/setup.sh
index fcf24ad..35d32b1 100755
--- a/hs20/server/ca/setup.sh
+++ b/hs20/server/ca/setup.sh
@@ -5,41 +5,52 @@ if [ -z "$OPENSSL" ]; then
 fi
 export OPENSSL_CONF=$PWD/openssl.cnf
 PASS=whatever
-CNI="w1.fi Hotspot 2.0 Intermediate CA"
+if [ -z "$DOMAIN" ]; then
+    DOMAIN=w1.fi
+fi
+CNI="$DOMAIN Hotspot 2.0 Intermediate CA"
 CNR="Hotspot 2.0 Trust Root CA - 99"
-CNO="ocsp.w1.fi"
-CNV="osu-revoked.w1.fi"
-CNOC="osu-client.w1.fi"
-SERVERNAME="osu.w1.fi"
+CNO="ocsp.$DOMAIN"
+CNV="osu-revoked.$DOMAIN"
+CNOC="osu-client.$DOMAIN"
+SERVERNAME="osu.$DOMAIN"
 DNS=$SERVERNAME
 DEBUG=0
+OCSP_URI="http://$CNO:8888/"
+LOGO_URI="http://osu.w1.fi/w1fi_logo.png"
 
 # Command line over-rides
 USAGE=$( cat <<EOF
 Usage:\n
 # -C:  SSL Commonname for Root CA ($CNR)\n
 # -d:  DNS Name ($DNS)\n
-# -D:  Enable debugging (set -x, etc)
+# -D:  Enable debugging (set -x, etc)\n
+# -h:  Show this help message\n
 # -I:  SSL Commonname for Intermediate CA ($CNI)\n
+# -m:  Domain ($DOMAIN)\n
 # -o:  SSL Commonname for OSU-Client Server ($CNOC)\n
 # -O:  SSL Commonname for OCSP Server ($CNO)\n
 # -p:  password ($PASS)\n
 # -S:  servername ($SERVERNAME)\n
+# -u:  OCSP-URI ($OCSP_URI)\n
 # -V:  SSL Commonname for OSU-Revoked Server ($CNV)\n
 EOF
 )
 
-while getopts "C:d:DI:o:O:p:S:V:" flag
+while getopts "C:d:DI:m:o:O:p:S:u:V:h" flag
   do
   case $flag in
       C) CNR=$OPTARG;;
       d) DNS=$OPTARG;;
       D) DEBUG=1;;
+      h) echo -e $USAGE; exit 0;;
       I) CNI=$OPTARG;;
+      m) DOMAIN=$OPTARG;;
       o) CNOC=$OPTARG;;
       O) CNO=$OPTARG;;
       p) PASS=$OPTARG;;
       S) SERVERNAME=$OPTARG;;
+      u) OCSP_URI=$OPTARG;;
       V) CNV=$OPTARG;;
       *) echo "Un-known flag: $flag"; echo -e $USAGE;exit 1;;
   esac
@@ -74,10 +85,17 @@ else
     cp openssl.cnf.orig openssl.cnf
 fi
 
-# Set the password accordingly.
-cat openssl-root.cnf | sed "s/@PASSWORD@/$PASS/" > openssl-root.cnf.tmp
+# Set the password and some other common config accordingly.
+cat openssl-root.cnf | sed "s/@PASSWORD@/$PASS/" \
+ > openssl-root.cnf.tmp
 mv openssl-root.cnf.tmp openssl-root.cnf
-cat openssl.cnf | sed "s/@PASSWORD@/$PASS/" > openssl.cnf.tmp
+
+set -x
+cat openssl.cnf | sed "s/@PASSWORD@/$PASS/" |
+sed "s,@OCSP_URI@,$OCSP_URI," |
+sed "s,@LOGO_URI@,$LOGO_URI," |
+sed "s/@DOMAIN@/$DOMAIN/" \
+ > openssl.cnf.tmp
 mv openssl.cnf.tmp openssl.cnf
 
 
@@ -155,8 +173,8 @@ echo "---[ Server ]-----------------------------------------------------------"
 echo
 
 ALT="DNS:$DNS"
-ALT="$ALT,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:engw1.fi TESTING USE"
-ALT="$ALT,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:finw1.fi TESTIKÄYTTÖ"
+ALT="$ALT,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:eng$DOMAIN TESTING USE"
+ALT="$ALT,otherName:1.3.6.1.4.1.40808.1.1.1;UTF8String:fin$DOMAIN TESTIKÄYTTÖ"
 
 cat openssl.cnf |
 	sed "s/#@CN@/commonName_default = $SERVERNAME/" |
-- 
1.9.3

