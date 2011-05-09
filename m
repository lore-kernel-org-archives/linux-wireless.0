Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1376 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1EIPva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 11:51:30 -0400
Subject: [PATCH] staging: brcm80211: brcmfmac: Fix memset using sizeof(ptr)
 not sizeof(*ptr)
From: Joe Perches <joe@perches.com>
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	devel <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 08:51:29 -0700
Message-ID: <1304956289.19586.35.camel@Joe-Laptop> (sfid-20110509_175143_014072_9F1808A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Found via coccinelle script

@@
type T;
T* ptr;
expression E1;
@@

* memset(E1, 0, sizeof(ptr));

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index a16b46c..4b810ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -498,9 +498,7 @@ wl_iw_get_range(struct net_device *dev,
 	list = (wl_u32_list_t *) channels;
 
 	dwrq->length = sizeof(struct iw_range);
-	memset(range, 0, sizeof(range));
-
-	range->min_nwid = range->max_nwid = 0;
+	memset(range, 0, sizeof(*range));
 
 	list->count = cpu_to_le32(MAXCHANNEL);
 	error = dev_wlc_ioctl(dev, WLC_GET_VALID_CHANNELS, channels,


