Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3967 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab2JJSNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:25 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] brcmfmac: fix sparse warnings
Date: Wed, 10 Oct 2012 11:13:08 -0700
Message-ID: <1349892792-4792-4-git-send-email-frankyl@broadcom.com> (sfid-20121010_201333_353869_C30B69AB)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following sparse warning is fixed:
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:2518:21: warning: symbol 'brcmf_find_wpaie' was not declared. Should it be static?
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3768:1: warning: symbol 'brcmf_set_management_ie' was not declared. Should it be static?

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b1c9be7..9c3fe1a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2674,7 +2674,7 @@ brcmf_tlv_has_ie(u8 *ie, u8 **tlvs, u32 *tlvs_len,
 	return false;
 }
 
-struct brcmf_vs_tlv *
+static struct brcmf_vs_tlv *
 brcmf_find_wpaie(u8 *parse, u32 len)
 {
 	struct brcmf_tlv *ie;
@@ -3963,7 +3963,7 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 	return ie_len + VNDR_IE_HDR_SIZE;
 }
 
-s32
+static s32
 brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 			struct net_device *ndev, s32 bssidx, s32 pktflag,
 			u8 *vndr_ie_buf, u32 vndr_ie_len)
-- 
1.7.9.5


