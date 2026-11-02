Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657990;
	b=iDMug0wAR1UFLMB3fgRbbVludLTCp2YcGhtpmSvAF24AScX6kHSjmncXqGOsCZkLfrOv
	 qIi9/ns0nlucf03/mjoN/HzIlm//RZaNvCBHH9nVCU1fV9US9Mr1KKGm+muDCzZvGkz6L
	 dl/Q+YEA8eOGx91rasSoVCTkChJM1dTltXdxn8uS1F6gt87QW5GQ9jTq952HmjXIVQjdK
	 ho8LdzsYj05npPiQvjt3VLEwUg0xQgaQ5W/5QY6hUvkSHirhgN4oNbENC6Fepf2heRu/H
	 MF8rN9dY2W7BN8+4FlvtsMf4AfrSQOadYoYea0ON/Q4Fe6ejHbMe/0Fik8AmCIhi/Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657990;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RjTbwBh8REOkHQLtS1u/DaMCtq6pWHvdkgT7EPpND/A=;
	b=UKSv2AC+Zns4VNr7dmu8WFh/w1Nw6WPMO306w+H7uS/gY4gCf1YooMEMw/vxqxuHoAYs
	 0iTv52kfNKzEynyLfiIUpZBnQh5EQjuMI7nZfS5Smr7JVRvCRDc0oCAteSfaL5z/zrCe7
	 W1Fo8mykiggPA0xFU6ixF2LxZEAMnXiXrWI3LbXsH7RwwriE1JgMpE2WQ3fScdr/eDJn2
	 vNqc7N8grDiDqCj3s7rMs9Ta8skOGl8q4bs/wISQq3UFxjxfgjM4MQ0mkjJ1Qvkis0yG9
	 dWX/IYp36uZz4PfzECATSRUo8gf8ChiP4tRCnwR5Ib3DcOjE0dTHNH49a5ZUi5lcb3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZhUs+E47;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17B606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ZhUs+E47
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=RjTbwBh8REOkHQLtS1u/DaMCtq6pWHvdkgT7EPpND/A=; t=1793657990; x=1794867590; 
	b=ZhUs+E47ni+i9IFLU/0kCSNUBjAz4pk9mQCt/0rrWhwUwVU6hW2Oa0XvIoM3yKtQq+4bvty8KkP
	0mY5kmV4c73G4ptg37SjHK4u3Khhtt+plajaTdUEiJpi1DoYeYwDNiiP/5DJ/5dcxAgctISEHaouq
	i6VQU7lk9vDBid3fi83JeNGUYAaXThA1tE0Tu2Amue5VreqgXP/lt16cminpMarV5ofRa72nOthlG
	l9DxcNriS3KWyUuGAVOy1X3Xv8s1JbwNILP7VXTMr9snn6kjNDjmxxh4XhjADR5T26h1YFvjg2FGZ
	skh02ajQIxwtWZXO6pcxn+4NY7EdminDfOgw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0NX-000000023f8-0XRJ;
	Mon, 02 Nov 2026 23:19:47 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: limit non-MLO STA to EHT
Date: Mon,  2 Nov 2026 23:19:44 +0100
Message-ID: <20261102231944.c992a3c398ed.I2cb7d329dd5ec71a255c5fd045735e208a76a6b8@changeid>
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

EHT already required MLO, but with UHR this got more complex
and we require the AP to have MLO to connection in UHR mode,
for EHT we don't enforce it.

However, if a UHR capable device is used with an old non-MLO
wpa_supplicant (or other tools), we would attempt to make a
non-MLO UHR connection to an AP (which has MLO in its beacon)
only to then find that it's not MLO in the assoc response.

Limit the station itself to EHT for non-MLO connections to
avoid (potential) this issue.

Fixes: 29eb4dc882d3 ("wifi: mac80211: mlme: allow UHR only with MLO")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8eda8154ba3d..9119d094b548 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6796,6 +6796,12 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	if (req && !req->ap_mld_addr) {
+		mlme_link_id_dbg(sdata, link_id,
+				 "UHR requires MLO, limiting to EHT\n");
+		goto out;
+	}
+
 	uhr_cap = ieee80211_get_uhr_iftype_cap_vif(sband, &sdata->vif);
 	if (!uhr_cap) {
 		mlme_link_id_dbg(sdata, link_id,
-- 
2.56.0

