Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793624193;
	b=AA5l5cYT10xYi1Esb5VbNYsFi4HbIIoaqiVxY7ukk3inlnS1+rfLViDSUqssJEWnfaY/
	 xRmKBFVQd7KOGyn4v1YamL0O5bnw8tlb5gUwPopIr4JFEuQpJWQ64qNNRVJhJr0MqetmG
	 bAjD0dINuHCPcZ2dlcp6lYS4annD6iQi4uGGItZ0BL2p6N4WCj81X9OAw1diM/gQKVwSW
	 hfaxVGXKajvdV7HVpDEQz5aQUFr/Z8IYLTz2ckFae5FjdIRYY3TDzb4gYc1D3gjdpPwcE
	 9Ur1rPPor0cI2YGEMbZXRBxFyTE6U3i7g2yWGEI+ZmzT+HIeY9E7itUmijZQ+sBl2NQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624193;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=XYeVSQrMQh5GQlHFrfRlPa7r3niYCPk6ssF2GHu7Wr4=;
	b=GYooKapeWLhKBFWA4N6jaJNeFdxQIfxvdoCUj/BLkXVLXxDg3lh1/xt1plSm1lZab1lK
	 tEQqmrZd105ShdQS8JQ5OxSx4j+zaX+2cK+mVl+RaUyuyhzaIEd7Bk2V+iPiZ/5CBpsdZ
	 CG7/3jdgHHDO9iT0RFzJBmzxJ232yZrFqVWRYE3Erxy+2rjL5gbU4u83c593k5WqrVcHq
	 u0aHzXkQ8+ydFjvAZ9mOB+7nBkA/HPOYgcFnX4aLTN/WpAecWBiEt9ap9NL50+P/xy0ng
	 oNi0WG5cUzwhHo6svItzoN2YPompnxK6xm4JLFC0dOseaF5N4jgfUuAgphWSE6pGFuA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nDE00e6/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629BA606A324;
	Mon,  2 Nov 2026 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nDE00e6/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793624192;
	b=YFdIcScwlNBOtMO7pWWv/Mvlpy+scwFibeK/ASA4K7PIoAZd789YDnnlTbkB9U7jRAhg
	 ChqI0XtaRCrg31u4xMA3KlBlITCYn9N8Ek9DfF1SHujW9N61xHQzJp0h83YHUhsL3F+H+
	 drhRL5UJ12TvVmzskqIQTz1GH349jGgxbeNIIBn7ym8pSeGs69bjHCiHfUOO4jTV1dzrw
	 OChKEiCcxM2ujVxPCzhTDuyTgLB937ux+TNrwS7tba8DaqylWvoQ98Y81q2A4QmPAKkiJ
	 z93WOyag854SK5wm7VEsKD7xZTw+uVUcsX+4InT4hVSlz/Gc8oQIxoGyA4qhaglyJMA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793624192;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=XYeVSQrMQh5GQlHFrfRlPa7r3niYCPk6ssF2GHu7Wr4=;
	b=WnSkvUBpjNTGq1kbs8CND1Zsc77Mf/YIlzvaNVA8rmocBobJb51ibRb+f7fE4QTXgBEK
	 dgpDAq+eFJ7ihtSFa/CfyWcr7F/qS4+tElWaLYAVE3T5OEUvPoOvBGS53qiipoVspAr4o
	 lpmqMxwzzMvrgxExj0Hbb0JuzqDo4raVtBdQ7bKQQ3jGRZGAZyCpbBsFF5/3nHjfO0Mp3
	 7LJceJAllTGwzVdc+Q6O8Pay/im9CmXal+Ri2SKNUuTgjKON5TSTbFZ3GOVB1snPjY+dF
	 QrYFF7AgWB+FYfo4LdcbeXJX5LcUWoeNG/AyxnAzjzzuLX6Fr9Li4M6Yv7mzRtuKdQg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 367841F00A16;
	Mon,  2 Nov 2026 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793624192;
	bh=XYeVSQrMQh5GQlHFrfRlPa7r3niYCPk6ssF2GHu7Wr4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=nDE00e6/DifO1qJBkIuvzJrvHz0sdW5e6hklXCmp/17vKAw2ADrbPK5wVGr9dCSC/
	 CRVPmuLtJLBwoiXE9utP8ZWCphhsWIB6NCc97nhYR5FoGcsgoY2wctTRI7yDI0/7x0
	 kfaovLnfNyllGlp8na6YQp+U9xLgaYVRp/31WDemut/LRAMOmiLETKXGgZwy/hhBVo
	 eKvYhf4PHOSoKPb508/Zjod/hXc145iEajjqqw7UUZlwvgywcgTHk9ckNbYxQhIJaq
	 fbtjztJwMJs6ZK8CzS3KbA5kWpAtsjJNWrGqgO0iGXr3FnzeXTf5F0R9mHgDdym8Ns
	 os93g33AJPdBQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BBB32464E1;
	Mon,  2 Nov 2026 12:56:31 +0000 (UTC)
From: Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Date: Mon, 02 Nov 2026 12:56:32 +0000
Subject: [PATCH wireless] wifi: mac80211: check for a NULL link in the MLD
 station RX loop
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261102-mac80211-rx-null-link-v1-1-3330b6b18c76@gmail.com>
X-B4-Tracking: v=1; b=H4sIAH+I6GoC/x3MQQrCQAxA0auUrA0kAQfxKuKiUzMaHEdJUAuld
 +/Q5Vv8v0ComwachwVcfxb2bh18GGB6jO2uaLduEJLETIKvcTqRMKPP2L61YrX2xFREKR+ppJy
 htx/XYvP+vcDfXKtGwHVdNwu+bA1xAAAA
To: Johannes Berg <johannes@sipsolutions.net>, 
 Benjamin Berg <benjamin.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Joas Antonio dos Santos <joasantonio108@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793624191; l=2170;
 i=joasantonio108@gmail.com; s=20261031; h=from:subject:message-id;
 bh=XTRyGFYezIX8XrXbmaW7af1M5K6Q2UNq4aXZjXe6+lc=;
 b=zK9lhxaAkTI3Deh5VzHJDZ4i1czdHDMM4w8vO6TkNcF4e8iAFKNvlur21Wn9+nkPXnUyZzH4Y
 qWboneJfTE4C2X3sPfJqDyBmCAuVDsTviobqSnXXcgKuOeIfCcYrrak
X-Developer-Key: i=joasantonio108@gmail.com; a=ed25519;
 pk=ZxAznJT/FcPPdzLrDDFJQm4LLjjHVGBBqDSG3TXS23w=
X-Endpoint-Received: by B4 Relay for joasantonio108@gmail.com/20261031 with
 auth_id=1371
X-Original-From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reply-To: joasantonio108@gmail.com
Content-Transfer-Encoding: 7bit

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

Since commit 6d531b9af16e ("wifi: mac80211: rework RX packet handling"),
__ieee80211_rx_handle_packet() looks up the link of each MLD station
that matches addr2 and passes it straight to ieee80211_rx_valid_freq(),
which dereferences link->sdata and link->conf whenever status->freq is
set.  The non-MLD loop and the interface loop below it check the link,
this one does not.

The link can be NULL there.  ieee80211_vif_update_links() clears
sdata->link[link_id] for a removed link first, and only later, after
ieee80211_tear_down_links() (including its synchronize_rcu()) and
drv_change_vif_links(), calls ieee80211_sta_remove_link(), which takes
the link station out of the hash.  RX runs under RCU only, so a data
frame from that link's address arriving in this window finds the link
station but a NULL link, and the kernel oopses in softirq context.  A
link is removed this way for example when an associated AP announces
removal of one of its links (ieee80211_ml_reconf_work()), and the
frames only need a matching transmitter address, before any crypto.

Before the rework, ieee80211_rx_data_set_link() returned false for a
NULL link and the frame was skipped.  Skip it again.

Fixes: 6d531b9af16e ("wifi: mac80211: rework RX packet handling")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
wifi: mac80211: check for a NULL link in the MLD station RX loop
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ecee9348c70d..038bca60a7c7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5469,7 +5469,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			sdata =	sta->sdata;
 			link = rcu_dereference(sdata->link[link_sta->link_id]);
 
-			if (!ieee80211_rx_valid_freq(status->freq, link))
+			if (!link || !ieee80211_rx_valid_freq(status->freq, link))
 				continue;
 
 			if (rx_data_pending) {

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261102-mac80211-rx-null-link-6f2e0b50f6bb

Best regards,
-- 
Joas Antonio dos Santos <joasantonio108@gmail.com>


