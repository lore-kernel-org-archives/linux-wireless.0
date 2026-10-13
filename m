Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906464F68DF
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898614; cv=none; b=I/Td9Y3TkVW73fwX0rMXNfFmEI+gFyjCPxUNTYPN+0KQQjFWXb5vrwWQhpgesxI9eQR/wNHC0CeGiEhGXqM6yNbIOtORJ8UxSqqinFftdoLCKbtfvbnBPlZgG7Og9ml209FWN644w8+2ipC28VE3Djjenhg+KNXLLMiKSwL+evg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898614; c=relaxed/simple;
	bh=WoNoj2iC7NHHA0E2UlPMVlfir5mMIYiNGXdUjA8KcVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inb0AP6l3tWxNvMRGk61iYDcTY5TbuGMxbQHVRo0j/ETNhEhpqIoSkg+myA8GzeC4W4Kn2lhMEBVtJQEBEbeIVFpki/+xC3PQshzxrnqTkmUDXM1N7/8YYE7IzGZnCh0tUUWMjtrUQXve1NI3BHW0OxGJkyxXtjEiCc+IYNWfVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=N5s4L93h; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="N5s4L93h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4vO/9Mu53IJW0DfrhizuBY+BW/UCV+kV4+hgSEp2Bpo=;
	t=1791898611; x=1793108211; b=N5s4L93h8C7Xdw2C3Gig25hy57dhim/7JwJGSxLSDBTrAxI
	vqeb5xSBdDReAsF4s/PnBIdPv352owq1XRJNecG/SBswKEab3ELCRj6I6jenqxLp+GnSc+mwLU8E9
	6pxPk4QBn4XT3qwimyKrAhW19GB8iaS/41gpzIamLxOF9nQ62MxmPOAcU+AhbG1CagDqMbtiySFI3
	0VNZAoYyAOAh2MmZLL3hsnCw6jcswrTTk5vUzLYZ2G/xorNZPsHimNbwKz+Hhh8dczPSEV6rRy8YW
	CvH6Es5Bf9ECXf5wm9r6fsMSALRnX4KMVseTHUjMb7fZOopvJU6JkkPf7wSjErKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgS-0000000HRBK-3arJ;
	Tue, 13 Oct 2026 15:36:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 07/10] wifi: ieee80211: check DUO in UHR operation size
Date: Tue, 13 Oct 2026 15:25:19 +0200
Message-ID: <20261013153640.7170e4ee362d.I65287c8da8c22a1753cd734488f77d2705f370ac@changeid>
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

If DUO is indicated present account for its size for the
length check to avoid later over-read.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index f2adb26cad66..1a1801783f2c 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -312,6 +312,12 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len)
 			return false;
 	}
 
+	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_DUO_PRES)) {
+		needed += 1;
+		if (len < needed)
+			return false;
+	}
+
 	/* NPCA Operation Parameters (fixed 4 bytes + optional 2 bytes) */
 	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_NPCA_PRES)) {
 		const struct ieee80211_uhr_npca_info *npca =
-- 
2.56.0

