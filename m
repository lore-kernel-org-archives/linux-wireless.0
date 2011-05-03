Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1625 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab1ECJgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 03/61] staging: brcm80211: bugfix for fullmac return
 codes
Date: Tue, 3 May 2011 11:35:03 +0200
Message-ID: <1304415361-7813-4-git-send-email-arend@broadcom.com> (sfid-20110503_113629_813088_686CFEAD)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Some code paths in the fullmac driver did not return a negative value
on error. This has been corrected.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 8d5acb8..9eca208 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -432,7 +432,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 
 	case DHD_GET_VERSION:
 		if (buflen < sizeof(int))
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 		else
 			*(int *)buf = DHD_IOCTL_VERSION;
 		break;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index bb4fdc6..b43ac8a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1699,7 +1699,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 
 	/* Copy the ioc control structure part of ioctl request */
 	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(wl_ioctl_t))) {
-		bcmerror = BCME_BADADDR;
+		bcmerror = -BCME_BADADDR;
 		goto done;
 	}
 
@@ -1715,11 +1715,11 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		{
 			buf = kmalloc(buflen, GFP_ATOMIC);
 			if (!buf) {
-				bcmerror = BCME_NOMEM;
+				bcmerror = -BCME_NOMEM;
 				goto done;
 			}
 			if (copy_from_user(buf, ioc.buf, buflen)) {
-				bcmerror = BCME_BADADDR;
+				bcmerror = -BCME_BADADDR;
 				goto done;
 			}
 		}
@@ -1728,12 +1728,12 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	/* To differentiate between wl and dhd read 4 more byes */
 	if ((copy_from_user(&driver, (char *)ifr->ifr_data + sizeof(wl_ioctl_t),
 			    sizeof(uint)) != 0)) {
-		bcmerror = BCME_BADADDR;
+		bcmerror = -BCME_BADADDR;
 		goto done;
 	}
 
 	if (!capable(CAP_NET_ADMIN)) {
-		bcmerror = BCME_EPERM;
+		bcmerror = -BCME_EPERM;
 		goto done;
 	}
 
-- 
1.7.4.1


