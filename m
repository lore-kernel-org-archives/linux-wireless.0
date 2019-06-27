Return-Path: <SRS0=XE1e=U2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62EBC48BD6
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECB6214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561596191;
	bh=5vj/vQzY5Cpq+1NpykmWv1HFdz9sPeRMPWazo0IuP+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zpvW7lMZPM9lPqf53p9CyXWAj48TSJ3Fpcsizt3bE+L0rYjzaE+nBarRfmx6UwB0Y
	 jxyMkymWsWBJ+MiKweJeyZigfom5CXnI/cILCDLyzkUHU9nhfDF248eWS21+SZMrLY
	 G0mv10E809SdI915G2Z1cS779xNVhZvEpaigueWI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbfF0Am6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbfF0Am5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jun 2019 20:42:57 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EADD21882;
        Thu, 27 Jun 2019 00:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596176;
        bh=5vj/vQzY5Cpq+1NpykmWv1HFdz9sPeRMPWazo0IuP+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJtBa6EWH0M2vNbf95i0Mr1UV0dSkGLv6GG4KsHYft7fgzGBW1iCpa4qhE2i/NbmG
         24kwiHPp4KKpKqw+EZJRwhUDNtJDgiHkFRxmHcAs1OFc4+IMPTW6+5Fn5rEgmKLXKn
         7Zgj3hBtpAvZ7wc/d6hKv8z6mRFxmReuKMZjTl5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/12] mwifiex: Abort at too short BSS descriptor element
Date:   Wed, 26 Jun 2019 20:42:27 -0400
Message-Id: <20190627004236.21909-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627004236.21909-1-sashal@kernel.org>
References: <20190627004236.21909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 685c9b7750bfacd6fc1db50d86579980593b7869 ]

Currently mwifiex_update_bss_desc_with_ie() implicitly assumes that
the source descriptor entries contain the enough size for each type
and performs copying without checking the source size.  This may lead
to read over boundary.

Fix this by putting the source size check in appropriate places.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mwifiex/scan.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 6f789899c888..b755f72d85d5 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1241,6 +1241,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_FH_PARAMS:
+			if (element_len + 2 < sizeof(*fh_param_set))
+				return -EINVAL;
 			fh_param_set =
 				(struct ieee_types_fh_param_set *) current_ptr;
 			memcpy(&bss_entry->phy_param_set.fh_param_set,
@@ -1249,6 +1251,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_DS_PARAMS:
+			if (element_len + 2 < sizeof(*ds_param_set))
+				return -EINVAL;
 			ds_param_set =
 				(struct ieee_types_ds_param_set *) current_ptr;
 
@@ -1260,6 +1264,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_CF_PARAMS:
+			if (element_len + 2 < sizeof(*cf_param_set))
+				return -EINVAL;
 			cf_param_set =
 				(struct ieee_types_cf_param_set *) current_ptr;
 			memcpy(&bss_entry->ss_param_set.cf_param_set,
@@ -1268,6 +1274,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_IBSS_PARAMS:
+			if (element_len + 2 < sizeof(*ibss_param_set))
+				return -EINVAL;
 			ibss_param_set =
 				(struct ieee_types_ibss_param_set *)
 				current_ptr;
@@ -1277,10 +1285,14 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_ERP_INFO:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->erp_flags = *(current_ptr + 2);
 			break;
 
 		case WLAN_EID_PWR_CONSTRAINT:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->local_constraint = *(current_ptr + 2);
 			bss_entry->sensed_11h = true;
 			break;
@@ -1320,6 +1332,9 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_VENDOR_SPECIFIC:
+			if (element_len + 2 < sizeof(vendor_ie->vend_hdr))
+				return -EINVAL;
+
 			vendor_ie = (struct ieee_types_vendor_specific *)
 					current_ptr;
 
-- 
2.20.1

