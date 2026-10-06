Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7E93DD537
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281233; cv=none; b=P0xVtO0GR6ealNQogDzI8YbhdHVGlUFKoegD4EbdXImoQgDEySEk+MYsWDWkyzkFgWKHOuarKusWLo0ohEY28kIkFuyj6bCm9KzVUAjbFyYj982yUWypjhc+p2SQRDQeZAuSNbWNLRNaS4oByk0UE5h/DTdVqp9eVqui2QrnJjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281233; c=relaxed/simple;
	bh=4rLtverpo/1EXhsjcYVO8fmjQpXUl665UlZbvvcOoV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3DBPl1yaCWoKuovx41Mjbe0ZcXTpL9ra+CZv1ZwRHAmRfR3gn4dQYqwplK5Izy3e8nWZC3mtelN50Iu1KviGiwGoHWkVA561m4uyB01gu0MYbTPm1dwruhz4ErbBJr0hmik3cme32GKBQllUYC5IxTdyoYtKdwmVeUZhY8u7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=w6RBa37D; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="w6RBa37D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jUm7or8r+iiSe9yd5uUkYVOUt77f1542EMp1EaDVqWc=;
	t=1791281231; x=1792490831; b=w6RBa37D3Kh+hbLHwtuuBJa301Ku/nxxe7z2ct/ZPaA5PI+
	/1XhBROUaaMJ0HC/5+dAJ2Q6JT+KIKkvtva8ZVothL0WbCKkl4iBY1xQlIqi2hh/L1aITCXP1nZLQ
	DmLNj/pBagPsp26UXkgjzbqtUjYEzEN/+2IL6Z+w5ZSiH8vcwGy0J7uNA6m6mDB39uCkv3V6he+no
	mxpThOuno/UkdT5UyRYgCCLCxGxWMd07B2e/fUupZRrk/lCdqhln6f9KrKb+sECHOBLQF+CYlx9sA
	vsfafMQx2yIjTB9RoSnnXzHOXn+siljweA6JAmKVTpcx6ZUrodymfzrV3ePsFPJA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24j-00000006XqW-0NgE;
	Tue, 06 Oct 2026 12:07:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 09/19] wifi: mac80211_hwsim: call cfg80211 event with wiphy mutex
Date: Tue,  6 Oct 2026 12:04:07 +0200
Message-ID: <20261006120655.34c6cd54cb9d.I4a45533cc3a020c472f7d90f33e854d7a89b2d3a@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

These functions really require the wiphy mutex (though
they're not yet documented as such), call them with it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 6cd9542e8b72..b0fd6bdd3ccc 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1133,6 +1133,8 @@ static ssize_t hwsim_background_cac_write(struct file *file,
 	if (copy_from_user(buf, user_buf, count))
 		return -EFAULT;
 
+	guard(wiphy)(data->hw->wiphy);
+
 	/* Check if background radar channel is configured */
 	if (!data->radar_background_chandef.chan)
 		return -ENOENT;
-- 
2.55.0

