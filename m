Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab1ASWfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:35:15 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:35:15 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 4/8] staging: brcm80211: Remove ETHER_MAX_LEN definition.
Date: Wed, 19 Jan 2011 23:35:28 +0100
Message-Id: <1295476532-21130-5-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-3-git-send-email-jonas.gorski@gmail.com>
 <1295476532-21130-4-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ETHER_MAX_LEN is only used for CDC_MAX_MSG_SIZE, directly use the value
in bcmcdc.h and remove the definition.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/include/bcmcdc.h         |    3 +--
 drivers/staging/brcm80211/include/proto/ethernet.h |    2 --
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/include/bcmcdc.h b/drivers/staging/brcm80211/include/bcmcdc.h
index 10c1ddc..e56470e 100644
--- a/drivers/staging/brcm80211/include/bcmcdc.h
+++ b/drivers/staging/brcm80211/include/bcmcdc.h
@@ -13,7 +13,6 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <proto/ethernet.h>
 
 typedef struct cdc_ioctl {
 	u32 cmd;		/* ioctl command value */
@@ -24,7 +23,7 @@ typedef struct cdc_ioctl {
 } cdc_ioctl_t;
 
 /* Max valid buffer size that can be sent to the dongle */
-#define CDC_MAX_MSG_SIZE   ETHER_MAX_LEN
+#define CDC_MAX_MSG_SIZE	1518
 
 /* len field is divided into input and output buffer lengths */
 #define CDCL_IOC_OUTLEN_MASK   0x0000FFFF	/* maximum or expected
diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 1176df9..bc99842 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -21,8 +21,6 @@
 
 #include <packed_section_start.h>
 
-#define	ETHER_MAX_LEN		1518
-
 #define	ETHER_TYPE_BRCM		0x886c
 
 BWL_PRE_PACKED_STRUCT struct ether_addr {
-- 
1.5.6.5

