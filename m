Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EE0C00319
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 058432077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaZf7nkT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfBUTbX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:23 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:47015 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfBUTbW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:22 -0500
Received: by mail-ot1-f68.google.com with SMTP id c18so24347191otl.13
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DF0SiowQyPUQnuJ9AFDaZAV91fRQ5yIDn5gEW9rb228=;
        b=YaZf7nkToE+oBRgzuDs38fBGx5I53Rw4LxuV+le8WIe8JFnizyh8YB7hiTNvt9+XVt
         KtT4jz5dbZxSQLtzS1iBetFGG2ft3WqxvLvsfM3ka+q4NwXhY/qlIZYCxashqumHiTa9
         ofzkGBDX7bj6Y5AmvJxY3rk4s/6cr8dl4b2vAZrt4/ME/A8KEQI34TcMyAoXM+Yb7RYV
         AXU5mdtA/zVa1RnDd/KrZAgA1q3xn+vBSH6NfVlCQUOWP4GERqsgAWIYdFZP5VkJHD2l
         9FG5FGCUqvk5zH7ci8CaKRwG9bXmWihFhVvEs/TArHrgdql04SrSjsUlJ5CzWZ+nEpr9
         lJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DF0SiowQyPUQnuJ9AFDaZAV91fRQ5yIDn5gEW9rb228=;
        b=OFkqvL5Pk8jSwdIAkaoc1dbS3H0R8fqndEBmtWDAOcczb83xEVudQVuDKik59UB9yG
         vk3z5nGmsf5fGBnIXoqvfkxqH9yfbBWeHwMDyYaJrJIsFP+puPKhw22XrbGaJryYJdbB
         bFUXyTib1u0mkLtSddY7w3elAlMJQjUsf6SRO/n8cDefx2droczZhFseG+oNGuZjvkc1
         8G7QTRX0a9RGe2TURKsv1uzcj5rodAeMOxWblQeefJ9Z+CoarKkTgrIZYjY3z+Jb/3LU
         4Ub8KcEg9ZB3+LlnqsziCsYxJ+ctFGAgmyYS/t7BzTSk35wNawjuSWoqDOsDXb3mt8+m
         fDyw==
X-Gm-Message-State: AHQUAua9qbyG9TPFndT5QGO8fMIyqTo3TdOn4kcWeUzUu1m3luBIkSNH
        Lo3K6TSD8BVy0ao2xFrzuGMzW1zS
X-Google-Smtp-Source: AHgI3IYGsti0mx+aycaX0zYJXV0rfyaPT6sgB2IBxmGhS2Quh3fJJjzBB5hNUffWXUKk4URDs/I0XA==
X-Received: by 2002:a05:6830:2096:: with SMTP id y22mr123906otq.266.1550777481579;
        Thu, 21 Feb 2019 11:31:21 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:20 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/8] rtlwifi: Fix errors in spacing in wifi.h
Date:   Thu, 21 Feb 2019 13:31:08 -0600
Message-Id: <20190221193115.30848-2-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Checkpatch.pl report problems in wifi.h where spaces are missing, as well
as extraneous spaces.

There are no changes in the generated code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 170 ++++++++++----------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 1ad71fb0ebf2..858cd798d5cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -413,8 +413,8 @@ enum hw_variables {
 	HW_VAR_MULTICAST_REG = 0x1,
 	HW_VAR_BASIC_RATE = 0x2,
 	HW_VAR_BSSID = 0x3,
-	HW_VAR_MEDIA_STATUS= 0x4,
-	HW_VAR_SECURITY_CONF= 0x5,
+	HW_VAR_MEDIA_STATUS = 0x4,
+	HW_VAR_SECURITY_CONF = 0x5,
 	HW_VAR_BEACON_INTERVAL = 0x6,
 	HW_VAR_ATIM_WINDOW = 0x7,
 	HW_VAR_LISTEN_INTERVAL = 0x8,
@@ -431,7 +431,7 @@ enum hw_variables {
 	HW_VAR_ACK_PREAMBLE = 0x13,
 	HW_VAR_CW_CONFIG = 0x14,
 	HW_VAR_CW_VALUES = 0x15,
-	HW_VAR_RATE_FALLBACK_CONTROL= 0x16,
+	HW_VAR_RATE_FALLBACK_CONTROL = 0x16,
 	HW_VAR_CONTENTION_WINDOW = 0x17,
 	HW_VAR_RETRY_COUNT = 0x18,
 	HW_VAR_TR_SWITCH = 0x19,
@@ -1456,15 +1456,15 @@ struct rtl_io {
 	/*PCI IO map */
 	unsigned long pci_base_addr;	/*device I/O address */
 
-	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
-	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
-	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
+	void (*write8_async)(struct rtl_priv *rtlpriv, u32 addr, u8 val);
+	void (*write16_async)(struct rtl_priv *rtlpriv, u32 addr, u16 val);
+	void (*write32_async)(struct rtl_priv *rtlpriv, u32 addr, u32 val);
 	void (*writen_sync)(struct rtl_priv *rtlpriv, u32 addr, void *buf,
 			     u16 len);
 
-	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
-	u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	u8 (*read8_sync)(struct rtl_priv *rtlpriv, u32 addr);
+	u16 (*read16_sync)(struct rtl_priv *rtlpriv, u32 addr);
+	u32 (*read32_sync)(struct rtl_priv *rtlpriv, u32 addr);
 
 };
 
@@ -2210,44 +2210,44 @@ struct rtl_int {
 };
 
 struct rtl_hal_ops {
-	int (*init_sw_vars) (struct ieee80211_hw *hw);
-	void (*deinit_sw_vars) (struct ieee80211_hw *hw);
+	int (*init_sw_vars)(struct ieee80211_hw *hw);
+	void (*deinit_sw_vars)(struct ieee80211_hw *hw);
 	void (*read_chip_version)(struct ieee80211_hw *hw);
-	void (*read_eeprom_info) (struct ieee80211_hw *hw);
-	void (*interrupt_recognized) (struct ieee80211_hw *hw,
+	void (*read_eeprom_info)(struct ieee80211_hw *hw);
+	void (*interrupt_recognized)(struct ieee80211_hw *hw,
 				      struct rtl_int *intvec);
-	int (*hw_init) (struct ieee80211_hw *hw);
-	void (*hw_disable) (struct ieee80211_hw *hw);
-	void (*hw_suspend) (struct ieee80211_hw *hw);
-	void (*hw_resume) (struct ieee80211_hw *hw);
-	void (*enable_interrupt) (struct ieee80211_hw *hw);
-	void (*disable_interrupt) (struct ieee80211_hw *hw);
-	int (*set_network_type) (struct ieee80211_hw *hw,
+	int (*hw_init)(struct ieee80211_hw *hw);
+	void (*hw_disable)(struct ieee80211_hw *hw);
+	void (*hw_suspend)(struct ieee80211_hw *hw);
+	void (*hw_resume)(struct ieee80211_hw *hw);
+	void (*enable_interrupt)(struct ieee80211_hw *hw);
+	void (*disable_interrupt)(struct ieee80211_hw *hw);
+	int (*set_network_type)(struct ieee80211_hw *hw,
 				 enum nl80211_iftype type);
 	void (*set_chk_bssid)(struct ieee80211_hw *hw,
 				bool check_bssid);
-	void (*set_bw_mode) (struct ieee80211_hw *hw,
+	void (*set_bw_mode)(struct ieee80211_hw *hw,
 			     enum nl80211_channel_type ch_type);
-	 u8(*switch_channel) (struct ieee80211_hw *hw);
-	void (*set_qos) (struct ieee80211_hw *hw, int aci);
-	void (*set_bcn_reg) (struct ieee80211_hw *hw);
-	void (*set_bcn_intv) (struct ieee80211_hw *hw);
-	void (*update_interrupt_mask) (struct ieee80211_hw *hw,
+	 u8 (*switch_channel)(struct ieee80211_hw *hw);
+	void (*set_qos)(struct ieee80211_hw *hw, int aci);
+	void (*set_bcn_reg)(struct ieee80211_hw *hw);
+	void (*set_bcn_intv)(struct ieee80211_hw *hw);
+	void (*update_interrupt_mask)(struct ieee80211_hw *hw,
 				       u32 add_msr, u32 rm_msr);
-	void (*get_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
-	void (*set_hw_reg) (struct ieee80211_hw *hw, u8 variable, u8 *val);
-	void (*update_rate_tbl) (struct ieee80211_hw *hw,
+	void (*get_hw_reg)(struct ieee80211_hw *hw, u8 variable, u8 *val);
+	void (*set_hw_reg)(struct ieee80211_hw *hw, u8 variable, u8 *val);
+	void (*update_rate_tbl)(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta, u8 rssi_leve,
 			      bool update_bw);
 	void (*pre_fill_tx_bd_desc)(struct ieee80211_hw *hw, u8 *tx_bd_desc,
 				    u8 *desc, u8 queue_index,
 				    struct sk_buff *skb, dma_addr_t addr);
-	void (*update_rate_mask) (struct ieee80211_hw *hw, u8 rssi_level);
+	void (*update_rate_mask)(struct ieee80211_hw *hw, u8 rssi_level);
 	u16 (*rx_desc_buff_remained_cnt)(struct ieee80211_hw *hw,
 					 u8 queue_index);
 	void (*rx_check_dma_ok)(struct ieee80211_hw *hw, u8 *header_desc,
 				u8 queue_index);
-	void (*fill_tx_desc) (struct ieee80211_hw *hw,
+	void (*fill_tx_desc)(struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      u8 *pbd_desc_tx,
 			      struct ieee80211_tx_info *info,
@@ -2256,68 +2256,68 @@ struct rtl_hal_ops {
 			      struct rtl_tcb_desc *ptcb_desc);
 	void (*fill_fake_txdesc)(struct ieee80211_hw *hw, u8 *pdesc,
 				 u32 buffer_len, bool bsspspoll);
-	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
+	void (*fill_tx_cmddesc)(struct ieee80211_hw *hw, u8 *pdesc,
 				 bool firstseg, bool lastseg,
 				 struct sk_buff *skb);
 	void (*fill_tx_special_desc)(struct ieee80211_hw *hw,
 				     u8 *pdesc, u8 *pbd_desc,
 				     struct sk_buff *skb, u8 hw_queue);
-	bool (*query_rx_desc) (struct ieee80211_hw *hw,
+	bool (*query_rx_desc)(struct ieee80211_hw *hw,
 			       struct rtl_stats *stats,
 			       struct ieee80211_rx_status *rx_status,
 			       u8 *pdesc, struct sk_buff *skb);
-	void (*set_channel_access) (struct ieee80211_hw *hw);
-	bool (*radio_onoff_checking) (struct ieee80211_hw *hw, u8 *valid);
-	void (*dm_watchdog) (struct ieee80211_hw *hw);
-	void (*scan_operation_backup) (struct ieee80211_hw *hw, u8 operation);
-	bool (*set_rf_power_state) (struct ieee80211_hw *hw,
+	void (*set_channel_access)(struct ieee80211_hw *hw);
+	bool (*radio_onoff_checking)(struct ieee80211_hw *hw, u8 *valid);
+	void (*dm_watchdog)(struct ieee80211_hw *hw);
+	void (*scan_operation_backup)(struct ieee80211_hw *hw, u8 operation);
+	bool (*set_rf_power_state)(struct ieee80211_hw *hw,
 				    enum rf_pwrstate rfpwr_state);
-	void (*led_control) (struct ieee80211_hw *hw,
+	void (*led_control)(struct ieee80211_hw *hw,
 			     enum led_ctl_mode ledaction);
 	void (*set_desc)(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 			 u8 desc_name, u8 *val);
 	u64 (*get_desc)(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 			u8 desc_name);
-	bool (*is_tx_desc_closed) (struct ieee80211_hw *hw,
+	bool (*is_tx_desc_closed)(struct ieee80211_hw *hw,
 				   u8 hw_queue, u16 index);
-	void (*tx_polling) (struct ieee80211_hw *hw, u8 hw_queue);
-	void (*enable_hw_sec) (struct ieee80211_hw *hw);
-	void (*set_key) (struct ieee80211_hw *hw, u32 key_index,
+	void (*tx_polling)(struct ieee80211_hw *hw, u8 hw_queue);
+	void (*enable_hw_sec)(struct ieee80211_hw *hw);
+	void (*set_key)(struct ieee80211_hw *hw, u32 key_index,
 			 u8 *macaddr, bool is_group, u8 enc_algo,
 			 bool is_wepkey, bool clear_all);
-	void (*init_sw_leds) (struct ieee80211_hw *hw);
-	void (*deinit_sw_leds) (struct ieee80211_hw *hw);
-	u32 (*get_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
-	void (*set_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
+	void (*init_sw_leds)(struct ieee80211_hw *hw);
+	void (*deinit_sw_leds)(struct ieee80211_hw *hw);
+	u32 (*get_bbreg)(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
+	void (*set_bbreg)(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
 			   u32 data);
-	u32 (*get_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
+	u32 (*get_rfreg)(struct ieee80211_hw *hw, enum radio_path rfpath,
 			  u32 regaddr, u32 bitmask);
-	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
+	void (*set_rfreg)(struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
-	void (*linked_set_reg) (struct ieee80211_hw *hw);
-	void (*chk_switch_dmdp) (struct ieee80211_hw *hw);
-	void (*dualmac_easy_concurrent) (struct ieee80211_hw *hw);
-	void (*dualmac_switch_to_dmdp) (struct ieee80211_hw *hw);
-	bool (*phy_rf6052_config) (struct ieee80211_hw *hw);
-	void (*phy_rf6052_set_cck_txpower) (struct ieee80211_hw *hw,
+	void (*linked_set_reg)(struct ieee80211_hw *hw);
+	void (*chk_switch_dmdp)(struct ieee80211_hw *hw);
+	void (*dualmac_easy_concurrent)(struct ieee80211_hw *hw);
+	void (*dualmac_switch_to_dmdp)(struct ieee80211_hw *hw);
+	bool (*phy_rf6052_config)(struct ieee80211_hw *hw);
+	void (*phy_rf6052_set_cck_txpower)(struct ieee80211_hw *hw,
 					    u8 *powerlevel);
-	void (*phy_rf6052_set_ofdm_txpower) (struct ieee80211_hw *hw,
+	void (*phy_rf6052_set_ofdm_txpower)(struct ieee80211_hw *hw,
 					     u8 *ppowerlevel, u8 channel);
-	bool (*config_bb_with_headerfile) (struct ieee80211_hw *hw,
+	bool (*config_bb_with_headerfile)(struct ieee80211_hw *hw,
 					   u8 configtype);
-	bool (*config_bb_with_pgheaderfile) (struct ieee80211_hw *hw,
+	bool (*config_bb_with_pgheaderfile)(struct ieee80211_hw *hw,
 					     u8 configtype);
-	void (*phy_lc_calibrate) (struct ieee80211_hw *hw, bool is2t);
-	void (*phy_set_bw_mode_callback) (struct ieee80211_hw *hw);
-	void (*dm_dynamic_txpower) (struct ieee80211_hw *hw);
-	void (*c2h_command_handle) (struct ieee80211_hw *hw);
-	void (*bt_wifi_media_status_notify) (struct ieee80211_hw *hw,
+	void (*phy_lc_calibrate)(struct ieee80211_hw *hw, bool is2t);
+	void (*phy_set_bw_mode_callback)(struct ieee80211_hw *hw);
+	void (*dm_dynamic_txpower)(struct ieee80211_hw *hw);
+	void (*c2h_command_handle)(struct ieee80211_hw *hw);
+	void (*bt_wifi_media_status_notify)(struct ieee80211_hw *hw,
 					     bool mstate);
-	void (*bt_coex_off_before_lps) (struct ieee80211_hw *hw);
-	void (*fill_h2c_cmd) (struct ieee80211_hw *hw, u8 element_id,
+	void (*bt_coex_off_before_lps)(struct ieee80211_hw *hw);
+	void (*fill_h2c_cmd)(struct ieee80211_hw *hw, u8 element_id,
 			      u32 cmd_len, u8 *p_cmdbuffer);
 	void (*set_default_port_id_cmd)(struct ieee80211_hw *hw);
-	bool (*get_btc_status) (void);
+	bool (*get_btc_status)(void);
 	bool (*is_fw_header)(struct rtlwifi_firmware_header *hdr);
 	void (*add_wowlan_pattern)(struct ieee80211_hw *hw,
 				   struct rtl_wow_pattern *rtl_pattern,
@@ -2330,24 +2330,24 @@ struct rtl_hal_ops {
 struct rtl_intf_ops {
 	/*com */
 	void (*read_efuse_byte)(struct ieee80211_hw *hw, u16 _offset, u8 *pbuf);
-	int (*adapter_start) (struct ieee80211_hw *hw);
-	void (*adapter_stop) (struct ieee80211_hw *hw);
+	int (*adapter_start)(struct ieee80211_hw *hw);
+	void (*adapter_stop)(struct ieee80211_hw *hw);
 	bool (*check_buddy_priv)(struct ieee80211_hw *hw,
 				 struct rtl_priv **buddy_priv);
 
-	int (*adapter_tx) (struct ieee80211_hw *hw,
+	int (*adapter_tx)(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta,
 			   struct sk_buff *skb,
 			   struct rtl_tcb_desc *ptcb_desc);
 	void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
-	int (*reset_trx_ring) (struct ieee80211_hw *hw);
-	bool (*waitq_insert) (struct ieee80211_hw *hw,
+	int (*reset_trx_ring)(struct ieee80211_hw *hw);
+	bool (*waitq_insert)(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta,
 			      struct sk_buff *skb);
 
 	/*pci */
-	void (*disable_aspm) (struct ieee80211_hw *hw);
-	void (*enable_aspm) (struct ieee80211_hw *hw);
+	void (*disable_aspm)(struct ieee80211_hw *hw);
+	void (*enable_aspm)(struct ieee80211_hw *hw);
 
 	/*usb */
 };
@@ -2666,30 +2666,30 @@ struct bt_coexist_info {
 };
 
 struct rtl_btc_ops {
-	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
+	void (*btc_init_variables)(struct rtl_priv *rtlpriv);
 	void (*btc_init_variables_wifi_only)(struct rtl_priv *rtlpriv);
 	void (*btc_deinit_variables)(struct rtl_priv *rtlpriv);
-	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
+	void (*btc_init_hal_vars)(struct rtl_priv *rtlpriv);
 	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
-	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
+	void (*btc_init_hw_config)(struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config_wifi_only)(struct rtl_priv *rtlpriv);
-	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
+	void (*btc_ips_notify)(struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
-	void (*btc_scan_notify) (struct rtl_priv *rtlpriv, u8 scantype);
+	void (*btc_scan_notify)(struct rtl_priv *rtlpriv, u8 scantype);
 	void (*btc_scan_notify_wifi_only)(struct rtl_priv *rtlpriv,
 					  u8 scantype);
-	void (*btc_connect_notify) (struct rtl_priv *rtlpriv, u8 action);
-	void (*btc_mediastatus_notify) (struct rtl_priv *rtlpriv,
+	void (*btc_connect_notify)(struct rtl_priv *rtlpriv, u8 action);
+	void (*btc_mediastatus_notify)(struct rtl_priv *rtlpriv,
 					enum rt_media_status mstatus);
-	void (*btc_periodical) (struct rtl_priv *rtlpriv);
+	void (*btc_periodical)(struct rtl_priv *rtlpriv);
 	void (*btc_halt_notify)(struct rtl_priv *rtlpriv);
-	void (*btc_btinfo_notify) (struct rtl_priv *rtlpriv,
+	void (*btc_btinfo_notify)(struct rtl_priv *rtlpriv,
 				   u8 *tmp_buf, u8 length);
 	void (*btc_btmpinfo_notify)(struct rtl_priv *rtlpriv,
 				    u8 *tmp_buf, u8 length);
-	bool (*btc_is_limited_dig) (struct rtl_priv *rtlpriv);
-	bool (*btc_is_disable_edca_turbo) (struct rtl_priv *rtlpriv);
-	bool (*btc_is_bt_disabled) (struct rtl_priv *rtlpriv);
+	bool (*btc_is_limited_dig)(struct rtl_priv *rtlpriv);
+	bool (*btc_is_disable_edca_turbo)(struct rtl_priv *rtlpriv);
+	bool (*btc_is_bt_disabled)(struct rtl_priv *rtlpriv);
 	void (*btc_special_packet_notify)(struct rtl_priv *rtlpriv,
 					  u8 pkt_type);
 	void (*btc_switch_band_notify)(struct rtl_priv *rtlpriv, u8 type,
-- 
2.20.1

