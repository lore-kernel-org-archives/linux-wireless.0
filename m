Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54994 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731863AbeGaNvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 09:51:24 -0400
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCHv2] ath10k : Fix channel survey dump
Date: Tue, 31 Jul 2018 17:41:17 +0530
Message-Id: <1533039077-1532-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180731_141132_970365_7EB518F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel active/busy time are showing incorrect(less than previous or
sometimes zero) for successive survey dump command.

example:
Survey data from wlan0
	frequency:                      5180 MHz [in use]
	channel active time:            54995 ms
	channel busy time:              432 ms
	channel receive time:           0 ms
	channel transmit time:          59 ms
Survey data from wlan0
	frequency:                      5180 MHz [in use]
	channel active time:            32592 ms
	channel busy time:              254 ms
	channel receive time:           0 ms
	channel transmit time:          0 ms

This patch fix this issue by assigning 'wmi_bss_survey_req_type'
as 'WMI_BSS_SURVEY_REQ_TYPE_READ' which accumulate survey data in
FW and send survey data to driver upon the driver request. Wrap around
is taken care by FW.

hardware used : QCA9984
firmware ver  : ver 10.4-3.5.3-00057

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
v2:
 * updated commit log.

 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f068e2b..db93ab1 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6837,7 +6837,7 @@ ath10k_mac_update_bss_chan_survey(struct ath10k *ar,
 				  struct ieee80211_channel *channel)
 {
 	int ret;
-	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
+	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-- 
2.7.4
