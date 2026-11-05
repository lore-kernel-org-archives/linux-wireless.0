Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863501;
	b=jc2AKBZxTUkOpoAClPi9YF+CqQBDhaU3CY+IXLQ/aWF8b7vxszFxnnNvT7XrurjjYJC+
	 QFcwjq9Q/OVEJ/sPDGk37kmX03grCRXseieizkeN4beh5TXaKfsDp/9Un3QmEt1dMOYYE
	 T379U4w6WueAwrYtLSKH04VN+M/P3bztWMGXddHIQq2swMzxmhje6OtLbtqja/32oFtpc
	 XKEU7FiBKxFWyDNf3n1XAyphcqxROjFksNXMuIotFPmKViN+5ehG4b2tPuZnNXDKIZLIn
	 dgERp0k/Z6uP56LnpvD5HKC0HKiKfEeDZqP16afWBlDCLoeyeUBXNN1EjEZ6+o6JnAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863501;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SzZ+9sL9Z87GJ5231u3VEd6ZbBPqnC3V670Ckyp+vZs=;
	b=SLXa8+nd+xEQxrb3CRr+KnoRw6t1oMHAzzWAYqpJZGT1J2AcZZtczxKyrsdhzsql02dq
	 c+D2xaRMsieyppIng+RW1bzyQr6pDUw5kN74R1jinjaY0dsmfWPMFt5A2P0MFb6EH8lWq
	 ztUHYjd+rwCPByMgSz8A1gzwR+7QkR2zcIBB3OJjDCXuQMFM5XktNAoHnncCKVL3JOLxH
	 OPGayHAktSVnqttM3Xy4ElWZ1TqhkG5MSJtniZk7hvcJYaSBWdDVDt6OTZTL2O8cNT21z
	 YwXDtVBHfwfphCAKZOLMNe8Rns6+uWBOwMkVMntyyrbCPo9cGoo3XLa2jv7uoXjQ42g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=eFQxHSzC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ADB606A328
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 07:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=eFQxHSzC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SzZ+9sL9Z87GJ5231u3VEd6ZbBPqnC3V670Ckyp+vZs=;
	t=1793863500; x=1795073100; b=eFQxHSzCPJxFR8ls3yInOEqfcMALwQUBfe3HuDqVmYmiEnl
	nGCkM18bNfSI+wpJQe1ukE5CV6qLDQPiTzbeZenp1NaAGECmpnjlSAQxJSMvpOWc2Q6/4nCOSV5bZ
	h0rluIpBfm9mFMSkAED6cPZTXUPKC7Sb+2X0ZHx58yZ7icu9BF2twpCyRbg7W9sCtrAPonyXO/m/t
	exg/P2EIA286ddr4kQqhRQrBLB8ck9U2wq5KX0tXWEM4ZM/HOE1N/5dxOZC4G3MxI4HEuL+/QUzVK
	SmddSMBim8O3HsgvrC8nTOyHoxVaGCutxN2Abg49QOWXOUxbHa289IBZTzrYcE0g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOrqC-00000007Ped-2Xjc;
	Thu, 05 Nov 2026 08:24:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 2/6] wifi: qtnfmac: register regulatory before wiphy
Date: Thu,  5 Nov 2026 08:23:50 +0100
Message-ID: <20261105072451.1710800-9-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105072451.1710800-8-johannes@sipsolutions.net>
References: <20261105072451.1710800-8-johannes@sipsolutions.net>
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

This order is going to become required, since userspace
can query the regulatory in the window between the two
registrations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index d9c84d5ce254..139f67adead7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1231,13 +1231,18 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version = hw_info->hw_version;
 
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
+		ret = regulatory_set_wiphy_regd(wiphy, mac->rd);
+		if (ret < 0)
+			goto out;
+	}
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0)
 		goto out;
 
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
-		ret = regulatory_set_wiphy_regd(wiphy, mac->rd);
-	else if (regdomain_is_known)
+	if (regdomain_is_known &&
+	    !(wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED))
 		ret = regulatory_hint(wiphy, mac->rd->alpha2);
 
 out:
-- 
2.56.0

