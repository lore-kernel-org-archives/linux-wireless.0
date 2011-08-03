Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9873 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1HCFEA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 01:04:00 -0400
Subject: [PATCH 3/3] compat: don't define genl_register_mc_group() for Linux
 2.6.22 and older
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 03 Aug 2011 01:03:46 -0400
Message-ID: <20110803050346.10364.36072.stgit@mj.roinet.com> (sfid-20110803_070403_687379_E6D8B8FF)
In-Reply-To: <20110803050333.10364.78012.stgit@mj.roinet.com>
References: <20110803050333.10364.78012.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat-2.6.23.h has a different definition of genl_register_mc_group().
Likewise, don't define genl_unregister_mc_group() for old kernels.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/linux/compat-2.6.37.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index d375746..78b0b38 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -91,8 +91,11 @@ int genl_unregister_family(struct genl_family *family);
 
 #define genlmsg_reply(_msg, _info) genlmsg_reply(_msg, (_info)->info)
 #define genlmsg_put(_skb, _pid, _seq, _fam, _flags, _cmd) genlmsg_put(_skb, _pid, _seq, &(_fam)->family, _flags, _cmd)
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 #define genl_register_mc_group(_fam, _grp) genl_register_mc_group(&(_fam)->family, _grp)
 #define genl_unregister_mc_group(_fam, _grp) genl_unregister_mc_group(&(_fam)->family, _grp)
+#endif
 
 
 extern void led_blink_set(struct led_classdev *led_cdev,
