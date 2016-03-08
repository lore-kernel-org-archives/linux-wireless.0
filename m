Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35112 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbcCHBCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 20:02:01 -0500
Received: by mail-qg0-f47.google.com with SMTP id y89so301114qge.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 17:02:00 -0800 (PST)
From: Steve deRosier <derosier@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Steve deRosier <steve.derosier@lairdtech.com>
Subject: [PATCH] ath6kl: ignore WMI_TXE_NOTIFY_EVENTID based on fw capability flags
Date: Mon,  7 Mar 2016 16:58:50 -0800
Message-Id: <1457398730-31088-1-git-send-email-steve.derosier@lairdtech.com> (sfid-20160308_020235_850726_DB5E2DAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Certain 6004 firmware releases redefine the WMI_TXE_NOTIFY_EVENTID event
number and sends the new event frequently. However it doesn't have the
tx-err-notify feature and thus this firmware capability flag isn't set on
the firmware package. By guarding the processing of this event by the same
method we guard the sending of the WMI_SET_TXE_NOTIFY_CMDID command, we
can ignore the spurious event that we don't know how to process.

Without this change we call cfg80211_cqm_txe_notify() with possibly bad
data.

Signed-off-by: Steve deRosier <steve.derosier@lairdtech.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a5e1de7..0b3e9c0 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1584,6 +1584,11 @@ static int ath6kl_wmi_txe_notify_event_rx(struct wmi *wmi, u8 *datap, int len,
 	if (len < sizeof(*ev))
 		return -EINVAL;
 
+	if (vif->nw_type != INFRA_NETWORK ||
+	    !test_bit(ATH6KL_FW_CAPABILITY_TX_ERR_NOTIFY,
+		      vif->ar->fw_capabilities))
+		return -EOPNOTSUPP;
+
 	if (vif->sme_state != SME_CONNECTED)
 		return -ENOTCONN;
 
-- 
1.9.1

