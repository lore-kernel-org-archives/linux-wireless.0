Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4135F3815E4
	for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2026 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774473372; cv=none; b=kdCgGrrKruz2uNLzmW6YIXuczCeQp3z7jNLX8lsDp+m+2fNSTU5cPLGU/uPE/4ERC2zd3hIGajA4z9MfYCUU4UWudUA99RLqZBYdJ+4TYfdlEukH4MfBXPvi8aNguTe7XIDCHKEHyvHE4iaSzZSTu0Zm5Z3niLYjUViEjrt1Zxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774473372; c=relaxed/simple;
	bh=g1aBotgoNT2wA2P/AVz++ZTkis3o+/uR384s1BKIjfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ivUcXtkJ+7el8AkXC62m/zGdms+Od2lAc/MX/l9Wq6Ge0ED3VULDcEkvSVmbop914RhiKfbSIdWj2/32+gsKDt6L3u6umxqUQFwDM+itkZbxdQ/1m4pFQQJUgb6hFw5gfpU2bF+LUsdCTpyWLs4OYQFhniqkoWLopGlxBGV+4t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gcROTrWT; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gcROTrWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774473372; x=1806009372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g1aBotgoNT2wA2P/AVz++ZTkis3o+/uR384s1BKIjfk=;
  b=gcROTrWTNvN2VzMfT0r1Hr3kbwDfTLx8Q9+rqmJOC8FtA0udlQvdWLqy
   2SuxIh0NU/LVyiQv7mvRVJQsdiaP3jZT2V2hJFejC49z0zUb3y81m/NxO
   kkcVJAgxTv1Q/t+IHDToFoDE6r77JjelhxscGpLi3MLR9kNOy9sPASfaA
   cuuyhz/UMS39imNhc+JtAb++4qU9TMlBHYloUydpCBgptRLXVGru0CqCj
   ATx3v5dwf3GHED2KqoanhQ3Yfaf/YTbN7wYdyUAjq8st0Prd/Ug81Fs6T
   QzSnqpZNCpfSCIcxyU+zO2+qZg2gHepuM4tMQNVRak0G8M0wr+pMRMBNR
   Q==;
X-CSE-ConnectionGUID: HfVxT2BgQbGp2QYEztsjRQ==
X-CSE-MsgGUID: RCpeycOsQiGZFwvDSYd2AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75485389"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="75485389"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 14:16:12 -0700
X-CSE-ConnectionGUID: nRseDtjfRZGxsXUed/Jpug==
X-CSE-MsgGUID: IqvF0LDITnyFPwLtGbDN7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="224747560"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 14:16:10 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 15/15] wifi: mac80211: allow add_key on NAN interfaces
Date: Wed, 25 Mar 2026 23:15:36 +0200
Message-Id: <20260325230443.d3b9dfd1638a.I5b7c646c456d4112e5ab8663026153ace9b6b7d6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325211536.910411-1-miriam.rachel.korenblit@intel.com>
References: <20260325211536.910411-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Keys may be added to the NAN interfaces to protect
NAN management frames and data, allow that.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8cdbefac1bee..210f0030f228 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -702,6 +702,8 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 		break;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_NAN:
+	case NL80211_IFTYPE_NAN_DATA:
 		/* Keys without a station are used for TX only */
 		if (sta && test_sta_flag(sta, WLAN_STA_MFP))
 			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
@@ -718,13 +720,11 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_P2P_DEVICE:
-	case NL80211_IFTYPE_NAN:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_OCB:
-	case NL80211_IFTYPE_NAN_DATA:
 		/* shouldn't happen */
 		WARN_ON_ONCE(1);
 		break;
-- 
2.34.1

