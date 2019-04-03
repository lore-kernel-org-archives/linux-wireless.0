Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA87C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE8B52084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBcQSue6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfDCENe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35974 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfDCENd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id 85so7626177pgc.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8BjrE2coOi7nEiMYzbZWgSRjcCgm92PMT0JoHAU+RxM=;
        b=RBcQSue6QIjGdOs3lnVTpXbUC3hEAaJOWWfxZDIuimUzQNtDVo+YkzNA4FJoaeqldc
         nbbdoVUNLHcI48hSBZCcc3xxndrwG9duVEn6ST7LHozAK2JjgmMTnw/9KsfCgCQsiwIW
         NrmlM8cyphPtZe9dS1J7XTYbuLTfFfLPnUojJ7TIcDhIO8ikoCjuGcIgUfnJetA3ZyZo
         tXdjMnlqUQYsw8rhXu0o343Tm7zvwaWtG+Nc5uR2rF6D6JC/n//KvEV1T4gEqUN7M2kI
         vRWNQ8jsmLz7TaQHrDLvtDpTVgUiVb99C6TlSWA8Y4Mjj3NWIMZwRJTWQ7cdadQtl//H
         PPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8BjrE2coOi7nEiMYzbZWgSRjcCgm92PMT0JoHAU+RxM=;
        b=t7h3oZaG9g59/1iE3QZjOaLIENMdSl5P33HXb989RSp399XWU3Xt07O7NeLX5JwGRj
         Se758LUsK3C7kxUJFQueHz3+Mt2VmEOjtvmpY7F+WsPv8E6fEESLIvpimj/EKygsU3cQ
         DyOnSLyAQG8FcTiYShzXdJ0FMZfWkg5jH50bIWNkCA660NFrrB/x+qJikS2cgAh53Mt0
         vnJmfvhvBvkY5ziRvlza49vmLPZlk+tV2PBfEWSh0DsslbJNBknXBuBKjtvzhyE+XSU9
         ttkK+acJ1u0kB6/EqW7tvkpIkm+9y50CzD7nfm0lbHedFJQro2hw83LVUBknLQ/1OJKB
         MVOA==
X-Gm-Message-State: APjAAAVkj4BsEgsdGk/N6RgUs6EjWrLW/yYqsN48hq+5h5WGpHfifu1l
        49LM8wgX/jZUdn3Mjd/ABGnHuLRAl34kP6kT
X-Google-Smtp-Source: APXvYqy9wG/LevXR8ndD3fd4MyM8/+r/p9BGPAlSRSm3DF7bAcGtdkU6zfzQqmvcL5nuHLNlvSGftw==
X-Received: by 2002:a62:ab12:: with SMTP id p18mr60220952pff.216.1554264812555;
        Tue, 02 Apr 2019 21:13:32 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:32 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 4/8] rsi: change in device init frame sequence for 9116
Date:   Wed,  3 Apr 2019 09:43:05 +0530
Message-Id: <20190403041309.12829-5-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initial frame exchange sequence has been changed for 9116 chip. Getting MAC
address using EEPROM read frame will be once common device configuration is
done and RESET_MAC frame is sending after bootup parameters confirmation is
received, which are different from RS9113 device

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 38 +++++++++++++++++++------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 844f2fac298f..9eb60a5501a2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1766,15 +1766,26 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 		rsi_dbg(FSM_ZONE, "%s: Boot up params confirm received\n",
 			__func__);
 		if (common->fsm_state == FSM_BOOT_PARAMS_SENT) {
-			adapter->eeprom.length = (IEEE80211_ADDR_LEN +
-						  WLAN_MAC_MAGIC_WORD_LEN +
-						  WLAN_HOST_MODE_LEN);
-			adapter->eeprom.offset = WLAN_MAC_EEPROM_ADDR;
-			if (rsi_eeprom_read(common)) {
-				common->fsm_state = FSM_CARD_NOT_READY;
-				goto out;
+			if (adapter->device_model == RSI_DEV_9116) {
+				common->band = NL80211_BAND_5GHZ;
+				common->num_supp_bands = 2;
+
+				if (rsi_send_reset_mac(common))
+					goto out;
+				else
+					common->fsm_state = FSM_RESET_MAC_SENT;
+			} else {
+				adapter->eeprom.length =
+					(IEEE80211_ADDR_LEN +
+					 WLAN_MAC_MAGIC_WORD_LEN +
+					 WLAN_HOST_MODE_LEN);
+				adapter->eeprom.offset = WLAN_MAC_EEPROM_ADDR;
+				if (rsi_eeprom_read(common)) {
+					common->fsm_state = FSM_CARD_NOT_READY;
+					goto out;
+				}
+				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
 			}
-			common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
 		} else {
 			rsi_dbg(INFO_ZONE,
 				"%s: Received bootup params cfm in %d state\n",
@@ -1936,6 +1947,17 @@ int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
 	case FSM_COMMON_DEV_PARAMS_SENT:
 		rsi_dbg(INIT_ZONE, "Card ready indication from WLAN HAL\n");
 
+		if (common->priv->device_model == RSI_DEV_9116) {
+			if (msg[16] != MAGIC_WORD) {
+				rsi_dbg(FSM_ZONE,
+					"%s: [EEPROM_READ] Invalid token\n",
+					__func__);
+				common->fsm_state = FSM_CARD_NOT_READY;
+				return -EINVAL;
+			}
+			memcpy(common->mac_addr, &msg[20], ETH_ALEN);
+			rsi_dbg(INIT_ZONE, "MAC Addr %pM", common->mac_addr);
+		}
 		/* Get usb buffer status register address */
 		common->priv->usb_buffer_status_reg = *(u32 *)&msg[8];
 		rsi_dbg(INFO_ZONE, "USB buffer status register = %x\n",
-- 
2.17.1

