Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1915 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab2IMTM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: add parameter check in
 brcmf_c_mkiovar()
Date: Thu, 13 Sep 2012 21:12:05 +0200
Message-ID: <1347563526-12513-10-git-send-email-arend@broadcom.com> (sfid-20120913_211241_183536_BF594CC2)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch assures data is only appended in output buffer when
data is not NULL and datalen is not zero.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 8121dba..6afb26c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -80,8 +80,10 @@ brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
 	strncpy(buf, name, buflen);
 
 	/* append data onto the end of the name string */
-	memcpy(&buf[len], data, datalen);
-	len += datalen;
+	if (data && datalen) {
+		memcpy(&buf[len], data, datalen);
+		len += datalen;
+	}
 
 	return len;
 }
-- 
1.7.9.5


