Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63537C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2646D2077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFaT874W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfBUTbZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:25 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44465 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfBUTbY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:24 -0500
Received: by mail-oi1-f194.google.com with SMTP id a81so2357709oii.11
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMkTTT4HYpWwB5amqaKZ1nQe3rS07JP/owxAnieyEP0=;
        b=lFaT874WTMHkqSxJdzJ6NqRCKFBZsUfIPlUDEzOz2Bq8aQY1n5/MBhc2lNKAWCcl/a
         fIlZXfPLvll1udPPvQgk/NdTN/thH+9av0VdKNrKpBa0vD48o2DcHh7MLRxN/rEsjRIk
         7r0CAm6DWZm82m0Dio0qQHSnqZmAG4IWkoHSYGDK95vhAApySBAzQAkOzS83ES6lJgJC
         rvCIGcrXC3NoXrDk2asMbzA9hoXbolCVsX1p2qycDhdg4NTwK8oGw2gV/gzRF3t2hvKs
         hkTbC4U9CY0uerINm64IqoTgJQpIA1/8Adi7LiI+W/Pc+qWGHDQYIhQgxw0WPk+597uB
         /DoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EMkTTT4HYpWwB5amqaKZ1nQe3rS07JP/owxAnieyEP0=;
        b=nBs4D2w9pJKk91V+fmm6p5ZqTYJ064Qjndgwq45FarLpWL9l/3+aTbvq3hPd6dc4fx
         aqtUu/SeTVQ0jxOSFH5+9A8BQ8vgnMGmZQ/9U8NLFS+TN7jR/z8oG21gWJ/Rv38UAm4B
         5cfXfYOLJB9n9uz3oIOD8BAF2BIec/q+JL30cWI1qSi6TFr973isGd+UW7gRRNFu0s6j
         yuKif7r1NrZOWx2zCWK5lgfUlE1Vha3NG9T6QLZRFBZx6Hcs0muDZwM1xbJe8wJpojEY
         xd87u+QufaBJ1uAGJATv8f/2n2wq7Xnm5vffikgl4Y4EzOK9yqLU4Q4abT9Y1IYJq8qf
         1GGA==
X-Gm-Message-State: AHQUAua/fnunVLz/nKxp0JKo0dGR/UY00rcACeHoUNhll9dO8EnJPaBN
        J6fNQkwgFXakQH+u0R/leI4=
X-Google-Smtp-Source: AHgI3IYOfLE5q1C0+RGM/EaGq2YfQVGmEuVhC0ZMUHJhGr98+/8K3vroS1AVO45/ofVxGYFCVmyGFg==
X-Received: by 2002:aca:d805:: with SMTP id p5mr105369oig.144.1550777483657;
        Thu, 21 Feb 2019 11:31:23 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:22 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/8] rtlwifi: Fix alignment errors in wifi.h
Date:   Thu, 21 Feb 2019 13:31:10 -0600
Message-Id: <20190221193115.30848-4-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The instances where statement continuations are improperly aligned have
been fixed.

There are no changes to generated code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 84 ++++++++++-----------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 9fe137fa5ead..88f94662c072 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1466,7 +1466,7 @@ struct rtl_io {
 	void (*write16_async)(struct rtl_priv *rtlpriv, u32 addr, u16 val);
 	void (*write32_async)(struct rtl_priv *rtlpriv, u32 addr, u32 val);
 	void (*writen_sync)(struct rtl_priv *rtlpriv, u32 addr, void *buf,
-			     u16 len);
+			    u16 len);
 
 	u8 (*read8_sync)(struct rtl_priv *rtlpriv, u32 addr);
 	u16 (*read16_sync)(struct rtl_priv *rtlpriv, u32 addr);
@@ -2222,7 +2222,7 @@ struct rtl_hal_ops {
 	void (*read_chip_version)(struct ieee80211_hw *hw);
 	void (*read_eeprom_info)(struct ieee80211_hw *hw);
 	void (*interrupt_recognized)(struct ieee80211_hw *hw,
-				      struct rtl_int *intvec);
+				     struct rtl_int *intvec);
 	int (*hw_init)(struct ieee80211_hw *hw);
 	void (*hw_disable)(struct ieee80211_hw *hw);
 	void (*hw_suspend)(struct ieee80211_hw *hw);
@@ -2230,22 +2230,22 @@ struct rtl_hal_ops {
 	void (*enable_interrupt)(struct ieee80211_hw *hw);
 	void (*disable_interrupt)(struct ieee80211_hw *hw);
 	int (*set_network_type)(struct ieee80211_hw *hw,
-				 enum nl80211_iftype type);
+				enum nl80211_iftype type);
 	void (*set_chk_bssid)(struct ieee80211_hw *hw,
-				bool check_bssid);
+			      bool check_bssid);
 	void (*set_bw_mode)(struct ieee80211_hw *hw,
-			     enum nl80211_channel_type ch_type);
+			    enum nl80211_channel_type ch_type);
 	 u8 (*switch_channel)(struct ieee80211_hw *hw);
 	void (*set_qos)(struct ieee80211_hw *hw, int aci);
 	void (*set_bcn_reg)(struct ieee80211_hw *hw);
 	void (*set_bcn_intv)(struct ieee80211_hw *hw);
 	void (*update_interrupt_mask)(struct ieee80211_hw *hw,
-				       u32 add_msr, u32 rm_msr);
+				      u32 add_msr, u32 rm_msr);
 	void (*get_hw_reg)(struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*set_hw_reg)(struct ieee80211_hw *hw, u8 variable, u8 *val);
 	void (*update_rate_tbl)(struct ieee80211_hw *hw,
-			      struct ieee80211_sta *sta, u8 rssi_leve,
-			      bool update_bw);
+				struct ieee80211_sta *sta, u8 rssi_leve,
+				bool update_bw);
 	void (*pre_fill_tx_bd_desc)(struct ieee80211_hw *hw, u8 *tx_bd_desc,
 				    u8 *desc, u8 queue_index,
 				    struct sk_buff *skb, dma_addr_t addr);
@@ -2255,74 +2255,74 @@ struct rtl_hal_ops {
 	void (*rx_check_dma_ok)(struct ieee80211_hw *hw, u8 *header_desc,
 				u8 queue_index);
 	void (*fill_tx_desc)(struct ieee80211_hw *hw,
-			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			      u8 *pbd_desc_tx,
-			      struct ieee80211_tx_info *info,
-			      struct ieee80211_sta *sta,
-			      struct sk_buff *skb, u8 hw_queue,
-			      struct rtl_tcb_desc *ptcb_desc);
+			     struct ieee80211_hdr *hdr, u8 *pdesc_tx,
+			     u8 *pbd_desc_tx,
+			     struct ieee80211_tx_info *info,
+			     struct ieee80211_sta *sta,
+			     struct sk_buff *skb, u8 hw_queue,
+			     struct rtl_tcb_desc *ptcb_desc);
 	void (*fill_fake_txdesc)(struct ieee80211_hw *hw, u8 *pdesc,
 				 u32 buffer_len, bool bsspspoll);
 	void (*fill_tx_cmddesc)(struct ieee80211_hw *hw, u8 *pdesc,
-				 bool firstseg, bool lastseg,
-				 struct sk_buff *skb);
+				bool firstseg, bool lastseg,
+				struct sk_buff *skb);
 	void (*fill_tx_special_desc)(struct ieee80211_hw *hw,
 				     u8 *pdesc, u8 *pbd_desc,
 				     struct sk_buff *skb, u8 hw_queue);
 	bool (*query_rx_desc)(struct ieee80211_hw *hw,
-			       struct rtl_stats *stats,
-			       struct ieee80211_rx_status *rx_status,
-			       u8 *pdesc, struct sk_buff *skb);
+			      struct rtl_stats *stats,
+			      struct ieee80211_rx_status *rx_status,
+			      u8 *pdesc, struct sk_buff *skb);
 	void (*set_channel_access)(struct ieee80211_hw *hw);
 	bool (*radio_onoff_checking)(struct ieee80211_hw *hw, u8 *valid);
 	void (*dm_watchdog)(struct ieee80211_hw *hw);
 	void (*scan_operation_backup)(struct ieee80211_hw *hw, u8 operation);
 	bool (*set_rf_power_state)(struct ieee80211_hw *hw,
-				    enum rf_pwrstate rfpwr_state);
+				   enum rf_pwrstate rfpwr_state);
 	void (*led_control)(struct ieee80211_hw *hw,
-			     enum led_ctl_mode ledaction);
+			    enum led_ctl_mode ledaction);
 	void (*set_desc)(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 			 u8 desc_name, u8 *val);
 	u64 (*get_desc)(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 			u8 desc_name);
 	bool (*is_tx_desc_closed)(struct ieee80211_hw *hw,
-				   u8 hw_queue, u16 index);
+				  u8 hw_queue, u16 index);
 	void (*tx_polling)(struct ieee80211_hw *hw, u8 hw_queue);
 	void (*enable_hw_sec)(struct ieee80211_hw *hw);
 	void (*set_key)(struct ieee80211_hw *hw, u32 key_index,
-			 u8 *macaddr, bool is_group, u8 enc_algo,
-			 bool is_wepkey, bool clear_all);
+			u8 *macaddr, bool is_group, u8 enc_algo,
+			bool is_wepkey, bool clear_all);
 	void (*init_sw_leds)(struct ieee80211_hw *hw);
 	void (*deinit_sw_leds)(struct ieee80211_hw *hw);
 	u32 (*get_bbreg)(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
 	void (*set_bbreg)(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
-			   u32 data);
+			  u32 data);
 	u32 (*get_rfreg)(struct ieee80211_hw *hw, enum radio_path rfpath,
-			  u32 regaddr, u32 bitmask);
+			 u32 regaddr, u32 bitmask);
 	void (*set_rfreg)(struct ieee80211_hw *hw, enum radio_path rfpath,
-			   u32 regaddr, u32 bitmask, u32 data);
+			  u32 regaddr, u32 bitmask, u32 data);
 	void (*linked_set_reg)(struct ieee80211_hw *hw);
 	void (*chk_switch_dmdp)(struct ieee80211_hw *hw);
 	void (*dualmac_easy_concurrent)(struct ieee80211_hw *hw);
 	void (*dualmac_switch_to_dmdp)(struct ieee80211_hw *hw);
 	bool (*phy_rf6052_config)(struct ieee80211_hw *hw);
 	void (*phy_rf6052_set_cck_txpower)(struct ieee80211_hw *hw,
-					    u8 *powerlevel);
+					   u8 *powerlevel);
 	void (*phy_rf6052_set_ofdm_txpower)(struct ieee80211_hw *hw,
-					     u8 *ppowerlevel, u8 channel);
+					    u8 *ppowerlevel, u8 channel);
 	bool (*config_bb_with_headerfile)(struct ieee80211_hw *hw,
-					   u8 configtype);
+					  u8 configtype);
 	bool (*config_bb_with_pgheaderfile)(struct ieee80211_hw *hw,
-					     u8 configtype);
+					    u8 configtype);
 	void (*phy_lc_calibrate)(struct ieee80211_hw *hw, bool is2t);
 	void (*phy_set_bw_mode_callback)(struct ieee80211_hw *hw);
 	void (*dm_dynamic_txpower)(struct ieee80211_hw *hw);
 	void (*c2h_command_handle)(struct ieee80211_hw *hw);
 	void (*bt_wifi_media_status_notify)(struct ieee80211_hw *hw,
-					     bool mstate);
+					    bool mstate);
 	void (*bt_coex_off_before_lps)(struct ieee80211_hw *hw);
 	void (*fill_h2c_cmd)(struct ieee80211_hw *hw, u8 element_id,
-			      u32 cmd_len, u8 *p_cmdbuffer);
+			     u32 cmd_len, u8 *p_cmdbuffer);
 	void (*set_default_port_id_cmd)(struct ieee80211_hw *hw);
 	bool (*get_btc_status)(void);
 	bool (*is_fw_header)(struct rtlwifi_firmware_header *hdr);
@@ -2343,14 +2343,14 @@ struct rtl_intf_ops {
 				 struct rtl_priv **buddy_priv);
 
 	int (*adapter_tx)(struct ieee80211_hw *hw,
-			   struct ieee80211_sta *sta,
-			   struct sk_buff *skb,
-			   struct rtl_tcb_desc *ptcb_desc);
+			  struct ieee80211_sta *sta,
+			  struct sk_buff *skb,
+			  struct rtl_tcb_desc *ptcb_desc);
 	void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
 	int (*reset_trx_ring)(struct ieee80211_hw *hw);
 	bool (*waitq_insert)(struct ieee80211_hw *hw,
-			      struct ieee80211_sta *sta,
-			      struct sk_buff *skb);
+			     struct ieee80211_sta *sta,
+			     struct sk_buff *skb);
 
 	/*pci */
 	void (*disable_aspm)(struct ieee80211_hw *hw);
@@ -2689,11 +2689,11 @@ struct rtl_btc_ops {
 					  u8 scantype);
 	void (*btc_connect_notify)(struct rtl_priv *rtlpriv, u8 action);
 	void (*btc_mediastatus_notify)(struct rtl_priv *rtlpriv,
-					enum rt_media_status mstatus);
+				       enum rt_media_status mstatus);
 	void (*btc_periodical)(struct rtl_priv *rtlpriv);
 	void (*btc_halt_notify)(struct rtl_priv *rtlpriv);
 	void (*btc_btinfo_notify)(struct rtl_priv *rtlpriv,
-				   u8 *tmp_buf, u8 length);
+				  u8 *tmp_buf, u8 length);
 	void (*btc_btmpinfo_notify)(struct rtl_priv *rtlpriv,
 				    u8 *tmp_buf, u8 length);
 	bool (*btc_is_limited_dig)(struct rtl_priv *rtlpriv);
@@ -3155,7 +3155,7 @@ static inline void rtl_set_bbreg(struct ieee80211_hw *hw, u32 regaddr,
 }
 
 static inline void rtl_set_bbreg_with_dwmask(struct ieee80211_hw *hw,
-				 u32 regaddr, u32 data)
+					     u32 regaddr, u32 data)
 {
 	rtl_set_bbreg(hw, regaddr, 0xffffffff, data);
 }
@@ -3226,7 +3226,7 @@ static inline struct ieee80211_sta *get_sta(struct ieee80211_hw *hw,
 }
 
 static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
-		u8 *mac_addr)
+						 u8 *mac_addr)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	return ieee80211_find_sta(mac->vif, mac_addr);
-- 
2.20.1

