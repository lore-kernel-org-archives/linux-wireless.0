Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741CB476680
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759882; cv=none; b=Mk6Sa0C/zb4DSWMbUYughJ7uewwNdaUlXxv0HRTC7TAUFteNLFX7Foz5QpKiZhTl7DU6nQywVnKOjqXgND48YxoPRLkMsoTQtRxmPBS6tWgG09QV3E4Wg75c8d5KVeEcgWlB3Kzvf8FehlIubk9/dU345CaIhWoAyxOEp4G93pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759882; c=relaxed/simple;
	bh=3GftMHPVlyZBoDIDr2pcqILa2F1/w1uu/2VVKhKqLwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LmSwV89x6GzHU1ESUFrWY33DRnQhqxvLFcJ4VuMpwDXZtprbLBWUrAZnnGy7gqsI95nmG+3WtuzQ9jc0DWQX+e4cOxutIIaDLWu4+vK1r+GBmY+2/w8zHSZN7SnzpwSYpMFC9Pb2G7TKVFEqcKIxvyQH7mg/c+HbmbcZ2KbzYjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCRYYb2q; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCRYYb2q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759881; x=1822295881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3GftMHPVlyZBoDIDr2pcqILa2F1/w1uu/2VVKhKqLwk=;
  b=mCRYYb2qOf7+Lg/MMns1gRDAqCrYSblcTOap4pBPkceLrjaawd7FTUj1
   2cg0RGcRYhLi8Rz72d1gMAc3EqIZQSc53IUGPQvqdgkHT04LtglQ76nVl
   Rx8eCOV/Dft3TZZ0kIjC6wrwfPRPTltd5i6NhceXkkgbwAfg1sZCGWG8Q
   280iR/9MQBSC7Zx12w+HI8ciiwwltciFbXXqhaB6NnvG4IQ0Kqs30//oA
   4CGMqINKErm8tT2KLroNwtj6D33pgFcfOJAYU22TXkL9l+zK6NI+ycAj+
   /jxDDpAR/3xnx1X0bmF1Y+tBhY7d3l7mfTADEzwYpBVV2B60sSQGPp4L+
   w==;
X-CSE-ConnectionGUID: eUqqDstCQHu8QKV+9n1Cgw==
X-CSE-MsgGUID: 6eSunei5SXGZjWlGGhRwGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447015"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447015"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:01 -0700
X-CSE-ConnectionGUID: XKFrT9vxQpSg7lUOEp4GnQ==
X-CSE-MsgGUID: dHDAVgtHRrqaN/++eZqZEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673513"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:17:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 03/15] wifi: iwlwifi: mld: fake a valid NSS field when needed
Date: Wed, 30 Sep 2026 12:19:40 +0300
Message-Id: <20260930121740.2589668e377b.Ib41003bd4e10f0fe6d7f4aa1038291be330c3175@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
References: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We hit a WARNING in mac80211 in sniffer that complains that
rx_status->nss is 0. This happens on frames that the firmware doesn't
really understand and when that happens, somehow the STBC bit is set.
The driver divides the number of antennas by 2 to get the NSS with STBC
set because each stream requires 2 antennas. Since NSTS=1, NSS end up
being 0.

Since we don't have devices with more than 2 antennas, just consider
that when we receive STBC traffic, we have one spatial stream.

Since this problem has been seen on HE traffic only, don't apply this
logic on VHT / HT code paths.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 5f18aa551af5..8fa438fd7815 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -553,7 +553,10 @@ iwl_mld_decode_he_tb_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 
 	nsts = le32_get_bits(phy_data->ntfy->sigs.he_tb.tb_rx1,
 			     OFDM_UCODE_TRIG_BASE_RX_NSTS) + 1;
-	rx_status->nss = nsts >> !!(rate_n_flags & RATE_MCS_STBC_MSK);
+
+	rx_status->nss = nsts;
+	if (rate_n_flags & RATE_MCS_STBC_MSK)
+		rx_status->nss = 1;
 }
 
 static void
@@ -589,7 +592,9 @@ iwl_mld_decode_he_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 		break;
 	}
 
-	rx_status->nss = nsts >> !!(rate_n_flags & RATE_MCS_STBC_MSK);
+	rx_status->nss = nsts;
+	if (rate_n_flags & RATE_MCS_STBC_MSK)
+		rx_status->nss = 1;
 
 	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
 				 IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN);
-- 
2.34.1

