Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35607 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcDQNZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 09:25:39 -0400
Received: by mail-lf0-f48.google.com with SMTP id c126so190527812lfb.2
        for <linux-wireless@vger.kernel.org>; Sun, 17 Apr 2016 06:25:38 -0700 (PDT)
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, brudley@broadcom.com,
	Per Forlin <per.forlin@gmail.com>
Subject: [PATCH] brcmf: Fix null pointer exception in bcdc_hdrpull
Date: Sun, 17 Apr 2016 15:25:03 +0200
Message-Id: <1460899503-5245-1-git-send-email-per.forlin@gmail.com> (sfid-20160417_152605_175110_4A86E9FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Per Forlin <per.forlin@gmail.com>

In fwsignal.c: brcmf_fws_commit_skb()
...
if (rc < 0) {
  entry->transit_count--;
    if (entry->suppressed)
      entry->suppr_transit_count--;
      (void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
                                                     ^^^^^^^
    goto rollback;
}
...

The call to hdrpull will trigger a null pointer exception
unless a null check is made in the method implementation.

Signed-off-by: Per Forlin <per.forlin@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 6af658e..81727da2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -321,7 +321,8 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	if (pktbuf->len == 0)
 		return -ENODATA;
 
-	*ifp = tmp_if;
+	if (ifp != NULL)
+		*ifp = tmp_if;
 	return 0;
 }
 
-- 
2.1.4

