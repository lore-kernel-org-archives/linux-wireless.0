Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13673 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaKTV1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:27:05 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/4] brcmfmac: fix static checker warning in pmklist handling
Date: Thu, 20 Nov 2014 22:26:59 +0100
Message-ID: <1416518822-29585-2-git-send-email-arend@broadcom.com> (sfid-20141120_222710_457681_B925FFE3)
In-Reply-To: <1416518822-29585-1-git-send-email-arend@broadcom.com>
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes a static checker warning:

   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c:2965
      brcmf_cfg80211_set_pmksa()
	warn: can 'pmkid_len' be negative?

The answer to the question above is likely no so changing its
type to unsigned is sufficient.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index f8a9dfa..d1928de 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2932,7 +2932,7 @@ brcmf_update_pmklist(struct net_device *ndev,
 		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
 {
 	int i, j;
-	int pmkid_len;
+	u32 pmkid_len;
 
 	pmkid_len = le32_to_cpu(pmk_list->pmkids.npmkid);
 
@@ -2960,8 +2960,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct pmkid_list *pmkids = &cfg->pmk_list->pmkids;
 	s32 err = 0;
-	int i;
-	int pmkid_len;
+	u32 pmkid_len, i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
@@ -3000,7 +2999,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct pmkid_list pmkid;
 	s32 err = 0;
-	int i, pmkid_len;
+	u32 pmkid_len, i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
-- 
1.9.1

