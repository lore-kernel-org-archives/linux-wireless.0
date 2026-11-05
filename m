Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863502;
	b=FHTAtO95gA+4qcVtuiZ9PwLWpSW9AWoZh9MDSEQWUd0bYzlnVVcJMyXoBfbVsuYCV2A0
	 4y4TIIYSWzlCLQ/cXkLPQlb9A5Uk1fqoVwd9mnB6h8ZKMcpTzETD8anjWzGUs7W78yrcN
	 UpTkiAgTtJ46u35GIMwX0Iq5Mc+K0MfGEY9qXEeEaGhwdNgw3LnrGMACl4geDj3nLgbhD
	 nz917Y1QwBRKNBjU7Dwn47wvssVjoTkECYV6kvgaoAEYKGKcMLX/oXV1Lh5XhsqkGEy84
	 XaPC/aPxQ1awYU0oW8GolNGvD0xXSALZ3BhI3KOi0EHpsFHJVAjNM4TLaHd0rHWQ5+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863502;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=LXUFZNu0I8dcHNELYgAHt8Di53PwXKOh2WUuYRvx8Yw=;
	b=mq8Hs90XH5Q01+k7G5QeDngZUlDZhmJlZBk+BZ/ARSn3//3LIgHMDLnigse0vsiQ85AI
	 UFt5/Ax2Ma8rRLIayvLZCO1fkTni65bGG00fHXhZ4lSj9iU7o7cymYBebD4ms0XN+lRBu
	 N8CoNZSp9hx98hp+IoisKVyVZQ7rSSMMSCDZATNO3kldq5O0zHiG8zKspfVHQLbINLD2e
	 JyuySPfuKQFYePBtWakemNwq5HIwPwlRxblgAZZusU2BmF/48QrJL9IgJp5FRyZ1mysON
	 pf1617ymPzuhlnc6LBUJhpE4LZgaoSCtNfmuNIQRDqr58sxgWXTr8QgXwir7TrEBJ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=g8QSg282;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E15606D803
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=g8QSg282
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LXUFZNu0I8dcHNELYgAHt8Di53PwXKOh2WUuYRvx8Yw=;
	t=1793863501; x=1795073101; b=g8QSg282rMPIWns7r8/kZKicxGDnl42Kp+sJMEO+nInw2qj
	czUhiJLtSUg4/kTgqdOmYYXiNdeKS+TWQwDzFgjrSUp2DBGuqxes5wJYClEkLGU7ueuhq6Cpbu48x
	Hcm6Hg2fNsmyJ0tjkpnD6OtTW+udiW9utFoou7CQjJQD+n3yGGfGIvdENZu2lEJJrNR0lBSTqhrqj
	pr8bfZpCeb4Cu8lzdgm8g0D89ZrcEdp4zwhcIbqBHetDdnuyAe3B3bFGfmLg2TEiTIp05n/xFzDsf
	+Tf4nXfx7jW80ajKypE8MH5d/Vdk8pc+yaAkXFwh1Qh3U+TzM/Q1tZ+vYQ9TNL+Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqF-00000007Ped-03vo;
	Thu, 05 Nov 2026 08:24:59 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next v2 5/6] Revert "wifi: iwlwifi: mld: Move regulatory domain initialization"
Date: Thu,  5 Nov 2026 08:23:53 +0100
Message-ID: <20261105082451.8c635c94a417.I3e7049a6765887736a9284beef2b0d7ff49f7748@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105072451.1710800-8-johannes@sipsolutions.net>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
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

