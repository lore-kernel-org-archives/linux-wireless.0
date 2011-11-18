Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:29728 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab1KROKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:10:14 -0500
Date: Fri, 18 Nov 2011 17:09:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jouni@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: ath6kl: Allow CCKM AKM and KRK to be configured
Message-ID: <20111118140954.GC9685@elgon.mountain> (sfid-20111118_151018_195739_3C2FC9EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jouni Malinen,

This is a semi-automatic email about new static checker warnings.

The patch 837cb97e5b72: "ath6kl: Allow CCKM AKM and KRK to be 
configured" from Oct 11, 2011, leads to the following Smatch 
complaint:

drivers/net/wireless/ath/ath6kl/cfg80211.c +939 ath6kl_cfg80211_add_key()
	 warn: variable dereferenced before check 'params' (see line 917)

drivers/net/wireless/ath/ath6kl/cfg80211.c
   916	
   917		if (params->cipher == CCKM_KRK_CIPHER_SUITE) {
                    ^^^^^^^^
new dereference.

   918			if (params->key_len != WMI_KRK_LEN)
   919				return -EINVAL;
   920			return ath6kl_wmi_add_krk_cmd(ar->wmi, vif->fw_vif_idx,
   921						      params->key);
   922		}
   923	
   924		if (key_index < WMI_MIN_KEY_INDEX || key_index > WMI_MAX_KEY_INDEX) {
   925			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
   926				   "%s: key index %d out of bounds\n", __func__,
   927				   key_index);
   928			return -ENOENT;
   929		}
   930	
   931		key = &vif->keys[key_index];
   932		memset(key, 0, sizeof(struct ath6kl_key));
   933	
   934		if (pairwise)
   935			key_usage = PAIRWISE_USAGE;
   936		else
   937			key_usage = GROUP_USAGE;
   938	
   939		if (params) {
                    ^^^^^^
check.

   940			if (params->key_len > WLAN_MAX_KEY_LEN ||
   941			    params->seq_len > sizeof(key->seq))

regards,
dan carpenter

