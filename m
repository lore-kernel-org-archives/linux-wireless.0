Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2DXCgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 22:36:48 -0400
Received: by mail-iy0-f174.google.com with SMTP id i9so315300iad.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 19:36:48 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: properly use pr_fmt()
Date: Mon, 23 Apr 2012 19:36:38 -0700
Message-Id: <1335234998-31547-2-git-send-email-mcgrof@frijolero.org> (sfid-20120424_043651_132967_2EAD612A)
In-Reply-To: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

pr_fmt() is either defined or we redefine it. Typically
drivers define it prior to including printk.h but this
is done under the assumption that no other subsystem
it uses has already defined pr_fmt(). In such cases
pr_fmt() should be undefined and redefined.

Doing this properly shaves down compilation time quite
considerably.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 ++
 drivers/net/wireless/ath/ath6kl/init.c     |    2 ++
 drivers/net/wireless/ath/ath6kl/main.c     |    3 +++
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 +++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 28a65d3..db9b7cf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -15,8 +15,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/moduleparam.h>
 #include <linux/inetdevice.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 29ef50e..68af79d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -16,8 +16,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4d818f9..c173a78 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -15,8 +15,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "core.h"
 #include "hif-ops.h"
 #include "cfg80211.h"
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 82f2f5c..920265e 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -15,8 +15,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "core.h"
 #include "debug.h"
 #include "htc-ops.h"
-- 
1.7.10.rc1.22.gf5241

