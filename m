Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:6278 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbeDRLlG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:41:06 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 19/22] staging: wilc1000: rename goto label '_fail_' linux naming convension
Date: Wed, 18 Apr 2018 17:09:21 +0530
Message-ID: <1524051564-15497-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134110_485400_49DC6F1C)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename '_fail_' goto label to have name as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 92 +++++++++++++++++------------------
 drivers/staging/wilc1000/wilc_sdio.c  | 84 ++++++++++++++++----------------
 drivers/staging/wilc1000/wilc_wlan.c  | 16 +++---
 3 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2236967..8f97c62 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -338,16 +338,16 @@ int wilc_wlan_get_firmware(struct net_device *dev)
 	netdev_info(dev, "loading firmware %s\n", firmware);
 
 	if (!(&vif->ndev->dev))
-		goto _fail_;
+		goto fail;
 
 	if (request_firmware(&wilc_firmware, firmware, wilc->dev) != 0) {
 		netdev_err(dev, "%s - firmware not available\n", firmware);
 		ret = -1;
-		goto _fail_;
+		goto fail;
 	}
 	wilc->firmware = wilc_firmware;
 
-_fail_:
+fail:
 
 	return ret;
 }
@@ -416,193 +416,193 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	*(int *)c_val = 1;
 
 	if (!wilc_wlan_cfg_set(vif, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = INFRASTRUCTURE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = RATE_AUTO;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = G_SHORT_PREAMBLE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = AUTO_PROT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = ACTIVE_SCAN;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = SITE_SURVEY_OFF;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	*((int *)c_val) = 0xffff;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	*((int *)c_val) = 2346;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = NO_POWERSAVE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = NO_SECURITY; /* NO_ENCRYPT, 0x79 */
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = OPEN_SYSTEM;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	strcpy(c_val, "123456790abcdef1234567890");
 	if (!wilc_wlan_cfg_set(vif, 0, WID_WEP_KEY_VALUE, c_val,
 			       (strlen(c_val) + 1), 0, 0))
-		goto _fail_;
+		goto fail;
 
 	strcpy(c_val, "12345678");
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	strcpy(c_val, "password");
 	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1),
 			       0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 192;
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 3;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 3;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = NORMAL_ACK;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1,
 			       0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 48;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 28;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	*((int *)c_val) = 100;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = REKEY_DISABLE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	*((int *)c_val) = 84600;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	*((int *)c_val) = 500;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = G_SELF_CTS_PROT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = HT_MIXED_MODE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = DETECT_PROTECT_REPORT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
 			       0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 0;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = MIMO_MODE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 7;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0,
 			       0))
-		goto _fail_;
+		goto fail;
 
 	c_val[0] = 1;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1,
 			       1, 1))
-		goto _fail_;
+		goto fail;
 
 	return 0;
 
-_fail_:
+fail:
 	return -1;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a088999..087ad42 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -274,7 +274,7 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10c data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	cmd.address = 0x10d;
@@ -282,7 +282,7 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10d data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	cmd.address = 0x10e;
@@ -290,11 +290,11 @@ static int sdio_set_func0_csa_address(struct wilc *wilc, u32 adr)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10e data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	return 1;
-_fail_:
+fail:
 	return 0;
 }
 
@@ -312,7 +312,7 @@ static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x10 data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	cmd.address = 0x11;
@@ -320,11 +320,11 @@ static int sdio_set_func0_block_size(struct wilc *wilc, u32 block_size)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x11 data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	return 1;
-_fail_:
+fail:
 	return 0;
 }
 
@@ -348,18 +348,18 @@ static int sdio_set_func1_block_size(struct wilc *wilc, u32 block_size)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x110 data...\n");
-		goto _fail_;
+		goto fail;
 	}
 	cmd.address = 0x111;
 	cmd.data = (u8)(block_size >> 8);
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Failed cmd52, set 0x111 data...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	return 1;
-_fail_:
+fail:
 	return 0;
 }
 
@@ -387,7 +387,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd 52, read reg (%08x) ...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 	} else {
 		struct sdio_cmd53 cmd;
@@ -396,7 +396,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		 *      set the AHB address
 		 **/
 		if (!sdio_set_func0_csa_address(wilc, addr))
-			goto _fail_;
+			goto fail;
 
 		cmd.read_write = 1;
 		cmd.function = 0;
@@ -410,13 +410,13 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53, write reg (%08x)...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 	}
 
 	return 1;
 
-_fail_:
+fail:
 
 	return 0;
 }
@@ -470,13 +470,13 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.block_size = block_size;
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
-				goto _fail_;
+				goto fail;
 		}
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], block send...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 		if (addr > 0)
 			addr += nblk * block_size;
@@ -493,19 +493,19 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
-				goto _fail_;
+				goto fail;
 		}
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], bytes send...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 	}
 
 	return 1;
 
-_fail_:
+fail:
 
 	return 0;
 }
@@ -526,14 +526,14 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd 52, read reg (%08x) ...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 		*data = cmd.data;
 	} else {
 		struct sdio_cmd53 cmd;
 
 		if (!sdio_set_func0_csa_address(wilc, addr))
-			goto _fail_;
+			goto fail;
 
 		cmd.read_write = 0;
 		cmd.function = 0;
@@ -548,7 +548,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53, read reg (%08x)...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 	}
 
@@ -556,7 +556,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 
 	return 1;
 
-_fail_:
+fail:
 
 	return 0;
 }
@@ -610,13 +610,13 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.block_size = block_size;
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
-				goto _fail_;
+				goto fail;
 		}
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], block read...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 		if (addr > 0)
 			addr += nblk * block_size;
@@ -633,19 +633,19 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
-				goto _fail_;
+				goto fail;
 		}
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
 				"Failed cmd53 [%x], bytes read...\n", addr);
-			goto _fail_;
+			goto fail;
 		}
 	}
 
 	return 1;
 
-_fail_:
+fail:
 
 	return 0;
 }
@@ -684,7 +684,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Fail cmd 52, enable csa...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	/**
@@ -692,7 +692,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	 **/
 	if (!sdio_set_func0_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail cmd 52, set func 0 block size...\n");
-		goto _fail_;
+		goto fail;
 	}
 	g_sdio.block_size = WILC_SDIO_BLOCK_SIZE;
 
@@ -708,7 +708,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	if (ret) {
 		dev_err(&func->dev,
 			"Fail cmd 52, set IOE register...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	/**
@@ -725,7 +725,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 		if (ret) {
 			dev_err(&func->dev,
 				"Fail cmd 52, get IOR register...\n");
-			goto _fail_;
+			goto fail;
 		}
 		if (cmd.data == 0x2)
 			break;
@@ -733,7 +733,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 
 	if (loop <= 0) {
 		dev_err(&func->dev, "Fail func 1 is not ready...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	/**
@@ -741,7 +741,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	 **/
 	if (!sdio_set_func1_block_size(wilc, WILC_SDIO_BLOCK_SIZE)) {
 		dev_err(&func->dev, "Fail set func 1 block size...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	/**
@@ -755,7 +755,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	ret = wilc_sdio_cmd52(wilc, &cmd);
 	if (ret) {
 		dev_err(&func->dev, "Fail cmd 52, set IEN register...\n");
-		goto _fail_;
+		goto fail;
 	}
 
 	/**
@@ -764,7 +764,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 	if (!resume) {
 		if (!sdio_read_reg(wilc, 0x1000, &chipid)) {
 			dev_err(&func->dev, "Fail cmd read chip id...\n");
-			goto _fail_;
+			goto fail;
 		}
 		dev_err(&func->dev, "chipid (%08x)\n", chipid);
 		if ((chipid & 0xfff) > 0x2a0)
@@ -777,7 +777,7 @@ static int sdio_init(struct wilc *wilc, bool resume)
 
 	return 1;
 
-_fail_:
+fail:
 
 	return 0;
 }
@@ -907,7 +907,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				dev_err(&func->dev,
 					"Failed cmd52, set 0xf8 data (%d) ...\n",
 					__LINE__);
-				goto _fail_;
+				goto fail;
 			}
 		}
 		return 1;
@@ -940,7 +940,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 						dev_err(&func->dev,
 							"Failed cmd52, set 0xf8 data (%d) ...\n",
 							__LINE__);
-						goto _fail_;
+						goto fail;
 					}
 				}
 				if (!ret)
@@ -948,7 +948,7 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 				flags >>= 1;
 			}
 			if (!ret)
-				goto _fail_;
+				goto fail;
 			for (i = g_sdio.nint; i < MAX_NUM_INT; i++) {
 				if (flags & 1)
 					dev_err(&func->dev,
@@ -983,11 +983,11 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 			dev_err(&func->dev,
 				"Failed cmd52, set 0xf6 data (%d) ...\n",
 				__LINE__);
-			goto _fail_;
+			goto fail;
 		}
 	}
 	return 1;
-_fail_:
+fail:
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index bcbb923..43cf9b8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -996,11 +996,11 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 
 		if (!ret) {
 			ret = -EIO;
-			goto _fail_;
+			goto fail;
 		}
 	} while (offset < buffer_size);
 
-_fail_:
+fail:
 
 	kfree(dma_buffer);
 
@@ -1421,12 +1421,12 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->hif_func->hif_init(wilc, false)) {
 		ret = -EIO;
-		goto _fail_;
+		goto fail;
 	}
 
 	if (!wilc_wlan_cfg_init()) {
 		ret = -ENOBUFS;
-		goto _fail_;
+		goto fail;
 	}
 
 	if (!wilc->tx_buffer)
@@ -1434,7 +1434,7 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
-		goto _fail_;
+		goto fail;
 	}
 
 	if (!wilc->rx_buffer)
@@ -1442,17 +1442,17 @@ int wilc_wlan_init(struct net_device *dev)
 
 	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
-		goto _fail_;
+		goto fail;
 	}
 
 	if (!init_chip(dev)) {
 		ret = -EIO;
-		goto _fail_;
+		goto fail;
 	}
 
 	return 1;
 
-_fail_:
+fail:
 
 	kfree(wilc->rx_buffer);
 	wilc->rx_buffer = NULL;
-- 
2.7.4
