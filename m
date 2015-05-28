Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbbE1Pql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:46:41 -0400
Subject: [PATCH 03/20] PKCS#7: Allow detached data to be supplied for
 signature checking purposes [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:46:34 +0100
Message-ID: <20150528154634.1259.89664.stgit@warthog.procyon.org.uk> (sfid-20150528_175319_741155_6A2D5F70)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is possible for a PKCS#7 message to have detached data.  However, to verify
the signatures on a PKCS#7 message, we have to be able to digest the data.
Provide a function to supply that data.  An error is given if the PKCS#7
message included embedded data.

This is used in a subsequent patch to supply the data to module signing where
the signature is in the form of a PKCS#7 message with detached data, whereby
the detached data is the module content that is signed.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   25 +++++++++++++++++++++++++
 include/crypto/pkcs7.h                |    3 +++
 2 files changed, 28 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 42bfc9de0d79..404f89a0f852 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -382,3 +382,28 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 	return enopkg;
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);
+
+/**
+ * pkcs7_supply_detached_data - Supply the data needed to verify a PKCS#7 message
+ * @pkcs7: The PKCS#7 message
+ * @data: The data to be verified
+ * @datalen: The amount of data
+ *
+ * Supply the detached data needed to verify a PKCS#7 message.  Note that no
+ * attempt to retain/pin the data is made.  That is left to the caller.  The
+ * data will not be modified by pkcs7_verify() and will not be freed when the
+ * PKCS#7 message is freed.
+ *
+ * Returns -EINVAL if data is already supplied in the message, 0 otherwise.
+ */
+int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
+			       const void *data, size_t datalen)
+{
+	if (pkcs7->data) {
+		pr_debug("Data already supplied\n");
+		return -EINVAL;
+	}
+	pkcs7->data = data;
+	pkcs7->data_len = datalen;
+	return 0;
+}
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 691c79172a26..e235ab4957ee 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -34,3 +34,6 @@ extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
  * pkcs7_verify.c
  */
 extern int pkcs7_verify(struct pkcs7_message *pkcs7);
+
+extern int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
+				      const void *data, size_t datalen);

