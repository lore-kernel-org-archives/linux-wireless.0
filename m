Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:29017 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab2BGNAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 08:00:13 -0500
Date: Tue, 7 Feb 2012 16:00:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: c_manoha@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: re: ath6kl: Remove redundant pointer check
Message-ID: <20120207130002.GA14460@elgon.mountain> (sfid-20120207_140017_539793_6B0ECDB4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sujith Manoharan,

This is a semi-automatic email about new static checker warnings.

The patch 4a8ce2fd055f: "ath6kl: Remove redundant pointer check" from 
Jan 10, 2012, leads to the following Smatch complaint:

drivers/net/wireless/ath/ath6kl/cfg80211.c:1061 ath6kl_cfg80211_add_key()
	 warn: variable dereferenced before check 'params' (see line 1026)

drivers/net/wireless/ath/ath6kl/cfg80211.c
  1025		memcpy(key->seq, params->seq, key->seq_len);
  1026		key->cipher = params->cipher;
                              ^^^^^^^^^^^^^^
dereference.

  1027	
  1028		switch (key->cipher) {
  1029		case WLAN_CIPHER_SUITE_WEP40:
  1030		case WLAN_CIPHER_SUITE_WEP104:
  1031			key_type = WEP_CRYPT;
  1032			break;

[ snip ]

  1058	
  1059		if (vif->nw_type == AP_NETWORK && !pairwise &&
  1060		    (key_type == TKIP_CRYPT || key_type == AES_CRYPT ||
  1061		     key_type == WAPI_CRYPT) && params) {
                                                ^^^^^^
check.  This check is redundant too so we should remove it as well.

  1062			ar->ap_mode_bkey.valid = true;
  1063			ar->ap_mode_bkey.key_index = key_index;

regards,
dan carpenter

