Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0486C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F35217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbfBRPSI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:18:08 -0500
Received: from smtpbg328.qq.com ([14.17.43.160]:36142 "EHLO smtpbg328.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730244AbfBRPSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 10:18:08 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2019 10:18:05 EST
X-QQ-mid: bizesmtp11t1550502642tzs2x1nw
Received: from localhost.localdomain (unknown [116.236.177.50])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 18 Feb 2019 23:10:31 +0800 (CST)
X-QQ-SSF: 01400000002000C0EFF2B00A0000000
X-QQ-FEAT: Me8Xob1wlXIeyo2M0ThHX3EltNWRfl/E2JQHzDu3zIliZrN8nZhDXT4/fwhun
        TjOT2b7k93Xw/cM08SsxejMaC2Mze33JNOItZ4phN52bupSBbb5zsisuWXHxr/ensfl1kx6
        2CN84rQAsJBjQqRs67kmUlOReQPM1N417hao1GAIe3ja37qavTxTl+LN1cQb5JTy1OEG6de
        FT/8fekEw+U+TWL3HtKg7D61fe4dE6yYBbK6EH97VkLrCoNrnXMf9UW2eBfzdfPQH1NazJ9
        Gh6w56JcI+vcw/
X-QQ-GoodBg: 1
From:   wangxuerui@qiniu.com
To:     linux-wireless@vger.kernel.org
Cc:     Wang Xuerui <wangxuerui@qiniu.com>
Subject: [PATCH] iwlwifi: mvm: fix an unaligned access
Date:   Mon, 18 Feb 2019 23:09:52 +0800
Message-Id: <20190218150952.6889-1-wangxuerui@qiniu.com>
X-Mailer: git-send-email 2.16.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:qiniu.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wang Xuerui <wangxuerui@qiniu.com>

Tested with a Wireless AC 7265 on a MIPS box, confirmed to fix the
unaligned accesses.

Signed-off-by: Wang Xuerui <wangxuerui@qiniu.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 6653a238f32e..a155e816262e 100644
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
@@ -355,8 +356,8 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	rx_res = (struct iwl_rx_mpdu_res_start *)pkt->data;
 	hdr = (struct ieee80211_hdr *)(pkt->data + sizeof(*rx_res));
 	len = le16_to_cpu(rx_res->byte_count);
-	rx_pkt_status = le32_to_cpup((__le32 *)
-		(pkt->data + sizeof(*rx_res) + len));
+	rx_pkt_status = le32_to_cpu(get_unaligned((__le32 *)
+		(pkt->data + sizeof(*rx_res) + len)));
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
 	 * ieee80211_hdr pulled.
-- 
2.16.1



