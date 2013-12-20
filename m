Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35084 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab3LTCWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 21:22:53 -0500
Received: by mail-bk0-f43.google.com with SMTP id mz12so1000780bkb.30
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 18:22:52 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Dec 2013 10:22:51 +0800
Message-ID: <CAPgLHd8Cn-UkVp1VMpAuR2w64-3BgxfHCqnqo3bjGGYtW0-RwQ@mail.gmail.com> (sfid-20131220_032259_740345_D2FA8BFA)
Subject: [PATCH -next] ath9k: fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ath9k-devel@qca.qualcomm.com, linville@tuxdriver.com,
	c_manoha@qca.qualcomm.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/net/wireless/ath/ath9k/spectral.c:500:24: warning:
 symbol 'rfs_spec_scan_cb' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/ath9k/spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 11adb5e..99f4de9 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -497,7 +497,7 @@ static int remove_buf_file_handler(struct dentry *dentry)
 	return 0;
 }
 
-struct rchan_callbacks rfs_spec_scan_cb = {
+static struct rchan_callbacks rfs_spec_scan_cb = {
 	.create_buf_file = create_buf_file_handler,
 	.remove_buf_file = remove_buf_file_handler,
 };

