Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [129.175.33.41] ([129.175.33.41]:51209 "EHLO smtp1.u-psud.fr"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758511Ab2CFJ6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 04:58:33 -0500
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Maximilian.Gmeiner.sam04@fh-joanneum.at
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH] compat: Fix module_init return type from void to int.
Date: Tue,  6 Mar 2012 10:55:28 +0100
Message-Id: <1331027728-18496-1-git-send-email-cavallar@lri.fr> (sfid-20120306_105836_618222_61A5ED9C)
In-Reply-To: <CDCF1538AB98AA4FBCA89C8D5750845F1A473A21@MALMO.technikum.fh-joanneum.local>
References: <CDCF1538AB98AA4FBCA89C8D5750845F1A473A21@MALMO.technikum.fh-joanneum.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

086f3a1 overrode module_init to make it depend on compat, but the
overriding module_init has return type 'void', so strange things would
happen when the module loading code see that init_module() returns
positive values.  This patch makes it return the value returned by
the overriden module_init.

Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
---
On 05/03/2012 22:50, Gmeiner Maximilian wrote:
> After compiling from the bleeding-edge without any errors this is what I get in kern.log when doing modprobe ath9k

I had the same problem with a completely different architecture and device,
and this patch fixed it.

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index bb00cd4..5715ce5 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -27,10 +27,10 @@ void compat_dependency_symbol(void);
 
 #undef module_init
 #define module_init(initfn)						\
-	static void __init __init_compat(void)				\
+	static int __init __init_compat(void)				\
 	{								\
 		compat_dependency_symbol();				\
-		initfn();						\
+		return initfn();					\
 	}								\
 	int init_module(void) __attribute__((alias("__init_compat")));
 
-- 
1.7.9

