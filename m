Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35420 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbbEMShD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 14:37:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	casey@schaufler-ca.com, keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [RFC v2 5/6] kernel/sysdata_signing: export data_verify_pkcs7()
Date: Wed, 13 May 2015 11:23:55 -0700
Message-Id: <1431541436-17007-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20150513_203721_223607_7CDDF769)
In-Reply-To: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431541436-17007-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will be used for firmware signature check support.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/sysdata-internal.h | 2 ++
 kernel/sysdata_signing.c  | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sysdata-internal.h b/kernel/sysdata-internal.h
index 0aa573e..52a5c42 100644
--- a/kernel/sysdata-internal.h
+++ b/kernel/sysdata-internal.h
@@ -10,3 +10,5 @@
  */
 
 extern int sysdata_verify_sig(const void *data, unsigned long *_len);
+int data_verify_pkcs7(const void *data, unsigned long len,
+		      const void *raw_pkcs7, size_t pkcs7_len);
diff --git a/kernel/sysdata_signing.c b/kernel/sysdata_signing.c
index adc44d4..6759c54 100644
--- a/kernel/sysdata_signing.c
+++ b/kernel/sysdata_signing.c
@@ -39,8 +39,8 @@ struct sysdata_signature {
 /*
  * Verify a PKCS#7-based signature on system data.
  */
-static int data_verify_pkcs7(const void *data, unsigned long len,
-			     const void *raw_pkcs7, size_t pkcs7_len)
+int data_verify_pkcs7(const void *data, unsigned long len,
+		      const void *raw_pkcs7, size_t pkcs7_len)
 {
 	struct pkcs7_message *pkcs7;
 	bool trusted;
@@ -75,6 +75,7 @@ error:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(data_verify_pkcs7);
 
 /*
  * Verify the signature on system data.
-- 
2.3.2.209.gd67f9d5.dirty

