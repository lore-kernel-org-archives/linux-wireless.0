Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbGQQQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:16:27 -0400
Subject: [PATCH 07/27] system_keyring.c doesn't need to #include
 module-internal.h
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:16:21 +0100
Message-ID: <20150717161621.2578.2045.stgit@warthog.procyon.org.uk> (sfid-20150717_182349_008181_27664B61)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

system_keyring.c doesn't need to #include module-internal.h as it doesn't use
the one thing that exports.  Remove the inclusion.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/system_keyring.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 875f64e8935b..4cda71ee51c7 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -16,7 +16,6 @@
 #include <linux/err.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
-#include "module-internal.h"
 
 struct key *system_trusted_keyring;
 EXPORT_SYMBOL_GPL(system_trusted_keyring);

