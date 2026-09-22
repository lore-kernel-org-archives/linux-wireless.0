Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA6153D0D4
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077706; cv=none; b=H7C6iECB+lqxt+Anm7AK+naT/wPsKyryfKE15f6BmQ1vIeefn26T1YyM5mLT8JzFCvXwXvSm+UqQQEZZPsE4fpnk0j6JNg8z9ijrbcsjLmDQ+SohOUiEygmWf1hUMLbnuD3K7KHM5rzMdbX9MQtCr69go+0UHGTlAmyQCeLhKfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077706; c=relaxed/simple;
	bh=yDX72+IBhYqu/P62ftjrw68VsFKZiODz142lQSfCeqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BSGbGVVioJS7wNdIVv+UogUgGGlc1StOvKaYjbPJ+ry/dv9M8ldjqmtwGuXwk0SH39ijES7QUk1L8YhYedRCAp3GZSFH7kPqzSOfHxUNaeZFoNRCfr4ocaS53PgC39AvAu9eVQ47V16ikZ4uJlFV97Q4VbRCwSNW+WoAutGtjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INrUJhFQ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INrUJhFQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077705; x=1821613705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yDX72+IBhYqu/P62ftjrw68VsFKZiODz142lQSfCeqo=;
  b=INrUJhFQhE37qt7kBrSmhhvZ85AU7Qx0n4I4ggEDHhZ7Rd+qB+DMTqmF
   liA7CAfjtw1yffW9qsqiwoYTGMGpWOG5G8yC5fGEpHj9cyJNrZAqAFf2n
   ApcVbEHFsWLNTteqlk1LC7Acw1cOOvhEhe9cpKnEGbDCp3/FbXqUDdSRq
   +vWYplLylu61CviG9ZSxbIX5pT9lez1yQDM+nBg/HYU21AfkvW0p7KGpj
   LLc0efBAIbJEzzXAluih58Wd0lIQBq6zWHKtPscSR1JW8dkF2Yj9vr5y5
   +oElH+2MJz2rpmT5D6XXijn7y96FjZwmHR6lWmk7CGtWk3p+C2NKXUIiL
   A==;
X-CSE-ConnectionGUID: 3JGTsg3NQSGeTN3y8aqXvA==
X-CSE-MsgGUID: c2PLN/dzSI2rbZ+veSCS1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170550"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170550"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:20 -0700
X-CSE-ConnectionGUID: DDK2n6+4Qd2lS7S4ry+E6g==
X-CSE-MsgGUID: a2mRxzgOTfKm1EX9lhVBfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275417"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: mld: log error when missing a recovery buffer
Date: Tue, 22 Sep 2026 14:49:58 +0300
Message-Id: <20260922144819.afd6c953d680.Ibbf29ef47b99a9037a56b3342883376e9f7749dd@changeid>
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

If we are recovering from FW error but we don't have a reocvery buffer
(for example due to a driver bug), it means that the FW might not have all
the data it needs and we can therefore have bugs after the recovery.
Those bugs can be difficult to debug. Log a clear error in such case.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 7b1fb84a641c..e5866d89176d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -396,8 +396,10 @@ void iwl_mld_send_recovery_cmd(struct iwl_mld *mld, u32 flags)
 
 	if (flags & ERROR_RECOVERY_UPDATE_DB) {
 		/* no buf was allocated upon NIC error */
-		if (!mld->error_recovery_buf)
+		if (!mld->error_recovery_buf) {
+			IWL_ERR(mld, "Recovering without recovery buffer. Expect bugs\n");
 			return;
+		}
 
 		cmd.data[1] = mld->error_recovery_buf;
 		cmd.len[1] =  error_log_size;
-- 
2.34.1

