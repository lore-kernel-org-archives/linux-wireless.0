Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC403C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95B05218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfCVONl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:13:41 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:40703 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbfCVONl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:13:41 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MHGPA-1hBieT1KrI-00DCYI; Fri, 22 Mar 2019 15:13:25 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: work around clang -Wuninitialized warning
Date:   Fri, 22 Mar 2019 15:13:08 +0100
Message-Id: <20190322141322.463149-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8LiqyZKY/9vFF7zcjDNigdSW/6DKivRTQP9iy6iNl7h0N+D52W+
 WjHMm4zaTiE1i/Hhs7lC/UTGioE6VlzNpLMhlqy/MQjFaRTUYhlih1WWd9uMGcXbc1LbV9q
 0wlcwt/W2jWT94/o41XckfCaMfdNOAv7khoQgihWfyg0mK5E651LokoTA/s6wpulv4as0a9
 MpaGM2VhVhbf9+uSoc1Pw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OqB1nMQOBws=:d3vBzx/V0HessxOj110NiJ
 gsTseOF2wW+VwFpYB3GPngpbR6OhRrcaNuSmuhGPF6BerpEiq0EGC+pcpFfM5BrhTIf9N1ktn
 XTn7j9qS1FGM/sDuNPFg9TavkEC05JXveJk/ekvhsKo1IYH6+IS+gE6OCiZ+7mZhIhFKLw0eR
 3ry4DaDsTyDhdbV+5Qh6WGtAlj6xPybINn9wTaFzc4BbGqi7Pjn86E0WZDCHE2qJAJ4KqnRny
 31czUwJJ4K10OFi0W7Xb07ndDPjAl40PobE+mzUCGlSU60nqqjm0bEqHLWS+0ts0E3vSL7G+B
 92rsKrcfGzRy6j2CqN9GMHS/Fd6bjgWAaPvR/U1UzjleC74CScyyf6PzjkKuUmVny/2nMXy+g
 9gqNn8MsLUo9dccciwGFMxaAgckOPac84Yt99RZe2b7Bgvx3wHF6OZbP0N/uNAcKkIM6Qi/1K
 r867fNdg8XuSM/cNwDvsxoi9uHLvtdYhYx8HR21DTzgaOEhR4A7VxlGtoUXC0DBnQ3FZ6D28e
 NDEavP7mlrvWpAGjqvNWs3H5KgQPYjQ6Gc0rY0YD0FKPTTDFvnDiUGMzL8wzz12nwCcxRsFwg
 p7SG+u2ambSelrts2pFF5PksAX7CFBxrDRAs7Ffq7iV1h6C2ZPusLQXCZtOvSaabZLKX6Do1V
 FO0xLZeS0XZ/Ka/SZBBAuXIa6YMhh603fJ84q/FkqsqFH9FnLn3PV13EBrfe/ophuer+QHTx5
 ABql4tF9YpEIFH94YRLPnumytCY0I6AEULzgWw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clang incorrectly warns about an uninitialized variable:

drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: error: variable 'queue' is used uninitialized whenever 'if'
      condition is false [-Werror,-Wsometimes-uninitialized]
                else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/asm-generic/bug.h:130:36: note: expanded from macro 'WARN'
 #define WARN(condition, format...) ({                                   \
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2119:33: note: uninitialized use occurs here
                iwl_mvm_enable_txq(mvm, NULL, queue, 0, &cfg, wdg_timeout);
                                              ^~~~~
drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:8: note: remove the 'if' if its condition is always true
                else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2094:11: note: initialize the variable 'queue' to silence this warning
        int queue;
                 ^
                  = 0
1 error generated.

This cannot happen because the if/else if/else if block always
has one code path that is entered. However, we can simply
rearrange the code to let clang see this as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 498c315291cf..91ce56d2ebb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2107,12 +2107,14 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
 		if (vif->type == NL80211_IFTYPE_AP ||
-		    vif->type == NL80211_IFTYPE_ADHOC)
+		    vif->type == NL80211_IFTYPE_ADHOC) {
 			queue = mvm->probe_queue;
-		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		} else if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			queue = mvm->p2p_dev_queue;
-		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
+		} else {
+			WARN(1, "Missing required TXQ for adding bcast STA\n");
 			return -EINVAL;
+		}
 
 		bsta->tfd_queue_msk |= BIT(queue);
 
-- 
2.20.0

