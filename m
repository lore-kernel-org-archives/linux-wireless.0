Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654355;
	b=N5XMIBowFYk4dJoAZks+zQZuGl3f6Ny73qU8f3GJ6IAoc9NEJo33m70BILD6XJ7z4+bw
	 ObIPk6SRrXF969hCPbkiW2F1OiwBwArkZCxXwePAJqtLbItxOeFxNKIOeieD1V27HyNiq
	 W7qcgCMQCcCrNXwBJ+7oC5Do3I6PjTofLuojDPKVZip8PNOPIK2XYERND9mQM3iEqin9K
	 95dOo+1rHsUG9iw5h2v06vRWiPLjaXMZf2fdMMAEba5I7Eaf+ATvJHmAima/bXGVUHQoT
	 KdFi1t1x00fqi+xExfMzFdjTTMS0vNu0ds5QRErRgsaNPDx8Y4BKY/LYBYUBEUaRlhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654355;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TdRCye9TAHPN6nq7ASKBHSMlnSWMkIGCM/yMh474A3E=;
	b=hu6P/GbNdp+qRs9VdmbeXzuWCTnS5E+KXMalEou3gIrvPHZApAbg5JksFXNJZr5MYQzB
	 q9/ZHPucsuqGNnVZCRCzdOzhzeaUDW+lW6IrlbBVP0c0TEE0Z38SjYdSKAEqoazGMdcR5
	 0+TvfRRX0r75S+foKkWXM+BZ11MHkGFl9oQ2k1KqAKmZK3G1P+FWdiKPNe52RGW0WkOGQ
	 ojvSx8voC5m7ffSkR6RGPMSDRtpmL2gENH4QosKrnjFQ+ajEtjJO1WVlkfXGybZWwnPdb
	 NLh/FKPF9obLBtpXI812Df1WGi68r3ztJGvNoQAw/3tdMsv7yNzrdLqcOHU3Rp18tDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jNfYJqDR;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BBA606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jNfYJqDR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=TdRCye9TAHPN6nq7ASKBHSMlnSWMkIGCM/yMh474A3E=; t=1793654354; x=1794863954; 
	b=jNfYJqDRkTz1eoD5AyDbu/fhM/UaV3UOq7kn8xGb1dJ124BcnF5I2CmABoHJoVuEV3FMhrseY/9
	I6K85H/+ts6X0D1YkgWVzyIAiUst2jOIlXkJnTFYkc2EP3lDKcYCyGUd0ypZimKR+WHexs8l2+8xq
	jl4wgaJgeuS0pr0gjWdfHSIQhcNN+P6MZAKGN61xtsRoo1O4cm8iqukbsUwFji8BC3OLGzF8+iiuO
	UNzzEkWSG9qBaDdJJUsXUZWjsH+Oj6d+eDWCcccOXL1Si+kj/sGrogyOusmGdmhs8cSX45xc1k4V+
	+I8hkCJAA6LVQ43E7nOJnf3Nyx2t9jKnsMoA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzQt-00000001z71-2BbY;
	Mon, 02 Nov 2026 22:19:11 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next] wifi: nl80211: mollify static checkers on ERR_PTR
Date: Mon,  2 Nov 2026 22:18:56 +0100
Message-ID: <20261102221856.7490f47bd44a.Idd9f303c4aaf1831416c66c56e729943b85e30c4@changeid>
X-Mailer: git-send-email 2.56.0
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

In nl80211_pre_doit(), we assign an ERR_PTR to wdev
and jump the 'out' label, which looks like it can
try to wdev_put() this wdev. That can't happen as
it's gated by a check for wdev_ref which is never
true in this path, but the dependency isn't always
clear to static checkers. Set wdev to NULL.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..80f094d9b2fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20209,6 +20209,7 @@ static int nl80211_pre_doit(const struct genl_split_ops *ops,
 			wdev = nl80211_lock_and_recheck(rdev, netns, wdev_id);
 			if (IS_ERR(wdev)) {
 				err = PTR_ERR(wdev);
+				wdev = NULL;
 				goto out;
 			}
 		}
-- 
2.56.0

