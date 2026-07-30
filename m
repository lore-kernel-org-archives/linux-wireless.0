Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CDB43C7D7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422120; cv=none; b=Z3bw2lwv9xbtRwm1tAtuI4HlK4GMURoBlCdOcT5ypbOIUr1dsrJZfjc4McsrL9ZDryQqYavEjNXoNHAHVDObIdOGwnUTYjR6ZqNRvvZnXc6LhzmFKsiT/yptCVIJfJ6BEkmSTNdkWB5L47WEhDjmOuztzDYkkReWZ/GLZnXP0Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422120; c=relaxed/simple;
	bh=MEQiUzCg83acwdXzkBH4d3ksrCoXU68yrJlDyqw8w8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaA0ZqnU1gBKxBdpErJvsnz9C9/ckysz9CVymGcHFGqjHWldSz7KcsBhaMM8Ts6OwpdkDHelr7eTys19GwcpRgnsy1sP90pcELW8atX7SKFx+ou9Sb7jSw6D7DRJA3PHEJGcVdnBYvmRyxAA7vuHIpwg11jR/8ZP1kslvqzqTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=m8fnO6L1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="m8fnO6L1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=A+G02hmHVcpztg5ZgXwqY0ZuZyT3NRGWL1xIrUSNLyQ=;
	t=1785422119; x=1786631719; b=m8fnO6L16coEgaF5q+al5HwA/UGw2qr0FJS8wm1cWCJcvKz
	L1K+VUSVYj/XqFVHUNJg8521a0zQltvY1KskfhRXavAx8jrCnVhz5zNpbdv+EHGE190DLkiO85dVX
	HkdqwIZbWUIfygZzBxGRJGAvxGpJEFTSI5rITTQ9ijBnR7/CNhSCscEuDLAoZpHZHCZa9+BBz7FuT
	Euu6ZFhXtjJghNyOTQJgfm/5Ej4/933hVneedqdM9LbMRO1dYGf32SWLE4VhOB0EaD8UWlnddVBPu
	34ZxH/VTModboTXKtTIZZckK1zK90NqmRxR5EXI3S22wdCd/BGosew6Ar3YXp1zg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpRqm-00000004mKH-3pij;
	Thu, 30 Jul 2026 16:35:09 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Jouni Malinen <j@w1.fi>,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 6/8] wifi: mac80211: report to cfg80211 when no STA is known for a frame
Date: Thu, 30 Jul 2026 16:34:22 +0200
Message-ID: <20260730163415.5d9b0cb2fdef.I28d8146b9189c5961411ecb26b44588895de1b56@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730143415.1833312-10-benjamin@sipsolutions.net>
References: <20260730143415.1833312-10-benjamin@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This is relevant for hostapd to know whether address translation was
done on a received management frame.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0660ff18f584..edf0e7700d0f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3983,6 +3983,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		.len = rx->skb->len,
 		.link_id = rx->link_id,
 		.have_link_id = rx->link_id >= 0,
+		.no_sta = !rx->sta,
 	};
 
 	/* skip known-bad action frames and return them in the next handler */
-- 
2.55.0

