Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:39828 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbcCAPX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:23:56 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: fix static checker warning
Date: Tue,  1 Mar 2016 23:22:23 +0800
Message-Id: <1e3c203b20c01a12078506469807a79ae6013955.1456845195.git.geliangtang@163.com> (sfid-20160301_162414_788197_8232AC2F)
In-Reply-To: <20160223050421.GA19763@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following static checker warning:

 drivers/staging/rtl8723au/core/rtw_sta_mgt.c:365 rtw_get_stainfo23a()
 error: potential NULL dereference 'psta'.

Fixes: e280d71("staging: rtl8723au: use list_for_each_entry*()")
Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index 22d857b..5f85ee0 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -346,7 +346,7 @@ void rtw_free_all_stainfo23a(struct rtw_adapter *padapter)
 struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 {
 	struct list_head *phead;
-	struct sta_info *psta = NULL;
+	struct sta_info *pos, *psta = NULL;
 	u32 index;
 	const u8 *addr;
 
@@ -362,7 +362,9 @@ struct sta_info *rtw_get_stainfo23a(struct sta_priv *pstapriv, const u8 *hwaddr)
 
 	spin_lock_bh(&pstapriv->sta_hash_lock);
 	phead = &pstapriv->sta_hash[index];
-	list_for_each_entry(psta, phead, hash_list) {
+	list_for_each_entry(pos, phead, hash_list) {
+		psta = pos;
+
 		/*  if found the matched address */
 		if (ether_addr_equal(psta->hwaddr, addr))
 			break;
-- 
2.5.0


