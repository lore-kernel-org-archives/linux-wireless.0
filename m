Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42970 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1JLBCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 21:02:47 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so235648bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 18:02:46 -0700 (PDT)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 12 Oct 2011 03:02:42 +0200
To: "linux-wireless.vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Bartosz MARKOWSKI" <bartosz.markowski@tieto.com>,
	"Janusz DZIEDZIC" <janusz.dziedzic@tieto.com>,
	"Johan Lilje" <johan.lilje@stericsson.com>
Subject: [RFC 03/07] compat-wireless: Enable changing regulatory domain
MIME-Version: 1.0
From: "Dmitry Tarnyagin" <abi.dmitryt@gmail.com>
Message-ID: <op.v27rusy7ya27un@edmitar> (sfid-20111012_030250_401722_D3C10EDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johan Lilje <johan.lilje@stericsson.com>
Date: Tue, 2 Aug 2011 09:21:49 +0200

If compat-wireless code is compiled into the kernel,
first request regulatory hint fails to return since
userspace is not ready yet.
Added timeout mechanism to remove old pending requests.

Signed-off-by: Johan Lilje <johan.lilje@stericsson.com>
---
  include/net/regulatory.h |    3 +++
  net/wireless/reg.c       |   26 +++++++++++++++++++++++---
  2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index eb7d3c2..98dda7b 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -61,6 +61,8 @@ enum environment_cap {
   * 	country IE
   * @country_ie_env: lets us know if the AP is telling us we are outdoor,
   * 	indoor, or if it doesn't matter
+ * @timestamp: stores the time when this request calls crda, to enable
+ *	timeout mechanism.
   * @list: used to insert into the reg_requests_list linked list
   */
  struct regulatory_request {
@@ -70,6 +72,7 @@ struct regulatory_request {
  	bool intersect;
  	bool processed;
  	enum environment_cap country_ie_env;
+	struct timespec timestamp;
  	struct list_head list;
  };

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6acba9d..1fbd36a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -35,6 +35,7 @@

  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

+#include <linux/time.h>
  #include <linux/kernel.h>
  #include <linux/export.h>
  #include <linux/slab.h>
@@ -1433,6 +1434,9 @@ new_request:
  		return r;
  	}

+	/* Get timestamp */
+	getnstimeofday(&(last_request->timestamp));
+
  	return call_crda(last_request->alpha2);
  }

@@ -1479,15 +1483,31 @@ static void reg_process_hint(struct  
regulatory_request *reg_request)
  static void reg_process_pending_hints(void)
  {
  	struct regulatory_request *reg_request;
+	struct timespec time_diff;
+	struct timespec timestamp_now;

  	mutex_lock(&cfg80211_mutex);
  	mutex_lock(&reg_mutex);

  	/* When last_request->processed becomes true this will be rescheduled */
  	if (last_request && !last_request->processed) {
-		REG_DBG_PRINT("Pending regulatory request, waiting "
-			      "for it to be processed...\n");
-		goto out;
+		/* Get time since last request */
+		if (last_request->timestamp.tv_nsec) {
+			getnstimeofday(&timestamp_now);
+			time_diff = timespec_sub(timestamp_now,
+						 last_request->timestamp);
+		}
+
+		/* Previous call to CRDA did not return within 2 seconds */
+		if (time_diff.tv_sec > 2) {
+			REG_DBG_PRINT("Regulatory request timeout, "
+				      "removing pending hint\n");
+			reg_set_request_processed();
+		} else {
+			REG_DBG_PRINT("Pending regulatory request, waiting "
+				      "for it to be processed...\n");
+			goto out;
+		}
  	}

  	spin_lock(&reg_requests_lock);
-- 
1.7.1
