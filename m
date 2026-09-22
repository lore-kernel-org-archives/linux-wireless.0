Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894314F4CFF
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077702; cv=none; b=HvgLss60C6tBnH0QJwLwlZsIuoT/HQcZHIGShLDTaRExVvcz/3dSymJvfEt9QRnhRU/OL5A7vBPCXmpz4bQ2RXsvpMyPc+I65Ck34SMyqti0qlg9AkucJbOzqtCAEQ6RPxSWN5LcCgtemae1pcrQdS0vc4eF9jg+R5nuBZsEAJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077702; c=relaxed/simple;
	bh=1l+iEAcUujG6TwLqd46RgevNntCrXeMaN6bzBVY4ruw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gyVco+XMx1Jdo3B0oF6zwUQNxC/va825TGxpXZOSZgLfo8URi4pDLUmiHXlRvxdB3oWfdmOhOxAxPM/XHTy6BEds/IRybD14DIdilfphxofZldAarM7HP3175KjdY8O4nUl0bR7NMi6SSRLo8XxAmUALmROHfgdKATbJYsMSGn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DCYF56rM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DCYF56rM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077700; x=1821613700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1l+iEAcUujG6TwLqd46RgevNntCrXeMaN6bzBVY4ruw=;
  b=DCYF56rM1htukNshp7qhO0lR0J9oBBVwtaFxlCdL+BwkG3B+6RiCYUMs
   HOpxsGICP0PpAXuL7MPcVLL8dOyl/Pg2WDSBv94ctvDMtmVDO6kLwHNtw
   /E07rmhbaS6Z69pbw8La8IfFscGgeb0Ql0kcjrF3W4IuzlC04pkAes7+5
   6nTAqs+IRBeED0jfw4DFbuI+DVDjLGZ0pAaBE1waJZLmRl+W6TpQkYBk8
   rnpRxLvIVRgpiXPXmpwCPhmjH4ZzH5txS6urPI4N0StwkAuF5nJdcYykD
   SrWl8FRNDb3edwpcYL57HQR0j0WQIsER5KMQrEZ5ihRJKznl0jrQY8YTW
   A==;
X-CSE-ConnectionGUID: fgnfcHFFQAumqCDTvdiSRA==
X-CSE-MsgGUID: MOZ6QbARSYiKPzmy0yGLJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170517"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170517"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:10 -0700
X-CSE-ConnectionGUID: xomJ0yzLSCSZvSIFXHT7Ag==
X-CSE-MsgGUID: usnwDgWqSPa91JRCVP7+Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275350"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: mvm: validate NVM read response length
Date: Tue, 22 Sep 2026 14:49:51 +0300
Message-Id: <20260922144819.a9d384de40a0.Id6028e4753a2af5638bed0279bbf55842845df3b@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Treat firmware-provided NVM response length as untrusted before copying
data into the host buffer.

Reject responses that are shorter than the fixed response header, where
reported bytes exceed the requested chunk length, or where payload size
does not contain the reported number of bytes.

This prevents heap overwrite and RX payload over-read in malformed or
malicious NVM_ACCESS responses.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index f76e57399c1f..54006d5e15a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -86,6 +86,7 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 		.data = { &nvm_access_cmd, },
 	};
 	int ret, bytes_read, offset_read;
+	unsigned int pkt_len;
 	u8 *resp_data;
 
 	cmd.len[0] = sizeof(struct iwl_nvm_access_cmd);
@@ -95,6 +96,12 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 		return ret;
 
 	pkt = cmd.resp_pkt;
+	pkt_len = iwl_rx_packet_payload_len(pkt);
+	if (pkt_len < sizeof(*nvm_resp)) {
+		IWL_ERR(mvm, "NVM ACCESS response too short: %u\n", pkt_len);
+		ret = -EINVAL;
+		goto exit;
+	}
 
 	/* Extract NVM response */
 	nvm_resp = (void *)pkt->data;
@@ -133,6 +140,14 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 		goto exit;
 	}
 
+	if (bytes_read > length ||
+	    pkt_len < struct_size(nvm_resp, data, bytes_read)) {
+		IWL_ERR(mvm, "NVM ACCESS response with invalid length %d\n",
+			bytes_read);
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	/* Write data to NVM */
 	memcpy(data + offset, resp_data, bytes_read);
 	ret = bytes_read;
-- 
2.34.1

