Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:48290 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbcGLLds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 07:33:48 -0400
From: weiyj_lk@163.com
To: Kalle Valo <kvalo@codeaurora.org>,
	sudip <sudipm.mukherjee@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH -next] libertas: fix non static symbol warning
Date: Tue, 12 Jul 2016 11:32:19 +0000
Message-Id: <1468323139-1756-1-git-send-email-weiyj_lk@163.com> (sfid-20160712_133412_511119_52700F88)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/net/wireless/marvell/libertas/cfg.c:2047:5: warning:
 symbol 'lbs_set_power_mgmt' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index ea48024..7ff2efa 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -2044,8 +2044,8 @@ static int lbs_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 
 
-int lbs_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
-		       bool enabled, int timeout)
+static int lbs_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			      bool enabled, int timeout)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 




