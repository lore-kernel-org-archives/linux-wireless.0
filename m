Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807101922FD
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2026 13:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631715; cv=none; b=XPPw4ElRhnDMLSPTKr+jhhlh4Y3J1sZ9963jQVXteG4xC1nceFN6YpFzDytBuDu0+umMVWrB6wv3dJezatwM+iKrIkPE+aR8aNQFJTwWhzeeNrlJbGjEnO5OvNThcnBLH2llp1vteet0kxr2EbncasKMiHNXPIFQIfD6sg/j4ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631715; c=relaxed/simple;
	bh=d9jxDBm0ns/usv0ncbYnhVxwyMCfWXVUjpTFmKdbJ88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EOgF7BeNnH6LK2DKOS3N2ck1q0WzSlVCRj/zEuIcuDhLOTlfKCOsnVogk0oZZJ9FpSuRwmKCQGn6b9j06YXRO26hn61IQ6DJNXlT6xaA9+YA9Q+UayVdr23RMbD4DgOz7D91L8W1ti+V2bowO5BSoAunUxEYa8czV9h+vONJPSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uokY9ic1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uokY9ic1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XeXt2YG/IbQMsBKlFJYG227UKb4AxZEzeNuMx0m7Dzk=; t=1772631714; x=1773841314; 
	b=uokY9ic1c7OBGb9DIttwcZFnobBy15+zxLtb+QBvyAvTiTMJSFB6y38+Pt+oQbWiyQ+sv6ajidp
	yPxkuRP97Cax4AucBOb8bjh7g1x97vMDeOXDc89WvQwsC2LxnsvMOGEsXOxzqbpaBtp2FRIf+Ta/Q
	WjDilzh0PM1f4wMtNDm/xb8cFOWinfHMHKBoHdssZbwyF176U9D+Rh0w4POMw702cv4Vb4Dvj3V63
	Z334qnp3ibuLd8yMgueV5BAtntNUzcfxU8l+udEd0t5CAkuskC2Z7kxFyqtZTgvqDCUYDaWaG4SP5
	6EelZvE/knm+8JDflkl9tFBkB13pvcinYk7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxmU3-000000086Jv-2I6a;
	Wed, 04 Mar 2026 14:41:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: ieee80211: fix UHR operation DBE vs. P-EDCA order
Date: Wed,  4 Mar 2026 14:41:48 +0100
Message-ID: <20260304144148.ce45942294e1.I22ab3f16e6376a19c3953cf81dd67105ea8e529d@changeid>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Draft P802.11bn_D1.3 switched the order here to align with
the order of the fields. Adjust the code accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 9729d23e4766..d199f3ebdba0 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -12,8 +12,8 @@
 
 #define IEEE80211_UHR_OPER_PARAMS_DPS_ENA		0x0001
 #define IEEE80211_UHR_OPER_PARAMS_NPCA_ENA		0x0002
-#define IEEE80211_UHR_OPER_PARAMS_DBE_ENA		0x0004
-#define IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA		0x0008
+#define IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA		0x0004
+#define IEEE80211_UHR_OPER_PARAMS_DBE_ENA		0x0008
 
 struct ieee80211_uhr_operation {
 	__le16 params;
-- 
2.53.0

