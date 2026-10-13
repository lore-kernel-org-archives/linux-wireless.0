Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B97350B432
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898615; cv=none; b=p/lyU6Okh4Xj7svRi3Jj4k0cOxYu7TBkSSFr/gdZEJzVUdsy66xz+uFA51ymg8wDwG3eApqKub7cGU9i31ppTalBtvXcmVm1iY10VXay1aDSyq+8JD0TKT3JS+cAnbLNASIwr8pDpOy/qwBvEzkQ5/Axq+hhu1iwvVk1Orm4leg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898615; c=relaxed/simple;
	bh=BODYapP+da7TcI0f1AvPZVWOQ7zZyiHVaxRloTscWtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC116DVjt+X63rq2sW7t8i+Cg38iTOZpmOoT550rYHtLANu1q8ip5zkqJ80Uq9ebz26zqxyjyZwVuxdDpllbR6qT1c6gUMI6dAwCfNVMbUljLqceX49eYo1JSmAwUwkUB4IZWkQG43XSW+3nhIO8MH6LlrBc1RCbZqZJSYOv8bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UE8sIHwa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UE8sIHwa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=N5yAnjCP74Zr3knCC2/HdA+cfacdwoJHeJaF63K/I78=;
	t=1791898614; x=1793108214; b=UE8sIHwaSdiBkEf2g3jaoUIRPIc9t6mE+njVncdLZaUEPEI
	cyxf5L/ZEzOdIWo0Cl6q8F/dpJl0lRP92PfGH9c/KT2GvcNxQ17N+GIV1qT6YEeOqc34FOQv8kxXy
	P7/fVloEOYbuWUVoTavZMCoJdS9scp3p/Ijwl2alZXtbxLAvanTbP7rk7qRucHgtWXQr0vepWptR6
	s47QwHE+3X8n6KOLKNOSjO6D23g5v8QbpfdBq1u7ONtPky3ISlvhErcJ/qHNUyDAyrWSckKA8DtsJ
	dl0rhvxUkcgOoKyY1Q3JxeTYjSdWiDwDxeL9mXGkoxA7ejlQIn31YcJfrwj46UqQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgP-0000000HRBK-3J2n;
	Tue, 13 Oct 2026 15:36:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 03/10] wifi: mac80211: refuse bad UHR parameter update element
Date: Tue, 13 Oct 2026 15:25:15 +0200
Message-ID: <20261013153640.62286e7b16ae.I8398d927082b25e32c210b39919ed35c1e240e94@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013133640.270974-12-johannes@sipsolutions.net>
References: <20261013133640.270974-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If a UHR parameter update element is present but invalid,
refuse using UHR.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5a02bf98e14f..b17fd100f657 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -550,6 +550,12 @@ ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 	if (conn->mode < IEEE80211_CONN_MODE_UHR || !uhr_oper || !elems->ml_basic)
 		return IEEE80211_CONN_MODE_EHT;
 
+	/* if UHR parameter update is invalid, ignore UHR entirely */
+	if (elems->parse_error & IEEE80211_PARSE_ERR_INVALID_UHR_PARAM_UPD) {
+		sdata_info(sdata, "AP has bad UHR parameter update, drop UHR\n");
+		return IEEE80211_CONN_MODE_EHT;
+	}
+
 	if (!ieee80211_determine_ap_chan_uhr(sdata, sband, data, out))
 		return IEEE80211_CONN_MODE_EHT;
 
-- 
2.56.0

