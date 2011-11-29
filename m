Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42263 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1K2RmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:42:03 -0500
Received: by qyk4 with SMTP id 4so1819016qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 09:42:02 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] prism54: fix compilation warning on wrqu.data.pointer
Date: Tue, 29 Nov 2011 12:41:58 -0500
Message-Id: <1322588518-15623-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111129_184218_416430_1665FE2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this compilation warning:

  CHECK   drivers/net/wireless/prism54/isl_ioctl.c
drivers/net/wireless/prism54/isl_ioctl.c:2052:27: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:2071:27: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    got char *[assigned] memptr

The wrqu.data.pointer shouldn't be assigned by the driver, addiotionally
custom wext driver events would simply be dropped anyway.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---

Johannes, it was unclear to me whether or not wireless_send_event()
no longer supports custom driver events if so then not only was this
bogus but also all the private driver event crap could likely be
removed from prism54 as well.

 drivers/net/wireless/prism54/isl_ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 4e44b1a..862dfea 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2049,7 +2049,6 @@ send_formatted_event(islpci_private *priv, const char *str,
 	memptr = kmalloc(IW_CUSTOM_MAX, GFP_KERNEL);
 	if (!memptr)
 		return;
-	wrqu.data.pointer = memptr;
 	wrqu.data.length = 0;
 	format_event(priv, memptr, str, mlme, &wrqu.data.length,
 		     error);
@@ -2068,7 +2067,6 @@ send_simple_event(islpci_private *priv, const char *str)
 	if (!memptr)
 		return;
 	BUG_ON(n >= IW_CUSTOM_MAX);
-	wrqu.data.pointer = memptr;
 	wrqu.data.length = n;
 	strcpy(memptr, str);
 	wireless_send_event(priv->ndev, IWEVCUSTOM, &wrqu, memptr);
-- 
1.7.4.15.g7811d

