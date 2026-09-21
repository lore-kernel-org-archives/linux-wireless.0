Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB933B3C11
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 19:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790020382; cv=none; b=S1nthyJ0BxQWUAPhzYG6n1hTh+JtWlbT2KeDZN1rsrHaHt1OhyqyhtOie9QloV4FaGp97Lgq7x7wbzkCIGJyxBPQUCkhZRtHSsI5SBKUi6nbdX1JrP9wTg3YzoxWcnTlCG9hZ2T9IoMVtCVsreTT+1jw0vOCqPQ/bZcR7qtRZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790020382; c=relaxed/simple;
	bh=aH8F5TG9/0ke0onMaFqQgl0/ELEfSzRzM7rjQgDvZew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B12iydAlwmnbzMF/osU71eI9Lqb6lTrZU8lbEOINZDWqVqbI237aHk2RAJ0w0dTVwFPMrv+7/cTQaz3f3FJJJ4fM88ZNJC4jmL3kj5dqWYpvpZHLAt8GqLwS6LLODTNHWBhEy5ycMw/QRkadJgOiCG90zNOY6vRLo7JGzgL2zhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LSCphxnu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LSCphxnu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790020380; x=1821556380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aH8F5TG9/0ke0onMaFqQgl0/ELEfSzRzM7rjQgDvZew=;
  b=LSCphxnuAWBtK3JalEpo4ruujEMQW6Ue06U1awc1fmYqT+143mMotZkf
   hdIGDkPQVY6rmmCCdz7oNIP8AL6gGpr9DJ8aec56JPdXe7VemP9B5RvBh
   MXAZy/ASLDU0IiWyj2Fg9MRbQwn0bmvuORus9SZPgiMLq2ctR9q2D/0/C
   a7A73qYqk+gE7q6t4ocgX3+QxugANmVgesnsTjQsrNaGPqpk3n6MuKVy5
   4SLmKzX4EyTT6/1F2ujdd3z2lOc+X/9nkPDDCgxcs6dLArIcFVwMoA/SD
   QQwyN9AuNKO7IiQ5fg6Qq/Hc2jzZJmCDmZiE2C66kpafFl9CDB04H45IF
   Q==;
X-CSE-ConnectionGUID: 3ocZcQ+TRCWH4Qk59spzlg==
X-CSE-MsgGUID: 8bgsIfUQTrufpHozEMlWnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90435090"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90435090"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:52:59 -0700
X-CSE-ConnectionGUID: TViok0D2QkmyQTvkKNzrYw==
X-CSE-MsgGUID: jY+FuEe1TWeX3FxfejhjtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="3891576"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:52:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: nl80211: reject color-change requests that change 6 GHz power type
Date: Mon, 21 Sep 2026 22:54:55 +0300
Message-Id: <20260921224731.1d8727ce4fbf.I1049058ae5e60b7ebcb450d03f6b13cee573eeea@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921224731.67fbc8a28a2c.I5633284cb4c82ffb4e4e32e6f2dcc9a71fd5b06a@changeid>
References: <20260921224731.67fbc8a28a2c.I5633284cb4c82ffb4e4e32e6f2dcc9a71fd5b06a@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

AP power type is regulatory operating state, so changing it requires
full AP reconfiguration and validation. Allowing it through
color-change could bypass stricter checks done in AP setup.

Keep color-change behavior limited to color updates only.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/nl80211.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0323b9c383b7..919ac18a2e92 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18944,6 +18944,7 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_color_change_settings params = {};
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	enum ieee80211_ap_reg_power reg_power;
 	struct nlattr **tb;
 	u16 offset;
 	int err;
@@ -19045,6 +19046,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 			goto out;
 	}
 
+	reg_power =
+		cfg80211_get_6ghz_power_type(params.beacon_color_change.tail,
+					     params.beacon_color_change.tail_len, 0);
+	if (wdev->links[params.link_id].ap.reg_power != reg_power) {
+		GENL_SET_ERR_MSG(info, "6 GHz power type change not allowed");
+		err = -EINVAL;
+		goto out;
+	}
+
 	err = rdev_color_change(rdev, dev, &params);
 
 out:
-- 
2.34.1

