Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657956;
	b=ECUiM3Kt6iXQts7sXhxgZlleQcdSV6jzVhwOHvavsPp9pxH6B4TIzIRRSFQpvPpMz3Jx
	 uaGyF26QH1sDYJ3cPN/twoBloIaiEaH7C60jUbYhD9ZpVYusXqanJB1SbgH0aTW7JYEYA
	 r8EC0I1roVhHNlE56Er2uaGeoZ53DtMQ5/vxb3DbSzK6nWeDf2S4haBvp50Xy8egRO7tg
	 J3SQHUpjv7muxw+pT3oiyMI4dTtK3doEe6BG1TG9th2r7W5jD9mLPHUA18qF1fkfGDXAB
	 dJCbJ+wsJ23v8d216D9MsYq9fkjq9azRb92eG4unhHbkCb3RS+6TZ8qi+8+eCqZ/yrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657956;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SY7ZSP6N+KMUR7DTPvFgXpf+Uub7k3VX0YbqsF6A5aQ=;
	b=LkpvMuJZPCJM9kd3rKgguI49IDd1vW9lP/y+p1sPd1pzYzZIciGwgeI5Fwn9gULIk70s
	 uXvCbRPxlFiw4QdEbDw7f0L+iCTa7jbyQFV3h7Vym/jUBA4W1GVv632r8vjXGmMKl7H1n
	 0vy2FCLGzxyiYixMk5mm6DT6XWhH56/BgrjRFSeUefTRq2WUc6rtpFgWbn3SrVU3dMasV
	 mdWYlgIdidNiU7M9ACVM0ocmD786bD4rP81n6dZA3zwrZzqc61qFiMQLBPqsxWafMNqdF
	 JcxjgyIeVHH7ewwlB45bfU8tWLVJfc9xQbB56biO2vJ3eNmUS2NcgK6RHw1FefJTNdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=t5MfH3Zo;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4C2606A327
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=t5MfH3Zo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=SY7ZSP6N+KMUR7DTPvFgXpf+Uub7k3VX0YbqsF6A5aQ=; t=1793657956; x=1794867556; 
	b=t5MfH3ZoOv4KlOqPEuywv0Eb5Pi9lk2+3SXmn3VDUWz3pE9BZworE7Jzlr8k0xACQ/6DF3uGpE8
	cBbyhBQ0K6LqyKaKNXtI7nyW2ZnjN3yDnYbwmbKZB2AO2alsUbHFvqf6dTG+HFBog5Cvv2ggXnGW8
	cgxR+9aoJuQwjj0JJWHP2elqlloG16XONNble+0qVET2OZczhvkpVwxVbrTFJMmxOMUwWfrTEWeBn
	d1THh2d13qJ14G/95NvgpicGvq8fDN9Mr20Sn8NTzbnIq9gVAB3W7Y92QqIdxPi1N575nawVdcrPO
	2uclwfShp1jnRnaGA7N4DxCL6tzviEZ9l+TQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Mz-000000023cK-2Ije;
	Mon, 02 Nov 2026 23:19:13 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: move valid_links update into link release
Date: Mon,  2 Nov 2026 23:19:10 +0100
Message-ID: <20261102231911.c539dba58893.I9518cc50fef2b65eeef04c3f2d25b152522e1d6e@changeid>
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

When releasing links (link BSSes) the valid_links must also be
updated, so move that into cfg80211_wdev_release_link_bsses().

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 1 -
 net/wireless/sme.c     | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2fc680382418..d311fd690f50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22224,7 +22224,6 @@ void cfg80211_links_removed(struct net_device *dev, u16 link_mask)
 		return;
 
 	cfg80211_wdev_release_link_bsses(wdev, link_mask);
-	wdev->valid_links &= ~link_mask;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b481d31dd8cc..eb218d3fd9b0 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -491,6 +491,8 @@ void cfg80211_wdev_release_link_bsses(struct wireless_dev *wdev, u16 link_mask)
 				 &wdev->links[link].client.current_bss->pub);
 		wdev->links[link].client.current_bss = NULL;
 	}
+
+	wdev->valid_links &= ~link_mask;
 }
 
 static int cfg80211_sme_get_conn_ies(struct wireless_dev *wdev,
-- 
2.56.0

