Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2411 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 26/26] staging: brcm80211: smac: fix for 64 bit systems
Date: Tue, 4 Oct 2011 23:19:12 +0200
Message-ID: <1317763152-17607-27-git-send-email-arend@broadcom.com> (sfid-20111004_232027_495423_2A641FBB)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

A bug was introduced by the following commit (Sep 13):

    staging: brcm80211: use endian annotated structures in brcmsmac

Result was that 64 bits systems will not be able to acquire an IP address.
Also the rmmod crashed. This has been fixed and retested on a Sparc64.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index fa00ab3..ac78052 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -1606,7 +1606,7 @@ fail:
  * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
+int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
 {
 	int i, entry;
 	const u8 *pdata;
@@ -1623,7 +1623,7 @@ int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
 						  "ERROR: fw hdr len\n");
 					return -ENOMSG;
 				}
-				*data = le32_to_cpu(*((__le32 *) pdata));
+				*n_bytes = le32_to_cpu(*((__le32 *) pdata));
 				return 0;
 			}
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
index 49d5b7e..18750a8 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
@@ -50,8 +50,8 @@ extern void brcms_ucode_data_free(struct brcms_ucode *ucode);
 
 extern int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf,
 				unsigned int idx);
-extern int brcms_ucode_init_uint(struct brcms_info *wl, unsigned *data,
-			      unsigned int idx);
+extern int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes,
+				 unsigned int idx);
 extern void brcms_ucode_free_buf(void *);
 extern int  brcms_check_firmwares(struct brcms_info *wl);
 
-- 
1.7.4.1


