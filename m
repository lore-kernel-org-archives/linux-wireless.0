Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5815839BFEE
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368447; cv=none; b=YpKeOc+F/SK28M0Jxj8DowNo9vju1mlIfJVroisg0cOlcf+2NwWXg8H72J76329VaJ+v4lYcNyW0QDcnpWzOuP68u4L7jvtvqfRWHoO4QywnKocKa33USfHdHOwqI79/2/Gcb7+0t1quLTB8g+PDSIH55z0X6rVKqQgIjdI4LnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368447; c=relaxed/simple;
	bh=FzpdefMChzKrxAyys0rudWSRMVkpcIaKdmJYVulS3Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1hKRyqQmlAEi07SUe5KAkF5rcV/vqC9y2d2MErdF8z7tyVQ+L24iEGt/hjoEOaX4kwKF9M52YeOY/VgPcUTCb82ntjVFltS6AXyPd6iyWhX8Slr+i1lDeTgp6r0Gr0tbq0Tg0xLCkQLk/JukJmQSrMHQWaLlz1A7mxsh2KoPyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=M66l9P5Q; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="M66l9P5Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=pnmzRitckKIAMEntcgv0lFhtwJ+e6bEVKyivXPq3DT4=;
	t=1777368446; x=1778578046; b=M66l9P5QK3EnUHxU9guo0LGtpR4KTa5MNkmOV8XEcsRPldF
	HW1eoyWVmsPyS83c5o8QL/B9doLV2ou47RDlh9JJiDhniFUWWs/DKbZYpX9sjjfjPgEzJ7F+Ner4M
	RWy7PxsxA9OMfm0RDNtQg0/mppQNWq41qcPvhM9byg7fxRNfDlz1PNTwgAo+Jt3AGRnXZsU7d0z5f
	tVysaL+5PLRBvDqGdwta02JkgeyHKAFvNFw9fWGqVr7SKGXHND+E4YuTChrHip4e4ihDoDwNZPJSd
	UGPWO6e71meP6SDDnJ+KZJ3l5u9c97DP4v7OsdmwP5lLJeQU397W3D6SYxjVRQmQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeix-0000000HLwg-2orK;
	Tue, 28 Apr 2026 11:27:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 14/14] wifi: mac80211: check AP using NPCA has NPCA capability
Date: Tue, 28 Apr 2026 11:25:42 +0200
Message-ID: <20260428112708.5c354a838ba5.I8e957767cdbc1b224a22dde0a9c343c3a5851783@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428092708.71740-16-johannes@sipsolutions.net>
References: <20260428092708.71740-16-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If an AP advertises NPCA, it should also advertise NPCA
capability. Validate this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e23575745c38..f84bf50cb353 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -397,8 +397,19 @@ ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 		const struct ieee80211_sta_uhr_cap *uhr_cap;
 		const struct ieee80211_uhr_npca_info *npca;
 
+		/* frames other than beacons carry UHR capability too */
+		if (!elems->uhr_cap)
+			return IEEE80211_CONN_MODE_EHT;
+
 		npca = ieee80211_uhr_npca_info(uhr_oper);
 
+		if (npca && !(elems->uhr_cap->mac.mac_cap[0] &
+				IEEE80211_UHR_MAC_CAP0_NPCA_SUPP)) {
+			sdata_info(sdata,
+				   "AP without UHR NPCA capability uses it, disabling UHR\n");
+			return IEEE80211_CONN_MODE_EHT;
+		}
+
 		/* DBE is not considered yet, so this works */
 		if (!cfg80211_chandef_npca_valid(sdata->local->hw.wiphy,
 						 &npca_chandef, npca) ||
-- 
2.53.0

