Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664328;
	b=brqRCiWhfQyUHD3D9geu/34icl4QxXU0w/o0QiAx68vcNSlxNwpMDZMS9qaJ74vGgloC
	 ORxl1ea+SHarr8eHjHchoL8tDDDBQnNLN+sNsTkn2dmNHfkS7EYpexJeZPANu14Ny6gF5
	 k9WIetmg2x1/DgZhNPbrh3Qvx22kOpTlVYHDg6Af/xxQ0T9Vf8lYWVUxuebaTzy8Nu3RX
	 PFdGxJSsY27fR8Bx5N8sExvbfNuVzhglcADCRD3EhbKsgqmlyFnO7VI/D/QciZUd9pxoe
	 n9RS6x8pJ39AWHcuicHtq46WHRevJmWiKc3OOQ8TLI6a7K4mgR5fm4qAh1MlA+AeAWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664328;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LXUFZNu0I8dcHNELYgAHt8Di53PwXKOh2WUuYRvx8Yw=;
	b=sf0cmWiG5ZjpGGC6gIFxiNxtIJuEihE6NWoPNoxElBmKJQJCEPM4AffYtpGsZtjZ0GHE
	 YmNC+2IyCPAlwdGGt9yU61rl4s824GMyJUilLKR9Xe1skjLVndzZS0hiHUlbNwF7+Rn0R
	 /FpGrTwkG4ylLnYzTeOP5D9pmZyacIHeafX1D0NmO0aXnxnp6i8sOmeRHGyrKDz0CgZqA
	 ywMxWOZDNTuF0O8nvIHOPQFt2d9+9Fi6MJw4JwchOUwxtxp+/7aooWLDXWjIL2bprm1P5
	 j+txcxrsaiZQ6Z23AJZyEi3cMwlfLvPalSql/UwTX0joKT8FiqV8oVwcOXcdlvp1AHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nTOegHZo;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAAB606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nTOegHZo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LXUFZNu0I8dcHNELYgAHt8Di53PwXKOh2WUuYRvx8Yw=;
	t=1792664327; x=1793873927; b=nTOegHZoOBTLskUfPBZ0j9wrqVavQCT6+SebeIWPrQ/9T0n
	uKKNZIcZxKEbhpaH1puPFWVx0/FQmSe6ZT2nBTJb5Sjxm0CvCYPcBGH7lcPK7E/OXYlh9Qw9z+/T+
	P402GLa2Z+DwcoKF2DSZ4Gy9Us0sI91v3qpM9a5bIE4hxoWXYGOFJHE8ci1oRnBDAD249/AKM7T0B
	9LdT+OTxITNtntNUFMfiCuU0pw39eGEHxOJ/+xVD4gCV3EOGiEzBGOkYz7xw+w8CUnEYIs6F9e2yk
	M1qz++vSKI6hJN3KA6FVkAPR2GIhPgihsuNdzko0p/PHNdt3VSrKyW5ea6LLi/kQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsj-00000004Ifb-3XvQ;
	Thu, 22 Oct 2026 12:18:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 5/6] Revert "wifi: iwlwifi: mld: Move regulatory domain initialization"
Date: Thu, 22 Oct 2026 12:15:36 +0200
Message-ID: <20261022121836.64d4ecec7915.I3e7049a6765887736a9284beef2b0d7ff49f7748@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit f81aa834bfa9 ("wifi: iwlwifi: mld: Move
regulatory domain initialization"), a custom regdomain must
be registered before the wiphy is, otherwise a warning in
nl80211 can be hit if userspace queries quickly enough.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index c33a553488ee..92e519bbc977 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -347,6 +347,10 @@ int iwl_mld_load_fw(struct iwl_mld *mld)
 	if (ret)
 		goto err;
 
+	ret = iwl_mld_init_mcc(mld);
+	if (ret)
+		goto err;
+
 	mld->fw_status.running = true;
 
 	return 0;
@@ -544,10 +548,6 @@ int iwl_mld_start_fw(struct iwl_mld *mld)
 	if (ret)
 		goto error;
 
-	ret = iwl_mld_init_mcc(mld);
-	if (ret)
-		goto error;
-
 	iwl_mld_tx_gp2_start(mld);
 
 	return 0;
-- 
2.56.0

