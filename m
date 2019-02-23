Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336F0C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 08:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03B09206A3
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 08:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfBWIgx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 03:36:53 -0500
Received: from smtpbg65.qq.com ([103.7.28.233]:45839 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfBWIgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 03:36:52 -0500
X-QQ-mid: bizesmtp3t1550911007tviwzfxl0
Received: from localhost.localdomain (unknown [116.236.177.50])
        by esmtp4.qq.com (ESMTP) with 
        id ; Sat, 23 Feb 2019 16:36:22 +0800 (CST)
X-QQ-SSF: 01400000002000C0EF82B00A0000000
X-QQ-FEAT: tMyt+NWEO8hiEvvOMb5S74F6dAY3XyMAxv1Po3ti/OB47cjPnyPgYrTI65Iof
        UT2bDB21ByK/KwFN6QR1R+eUrjnUrLSerICXe8HVMuIG80cZpHEdo6E+cN0JUI9kvFxuOyq
        6AWuF2m1Z8IAbv7nCKot6Ki+dpJD1SNFM+HASZSU4Rhh6zGDXnx/B62tio0wPWPn/q0ZRt4
        A2OaD4m+2YVmCtS4vD+PJo+riIpNk+Nt8/zOqEARvBOKb0FltHfoD8UvpjGkv7LsDVL2cGB
        4xjuOR7JzeE6QtcKxbz8n0xnBx0JOxEMbvRw==
X-QQ-GoodBg: 2
From:   Wang Xuerui <wangxuerui@qiniu.com>
To:     linux-wireless@vger.kernel.org
Cc:     Wang Xuerui <wangxuerui@qiniu.com>
Subject: [PATCH] iwlwifi: mvm: fix unaligned read of rx_pkt_status
Date:   Sat, 23 Feb 2019 16:35:43 +0800
Message-Id: <20190223083543.6009-2-wangxuerui@qiniu.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190223083543.6009-1-wangxuerui@qiniu.com>
References: <20190218150952.6889-1-wangxuerui@qiniu.com>
 <20190223083543.6009-1-wangxuerui@qiniu.com>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:qiniu.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is present since the introduction of iwlmvm.
Example stack trace on MIPS:

[<ffffffffc0789328>] iwl_mvm_rx_rx_mpdu+0xa8/0xb88 [iwlmvm]
[<ffffffffc0632b40>] iwl_pcie_rx_handle+0x420/0xc48 [iwlwifi]

Tested with a Wireless AC 7265 for ~6 months, confirmed to fix the
problem. No other unaligned accesses are spotted yet.

Signed-off-by: Wang Xuerui <wangxuerui@qiniu.com>
Tested-by: Wang Xuerui <wangxuerui@qiniu.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 6653a238f32e..a9f35799e532 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -57,6 +57,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <asm/unaligned.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include "iwl-trans.h"
@@ -355,7 +356,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
-	rx_pkt_status = le32_to_cpup((__le32 *)
+	rx_pkt_status = get_unaligned_le32((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
-- 
2.16.1



