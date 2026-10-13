Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD09D331EBC
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897185; cv=none; b=sMxwLrtxj4SsSKL95eiR7+4vZaK6ZSHXzB7j+VZMZOAZA2EfeYAIAlkVF1mbIFCscNtDrAlOWwxkap9hVxHWwU76X631BwhImyxrq9iPm6AFlHlPGYMBogpv/86Sb9B+CjhxISXMEE2pxdr0PvUsqtWAWlZ/kljWMJlmi+cwpSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897185; c=relaxed/simple;
	bh=lQiyJkMa8ZnUzQBo/wbTeKIdlFCRgMiZPPBBZPhnBMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L3Xg9y+KyW1iekKeg3ymcWrXsqGnwJOxlfmEM+j34yldhBDKGUmTSevWnQJSXnw2sxytbyVJhdYmCEUjSSDmTn1B4dBaCczsrJyBh1rrWeZNIVnNEvvldDwUcsnVPYM+5YG+DmNwLIBz9mWCm8mePtr8v38M1F8W+pU1PJ6VnaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UKRqSbY3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UKRqSbY3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=hDJxJrgcxF+7mYN3v92bv2KfYb5YY0gPO/09vhPMMfg=; t=1791897183; x=1793106783; 
	b=UKRqSbY3RYzZtnyLMXVGlCQ7AONaPtyAVkty/lRYROnKOrfHEGPkX4XuVsAPX0cxQgDrsdS9cv/
	d09r+1Ff3ASYj5LXOFNY6ufaG1P5RBDKvzBW0MOedgHzXydc/PNFpEobLspvyByQNMRn0wZ0vTsFS
	4bHxi3NWHezbUMNZgTs2N2+oZy8VrG+tpTllzl4WQobClYq67jIYTOjEZWnc8vlRXpCknJahysh0A
	/JBsHR6YtDNDPYn/ZbBlBC/HBP+LRXcjsBX6R9rWmNLDlWcr91UvTcClYSfaIahkdMNkKtDdOtyuG
	x3gaMYfu7qRH3fqGypX4N22jENMv+ECx34Hg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcJQ-0000000HPqi-2Wyu;
	Tue, 13 Oct 2026 15:13:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: track SSID regardless of country data
Date: Tue, 13 Oct 2026 15:12:58 +0200
Message-ID: <20261013151258.7fbca481c328.I7beb03fb4309698bdcfade57c6804573f96eeb18@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If the country data cannot be found, the function exits
and then doesn't track the SSID. Move the SSID tracking
up to fix that.

Fixes: c38c70185101 ("wifi: cfg80211: Set SSID if it is not already set")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index fde86c900f4f..710472c197c9 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -872,6 +872,25 @@ void __cfg80211_connect_result(struct net_device *dev,
 
 	cfg80211_upload_connect_keys(wdev);
 
+	if (!wdev->u.client.ssid_len) {
+		rcu_read_lock();
+		for_each_valid_link(cr, link) {
+			u32 ssid_len;
+
+			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
+						      WLAN_EID_SSID);
+
+			if (!ssid || !ssid->datalen)
+				continue;
+
+			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
+			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
+			wdev->u.client.ssid_len = ssid_len;
+			break;
+		}
+		rcu_read_unlock();
+	}
+
 	rcu_read_lock();
 	for_each_valid_link(cr, link) {
 		country_elem =
@@ -897,25 +916,6 @@ void __cfg80211_connect_result(struct net_device *dev,
 				   country_data, country_datalen);
 	kfree(country_data);
 
-	if (!wdev->u.client.ssid_len) {
-		rcu_read_lock();
-		for_each_valid_link(cr, link) {
-			u32 ssid_len;
-
-			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
-						      WLAN_EID_SSID);
-
-			if (!ssid || !ssid->datalen)
-				continue;
-
-			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
-			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
-			wdev->u.client.ssid_len = ssid_len;
-			break;
-		}
-		rcu_read_unlock();
-	}
-
 	return;
 out:
 	for_each_valid_link(cr, link)
-- 
2.56.0

