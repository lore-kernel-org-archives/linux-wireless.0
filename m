Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289E34CB8B5
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533789; cv=none; b=qO5O7ApU62HRSfWOUeg3zUdb+6ft/D+Q9zDOhlArM6uJ06oL4CLaIFAUZAhpnGuyEwkgbe6WIi3X88rIhnCoBwmQHszctjy67zWMBv1FgsWoQELFqGJim9TJxfkCgyZ22YvcNkwnP6O+2lwIjusDwTavNT8+/mB7V2yJtSK15I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533789; c=relaxed/simple;
	bh=KXbgTtJi3WjW3DTT7LRUyQLq73E8DKoha4hAl6gaoRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMFT2/Cdj8GsSXOap+k33OKHdRLZtXCicry8915QxX8/oWUipmkfoYzGK2L5xfC90dkqjxAjnDjOfVdSYoFTAnb/w6DydZshF9VD2X3b3ooAE/eiUGIDJ6lPesKtPkCL3TZT4Y3vLRq/Nh654nzRUyY6Zs61SniX00Pg52p17aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kAii9kLW; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kAii9kLW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zlPM8UXHQpBez30/BNfJLXZDhbBmht19YEb4VsIf420=;
	t=1788533787; x=1789743387; b=kAii9kLW/wcKlKXTYG41S42Cjax5JssWUhKdsIFTZA9lKC1
	ZnDoGCLXXeBtDCk0te5M7Wb7P6cTiKKL50WXvBEnR1+Byx6v9dMPDmqsrYUiVv056A1F1ETlYOKW4
	Hs7zLpmcNtdefIKzK8jT7QiSXmZ1/TfOj5kP4g9BnlIYCBS8MUopBzIKUsFfbvrSrmqOWHCF77J1V
	i0dP9MoogAjogucjGuLiUrmX3tZO35/MmC6T3f7dn67sSpijhdZiLhp6U1IJe5rSRJShuPyGrkYd3
	4cAGa+qBJahlwE1p3kavB6K4TjYxv9LP0wXCi04N2mCrFRqOCWiCSat4hWtgpCvw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VL5-00000001SUL-3Uvx;
	Fri, 04 Sep 2026 16:56:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+189dcafc06865d38178d@syzkaller.appspotmail.com
Subject: [PATCH wireless 3/8] wifi: cfg80211: don't free driver-owned scan requests
Date: Fri,  4 Sep 2026 16:55:03 +0200
Message-ID: <20260904165614.375e543228b1.I03cbb5a54cb02d6bba5034286af1ed73aba134d1@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145614.423902-10-johannes@sipsolutions.net>
References: <20260904145614.423902-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When an interface goes down while a scan is running, cfg80211 completes
the scan towards userspace and frees the scan request. However, the
driver can be convinced that it owns the request, since the cancellation
is (intended to be) asynchronous.

The WARN_ON() in the netdev notifier was meant to catch this, but it's
not actually avoidable, so it triggers and we get a UAF in scan_done().

There doesn't seem to be a great way around it, so just track that the
driver is still convinced it owns the request, and then just free it on
completion if it was already cancelled. Also remove the warnings since
they can trigger in the intended architecture.

Assisted-by: LLM
Fixes: 4a58e7c38443 ("cfg80211: don't 'leak' uncompleted scans")
Reported-by: syzbot+189dcafc06865d38178d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=189dcafc06865d38178d
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c     | 11 +++++------
 net/wireless/core.h     | 10 ++++++++++
 net/wireless/rdev-ops.h |  3 +++
 net/wireless/scan.c     | 31 +++++++++++++++++++++++++++++--
 4 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..8bb2cbd66b48 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -244,9 +244,8 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	rdev->opencount--;
 
 	if (rdev->scan_req && rdev->scan_req->req.wdev == wdev) {
-		if (WARN_ON(!rdev->scan_req->notified &&
-			    (!rdev->int_scan_req ||
-			     !rdev->int_scan_req->notified)))
+		if (!rdev->scan_req->notified &&
+		    (!rdev->int_scan_req || !rdev->int_scan_req->notified))
 			rdev->scan_req->info.aborted = true;
 		___cfg80211_scan_done(rdev, false);
 	}
@@ -1758,9 +1757,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wiphy_lock(&rdev->wiphy);
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
 		if (rdev->scan_req && rdev->scan_req->req.wdev == wdev) {
-			if (WARN_ON(!rdev->scan_req->notified &&
-				    (!rdev->int_scan_req ||
-				     !rdev->int_scan_req->notified)))
+			if (!rdev->scan_req->notified &&
+			    (!rdev->int_scan_req ||
+			     !rdev->int_scan_req->notified))
 				rdev->scan_req->info.aborted = true;
 			___cfg80211_scan_done(rdev, false);
 		}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b4610f6685dc..a0c2b6ebe31f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -24,6 +24,16 @@
 struct cfg80211_scan_request_int {
 	struct cfg80211_scan_info info;
 	bool notified;
+	/*
+	 * set while the request is handed to the driver, i.e. between
+	 * rdev_scan() and cfg80211_scan_done()
+	 */
+	bool driver_owns;
+	/*
+	 * set when cfg80211 is done with the request but the driver still
+	 * owns it, so that cfg80211_scan_done() knows to just free it
+	 */
+	bool stale;
 	/* must be last - variable members */
 	struct cfg80211_scan_request req;
 };
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 46849fe8d0b3..adcfd0278da3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -464,7 +464,10 @@ static inline int rdev_scan(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	trace_rdev_scan(&rdev->wiphy, request);
+	request->driver_owns = true;
 	ret = rdev->ops->scan(&rdev->wiphy, &request->req);
+	if (ret)
+		request->driver_owns = false;
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9e934b185e34..4fe114f6aee3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1114,6 +1114,21 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
 	return 0;
 }
 
+/*
+ * Release the scan request, but free it only if the driver is also done,
+ * e.g. mac80211 may cancel it asynchronously and still use it.
+ */
+static void cfg80211_put_scan_req(struct cfg80211_scan_request_int *req)
+{
+	if (!req)
+		return;
+
+	if (req->driver_owns)
+		req->stale = true;
+	else
+		kfree(req);
+}
+
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message)
 {
@@ -1173,10 +1188,10 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 
 	dev_put(wdev->netdev);
 
-	kfree(rdev->int_scan_req);
+	cfg80211_put_scan_req(rdev->int_scan_req);
 	rdev->int_scan_req = NULL;
 
-	kfree(rdev->scan_req);
+	cfg80211_put_scan_req(rdev->scan_req);
 	rdev->scan_req = NULL;
 
 	if (!send_message)
@@ -1199,6 +1214,18 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 	struct cfg80211_scan_info old_info = intreq->info;
 
 	trace_cfg80211_scan_done(intreq, info);
+
+	intreq->driver_owns = false;
+
+	if (intreq->stale) {
+		/*
+		 * The scan is already completed as far as we're concerned,
+		 * it was just kept around for the driver - done now, free it.
+		 */
+		kfree(intreq);
+		return;
+	}
+
 	WARN_ON(intreq != rdev->scan_req &&
 		intreq != rdev->int_scan_req);
 
-- 
2.55.0

