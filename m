Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943502AbcJSPAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:00:49 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/5] mei: bus: add  module_mei_cl_driver helper macro
Date: Wed, 19 Oct 2016 16:33:27 +0300
Message-Id: <1476884011-20645-2-git-send-email-tomas.winkler@intel.com> (sfid-20161019_174325_965266_D9D8AC16)
In-Reply-To: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add module_mei_cl_driver helper macro for eliminating the boilerplate
code from mei_cl drivers registration. The macro is intended for
drivers which in their init/exit sections does only register/unregister
of a mei_cl driver.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/mei_cl_bus.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/mei_cl_bus.h b/include/linux/mei_cl_bus.h
index e746919530f5..e6fbd98ea90e 100644
--- a/include/linux/mei_cl_bus.h
+++ b/include/linux/mei_cl_bus.h
@@ -74,6 +74,19 @@ int __mei_cldev_driver_register(struct mei_cl_driver *cldrv,
 
 void mei_cldev_driver_unregister(struct mei_cl_driver *cldrv);
 
+/**
+ * module_mei_cl_driver - Helper macro for registering mei cl driver
+ *
+ * @__mei_cldrv mei_cl_driver structure
+ *
+ *  Helper macro for mei cl drivers which do not do anything special in module
+ *  init/exit, for eliminating a boilerplate code.
+ */
+#define module_mei_cl_driver(__mei_cldrv) \
+	module_driver(__mei_cldrv, \
+		      mei_cldev_driver_register,\
+		      mei_cldev_driver_unregister)
+
 ssize_t mei_cldev_send(struct mei_cl_device *cldev, u8 *buf, size_t length);
 ssize_t  mei_cldev_recv(struct mei_cl_device *cldev, u8 *buf, size_t length);
 
-- 
2.7.4
