Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FA541CB5F
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499445; cv=none; b=cWhQFcFGli3GlW5iRNiieekpdviahIypMncEp1iKmFYA4LEMlOQKApQZ+u7xmi52YLextPwrA4cZC5D9ZMofRgUt2eVHsbLY1fDaixVA6dL9pTs/efNNgBS+O4CjXCLVpLXqybbIcSvKSHPVmDM1Dab8yG/pAjebBnGtR5Nr2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499445; c=relaxed/simple;
	bh=swbBxxTVV9JAsY8vfRG6ac5RaOczT3pnbfZvhxHCzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7HkmYJzJIAOn9WunbvnX3cZkFSRzBNsh4ZmbvRW0N/Ko1nqFONd70WetOyOF1DnYiumX34Mt5ur261gh2j2tfG6+7FWaozC9vSDlaTPNJVNDgJLr3VlFJQg9tEjY/YYr/XLUHg0OMFk/gtLDuU/WKQm/RAqxhvjQTmRM4BpOus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=DCol1moP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="DCol1moP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eZIT8iGjeu8DchLVTYreiw1M07dakGQadvsJ1F2UJsQ=;
	t=1785499443; x=1786709043; b=DCol1moPS2s5fRrFtlxdUmW/D3QBZXZ2uvnIfke24HS9pfl
	cHSmDHKIQsoTVf5qhfPAxxTPJSxcmrxVMx8W2x9gJ3ahc4Jn3eBPdcTSarOKNfCZ0uln8RZqbn8pr
	0AhdcaFvE5SaVNKVF2tBPKsoBPxKkFNSc9via+2cACNFvMoVk5aBVG6sf+kO7kJgeMfLIH3p5OxBQ
	Hohgxo1ZilTXhtV5/EGzwLcdW4cPLKt10rxiTHg3TGHdNW9cbe1ca5p9RRqEa2fzMqgb3i0iXy36w
	dPnb8eaMFSc6R6isfJr4BnnUqX3MARFyU4Pe2xbeMFoQxarJ2ygtGWCHOfCMThTw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wply4-00000001n1K-1Bzi;
	Fri, 31 Jul 2026 14:04:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: skip DUO params when looking for NPCA
Date: Fri, 31 Jul 2026 14:02:32 +0200
Message-ID: <20260731140351.cb57484a68b1.I229dcd80b8e30c3fdfe8eedb81725dc35d9d9fe1@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731120351.213903-4-johannes@sipsolutions.net>
References: <20260731120351.213903-4-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If DUO parameters are present, they need to be skipped.
This was missed during the D1.3 -> D1.4 transition and
causes frames to be mis-parsed for NPCA when DUO is also
enabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 665d4b3a5b41..398ce01fcdee 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -341,6 +341,9 @@ ieee80211_uhr_npca_info(const struct ieee80211_uhr_operation *oper)
 	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_ENA)))
 		return NULL;
 
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DUO_PRES))
+		pos += 1;
+
 	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_PRES))
 		pos += sizeof(struct ieee80211_uhr_dps_info);
 
@@ -372,6 +375,9 @@ ieee80211_uhr_oper_dbe_info(const struct ieee80211_uhr_operation *oper)
 	if (!(oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DBE_ENA)))
 		return NULL;
 
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DUO_PRES))
+		pos += 1;
+
 	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DPS_PRES))
 		pos += sizeof(struct ieee80211_uhr_dps_info);
 
-- 
2.55.0

