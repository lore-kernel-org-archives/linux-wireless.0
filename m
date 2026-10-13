Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87114F93A8
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898613; cv=none; b=B8oeaR94zRqqgHUjxHgUIkVnQ+8UDUgYQVoZKKOXrxm4RNWtqgTb7y1I6TiW7sPfY8C6E+fU0CzqmyjSaP+d3Ig/d2J+jCRGkEUaL8dqlSRT900L9XU4zNjAvsxQQJDIRelLTXXFoL+DWuiCHEB2nn9Gj0QYW5NRw7NYaDO/GBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898613; c=relaxed/simple;
	bh=L7BqVGl6aInw5itsrJ8K+3WVBgZmGAEYgTTPkkLeGa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elna6IiTgQ61e5knn7mEJOGhG4Zg8JXpwd0PoN//cow1MT1Qu0nL+fI2WQTLcYsa4ToLrD+Qd3IV1CWqo5LR8ZV2oZp7pidl+UYQ8+rzfo8dfKxXJBFBq5xTPB3o1slzPkoep+dJ2GrltfqkvdOrRBeScOnHnNCQK6Rc7YClozs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=AI+JrlqA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="AI+JrlqA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nxDMTVEda8uvFEavqm7Um8UxjUgtnOXKtg9MFMPaXME=;
	t=1791898611; x=1793108211; b=AI+JrlqAsO3uWJo+dCC60EcuXn+2g3yn0WTr80e5FauPoKn
	HKUG8fV2T4amnBSVQVxCt6Tt+SJdfhWIhpF7NO+tJJeSTwE8Q/1zabPnOB1/L7i8KyJ1+R1N+rDiT
	QNTP2Cl3GiVY2SKCP6KBbPx0UD3rHYza5EU8g8v7xPb+z3P/1wCiExjU+fZXN2yGvxLba5z1AvfhP
	bRzNux16KYOelGyqnF0/qUYcuKbeAgpsw2f2BxpRS3J6KDOChZ9KmqqeCOmTrJ/8wt8Rl58Nl1gM7
	Dozjb28dE84Aw3dfPx4B31W+px98cH+1RhyhZzNwnVPCHLX30JhPrxgWXiaa7CUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgT-0000000HRBK-2RUQ;
	Tue, 13 Oct 2026 15:36:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 08/10] wifi: ieee80211: fix reconfiguration MLE size check
Date: Tue, 13 Oct 2026 15:25:20 +0200
Message-ID: <20261013153640.46883b68e1c0.I48ef9b2695252b412c724c45a35ab4e2ef498ccc@changeid>
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

The operation parameters are three octets, and NSTR indication
as well as DSO information was missing. Fix/add this.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-eht.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index a699d108eee6..cada6270f60a 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -1189,7 +1189,14 @@ static inline bool ieee80211_mle_reconf_sta_prof_size_ok(const u8 *data,
 	if (control & IEEE80211_MLE_STA_RECONF_CONTROL_AP_REM_TIMER_PRESENT)
 		info_len += 2;
 	if (control & IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_PARAMS_PRESENT)
-		info_len += 2;
+		info_len += 3;
+	if (control & IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_NSTR_IND_BMAP_PRES)
+		info_len += 1 + !!(control &
+				   IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_NSTR_BMAP_SIZE);
+	if (control & IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_DSO_INFO_PRESENT) {
+		/* "Offered 80 MHz DSO Subband" OR "DSO Confirmation" */
+		info_len += 1;
+	}
 
 	return prof->sta_info_len >= info_len &&
 	       fixed + prof->sta_info_len - 1 <= len;
-- 
2.56.0

