Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44822 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2HZBYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 21:24:22 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:24:21 +0800
Message-ID: <CAPgLHd94RKJg7MwY8sf7S00aukdmrS8LHGvvfWv_iSZZ9TMiuw@mail.gmail.com> (sfid-20120826_032426_898856_41775417)
Subject: [PATCH] wl3501_cs: use is_broadcast_ether_addr() instead of memcmp()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: acme@ghostprotocols.net, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using is_broadcast_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is broadcast
address.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/wl3501_cs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 00f6e69..730186d 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1520,13 +1520,12 @@ static int wl3501_set_wap(struct net_device *dev, struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
 {
 	struct wl3501_card *this = netdev_priv(dev);
-	static const u8 bcast[ETH_ALEN] = { 255, 255, 255, 255, 255, 255 };
 	int rc = -EINVAL;
 
 	/* FIXME: we support other ARPHRDs...*/
 	if (wrqu->ap_addr.sa_family != ARPHRD_ETHER)
 		goto out;
-	if (!memcmp(bcast, wrqu->ap_addr.sa_data, ETH_ALEN)) {
+	if (is_broadcast_ether_addr(wrqu->ap_addr.sa_data)) {
 		/* FIXME: rescan? */
 	} else
 		memcpy(this->bssid, wrqu->ap_addr.sa_data, ETH_ALEN);


