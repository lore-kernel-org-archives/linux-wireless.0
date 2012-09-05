Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58275 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab2IEGeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 02:34:13 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 14:34:12 +0800
Message-ID: <CAPgLHd-7DpM_OQ7RTVip6d-zb8DZS9SiscrMugm2-D992ajjsg@mail.gmail.com> (sfid-20120905_083416_637090_5EB51AF1)
Subject: [PATCH] cfg80211: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com,
	davem@davemloft.net
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/wireless/reg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2ded3c7..1ad04e5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1949,8 +1949,7 @@ static void restore_regulatory_settings(bool reset_user)
 			if (reg_request->initiator !=
 			    NL80211_REGDOM_SET_BY_USER)
 				continue;
-			list_del(&reg_request->list);
-			list_add_tail(&reg_request->list, &tmp_reg_req_list);
+			list_move_tail(&reg_request->list, &tmp_reg_req_list);
 		}
 	}
 	spin_unlock(&reg_requests_lock);
@@ -2009,8 +2008,7 @@ static void restore_regulatory_settings(bool reset_user)
 			      "into the queue\n",
 			      reg_request->alpha2[0],
 			      reg_request->alpha2[1]);
-		list_del(&reg_request->list);
-		list_add_tail(&reg_request->list, &reg_requests_list);
+		list_move_tail(&reg_request->list, &reg_requests_list);
 	}
 	spin_unlock(&reg_requests_lock);
 

