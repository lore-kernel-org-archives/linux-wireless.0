Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9F5376A08;
	Tue,  4 Aug 2026 03:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812738; cv=none; b=fJ+VnWaOzUmgXImr+jIw7PB8lDpYGEBjq3XM2goz7g340EhM3klqHnidP5Z0C7yHPtY/bFd02/KCIk8+jAtxswv0Nk+5f0N08zd0FOwBr/VOqZgktMBstNg3S8FmG72pngxd+lL4aAYfdDQjDvfwFRcxALu1KLsUBg5yc0hEkkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812738; c=relaxed/simple;
	bh=OV3biQmd94ysNNgJ4nTIQiGTUEzAo7UMTuKJzA8CS5g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pNK8jvyODtl2O5+CCAmIpikKhX96P3epNYgMUsa42xRQYmuEMkEXUogaYQmWe99Hl95A2tKDlk4sq6VeZ5gDtG47b2kWGUz1R2IpRfO7Cegel/3VFj3O1r9/ssF/3sZbcCjmmLs7pv71Souv08yVLL38q+ziW0Kvo1W7sX/hpeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=cERRzc35; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="cERRzc35"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785812737; x=1817348737;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OV3biQmd94ysNNgJ4nTIQiGTUEzAo7UMTuKJzA8CS5g=;
  b=cERRzc354fgLdhtd7fKSzkYtw4apJI6uhYfxiK5kb0ExsOXEiBZNIyQe
   iU2dpjc/7q+TeRzDRnTlSdCGCrmozJmkfV2CcGZokczAjFN3fETaEYrZ0
   AJ6J57pE89zxCd4zz4iJ/oGL36i27K5iRzfmeevHROM7B784tAmGx5fsy
   Y=;
X-CSE-ConnectionGUID: E4Fc/NKJSzK/s00WKvYmsQ==
X-CSE-MsgGUID: qaVCwRKyT/CBZ+RJXfKG5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="103351045"
X-IronPort-AV: E=Sophos;i="6.25,203,1779141600"; 
   d="scan'208";a="103351045"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE819.infineon.com) ([172.23.29.45])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 05:05:28 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 05:05:27 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 05:05:25 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Jason Huang <jason.huang2@infineon.com>, Chung-Hsien Hsu
	<Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Johannes Berg <johannes@sipsolutions.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] wifi: cfg80211: report authorized connect and roam events
Date: Tue, 4 Aug 2026 11:04:48 +0800
Message-ID: <20260804030450.232028-1-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE809.infineon.com (172.23.29.35)

From: Jason Huang <jason.huang2@infineon.com>

Drivers that offload the 802.1X/FT key exchange can know that
the link is ready for data traffic when reporting a successful
connect or roam event. Carry that state through cfg80211 and
include NL80211_ATTR_PORT_AUTHORIZED in the corresponding nl80211
notification when the driver provides it.

This lets userspace avoid restarting authentication state machines
after firmware has already completed the security exchange during
offloaded roaming.

Assisted-by: GitHub Copilot CLI:gpt-5.5
Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 include/net/cfg80211.h       | 6 ++++++
 include/uapi/linux/nl80211.h | 4 +++-
 net/wireless/nl80211.c       | 6 +++++-
 net/wireless/sme.c           | 2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 97c16d4ff127..7f576bb7325c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -9103,6 +9103,8 @@ struct cfg80211_fils_resp_params {
  * @assoc_encrypted: The driver should set this flag to indicate that the
  *	(Re)Association Request/Response frames are transmitted encrypted over
  *	the air.
+ * @authorized: Indicates whether the connection is ready to transport data
+ *	packets.
  */
 struct cfg80211_connect_resp_params {
 	int status;
@@ -9113,6 +9115,7 @@ struct cfg80211_connect_resp_params {
 	struct cfg80211_fils_resp_params fils;
 	enum nl80211_timeout_reason timeout_reason;
 	bool assoc_encrypted;
+	bool authorized;
 
 	const u8 *ap_mld_addr;
 	u16 valid_links;
@@ -9281,6 +9284,8 @@ cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
  * @links.bss: For MLO roaming, entry of new bss to which STA link got
  *	roamed. For non-MLO roaming, links[0].bss points to entry of bss to
  *	which STA got roamed (may be %NULL if %links.bssid is set)
+ * @authorized: Indicates whether the new connection is ready to transport data
+ *	packets.
  */
 struct cfg80211_roam_info {
 	const u8 *req_ie;
@@ -9297,6 +9302,7 @@ struct cfg80211_roam_info {
 		struct ieee80211_channel *channel;
 		struct cfg80211_bss *bss;
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
+	bool authorized;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..66b4cfd8de86 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2705,7 +2705,9 @@ enum nl80211_commands {
  *	in %NL80211_CMD_CONNECT to indicate that for 802.1X authentication it
  *	wants to use the supported offload of the 4-way handshake.
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
- * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
+ * @NL80211_ATTR_PORT_AUTHORIZED: flag attribute used in %NL80211_CMD_CONNECT
+ *	or %NL80211_CMD_ROAM notifications to indicate that 802.1X
+ *	authentication was done by the driver or is not needed.
  *
  * @NL80211_ATTR_EXTERNAL_AUTH_ACTION: Identify the requested external
  *     authentication operation (u32 attribute with an
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..55161ddb56b4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21198,6 +21198,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	     (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
 	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON,
 			  cr->timeout_reason))) ||
+	    (cr->authorized &&
+	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
 	    (cr->req_ie &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, cr->req_ie_len, cr->req_ie)) ||
 	    (cr->resp_ie &&
@@ -21321,7 +21323,9 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 	    (info->fils.pmk &&
 	     nla_put(msg, NL80211_ATTR_PMK, info->fils.pmk_len, info->fils.pmk)) ||
 	    (info->fils.pmkid &&
-	     nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, info->fils.pmkid)))
+	     nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, info->fils.pmkid)) ||
+	    (info->authorized &&
+	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)))
 		goto nla_put_failure;
 
 	if (info->valid_links) {
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2a719b5c487e..974e79f57392 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1067,6 +1067,7 @@ void cfg80211_connect_done(struct net_device *dev,
 	ev->cr.status = params->status;
 	ev->cr.timeout_reason = params->timeout_reason;
 	ev->cr.assoc_encrypted = params->assoc_encrypted;
+	ev->cr.authorized = params->authorized;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
@@ -1253,6 +1254,7 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 		next += ETH_ALEN;
 	}
 	ev->rm.valid_links = info->valid_links;
+	ev->rm.authorized = info->authorized;
 	for_each_valid_link(info, link) {
 		ev->rm.links[link].bss = info->links[link].bss;
 
-- 
2.25.1

