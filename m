Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40483 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2ADUay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 15:30:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libipw_wx_set_encodeext: mark dev as __maybe_unused to prevent warning
Date: Wed,  4 Jan 2012 15:24:35 -0500
Message-Id: <1325708675-23408-1-git-send-email-linville@tuxdriver.com> (sfid-20120104_213058_447847_8BBE800A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/libipw_wx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 1571505..fce8bbf 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -523,7 +523,7 @@ int libipw_wx_set_encodeext(struct libipw_device *ieee,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
 {
-	struct net_device *dev = ieee->dev;
+	struct net_device *dev __maybe_unused = ieee->dev;
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	int i, idx, ret = 0;
-- 
1.7.4.4

