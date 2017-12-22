Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdLVGDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:15 -0500
Received: from mail-it0-f69.google.com ([209.85.214.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQM-0002eY-En
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:14 +0000
Received: by mail-it0-f69.google.com with SMTP id p144so9668079itc.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:14 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/6] wireless-regdb: Better support for generating public certificates
Date: Fri, 22 Dec 2017 00:03:01 -0600
Message-Id: <20171222060303.14478-5-seth.forshee@canonical.com> (sfid-20171222_070347_501251_879EB8B2)
In-Reply-To: <20171222060303.14478-1-seth.forshee@canonical.com>
References: <20171222060303.14478-1-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current makefile rule for the public certificate calls for an
openssl config file which is not provided. Let's put the pubcert
generation into a script named gen-pubcert.sh and embed the
openssl configuration file there.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile       |  4 +---
 gen-pubcert.sh | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100755 gen-pubcert.sh

diff --git a/Makefile b/Makefile
index 9532c29a1dc2..044251f64785 100644
--- a/Makefile
+++ b/Makefile
@@ -79,9 +79,7 @@ $(REGDB_PUBKEY): $(REGDB_PRIVKEY)
 
 $(REGDB_PUBCERT): $(REGDB_PRIVKEY)
 	@echo "Generating certificate for $(REGDB_AUTHOR)..."
-	@openssl req -config regulatory.openssl.conf \
-		-key $(REGDB_PRIVKEY) -days 36500 -utf8 -nodes -batch \
-		-x509 -outform PEM -out $(REGDB_PUBCERT)
+	./gen-pubcert.sh $(REGDB_PRIVKEY) $(REGDB_PUBCERT)
 	@echo $(REGDB_PUBKEY) > .custom
 
 
diff --git a/gen-pubcert.sh b/gen-pubcert.sh
new file mode 100755
index 000000000000..1a4d57999e5d
--- /dev/null
+++ b/gen-pubcert.sh
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+if [[ $# -ne 2 ]]; then
+	echo "Usage: $0 priv-key out-file"
+	exit 1
+fi
+
+openssl req -new -key "$1" -days 36500 -utf8 -nodes -batch \
+	-x509 -outform PEM -out "$2" \
+	-config <(cat <<-EOF
+		[ req ]
+		distinguished_name = req_distinguished_name
+		string_mask = utf8only
+		prompt = no
+		[ req_distinguished_name ]
+		commonName = sforshee
+		EOF
+	)
-- 
2.14.1
