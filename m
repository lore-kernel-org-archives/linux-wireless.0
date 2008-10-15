Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbYJOSPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 14:15:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: protect headers from double inclusion
Date: Wed, 15 Oct 2008 11:06:23 -0700
Message-Id: <1224093984-20779-1-git-send-email-reinette.chatre@intel.com> (sfid-20081015_201551_179568_B460FF0E)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch protects iwl-csr.h and iwl-fh.h from double inclusion
by ifndef define endif idiom

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-fh.h  |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 662edf4..84f56a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -60,6 +60,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#ifndef __iwl_csr_h__
+#define __iwl_csr_h__
 /*=== CSR (control and status registers) ===*/
 #define CSR_BASE    (0x000)
 
@@ -286,4 +288,4 @@
 #define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
 
 
-
+#endif /* !__iwl_csr_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index a72efdf..8c48d88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -60,6 +60,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  *****************************************************************************/
+#ifndef __iwl_fh_h__
+#define __iwl_fh_h__
 
 /****************************/
 /* Flow Handler Definitions */
@@ -391,3 +393,4 @@
 /* TCSR: tx_config register values */
 #define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
 
+#endif /* !__iwl_fh_h__ */
-- 
1.5.4.3

