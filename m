Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663770;
	b=kNPaVzo/lBkgaA34dKHVfRcfFAwtmUDaX0dJ/ajaYGV7QL0xBcp3H94mESW7sPglyj4f
	 3CyA1rkmI1eUkOAQv6t1UkvYhox4joCgg11zj3jEDQJXDZrRP46LqT6PUW4so82m+e6ez
	 PNKqIf9Bu3ysU0gqA185CsGregj0Ju2z+1xIN0h2P1sDYemfGjBnc3a3X3BRxx3Gq9x9S
	 IKJVlChGhyuVuAibo81DBp2oftLX7XVsBXXcscGoDC9hXmr6YB8vyNrFHVGbHrSP8vQCZ
	 9Ica3wXtfuM4y4PzbH8d/tOSika4fH/wpaePnEe/wwhw6R6i10D3mpFFtS5ghtKXVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663770;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eNir8LGbOcgLOW78S8zEEq2RpkSc+cNclHB1aQovCD4=;
	b=YB7BIeiy3nh01LE91Ak7LonD4qXSbN0iZHZaYItOoM7lW06QUhzSIAct0AUGnev1V/oA
	 1QS7/jrBuqLkXG+o02Rka7B4V0hBpGzzCgmxti+R3KbmgEZ8JHH5WfKFVcFEvxwdqRhxN
	 Qy5MwaLqzzCHXFwhExMediTmXOczUV59Ap7GhmbYksAucL9Fzk7XUq7mrOwUu8DNQugOm
	 wF9DR25P8bDYm3MpVnyrjztYQc2R4Njb3yZGtUE3foWvftUnawpq5Qr7/mKbUYS8JpVVg
	 A7k7+Ni4t2PX+8Nx8JPwWHJC1+0EKI0gdqnXwIUMCgKFyvbWVvni7+L20cQa6m76a2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=cTRLNq7+;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA66606A32F
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=cTRLNq7+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eNir8LGbOcgLOW78S8zEEq2RpkSc+cNclHB1aQovCD4=;
	t=1793663770; x=1794873370; b=cTRLNq7+Yo05iomwpLqjbFxaT+F7ecrQA9scWHonBJUAuaC
	UoTZ1nZdTBEh8seQQhs5BhCBsfVT80HTpKXUA/0zv4mfFPKhs9pxv2Pb56UIsadDuaFhCmb2HVU48
	Ds8MoMnP5tHK0lc+nKKU/LOT9AYOEW6+v5yk1BY8pO7IwrPRnGb/zFoK2bb7vsk8QWEmudffHLWe3
	Ny3wKRvKXvFAFfhc9Z4xxNl3aDU3FkWHUT8GRpHFptPngJKmiUIoJk0gLw/dgdv+4nV81TNL/DN6f
	RF/u7LDtTG+biH6oVExPXrdByxIUtanbYblR44hEIVI4dwh6cvPxDJ/EQlLxairw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO1sl-00000002AZf-2qpk;
	Tue, 03 Nov 2026 00:56:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/7] wifi: cfg80211: free scan requests after RCU grace period
Date: Tue,  3 Nov 2026 00:53:59 +0100
Message-ID: <20261102235603.1181883-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102235603.1181883-9-johannes@sipsolutions.net>
References: <20261102235603.1181883-9-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Drivers may, and mac80211 needs to, access the scan request
within the RX path, under RCU. Therefore, they now have to
call synchronize_rcu() before cfg80211_scan_done() but that
can take some time and happens under wiphy mutex.

Free all scan requests only with call_rcu() so that we can
avoid the synchronize_rcu().

Note that this then fixes some error paths in mac80211 that
were missing the synchronization which is no longer needed
now.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  4 ++++
 net/wireless/core.h    |  1 +
 net/wireless/nl80211.c |  2 +-
 net/wireless/scan.c    | 12 ++++++------
 net/wireless/sme.c     |  2 +-
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 46ba0fb27b14..516f6fa591fe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8314,6 +8314,10 @@ int reg_query_regdb_wmm(char *alpha2, int freq,
  *
  * @request: the corresponding scan request
  * @info: information about the completed scan
+ *
+ * After calling this, the driver must no longer use the request, except
+ * that readers within an RCU read-side critical section that started
+ * before this call may still access it.
  */
 void cfg80211_scan_done(struct cfg80211_scan_request *request,
 			struct cfg80211_scan_info *info);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7318cec3a956..729f6f4aa3a8 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -27,6 +27,7 @@ extern struct mutex cfg80211_mutex;
 
 struct cfg80211_scan_request_int {
 	struct cfg80211_scan_info info;
+	struct rcu_head rcu_head;
 	bool notified;
 	/*
 	 * set while the request is handed to the driver, i.e. between
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..f79645ee32aa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12013,7 +12013,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
  out_free:
 	rdev->scan_req = NULL;
-	kfree(request);
+	kfree_rcu(request, rcu_head);
 
 	return err;
 }
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ac56338f0f43..4954d63cca18 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1057,9 +1057,9 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev,
 		err = rdev_scan(rdev, request);
 		if (err) {
 			rdev->int_scan_req = old;
-			kfree(request);
+			kfree_rcu(request, rcu_head);
 		} else {
-			kfree(old);
+			kfree_rcu(old, rcu_head);
 		}
 
 		return err;
@@ -1106,7 +1106,7 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	rdev_req->req.first_part = true;
 	err = rdev_scan(rdev, request);
 	if (err) {
-		kfree(request);
+		kfree_rcu(request, rcu_head);
 		return err;
 	}
 
@@ -1126,7 +1126,7 @@ static void cfg80211_put_scan_req(struct cfg80211_scan_request_int *req)
 	if (req->driver_owns)
 		req->stale = true;
 	else
-		kfree(req);
+		kfree_rcu(req, rcu_head);
 }
 
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
@@ -1222,7 +1222,7 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 		 * The scan is already completed as far as we're concerned,
 		 * it was just kept around for the driver - done now, free it.
 		 */
-		kfree(intreq);
+		kfree_rcu(intreq, rcu_head);
 		return;
 	}
 
@@ -3713,7 +3713,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	}
 
  out:
-	kfree(creq);
+	kfree_rcu(creq, rcu_head);
 	return err;
 }
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b481d31dd8cc..2c5e95a701da 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -138,7 +138,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 		dev_hold(wdev->netdev);
 	} else {
 		rdev->scan_req = NULL;
-		kfree(request);
+		kfree_rcu(request, rcu_head);
 	}
 	return err;
 }
-- 
2.56.0

