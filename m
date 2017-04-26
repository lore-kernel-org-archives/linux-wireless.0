Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44760 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040667AbdDZOlC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 10:41:02 -0400
From: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
        Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
Subject: [PATCH] ath10k : Fix channel survey dump
Date: Wed, 26 Apr 2017 20:11:38 +0530
Message-ID: <1493217698-22451-1-git-send-email-c_vnaral@qti.qualcomm.com> (sfid-20170426_164117_796814_EBEB59D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel active/busy time are showing incorrect
(less than previous or sometimes zero) for
successive survey dump command.

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
as 'WMI_BSS_SURVEY_REQ_TYPE_READ'.

Firmware ver 10.4-3.4-00082
Hardware QCA4019

Signed-off-by: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9977829..87a9b55 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6621,7 +6621,7 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 				  struct ieee80211_channel *channel)
 {
 	int ret;
-	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ_CLEAR;
+	enum wmi_bss_survey_req_type type = WMI_BSS_SURVEY_REQ_TYPE_READ;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-- 
1.7.9.5
