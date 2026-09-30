Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984A245A2BD
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755989; cv=none; b=i2RcJJto69CLF1nnf2SGa/OwwkzaXqxBr6aNo//EGks8BkY3p2+A52QGjcUNZoI1YW+UZ5NqiVS4W0v1Uld2BeN+VVi5as5mOeteqFJ3TiXB+eh0yNbQQHIrq5V6Q0KZiar/rT1CRuWgF8Wr38udhc0xdcrIm/1uvHrwK6I2hqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755989; c=relaxed/simple;
	bh=DPcXtCduZLDJOUn8hzeJELDzruV0AcDS16UF3vz5+RQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m6UdNlFM9VE+3dDn/dy5IOTZqqKGMQ7lkRlye+gGW/gaxI147sgxcBlIJzRUUnAheDttzF6WV+kql84TzDQs0Y0jdKa+eW/a2bPNVQ2fEf62vWYDhSpITukiqgvAu/t6XrIiH5m+Y1TABaxhNSCJWFSZR1bPQJ1kIvvWDq5H1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bCFQg901; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bCFQg901"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790755983; x=1822291983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DPcXtCduZLDJOUn8hzeJELDzruV0AcDS16UF3vz5+RQ=;
  b=bCFQg901YfBoxAcs4WI/aVYENeE/kjEd5l/lR48zdltsczVFEsm7p9CN
   jphLCp+fhr7aN7bq+HDDEN0BJ4MEw3w+thywP5F6zWCver+nNi98zt4Tl
   GIuBCW7vZVVbnVJuM9g9slGy6Qj5eXLWY8GcuqyT7crJndm8tCBfaqm8R
   TYqIbPox8it0Kp05BmC36Cqc8vxYLqG1SfLhKnRqd4FV+jgbmpDL2QLI1
   pUHMy5MMpvKXw5kROLgBaHJg18uw4WzPwn0g7CVb51NhEY3Mt26S9MWFl
   u+8jkqu8tMr7HOX3bkih/+Ffbv9ByAd4eGt2FCbecgmLbn6+cxDTzJgCV
   w==;
X-CSE-ConnectionGUID: lQPZk1QhQWaVDPd7laTw0g==
X-CSE-MsgGUID: 8sz7TylkSki7s1ql+zjWcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102058591"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102058591"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 01:13:02 -0700
X-CSE-ConnectionGUID: aMv6HkVwR+iy+WEHmHUQQA==
X-CSE-MsgGUID: giLGCfM8QfenWO/4XRbcIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="283707457"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 01:12:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next] wifi: radiotap: add field for information about observed energy
Date: Wed, 30 Sep 2026 11:14:51 +0300
Message-Id: <20260930111326.636781f321b7.Id8d5f0036705f42e496984c269956088bd85e067@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This can be used to report some information about frames that are
duplicated across multiple channels. The reported information may just
be an estimate based on the energy observed on each subchannel. An
example of such duplication are RTS frames that are sent using a legacy
rate but are duplicated into multiple subchannels for compatibility.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/ieee80211_radiotap.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 782c3dcd8b52..1881ebf8c713 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -96,6 +96,7 @@ enum ieee80211_radiotap_presence {
 	IEEE80211_RADIOTAP_S1G = 32,
 	IEEE80211_RADIOTAP_EHT_USIG = 33,
 	IEEE80211_RADIOTAP_EHT = 34,
+	IEEE80211_RADIOTAP_OBSERVED_ENERGY = 35,
 	IEEE80211_RADIOTAP_UHR_ELR = 37,
 	IEEE80211_RADIOTAP_UHR = 38,
 };
@@ -651,6 +652,25 @@ enum ieee80211_radiotap_uhr_usig_elr {
 	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B20_B25_TAIL		= 0xfc000000,
 };
 
+/* for IEEE80211_RADIOTAP_OBSERVED_ENERGY */
+enum ieee80211_radiotap_observed_energy_known {
+	IEEE80211_RADIOTAP_OBSERVED_ENERGY_KNOWN_BW		= 0x0001,
+};
+
+/**
+ * struct ieee80211_radiotap_observed_energy - Observed Energy (type 35)
+ * see www.radiotap.org/fields/observed%20energy.html for details.
+ *
+ * @known: Bitmap indicating which information is present
+ * @bw: The bandwidth in MHz sufficient to contain all subchannels where energy
+ *	likely belonging to the same transmission was observed. This may
+ *	indicate that the transmission was duplicated on multiple channels.
+ */
+struct ieee80211_radiotap_observed_energy {
+	__le16 known;
+	__le16 bw;
+} __packed;
+
 /*
  * ieee80211_radiotap_uhr_elr - content of UHR-ELR TLV (type 37)
  * see https://www.radiotap.org/fields/UHR-ELR for details
-- 
2.34.1

