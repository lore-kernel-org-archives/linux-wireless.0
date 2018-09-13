Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36678 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbeIMTz1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 15:55:27 -0400
Received: by mail-lf1-f68.google.com with SMTP id x207-v6so5050850lff.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Sep 2018 07:45:35 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 2/2] ath10k: remove num_peers in hw_params for most targets
Date: Thu, 13 Sep 2018 16:45:06 +0200
Message-Id: <20180913144506.8272-2-erik.stromdahl@gmail.com> (sfid-20180913_164540_564785_B2B9951B)
In-Reply-To: <20180913144506.8272-1-erik.stromdahl@gmail.com>
References: <20180913144506.8272-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From commit "ath10k: add per target config of max_num_peers",
the num_peers value in struct ath10k_hw_params is used to override
the value obtained from the WMI op version in the firmware file.

Currently, only high latency devices (USB and SDIO) need to use this
value, since the value obtained from the WMI op version is not
applicable for these devices.

Many devices in ath10k_hw_params_list have the wrong value set.

An example of this is the QCA9880 hw2.0 chipset that had (before this
patch) num_peers set to TARGET_TLV_NUM_PEERS although the firmware
uses WMI version ATH10K_FW_WMI_OP_VERSION_10_2_4.

Using the wrong value for the QCA9880 chip results in a fw crash:

ath10k_pci 0000:01:00.0: firmware crashed! (guid ddf39880-3e64-4edf-b4e4-979d31724503)
ath10k_pci 0000:01:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 0
ath10k_pci 0000:01:00.0: firmware ver 10.2.4-1.0-00037 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 a4a52adb
ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
ath10k_pci 0000:01:00.0: htt-ver 0.0 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1
ath10k_pci 0000:01:00.0: firmware register dump:
ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3 0x009B54B7 0x00955B31
ath10k_pci 0000:01:00.0: [04]: 0x009B54B7 0x00060530 0x00000011 0x00400000
ath10k_pci 0000:01:00.0: [08]: 0x000001B8 0x00000007 0x00443138 0x00955A00
ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000 0x009B548E 0x009B54AB
ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094078E 0x00000000 0x00000000
ath10k_pci 0000:01:00.0: [20]: 0x409B54B7 0x0040AC64 0x00400000 0x00000087
ath10k_pci 0000:01:00.0: [24]: 0x809A3831 0x0040ACC4 0x000001B1 0xC09B54B7
ath10k_pci 0000:01:00.0: [28]: 0x809A2F08 0x0040AD04 0x00410410 0x00000001
ath10k_pci 0000:01:00.0: [32]: 0x80988856 0x0040AD24 0x00410410 0x00000001
ath10k_pci 0000:01:00.0: [36]: 0x8098AF64 0x0040AD44 0x00410410 0x00000001
ath10k_pci 0000:01:00.0: [40]: 0x809B5DEC 0x0040AD84 0x00410410 0x00410FF4
ath10k_pci 0000:01:00.0: [44]: 0x809B1F20 0x0040ADA4 0x00400000 0x00416C54
ath10k_pci 0000:01:00.0: [48]: 0x809C0295 0x0040ADE4 0x0040AE08 0x00411DC8
ath10k_pci 0000:01:00.0: [52]: 0x809486FA 0x0040AE04 0x00000001 0x00000000
ath10k_pci 0000:01:00.0: [56]: 0x80948E2C 0x0040AEA4 0x0041F290 0x004123D4
ath10k_pci 0000:01:00.0: Copy Engine register dump:
ath10k_pci 0000:01:00.0: [00]: 0x00057400  10  10   3   3
ath10k_pci 0000:01:00.0: [01]: 0x00057800   3   3   8   9
ath10k_pci 0000:01:00.0: [02]: 0x00057c00   2   2   1   2
ath10k_pci 0000:01:00.0: [03]: 0x00058000   1   1   2   1
ath10k_pci 0000:01:00.0: [04]: 0x00058400   0   0  40   0
ath10k_pci 0000:01:00.0: [05]: 0x00058800   1   1   0   1
ath10k_pci 0000:01:00.0: [06]: 0x00058c00   0   0   0   0
ath10k_pci 0000:01:00.0: [07]: 0x00059000   0   0   0   0

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 039ddafdb3b9..11ce6c886d7c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -86,7 +86,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -120,7 +119,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -156,7 +154,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -191,7 +188,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -226,7 +222,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -261,7 +256,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -299,7 +293,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -340,7 +333,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 11,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -388,7 +380,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 1560,
 		.vht160_mcs_tx_highest = 1560,
 		.n_cipher_suites = 11,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -433,7 +424,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 780,
 		.vht160_mcs_tx_highest = 780,
 		.n_cipher_suites = 11,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -468,7 +458,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -505,7 +494,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 8,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
@@ -599,7 +587,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.vht160_mcs_rx_highest = 0,
 		.vht160_mcs_tx_highest = 0,
 		.n_cipher_suites = 11,
-		.num_peers = TARGET_TLV_NUM_PEERS,
 		.ast_skid_limit = 0x10,
 		.num_wds_entries = 0x20,
 		.target_64bit = false,
-- 
2.18.0
