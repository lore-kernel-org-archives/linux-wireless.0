Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609558;
	b=to86dEUSIFX0yXkopCOw8hs4NKzy+6ISkpSs9rAHw+uTTCGzgQBOarAOGkB62dlJHJp2
	 hA/3hjymO6SXsrNEhumk7d2w+h7KEZmOZFE3vT6KpEOQ8QnREdzPQP+LzXjKdlSTWOUzF
	 qQ1OFRiD706rshD3yOWLMSraunk22Fh1WJoc7aW+lUzeAuGWtyxALb6VoPmHK0UtbJSPS
	 9WIJOYoklGxHDCyqC4HvRBZzwRWnTpud8MssRnuG1wTT8pm/J4Ac3dQnVgLBcyhPyXMWG
	 yqfpfuGp2QvYUVEtnGOSV4z8Pa809TsOiUOBCZJpefn+sr8q18iixCpoFtesv5GMPvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609558;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7C///B+JAdg2fEZb31+zVpijJFSPfJpD6U8hDCbaYGI=;
	b=5ZNHoOuxLoKblYwhYp9/nGt+wQ0ehpHdqGUV8sz9DpgdTV1RyLKNKg1KV+HdBATvDqS0
	 xDduEYRXkxYEEvIRiRe/nQJyUlZz5LaHh1t1R1RdUQs1xJ+zg2uNldiQ4hOuLtlAjmu0z
	 gMLas1Mw4zJ0RjYxFWYY6B3ZBmJx7C9mrgpy4MPsgjDQqKAhb6G+RuCtB9GX3hSFiL4UE
	 QoW8YD/T3JR2jbP1pOTh9ZYDJamOMsLuaoMNJZhs88/XrgOXQmG+ujZIU21kuqOKO8cum
	 VWpSr7l7DO9Dcc2HiRnfe9YIAtAt4QWCnIMu/wclonPsjRomYfPkeZFMTyn69Np92kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=eTpGcKjA;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DA4606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 19:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69DA4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=eTpGcKjA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792609555;
	bh=CunkBMf+dZ+9FAAEI2ahHWYssUN2MSl4DCdiPNQMjek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTpGcKjAwRezWmlZ/ig0SZL6OVYex4E4afjjpyC616vf5TtEnSgdKbjWwb6rZZmJk
	 0unFI2FMwl72++XXCOsvT4WJqzntNSvt25UmAANr2IMeXupuSAgU5TfqhHWYlNMq2W
	 7LamDQnvS33YkwD1YUx9PZbAQQDt1UFxNaMLJbwRGhGQq0QvF8syoJ0vYscIWkBcVE
	 GIaNyU8OcwabgxbkRDrmrxBhTD2xAV7wrPJUQSNxgmXM+8u3XiCGX9AiYOjk6o/4wB
	 NDcEWAjPCbd3iuUEqs0DRo2pnIV+p+8lz2j0aZZdV3urijWgPvzWC93rMLaooS+4+T
	 BSmA5V4pb9+EA==
Received: from hermes-devbox.localdomain (unknown [100.64.1.183])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbeckett)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5E89717E07F3;
	Wed, 21 Oct 2026 21:05:55 +0200 (CEST)
From: Bob Beckett <bob.beckett@collabora.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Timlee <timlee@realtek.com>,
	matthew.leach@collabora.com,
	kernel@collabora.com
Subject: [RFC PATCH rtw-next 4/5] wifi: rtw88: make the PN guard threshold a test parameter
Date: Wed, 21 Oct 2026 20:05:23 +0100
Message-ID: <20261021190529.3893821-5-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021190529.3893821-1-bob.beckett@collabora.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com>
 <20261021190529.3893821-1-bob.beckett@collabora.com>
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

From: Robert Beckett <bob.beckett@collabora.com>

The suspect-frame report, the rx_debug recheck and the
sw_decrypt_suspect drop path only run when a hardware-decrypted frame's
CCMP PN jumps forward by more than 2^24, which never happens on a
healthy link. Make the threshold rtw88_core.pn_guard_jump (default
2^24, unchanged behaviour) so these paths can be exercised in testing,
e.g. with pn_guard_jump=0 every frame whose PN advances is treated as
suspect. That also gives a baseline of the rx_debug poison/reread
results for good frames.

Test only; leave it at the default in the field.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
 drivers/net/wireless/realtek/rtw88/main.h | 1 +
 drivers/net/wireless/realtek/rtw88/rx.c   | 9 ++-------
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index d667e7452e4f..0cbf65c7f2c5 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -35,17 +35,22 @@ EXPORT_SYMBOL(rtw_debug_mask);
  */
 bool rtw_edcca_enabled = true;
 bool rtw_sw_decrypt_suspect;
+/* Test only: lower it to make rtw_rx_pn_guard() treat ordinary frames as suspect. */
+unsigned long long rtw_pn_guard_jump = BIT_ULL(24);
 
 module_param_named(disable_lps_deep, rtw_disable_lps_deep_mode, bool, 0644);
 module_param_named(support_bf, rtw_bf_support, bool, 0644);
 module_param_named(debug_mask, rtw_debug_mask, uint, 0644);
 module_param_named(sw_decrypt_suspect, rtw_sw_decrypt_suspect, bool, 0644);
+module_param_named(pn_guard_jump, rtw_pn_guard_jump, ullong, 0644);
 
 MODULE_PARM_DESC(disable_lps_deep, "Set Y to disable Deep PS");
 MODULE_PARM_DESC(support_bf, "Set Y to enable beamformee support");
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(sw_decrypt_suspect,
 		 "Set Y to have mac80211 verify hardware-decrypted frames whose CCMP PN jumps implausibly (default: only report them)");
+MODULE_PARM_DESC(pn_guard_jump,
+		 "CCMP PN forward jump treated as suspect (test only, default 2^24)");
 
 static struct ieee80211_channel rtw_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 295af5529fcc..43c4602eb400 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -44,6 +44,7 @@ extern bool rtw_bf_support;
 extern bool rtw_disable_lps_deep_mode;
 extern unsigned int rtw_debug_mask;
 extern bool rtw_sw_decrypt_suspect;
+extern unsigned long long rtw_pn_guard_jump;
 extern bool rtw_edcca_enabled;
 extern const struct ieee80211_ops rtw_ops;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rx.c b/drivers/net/wireless/realtek/rtw88/rx.c
index d29b4bed2ad3..8f00153568a1 100644
--- a/drivers/net/wireless/realtek/rtw88/rx.c
+++ b/drivers/net/wireless/realtek/rtw88/rx.c
@@ -280,12 +280,6 @@ static bool rtw_rx_ccmp_hdr_valid(struct rtw_rx_pkt_stat *pkt_stat,
 	return iv[2] == 0 && (iv[3] & BIT(5));
 }
 
-/* A forward PN jump this large between two frames of one key/TID is not
- * plausible; frames with garbage after the 802.11 header produce random
- * 48-bit PNs.
- */
-#define RTW_RX_PN_GUARD_JUMP	BIT_ULL(24)
-
 static u64 rtw_rx_ccmp_pn(const u8 *iv)
 {
 	return (u64)iv[0] | (u64)iv[1] << 8 | (u64)iv[4] << 16 |
@@ -384,7 +378,8 @@ static void rtw_rx_pn_guard(struct rtw_dev *rtwdev,
 	if (pn <= max)
 		return;
 
-	if (pn - max > RTW_RX_PN_GUARD_JUMP) {
+	/* rtw_pn_guard_jump is 2^24 by default; see the comment above */
+	if (pn - max > READ_ONCE(rtw_pn_guard_jump)) {
 		if (READ_ONCE(rtw_sw_decrypt_suspect))
 			pkt_stat->decrypted = false;
 		rtw_rx_report_suspect(rtwdev, "PN jump", pkt_stat, rx_desc8,
-- 
2.55.0

