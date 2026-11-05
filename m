Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863502;
	b=yJ6jPKUTTDS90HYGixOFWHALlO1pqCpLoxKBXkIbTSwsZzEGSM+QKDHydhCHa8RUX+AO
	 Zof0i5EWMOxs1nrdHttesL7zMi6uMm97DftztldhHZkCPsNlnIzoPKm4SKcq8MHmc0ilk
	 7U/j8Gvyg653BYk4TIifW5NtFMRdg6w/kzPIu6YY/OndtWltchAAIHebsX37gqt4ygPob
	 NuMOptIKIJbUEXsb5MuGFiPB2RwJHWfkv0WiuW/JwvljbPand/PLNBpYlmrBwpQFku6ic
	 x1SD1bA/aAGmq1JfSARH1PqKeuWG3M4lb+WeIAKbWANpMFnVrCVQa8RFT5KKOFJ4SVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863502;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TTlq8mCjJMLfUvBgXw1arp9feK8pP6imSYHInsxN/YE=;
	b=K3316Zta2w1i/LK63LJzeas8EoDLpiiVd6kaqhFg72ANPZ28B5uAYgxRJ3UvFPKev3/d
	 rsCw25PDX3WE3J4qfzY+JO0i1FweMV+8BMIWjUmFna82b7fxVMyNMxrNHrf0YRb/Ivmkb
	 fs0zMwV+I94rKwRSEusglBNR55V6lSaV/pUcsLEOrVNIqAiiCL6SGdaUwsy08zBJyVSMM
	 RoPyY9RCEtAYlxxlgaroyUctf4N1Jjm/BR84yyiq2ODBQva9G/bH0dklFix+WHxolXDA8
	 DOvZhcWM/aegl7EbnvzU0THReUwq20eK4BbFV627BRIZLOBCvIKI8LDgo3G+ZZVk62g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=guekAdwn;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97509606A33B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=guekAdwn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=TTlq8mCjJMLfUvBgXw1arp9feK8pP6imSYHInsxN/YE=;
	t=1793863501; x=1795073101; b=guekAdwntImq/vwY/zvKKlmZIBjsbaKPgJyEEfCQetTutuY
	bTDOFglDKIaKUl2ajAvcN3Rd0rvJRgphCRK9kQockZKMdVELIqfdQH18eHbF4nnQ852/MBQs5tfsQ
	RkrSvb2CPOW0dQfkXX+E3j/MfH+2fdOZXNjYlYFptX8mAonTqlyT4dYWWJjyCjS2zj1LNflW3hRyZ
	/6qEluq7eRxunUG7iB/DDvfFK++pa9uEJRc4AtgoneymFvpiBPBiHAiAwz6Atsu0Wsv7QItcFrvtM
	LcKvV7pZDsKg5jxSSjkIJ17HG8qpEjFBzeU4ltzVLsTRAns4aK/NjG0hVjyRDNgw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqE-00000007Ped-0wRX;
	Thu, 05 Nov 2026 08:24:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 4/6] wifi: ath12k: register regulatory before wiphy
Date: Thu,  5 Nov 2026 08:23:52 +0100
Message-ID: <20261105072451.1710800-11-johannes@sipsolutions.net>
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

Soon cfg80211 is going to require self-managed wiphys
to have their own regdomain before registration. Add
one for ath12k, but keep the old regdomain update due
to potential races with user hints.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: keep the old code too
---
 drivers/net/wireless/ath/ath12k/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index c08216352c2c..3e365f879aee 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -15088,6 +15088,14 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	for_each_ar(ah, ar, i)
 		complete_all(&ar->regd_update_completed);
 
+	for_each_ar(ah, ar, i) {
+		ret = ath12k_regd_update(ar, true);
+		if (ret) {
+			ath12k_err(ar->ab, "ath12k regd update failed: %d\n", ret);
+			goto err_cleanup_if_combs;
+		}
+	}
+
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
 		ath12k_err(ab, "ieee80211 registration failed: %d\n", ret);
-- 
2.56.0

