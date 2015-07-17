Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbGQQPj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:15:39 -0400
Subject: [PATCH 03/27] PKCS#7: Allow detached data to be supplied for
 signature checking purposes
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:15:33 +0100
Message-ID: <20150717161533.2578.35303.stgit@warthog.procyon.org.uk> (sfid-20150717_182414_075563_164BC49F)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
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

