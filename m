Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:54050 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0K4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 06:56:35 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/16] brcmfmac: make chandef_to_chanspec() function static
Date: Tue, 27 May 2014 12:56:15 +0200
Message-ID: <1401188188-16492-4-git-send-email-arend@broadcom.com> (sfid-20140527_125642_006298_B698D8AD)
In-Reply-To: <1401188188-16492-1-git-send-email-arend@broadcom.com>
References: <1401188188-16492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function chandef_to_chanspec() was added by

    brcmfmac: determine chanspec from struct cfg80211_chan_def info

    The struct cfg80211_chan_def contains additional info to derive the
    bandwidth and side-band information of the chanspec. This patch adds
    chandef_to_chanspec() function used in IBSS join and starting AP
    operation.

However, it introduced a sparse warning because the function
is only called from within the source file wl_cfg80211.c.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index df42a10..d8fa276 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -341,8 +341,8 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
-u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
-			struct cfg80211_chan_def *ch)
+static u16 chandef_to_chanspec(struct brcmu_d11inf *d11inf,
+			       struct cfg80211_chan_def *ch)
 {
 	struct brcmu_chan ch_inf;
 	s32 primary_offset;
-- 
1.7.9.5

