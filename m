Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655024;
	b=NZCjLlyzQarCPZqoQp9FSbL3iujs2eP9VamVaU//S9E/kvPvpGtFQc0xVkNvqas3mGl+
	 hSRaRwzXc0ecngtO7pxL+Rt8ZH9gVPhem/ETA/DH2/qYKWYvnnGHkXoMOtuzfgdOc6iRo
	 SjO8cUBRFBuV6gj7UfK6mvSn9K3VZa3y6kaGQ+tBOKZsRNeMgpgozVSP86l7j3Vrxx7Bj
	 Noxkh3U9KhW7TFpfvPZOCaVwGNjS0Xpq/jM6vuytRRKxZwdqElUJMyc5GBNsYW+ew1EmN
	 c6ED4CmV5CcCfTNUCm9RUfyytY0W5w3Z9xcZ1dD1pvTFOHkUQ+SZ59a0ezRH0LedR9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655024;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hUcdJ5LQ+cU69YDsBNLHIrCQndr0RlwUc6MwlR1hb1g=;
	b=Xwp9OKjPNx3tOCoC8SpPrLCR+F11XIetwKiQQiaiFJx509lldb5iwBFnqJFJQ6BVmBXj
	 xXVEq1pqUKkc+HeiUjjBjHn6M1yFeA6htpEcfZHwK+PV++DT+ZUkGRhW/kzgPT0PC68V2
	 V0I6u7UYGcrn3UmPZwRBiJffjbQ2ta1UqXEbBoloQcvRdUkVkZRbyQSWQACtzG+lqTFk+
	 ZZ2z5vfMUoYGwAW61g+jkqyl1gOO6ZIFr4u5KhDnqlwz+jfXxrccVkHyGsIMspXcmvQxU
	 nGTjQtkT2dd3ruanP4pSGPOY2jEdleGU5zc2u2c9yNZ7/LGwZ28i/+1VJk6xnXVPtRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jsGKqQbo;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84A606EE96
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=jsGKqQbo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hUcdJ5LQ+cU69YDsBNLHIrCQndr0RlwUc6MwlR1hb1g=;
	t=1793655023; x=1794864623; b=jsGKqQbocDUyw/kC+ScKr1hXzvkz2kGNfTuRyTISSZPua2a
	fKwLWC/u1uOkhH2TOK4HZmHkjHLO59Ghu4NVWacVCTGt0IqBnrvUWKtNSI/MeVOoi1P2en3sAynkX
	KqzCXcydhNXAusKou38evLOAuF/0aW1J2aVYuc9pGcPD0svQjD6W+5d4gLTzwfnsOBHVWmodNfXpR
	cS45gtdw1CnPoKQDtN9hF7SgICPZAq0CjMUJy8kEpygTFNPABB8NNVMYTP5K0ZsYWFCZxpOSfjUqk
	3MjkQ9zViIfhf2Rvm6DnpuMnG/Zwtev7CN1QjbO+VvAvzC0zyfQlcT42LlphIn2A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzbh-00000001zui-0012;
	Mon, 02 Nov 2026 22:30:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 2/4] wifi: ieee80211: correct UHR link reconf response
Date: Mon,  2 Nov 2026 22:26:29 +0100
Message-ID: <20261102223017.283d0275abb6.Iad0baa73596108303e8ca8d9f0620dbad84bbcd2@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102213017.1095413-6-johannes@sipsolutions.net>
References: <20261102213017.1095413-6-johannes@sipsolutions.net>
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

Evidently I put (copy/pasted?) a "u8 count" field where a
"__le16 status_code" should be. Fix that.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b2c90c4b262d..6aba27534322 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1193,7 +1193,7 @@ struct ieee80211_mgmt {
 				struct {
 					u8 dialog_token;
 					u8 type;
-					u8 count;
+					__le16 status_code;
 					u8 variable[];
 				} __packed uhr_link_reconf_resp;
 				struct {
-- 
2.56.0

