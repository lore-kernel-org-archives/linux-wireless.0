Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:55502 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbbILKM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 06:12:29 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH] iwlwifi: mvm: fix tof.h header guard
Date: Sat, 12 Sep 2015 12:04:51 +0200
Message-Id: <1442052291-2328-1-git-send-email-nicolas.iooss_linux@m4x.org> (sfid-20150912_121249_388301_136F5B59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit ce7929186a39 ("iwlwifi: mvm: add basic Time of Flight (802.11mc
FTM) support") created drivers/net/wireless/iwlwifi/mvm/tof.h with a
broken header guard:

    #ifndef __tof
    #define __tof_h__

    ...

    #endif /* __tof_h__ */

Use __tof_h__ in the first line.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/net/wireless/iwlwifi/mvm/tof.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.h b/drivers/net/wireless/iwlwifi/mvm/tof.h
index 50ae8adaaa6e..9beebc33cb8d 100644
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
2.5.1

