Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F74C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314722077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2O2m56J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbfBUTb2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:28 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34083 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfBUTb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:27 -0500
Received: by mail-oi1-f194.google.com with SMTP id g16so2355393oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQPwX/NdD4794A6GxPRIFHY2/reORggu5CUeryqxIYY=;
        b=p2O2m56J+W9DqXVaRMBpDnhVO0CJLJqWWQSuH+yAQ1otDclMP+fJBld6aEiso4kkDs
         v3/LMea3WGeeJi5UBOacGU67Ec3kvfEi018qsEc+wwO+8gdXxiq1bUDhQS9OGhwpWAVa
         guLMGqZ6TNs5PXJYSwvk6zX1qwVvbMyFHbcTaPlnWf1TPgUR9UtEauhNWE2EAAp1/a7g
         qW+ish2PSg0UuocY1dR4dr8S4nub04HmyspkK6vZL+D1ocUzRiMed4oi+SDTu+dYeHE9
         sIjaJtD3vD5SXLkhoaWKCs6cURT3433BlW+FbGQwfeFHQkt5N+0CWaojj8EF/IBb/K6k
         2ZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=PQPwX/NdD4794A6GxPRIFHY2/reORggu5CUeryqxIYY=;
        b=TR3DcrikgeI5mYNKNKvfmiYR+MdmsmbxAi8zeDl9d8qF0eUI9ZYt7+1Tqu3Qd2rU+Y
         vqI8V1dcN/JFqpVZ8UwBmhvXSLwfhsZqclnP/PnC9mnQSrWXKkZ7nMzKonYOBEnTHa2Z
         yvU5Iazsypa5y5/0QluPIUPx3FcbPMGJN5hYmmGopzZGet+1C3a+qBhVz0pnANR3npzR
         HnfRZ5Dz0ZJgcQIpj1BEKu/8D8YkR0b4N2zXYc7jSZD/nI8iUEBqotRI58SkcVHjoC3z
         5A0xsLHD1nrGFN+MMP6R72w1jNCxVaNYa26c9S60GrMgeF5PnA0vdo9uU8PqnYdWg6W8
         q0/Q==
X-Gm-Message-State: AHQUAubL4+ATV4Qh6EeaME99Qzm756weswJUj3ekNkSl26W8bw1RMX1P
        yZ8+72Cz437So1x0odrjfGqbDSlj
X-Google-Smtp-Source: AHgI3IaPnnW5QJl0SoUzoJS7e50uFIxH1Hc99DSCRl6FOcL5rV8kRLOV80JKAEESeWwSZoAaxPB06Q==
X-Received: by 2002:aca:dd42:: with SMTP id u63mr119027oig.38.1550777486340;
        Thu, 21 Feb 2019 11:31:26 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:25 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/8] rtlwifi: Fix all blank line irregularities in main code files
Date:   Thu, 21 Feb 2019 13:31:12 -0600
Message-Id: <20190221193115.30848-6-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The types of problems fixed are as follows:

WARNING: Missing a blank line after declarations
CHECK: Please use a blank line after function/struct/union/enum declarations
CHECK: Please don't use multiple blank lines

There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c  | 7 +++++--
 drivers/net/wireless/realtek/rtlwifi/core.c  | 8 ++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 8 +++++---
 drivers/net/wireless/realtek/rtlwifi/ps.c    | 1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c    | 2 ++
 drivers/net/wireless/realtek/rtlwifi/regd.c  | 1 -
 drivers/net/wireless/realtek/rtlwifi/usb.c   | 3 +++
 7 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 28d47e3e79fa..f128be46755c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -430,6 +430,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 		SET_IEEE80211_PERM_ADDR(hw, rtlefuse->dev_addr);
 	} else {
 		u8 rtlmac1[] = { 0x00, 0xe0, 0x4c, 0x81, 0x92, 0x00 };
+
 		get_random_bytes((rtlmac1 + (ETH_ALEN - 1)), 1);
 		SET_IEEE80211_PERM_ADDR(hw, rtlmac1);
 	}
@@ -459,7 +460,6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 			  (void *)rtl_fwevt_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.c2hcmd_wq,
 			  (void *)rtl_c2hcmd_wq_callback);
-
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw, bool ips_wq)
@@ -618,6 +618,7 @@ static void _rtl_query_shortgi(struct ieee80211_hw *hw,
 	u8 rate_flag = info->control.rates[0].flags;
 	u8 sgi_40 = 0, sgi_20 = 0, bw_40 = 0;
 	u8 sgi_80 = 0, bw_80 = 0;
+
 	tcb_desc->use_shortgi = false;
 
 	if (sta == NULL)
@@ -1850,6 +1851,7 @@ int rtl_rx_agg_stop(struct ieee80211_hw *hw,
 
 	return 0;
 }
+
 int rtl_tx_agg_oper(struct ieee80211_hw *hw,
 		struct ieee80211_sta *sta, u16 tid)
 {
@@ -2073,7 +2075,6 @@ void rtl_watchdog_wq_callback(void *data)
 	 * busytraffic we don't change channel
 	 */
 	if (mac->link_state >= MAC80211_LINKED) {
-
 		/* (1) get aver_rx_cnt_inperiod & aver_tx_cnt_inperiod */
 		for (idx = 0; idx <= 2; idx++) {
 			rtlpriv->link_info.num_rx_in4period[idx] =
@@ -2233,6 +2234,7 @@ void rtl_watch_dog_timer_callback(struct timer_list *t)
 	mod_timer(&rtlpriv->works.watchdog_timer,
 		  jiffies + MSECS(RTL_WATCH_DOG_TIME));
 }
+
 void rtl_fwevt_wq_callback(void *data)
 {
 	struct rtl_works *rtlworks =
@@ -2385,6 +2387,7 @@ void rtl_easy_concurrent_retrytimer_callback(struct timer_list *t)
 
 	rtlpriv->cfg->ops->dualmac_easy_concurrent(hw);
 }
+
 /*********************************************************
  *
  * frame process functions
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 0913f02b7ff1..f73e690bbe8e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -188,6 +188,7 @@ static void rtl_op_tx(struct ieee80211_hw *hw,
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_tcb_desc tcb_desc;
+
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
 	if (unlikely(is_hal_stop(rtlhal) || ppsc->rfpwr_state != ERFON))
@@ -346,12 +347,14 @@ static void rtl_op_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
+
 static int rtl_op_change_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   enum nl80211_iftype new_type, bool p2p)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int ret;
+
 	rtl_op_remove_interface(hw, vif);
 
 	vif->type = new_type;
@@ -881,6 +884,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *)(&mac->rx_conf));
 }
+
 static int rtl_op_sta_add(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta)
@@ -933,6 +937,7 @@ static int rtl_op_sta_remove(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_sta_info *sta_entry;
+
 	if (sta) {
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 "Remove sta addr is %pM\n", sta->addr);
@@ -945,6 +950,7 @@ static int rtl_op_sta_remove(struct ieee80211_hw *hw,
 	}
 	return 0;
 }
+
 static int _rtl_get_hal_qnum(u16 queue)
 {
 	int qnum;
@@ -1066,6 +1072,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 	/*TODO: reference to enum ieee80211_bss_change */
 	if (changed & BSS_CHANGED_ASSOC) {
 		u8 mstatus;
+
 		if (bss_conf->assoc) {
 			struct ieee80211_sta *sta = NULL;
 			u8 keep_alive = 10;
@@ -1294,6 +1301,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 		 * set in sta_add, and will be NULL here */
 		if (vif->type == NL80211_IFTYPE_STATION) {
 			struct rtl_sta_info *sta_entry;
+
 			sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 			sta_entry->wireless_mode = mac->mode;
 		}
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index de0437b3cb95..e68340dfd980 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -474,6 +474,7 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 
 		if (word_en != 0x0F) {
 			u8 tmpdata[8];
+
 			memcpy(tmpdata,
 			       &rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base],
 			       8);
@@ -487,7 +488,6 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 				break;
 			}
 		}
-
 	}
 
 	efuse_power_switch(hw, true, false);
@@ -662,6 +662,7 @@ static int efuse_one_byte_write(struct ieee80211_hw *hw, u16 addr, u8 data)
 static void efuse_read_all_map(struct ieee80211_hw *hw, u8 *efuse)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	efuse_power_switch(hw, false, true);
 	read_efuse(hw, 0, rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], efuse);
 	efuse_power_switch(hw, false, false);
@@ -812,6 +813,7 @@ static void efuse_write_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
 				if (0x0F != (badworden & 0x0F))	{
 					u8 reorg_offset = offset;
 					u8 reorg_worden = badworden;
+
 					efuse_pg_packet_write(hw, reorg_offset,
 							      reorg_worden,
 							      originaldata);
@@ -901,6 +903,7 @@ static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
 			if (0x0F != (badworden & 0x0F)) {
 				u8 reorg_offset = tmp_pkt.offset;
 				u8 reorg_worden = badworden;
+
 				efuse_pg_packet_write(hw, reorg_offset,
 						      reorg_worden,
 						      originaldata);
@@ -957,7 +960,6 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 
 	while (continual && (efuse_addr < (EFUSE_MAX_SIZE -
 		rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN]))) {
-
 		if (write_state == PG_STATE_HEADER) {
 			dataempty = true;
 			badworden = 0x0F;
@@ -1114,7 +1116,6 @@ void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 	u16 tmpv16;
 
 	if (pwrstate && (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)) {
-
 		if (rtlhal->hw_type != HARDWARE_TYPE_RTL8192CE &&
 		    rtlhal->hw_type != HARDWARE_TYPE_RTL8192DE) {
 			rtl_write_byte(rtlpriv,
@@ -1219,6 +1220,7 @@ static u16 efuse_get_current_size(struct ieee80211_hw *hw)
 static u8 efuse_calculate_word_cnts(u8 word_en)
 {
 	u8 word_cnts = 0;
+
 	if (!(word_en & BIT(0)))
 		word_cnts++;
 	if (!(word_en & BIT(1)))
diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index dca70d239760..70f04c2f5b17 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -718,6 +718,7 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 	static u8 p2p_oui_ie_type[4] = {0x50, 0x6f, 0x9a, 0x09};
 	u8 noa_num, index , i, noa_index = 0;
 	bool find_p2p_ie = false , find_p2p_ps_ie = false;
+
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = data + len;
 	ie = NULL;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index 8fa76eab61d2..cf8e42a01015 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -236,6 +236,7 @@ static void rtl_tx_status(void *ppriv,
 		    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 			if (ieee80211_is_data_qos(fc)) {
 				u8 tid = rtl_get_tid(skb);
+
 				if (_rtl_tx_aggr_check(rtlpriv, sta_entry,
 						       tid)) {
 					sta_entry->tids[tid].agg.agg_state =
@@ -293,6 +294,7 @@ static void rtl_rate_free_sta(void *rtlpriv,
 			      struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct rtl_rate_priv *rate_priv = priv_sta;
+
 	kfree(rate_priv);
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index c7048830decd..6ccb5b93a595 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -41,7 +41,6 @@ static struct country_code_to_enum_rd all_countries[] = {
 	NL80211_RRF_PASSIVE_SCAN | \
 	NL80211_RRF_NO_OFDM)
 
-
 /* 5G chan 36 - chan 64*/
 #define RTL819x_5GHZ_5150_5350	\
 	REG_RULE(5150-10, 5350+10, 80, 0, 30, 0)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 525f72bad433..e24fda5e9087 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -267,6 +267,7 @@ static int _rtl_usb_init_tx(struct ieee80211_hw *hw)
 
 	for (i = 0; i < __RTL_TXQ_NUM; i++) {
 		u32 ep_num = rtlusb->ep_map.ep_mapping[i];
+
 		if (!ep_num) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 "Invalid endpoint map setting!\n");
@@ -331,6 +332,7 @@ static int _rtl_usb_init(struct ieee80211_hw *hw)
 	rtlusb->out_ep_nums = rtlusb->in_ep_nums = 0;
 	for (epidx = 0; epidx < epnums; epidx++) {
 		struct usb_endpoint_descriptor *pep_desc;
+
 		pep_desc = &usb_intf->cur_altsetting->endpoint[epidx].desc;
 
 		if (usb_endpoint_dir_in(pep_desc))
@@ -753,6 +755,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 
 	return err;
 }
+
 /**
  *
  *
-- 
2.20.1

