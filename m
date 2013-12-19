Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41488 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3LSRFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 12:05:53 -0500
Date: Thu, 19 Dec 2013 20:05:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Max.Stepanov@intel.com
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: re: iwlwifi: mvm: add a generic cipher scheme support
Message-ID: <20131219170541.GA21029@elgon.mountain> (sfid-20131219_180556_709153_0695AFEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Max Stepanov,

The patch e36e5433c98d: "iwlwifi: mvm: add a generic cipher scheme
support" from Aug 27, 2013, leads to the following (soon to be pushed)
Smatch warning:
	drivers/net/wireless/iwlwifi/mvm/mac80211.c:265 iwl_mvm_mac_setup_register()
	warn: this array is probably non-NULL. 'mvm->fw->cs'

drivers/net/wireless/iwlwifi/mvm/mac80211.c
   264          /* currently FW API supports only one optional cipher scheme */
   265          if (mvm->fw->cs && mvm->fw->cs->cipher) {
                    ^^^^^^^^^^^
This is an array, not a pointer.

   266                  mvm->hw->n_cipher_schemes = 1;
   267                  mvm->hw->cipher_schemes = mvm->fw->cs;
   268          }

regards,
dan carpenter

