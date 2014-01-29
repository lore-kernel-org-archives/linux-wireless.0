Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:3582 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaA2Oce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:34 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/14] brcmfmac: remove unintended error logging
Date: Wed, 29 Jan 2014 15:32:21 +0100
Message-ID: <1391005944-3220-12-git-send-email-arend@broadcom.com> (sfid-20140129_160006_290767_00AE1BAE)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmf_contstruct_reginfo() some error logging was added by:

  commit f7c51a1a72f50870f80001ddf528a6f7f992bc16
  Author: Arend van Spriel <arend@broadcom.com>
  Date:   Wed Dec 11 16:21:21 2013 +0100

      brcmfmac: correct reporting HT40 support in wiphy htcap

This logging was not intended to be delivered and adds a lot
of messages in the log. The patch removes this logging statement.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 17170a5..843f1c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5190,9 +5190,6 @@ static s32 brcmf_construct_reginfo(struct brcmf_cfg80211_info *cfg,
 				ieee80211_channel_to_frequency(ch.chnum, band);
 			band_chan_arr[index].hw_value = ch.chnum;
 
-			brcmf_err("channel %d: f=%d bw=%d sb=%d\n",
-				  ch.chnum, band_chan_arr[index].center_freq,
-				  ch.bw, ch.sb);
 			if (ch.bw == BRCMU_CHAN_BW_40) {
 				/* assuming the order is HT20, HT40 Upper,
 				 * HT40 lower from chanspecs
-- 
1.7.10.4

