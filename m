Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3263 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2LEO0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/11] brcmsmac: fix uninitialized variable warning on
 arm architecture
Date: Wed, 5 Dec 2012 15:25:55 +0100
Message-ID: <1354717564-7183-3-git-send-email-arend@broadcom.com> (sfid-20121205_152630_448003_4858295E)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using gcc v4.7.2 gave following warning:

  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/aiutils.o
brcmsmac/aiutils.c: In function 'ai_deviceremoved':
brcmsmac/aiutils.c:733:9: error: 'w' may be used uninitialized
in this function [-Werror=uninitialized]

Inspection of the pci_read_config_dword() function showed it can
return without modifying the output variable 'w' so this patch
initializes it to 0.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index de96290..f0888a9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -721,7 +721,7 @@ void ai_epa_4313war(struct si_pub *sih)
 /* check if the device is removed */
 bool ai_deviceremoved(struct si_pub *sih)
 {
-	u32 w;
+	u32 w = 0;
 	struct si_info *sii;
 
 	sii = container_of(sih, struct si_info, pub);
-- 
1.7.9.5


