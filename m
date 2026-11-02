Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793658063;
	b=Bx63lhYagcQnJ+gnJXDY6hfC5AM6V5BLS3id74gWF6T2v8niorcyIei+R96ytulUeqpb
	 GV2aPktNC3czA7h3Haa+hP+yeyByTJgFogFbIlE16FBAkfLK5yCNi7UNOYPmErYzqmtI9
	 eYLXeQGP7uq4+S8M9LlRg4wWv457IWOBkefaSucqKwLCcCPQvVAqMKlIIVU3C7/bMuXe6
	 Qt0lQw7dvHBND1tU7EdWu4QYfPFilh2UN1P3kV9Ek0b/6A8Ugr8X0NKGzC30/YNHLkWxM
	 hx/zwitFmWjJB8JBql7kpwGPCW07fl0CxCJcNkOnFM4/G9ANomu0SMyFFCAEWIKziGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658063;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yO63MXfPEAYYo/3JVUpwQMqgw9K4FdB8B3+7iFgyPso=;
	b=iHp92wsqD69cTikHEJz/bNpgGEPU2fiXAdJAd6bMl5kkckvN0r5r9KBVGM9A/cX3ycAz
	 Mk59mfwcROPhDRXHBbth9DNqJlFlIMEpKLLHVjKuZ69OT6PFldtau7qATVU8fccodGiCn
	 XTePY3MMbb7Vqoxi18dO/TAy0XGOyqainiy+2H4n3Y4TVhJmv5kwl3/iiW49gt5OrkDPn
	 3UWzWIaRS6GvHzgqoFQ66lzPgovlArNmf0bAYGFZmDg+XlxgDSWSwfhiaxoyFn+pLP5du
	 gM5bUet1PO+wdV3kx8rjSkIvK73oJaXcBxIiZTIq/MYx9W83k8Y81DYamEX3H8gNkyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="bqNj8o/V";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD93606A332
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=bqNj8o/V
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=yO63MXfPEAYYo/3JVUpwQMqgw9K4FdB8B3+7iFgyPso=; t=1793658063; x=1794867663; 
	b=bqNj8o/V1naZ7BzrAIxpNvyuH1hnCSCu5KehB4DergCO/lx35uB0NxKRntJ2vSw2HrLLj57TgZj
	qqEg2DNwS6V/MX8b1wng5oBVRsCBXNj0WqYBSiiiSIjxtNJmNr3IuukiccsYPfzcodnF8s5CxDN63
	j28teeUhyZSwUi/FJaqKXdPwK8ueNpDF3mpg9r2IYLM8zlkchlxuX6uFZ1WYlNoHUobsjLb4mlZ69
	rbRd0/GShGIX9PoOiaMo8j2AwrpdvHqqPq3s7NR0s/3umRteEdgUHq5JfqT6qu1lzDodwIKuCYlrr
	uuc7ea5541de+hntg7H4ow24EOxsp5yjR0mQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Oh-000000023lZ-3lH6;
	Mon, 02 Nov 2026 23:21:00 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: always limit TX BA buffer size
Date: Mon,  2 Nov 2026 23:20:58 +0100
Message-ID: <20261102232057.d71df466db1e.I2dd5d746156510d04b9a3e9c192df1260c7d251b@changeid>
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

Currently, in strict mode, max_tx_aggregation_subframes is used
for all peers, but that conflicts with not sending AddBA ext to
them unless they are at least HE capable, as we can't advertise
a large size without that. Limit the strict case to HE capable
peers.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..3dedcb605f0d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -465,7 +465,8 @@ static void ieee80211_send_addba_with_timeout(struct sta_info *sta,
 
 	if (sta->sta.valid_links ||
 	    sta->sta.deflink.eht_cap.has_eht ||
-	    ieee80211_hw_check(&local->hw, STRICT)) {
+	    (ieee80211_hw_check(&local->hw, STRICT) &&
+	     sta->sta.deflink.he_cap.has_he)) {
 		buf_size = local->hw.max_tx_aggregation_subframes;
 	} else if (sta->sta.deflink.he_cap.has_he) {
 		buf_size = min_t(u16, local->hw.max_tx_aggregation_subframes,
-- 
2.56.0

