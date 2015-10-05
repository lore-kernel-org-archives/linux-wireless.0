Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57103 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbbJEOhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:39 +0300
Message-Id: <1444055820-27506-8-git-send-email-luca@coelho.fi> (sfid-20151005_163724_516573_6DDBC0CC)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 08/29] iwlwifi: mvm: fix tof.h header guard
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Commit ce7929186a39 ("iwlwifi: mvm: add basic Time of Flight (802.11mc
FTM) support") created drivers/net/wireless/iwlwifi/mvm/tof.h with a
broken header guard:

    #ifndef __tof
    #define __tof_h__

    ...

    #endif /* __tof_h__ */

Use __tof_h__ in the first line.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tof.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.h b/drivers/net/wireless/iwlwifi/mvm/tof.h
index 50ae8ad..9beebc3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tof.h
+++ b/drivers/net/wireless/iwlwifi/mvm/tof.h
@@ -60,7 +60,7 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
-#ifndef __tof
+#ifndef __tof_h__
 #define __tof_h__
 
 #include "fw-api-tof.h"
-- 
2.5.3

