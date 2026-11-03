Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719769;
	b=nkG+aRu4YBQ6YJvxNgiVJDE/WzGn3AABcZktCdwpo7YT+e5aKOASV9aNGAZJ2zZDNUsh
	 c1R51w/Yb3RQtAmLMX/Vkue2dSZ7ZTKXIkwR2looF8otyOwSZHzEa1XQ0wgt5joasdGkc
	 /705W0jp9w/xa3Dh7DLUrtaKzaMUUnJ40/RB4PnXB8FbulW6CJw7E+aJpntJ5DbO7pfGo
	 vRK3DO5+7C3c2qAaOy2XZibYDJS+qliS4IxQ3uyFcVKTQdmiftkIvf7BjEh87U+zJPqMj
	 RixmF0LV62zHh2JPzxE+NNeW6gAv9nC+uAVvkeuQqM/iaOFk91XKeFSD3Mp0+Nh271w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719769;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AOEP+fZAsIyQCUPANAHPvdkXuiumY5Jq4g5WfrYLWdI=;
	b=X13PxAjI+IY8+yHdFibuVePwkIPJn5NN60dsMwxYNGySgO2qJqES6pjkV3nMaNyo7o52
	 hF9wP4Qk9SCwqVuE5bx5A9fm7gu/YfYv3pCYao3qGZ7ezSBZbBNpJdijcH+ax3nQtjB91
	 /Mz+NaCFlaYdi7CJKgCpl7aGTQIeyaBU0KZl2HlzdmVAIl9BbgPIIXlktSBB72xF3jxuJ
	 nTlxd9KNQTPyqrBmuOAc+nOqstd7Ukp9YxLqPWKWAObB/cSjziB8E3A8Z7uWNwk3N216q
	 c2lOdnuJVcy/GPBSK+RR6rL8TRDlGEhyC0ORvWkb+O06YpqeMO1khCrT/Rv3IUmNJFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RnWEkANe;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5AD606A338
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RnWEkANe
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=AOEP+fZAsIyQCUPANAHPvdkXuiumY5Jq4g5WfrYLWdI=;
	t=1793719768; x=1794929368; b=RnWEkANe/tevJcDPQEq1gh8CvyaGVbzj4GQjjHuk52kWTlw
	8GdQhz7a4NjeOVnZ8SpwG6FolfyMrOZkPD6WhaxtWVckF1fQZFDXf/LHAwGP0DaoeQ/czkn8gooul
	bYaiE9vloHTYEEyo9A/nqRSg8cfcQ6T4s5vZEVamxQronnulOvGFzkPr2i+ucRB2OucYOK4aq6w6P
	QMaON4uhIdhSTxQu7BvJgyuAvRG1GM5mQ3jvAmG6enecp+XCPcpoEvnwzxy7xrvIguvzwukoF3Zu/
	njKsXAaXPeCwPhGLpvo0u02LifG+cNr1RiswKuZeC51Uza7xjBa50cN7oqd+1mQw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGRy-00000003eXZ-1yul;
	Tue, 03 Nov 2026 16:29:26 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/4] wifi: virtual: enable context analysis
Date: Tue,  3 Nov 2026 16:29:16 +0100
Message-ID: <20261103162921.5ed8c1bd933a.I74506a25be425d4511108d74f23a91e313db877c@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103152920.294873-6-johannes@sipsolutions.net>
References: <20261103152920.294873-6-johannes@sipsolutions.net>
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

There's nothing to change here, both hwsim and virt_wifi
build as-is so we can just enable it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/Makefile b/drivers/net/wireless/virtual/Makefile
index 6ad860dd7643..353f8388befe 100644
--- a/drivers/net/wireless/virtual/Makefile
+++ b/drivers/net/wireless/virtual/Makefile
@@ -3,3 +3,5 @@ mac80211_hwsim-objs		+= mac80211_hwsim_main.o
 mac80211_hwsim-objs		+= mac80211_hwsim_nan.o
 
 obj-$(CONFIG_VIRT_WIFI)	+= virt_wifi.o
+
+CONTEXT_ANALYSIS := y
-- 
2.56.0

