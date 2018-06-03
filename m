Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34319 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbeFCSWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:13 -0400
Received: by mail-lf0-f68.google.com with SMTP id o9-v6so21774219lfk.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:12 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 03/12] ath10k: add bus type check in ath10k_init_hw_params
Date: Sun,  3 Jun 2018 20:20:20 +0200
Message-Id: <20180603182029.8914-4-erik.stromdahl@gmail.com> (sfid-20180603_202230_659877_F6B10AF8)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus type is used together with the other hw parameters
to find a matching entry in ath10k_hw_params_list for the device.

This is necessary since HL devices can have the same dev_id and
target_version as a corresponding LL device (same chipset) and
yet use a totally different configuration.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 16 +++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  8 --------
 drivers/net/wireless/ath/ath10k/hw.h   |  9 +++++++++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ebc8ea7cfd40..a146c83d6ff9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -65,6 +65,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA988X_HW_2_0_VERSION,
 		.dev_id = QCA988X_2_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -128,6 +129,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA9887_HW_1_0_VERSION,
 		.dev_id = QCA9887_1_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca9887 hw1.0",
 		.patch_load_addr = QCA9887_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -160,6 +162,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA6174_HW_2_1_VERSION,
 		.dev_id = QCA6164_2_1_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca6164 hw2.1",
 		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -191,6 +194,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA6174_HW_2_1_VERSION,
 		.dev_id = QCA6174_2_1_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca6174 hw2.1",
 		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -222,6 +226,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA6174_HW_3_0_VERSION,
 		.dev_id = QCA6174_2_1_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca6174 hw3.0",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -253,6 +258,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA6174_HW_3_2_VERSION,
 		.dev_id = QCA6174_2_1_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca6174 hw3.2",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -287,6 +293,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
 		.dev_id = QCA99X0_2_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca99x0 hw2.0",
 		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -324,6 +331,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
 		.dev_id = QCA9984_1_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca9984/qca9994 hw1.0",
 		.patch_load_addr = QCA9984_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -366,6 +374,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
 		.dev_id = QCA9888_2_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca9888 hw2.0",
 		.patch_load_addr = QCA9888_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -407,6 +416,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
 		.dev_id = QCA9377_1_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca9377 hw1.0",
 		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -438,6 +448,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
 		.dev_id = QCA9377_1_0_DEVICE_ID,
+		.bus = ATH10K_BUS_PCI,
 		.name = "qca9377 hw1.1",
 		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
@@ -471,6 +482,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
+		.bus = ATH10K_BUS_AHB,
 		.name = "qca4019 hw1.0",
 		.patch_load_addr = QCA4019_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
@@ -509,6 +521,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
+		.bus = ATH10K_BUS_PCI,
 		.name = "wcn3990 hw1.0",
 		.continuous_frag_desc = true,
 		.tx_chain_mask = 0x7,
@@ -1871,7 +1884,8 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	for (i = 0; i < ARRAY_SIZE(ath10k_hw_params_list); i++) {
 		hw_params = &ath10k_hw_params_list[i];
 
-		if (hw_params->id == ar->target_version &&
+		if (hw_params->bus == ar->hif.bus &&
+		    hw_params->id == ar->target_version &&
 		    hw_params->dev_id == ar->dev_id)
 			break;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f3e94531bbee..d0c7b821a13e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -91,14 +91,6 @@
 
 struct ath10k;
 
-enum ath10k_bus {
-	ATH10K_BUS_PCI,
-	ATH10K_BUS_AHB,
-	ATH10K_BUS_SDIO,
-	ATH10K_BUS_USB,
-	ATH10K_BUS_SNOC,
-};
-
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 {
 	switch (bus) {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 23467e9fefeb..53a7778c63a9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -21,6 +21,14 @@
 
 #include "targaddrs.h"
 
+enum ath10k_bus {
+	ATH10K_BUS_PCI,
+	ATH10K_BUS_AHB,
+	ATH10K_BUS_SDIO,
+	ATH10K_BUS_USB,
+	ATH10K_BUS_SNOC,
+};
+
 #define ATH10K_FW_DIR			"ath10k"
 
 #define QCA988X_2_0_DEVICE_ID_UBNT   (0x11ac)
@@ -501,6 +509,7 @@ struct ath10k_hw_clk_params {
 struct ath10k_hw_params {
 	u32 id;
 	u16 dev_id;
+	enum ath10k_bus bus;
 	const char *name;
 	u32 patch_load_addr;
 	int uart_pin;
-- 
2.17.0
