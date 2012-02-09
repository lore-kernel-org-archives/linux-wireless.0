Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3937 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab2BIUJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/15] brcm80211: fmac: resolve smatch issues in
 brcmfmac code
Date: Thu, 9 Feb 2012 21:09:00 +0100
Message-ID: <1328818149-4826-7-git-send-email-arend@broadcom.com> (sfid-20120209_211026_937738_88E6EC96)
In-Reply-To: <1328818149-4826-1-git-send-email-arend@broadcom.com>
References: <1328818149-4826-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch resolves the following smatch issues:

wl_cfg80211.c +1377 brcmf_cfg80211_connect(65) warn: min_t truncates
here '(sme->ssid_len)' (4294967295 vs 9223372036854775807)
dhd_sdio.c +1275 brcmf_sdbrcm_rxglom(156) warn: min_t truncates here
'(pfirst->len)' (2147483647 vs 4294967295)
dhd_sdio.c +1457 brcmf_sdbrcm_rxglom(338) warn: min_t truncates here
'(pfirst->len)' (2147483647 vs 4294967295)
bcmsdh_sdmmc.c +300 brcmf_sdioh_request_buffer(10) warn: variable
dereferenced before check 'pkt' (see line 295)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index ac71ade..b698a76 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -294,13 +294,14 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			       struct sk_buff *pkt)
 {
 	int status;
-	uint pkt_len = pkt->len;
+	uint pkt_len;
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (pkt == NULL)
 		return -EINVAL;
+	pkt_len = pkt->len;
 
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_buffer_wait);
 	if (brcmf_pm_resume_error(sdiodev))
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 74c95a5..e95a883 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1376,7 +1376,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid_le);
 
-	ssid.SSID_len = min_t(u32, sizeof(ssid.SSID), sme->ssid_len);
+	ssid.SSID_len = min_t(u32, sizeof(ssid.SSID), (u32)sme->ssid_len);
 	memcpy(&join_params.ssid_le.SSID, sme->ssid, ssid.SSID_len);
 	memcpy(&ssid.SSID, sme->ssid, ssid.SSID_len);
 	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
-- 
1.7.5.4


