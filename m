Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7692F4C6D;
	Fri, 18 Sep 2026 00:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689872; cv=none; b=YSE/juEVDxJfNbA0Yes6H86m5deO4RnCnIJ7Sn8vFMu9eYiKBkJUvVJvvKewn/L2aYGLxaL25iq/g8ebgbSwD85BvHVu4JZVXaxMFwedijlCUvzZ4qIjXkZpJ3bFKfGXPxYZDYsrQXQXIPGTOrML7a8t8qxBXhxLYvqezpLVluc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689872; c=relaxed/simple;
	bh=1vVUpsL01Hk6U5pBubrJF++MINGQNt97WMwbDKbPEvA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=g1ADMO9hRoUdY4EPSyaqZ46tyDio53mjmOfQtOV/mVA2PTU5akeqi36jJ8Onvrl+vL+EhjS/EhvYjNlrEebz8mvaT+PvaVQi2YUFxOXZkwK/xzK+Ys1XFXy2U6XB6kcfPsrTui3lJcu5EPuvUi67Hgv/a/pECGqLNYAuyruimTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6n1lSQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6n1lSQM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD5A6C2BCB3;
	Fri, 18 Sep 2026 00:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789689871;
	bh=1vVUpsL01Hk6U5pBubrJF++MINGQNt97WMwbDKbPEvA=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=A6n1lSQMsTOCs8c5euNI53dvMoTGeAoAeRPYpBU07X+a5qGNp3O4jxMgVB1H5aasz
	 YW3kIfBtM9PCu78Qnp1pJmK5+S3znAfSSpUtGUiUvw6A3udf2v5CWxI4z1XNFQICoV
	 ooCbBjZ5QKbaLRR3VK9rwUKtqliJbbmNqqghA7M9ZlXok11arEtMISNkmeoCZO/Oq4
	 gujfOvus/c8/z3hwsQb/NrGmMaBPZFSx8yBsbCFqpl0Ke9y58y27lBkJaL0xS2Ew9U
	 wQwXmjV9dbhSLccOGMk+PFN2MBtesawt8epAlg1F1pc+erVmX8dlz/rRgcQCzP/laJ
	 Mt5CC29qg1SKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F29C982D2;
	Fri, 18 Sep 2026 00:04:31 +0000 (UTC)
From: David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org>
Date: Fri, 18 Sep 2026 02:04:22 +0200
Subject: [PATCH RFC] wifi: ath10k: skip completion wait for pairwise key
 removal
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-ath10k-del-v1-1-53cd7a7d682b@ixit.cz>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDS0Nz3cSSDEODbN2U1BzdFMs0S1Oz1FRDQzNzJaCGgqLUtMwKsGHRSkF
 uzkqxEMHi0qSs1OQSkDFKtbUAf3SBRnMAAAA=
X-Change-ID: 20260917-ath10k-del-d9f956ee1167
To: Jeff Johnson <jjohnson@kernel.org>, 
 James Prestwood <prestwoj@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org, 
 David Heidelberg <david@ixit.cz>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6103; i=david@ixit.cz;
 h=from:subject:message-id;
 bh=FELe9NmnHc/Z1AYZfWNf8CZnzmbSuiDQc/9zq9Hq4ec=;
 b=owEBbQKS/ZANAwAIAWACP8TTSSByAcsmYgBqrIAO+KO32+sfEQMGmqCkJT59g32a8tMUC+aHU
 3KgUSRtui2JAjMEAAEIAB0WIQTXegnP7twrvVOnBHRgAj/E00kgcgUCaqyADgAKCRBgAj/E00kg
 clX9D/4tO8IZM5DVpv4uC5hOfA4JXfKNbHMdfu403oIAq7wmEY3Cfa9mAN85xaiCwbYAAR4NbuL
 kP/uIMpQzOnpSTNZP66CMC0neDE+8iABDxRdCAfCO3QxqPnhdOyBZeK6NRcYMxJNeDleLDkOrpm
 hFuY/lVPaUxZTroisSTfumlQMl/zVaPktFCUNZFgMpnVsECOO/YxStj0ZxyZEJQeYZEQJ50aXcR
 NClyajPMo0+oOxmym4UsAp5O8B3jKi3rWARUe9X/SomAZMP7NiFBKtCiZ2j9FoIbb8x0Kxjkz89
 xX4HslBOF67uSKDtdWfLZuBwdReXMzfQUrzc7xRbnL4tNN/e1PIv063nDgv7UohSQ5VL9JgyP1+
 ZOHbKEqsN80keWy7CNQ7jKETFso8inwBiBfDLQBQqd3xidLRFXwDJFqtwCumtzL7qVN+FNEdzJC
 d5awthuuA/G/3+sNz3rSKhCALBfuFr9XQfLJyqXRqRRgcbmMawXPnqvRnff8nfZNy303ZTBbpPW
 lIbp+5OORDdxgrFmqaUPv3VH1Qfd/qxGls67rdNEK/HzfrOvw9CApNYpstVAZKjWPGUcKJQCm2f
 H05It/D9VsLskmrWn7wDUKeikseRXB9/d1BQ7V08uOqR3Edd80vh+xVSMZH0A92XSCAidkE7tX5
 yq6UAurYDl20cng==
X-Developer-Key: i=david@ixit.cz; a=openpgp;
 fpr=D77A09CFEEDC2BBD53A7047460023FC4D3492072
X-Endpoint-Received: by B4 Relay for david@ixit.cz/default with auth_id=355
X-Original-From: David Heidelberg <david@ixit.cz>
Reply-To: david@ixit.cz

From: David Heidelberg <david@ixit.cz>

When removing a pairwise key, ath10k_send_key() sends a
WMI_VDEV_INSTALL_KEY with WMI_CIPHER_NONE and no key data. On WCN3990
the firmware never answers that with an HTT security indication, so
ath10k_install_key() always sleeps for the full 3 s and then fails:

    [  117.285854] wlan0: deauthenticating from XX:XX:XX:XX:XX:XX by local choice (Reason: 3=DEAUTH_LEAVING)
    [  120.302934] ath10k_snoc 18800000.wifi: failed to install key for vdev 0 peer XX:XX:XX:XX:XX:XX: -110
    [  120.302996] wlan0: failed to remove key (0, XX:XX:XX:XX:XX:XX) from hardware (-110)

The indication is missing, not late. Tracing mac80211:drv_set_key and
the ath10k "sec ind" debug message on WCN3990 with firmware
WLAN.HL.2.0.c8-00050-QCAHLSWMTPLZ-1.435283.1.441421.1 across a
disconnect/reconnect shows no indication at all for the pairwise
removal, while both installs on reconnect are acknowledged within 2 ms:

    866.899253: drv_set_key: sta:AP cmd: 1 flags=0x9, keyidx=0
    866.899270: ath10k_log_dbg: wmi tlv vdev install key
    869.920623: ath10k_log_warn: failed to install key ... peer AP: -110
    880.701296: drv_set_key: sta:AP cmd: 0 flags=0x8, keyidx=0
    880.701318: ath10k_log_dbg: wmi tlv vdev install key
    880.701584: ath10k_log_dbg: sec ind peer_id 86 unicast 1 type 6
    880.716075: drv_set_key: sta:GROUP cmd: 0 flags=0x0, keyidx=2
    880.716088: ath10k_log_dbg: wmi tlv vdev install key
    880.718250: ath10k_log_dbg: sec ind peer_id 86 unicast 0 type 6

Shortening the timeout would still stall every disconnect and still log
a failure for a key the firmware has already dropped. Add a
no_pairwise_key_del_ind hw_params flag, set it for WCN3990 only, and
skip the wait for pairwise removal when it is set. Other firmware
families have been observed to acknowledge the cipher-none deletion;
skipping the wait there would leave a stale indication that completes
the next installation's wait early, so they keep the unconditional wait.

Group-key removal is left alone on all targets: ath10k_send_key()
implements it as an installation of a random key with the original
cipher, which the firmware does acknowledge, and ieee80211_key_replace()
issues the following SET_KEY right after the DISABLE_KEY.

Tested on WCN3990 (SDM845): the pairwise removal returns immediately and
the reconnect installs are acknowledged as before.

From previous mailing list discussion assumed it's relevant for QCA6174 HW3.0.

Assisted-by: LLM
Signed-off-by: David Heidelberg <david@ixit.cz>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 ++
 drivers/net/wireless/ath/ath10k/hw.h   | 6 ++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7c2939cbde5f0..3177fa415ea06 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -342,16 +342,17 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.fw_diag_ce_download = false,
 		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
 		.delay_unmap_buffer = false,
 		.mcast_frame_registration = false,
+		.no_pairwise_key_del_ind = true,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
 		.dev_id = QCA6174_2_1_DEVICE_ID,
 		.bus = ATH10K_BUS_PCI,
 		.name = "qca6174 hw3.2",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -741,16 +742,17 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.fw_diag_ce_download = false,
 		.credit_size_workaround = false,
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = true,
 		.use_fw_tx_credits = false,
 		.delay_unmap_buffer = true,
 		.mcast_frame_registration = false,
+		.no_pairwise_key_del_ind = true,
 	},
 };
 
 static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX] = "wmi-mgmt-rx",
 	[ATH10K_FW_FEATURE_WMI_10X] = "wmi-10.x",
 	[ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX] = "has-wmi-mgmt-tx",
 	[ATH10K_FW_FEATURE_NO_P2P] = "no-p2p",
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index cd468b24bd333..a6abab83df7df 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -633,16 +633,22 @@ struct ath10k_hw_params {
 	bool hw_restart_disconnect;
 
 	bool use_fw_tx_credits;
 
 	bool delay_unmap_buffer;
 
 	/* The hardware support multicast frame registrations */
 	bool mcast_frame_registration;
+
+	/* Firmware sends no HTT security indication for a pairwise key
+	 * removal (WMI_CIPHER_NONE install), so waiting for one would only
+	 * time out.
+	 */
+	bool no_pairwise_key_del_ind;
 };
 
 struct htt_resp;
 struct htt_data_tx_completion_ext;
 struct htt_rx_ring_rx_desc_offsets;
 
 /* Defines needed for Rx descriptor abstraction */
 struct ath10k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8e604697d6c20..653bc70a9e6af 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -319,16 +319,21 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 
 	if (arvif->nohwcrypt)
 		return 1;
 
 	ret = ath10k_send_key(arvif, key, cmd, macaddr, flags);
 	if (ret)
 		return ret;
 
+	/* Group-key removal installs a replacement key and is acknowledged. */
+	if (cmd == DISABLE_KEY && !(flags & WMI_KEY_GROUP) &&
+	    ar->hw_params.no_pairwise_key_del_ind)
+		return 0;
+
 	time_left = wait_for_completion_timeout(&ar->install_key_done, 3 * HZ);
 	if (time_left == 0)
 		return -ETIMEDOUT;
 
 	return 0;
 }
 
 static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,

---
base-commit: 7079a12d7506b07fb53b54a664bfad5fa9b16d70
change-id: 20260917-ath10k-del-d9f956ee1167

Best regards,
--  
David Heidelberg <david@ixit.cz>


