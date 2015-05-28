Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbbE1PrS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:47:18 -0400
Subject: [PATCH 07/20] system_keyring.c doesn't need to #include
 module-internal.h [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:47:11 +0100
Message-ID: <20150528154711.1259.89337.stgit@warthog.procyon.org.uk> (sfid-20150528_174740_173922_5FA3A568)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
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

