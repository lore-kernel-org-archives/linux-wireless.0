Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833F2EA754
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715231; cv=none; b=epbGC38sWzkL0cWjPmO98ch4NSZIFrvsfKN7RGasfhrBnM6PnsHgBoa21wC6Hle4c6VEQKynHowfLt+/4CIiN2XIvg20VjIjkc6boZaUjeoCWKaMzEsahANiQRR3yS19WM15/vjAtnZi+Oep+gwF2pp58YuUHnZjfwc7pTHHTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715231; c=relaxed/simple;
	bh=0MAZSpI1FB2pQAJD2x8qbdLKZzJxcnDItyqwbUnBYqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TBKlp0BLRp9oE8iDr/ndObEebZDjmbbMbh5On5vHzq/y89U3xBoXrQk7ZEwSAD5IndbM1ydHrChMv9Z3mnKWaX/uLrYmKgybEBuPaeGqi24bVCRp6QTkR2gYvXFhSD7juZJpoYNVyPXRjTh+N62ZEGJ3zzxL3Rr8JhtReM32OO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0sec.ai; spf=pass smtp.mailfrom=0.security; dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b=qLjfhZ+B; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0sec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0.security
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=0sec.ai header.i=@0sec.ai header.b="qLjfhZ+B"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f633e6058so905096f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0sec.ai; s=google; t=1786715227; x=1787320027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=la6HmzMWjOjdupN59/M7Vsrfzm3xyDbqoAwnTK10twI=;
        b=qLjfhZ+BelAiOxKLgA6nrpt9+96IeGwBCh2vcS2MnDhFRsFP0V2c+Jd6mY/Rq8YMIC
         i6hV5FAakmPr8slmougtvIBKAVaMRrY6PfBH1lXGHZl2OdPJHeV5d9LUnCC5wXGTXJHu
         Q3JTjDJ2viOJkQpK5W5mXkxjTYyytxeDcG9GNbALegv6Gwvgn1fR9bNnzlB9Sxalp07W
         LL4oJ2ZlOIPseCDEVWAsiI6zW9aqMyv7chB9SYn+rJGVHounjfgitjXdd3giByKTRn1P
         5Y3Mm35kKJ+jqNVCggslRqU2pX9+XEBZj1sc06cq43+AZdZ2xuBle9jO0AzneMvCkkkS
         sO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786715227; x=1787320027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=la6HmzMWjOjdupN59/M7Vsrfzm3xyDbqoAwnTK10twI=;
        b=HmpPj1VBwKcChQ3c7LBtElfRMG9Y353lpTpjwmoQsVbXM4qJRgvP1sZdmVkWNA0h8t
         9dlZIBpgM/LfuaG+kLPUXcbn07YAbeDSu2eldXOpTJnayrqBtxW080xiiSvza6zmn7EH
         XBtmj9rtPzoF7jzO0FMBUbjR6/NAkJOWzWGvnd4C5+fnvN91xcqmciVG8+Eu+gahaf/n
         3v4C3nJpY/ssaMMJ+Fhg1r0mwBolXN33Ai/qkPgR6iomqEObV7gZAMOwtLZRyY013UId
         SpPqwZ3H75okREWTAH8nwZ3v9dx8XYkKKKIfbo7g3tKOSYb2F1Xs86HqtVi+FLpFK7y/
         3POg==
X-Forwarded-Encrypted: i=1; AHgh+RqtkX1LkS0/bF2ErPShLu+HsBfK+PEgj7FnDEjPR68aYkyfIpEBuUrOlu3GzEmG+NvNSiwajJErJlwJDmgVNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyqkIoGsK5SxD7ZbQ5T89ehky3nCcKH4hTOoVU2k8KskAtOd2I
	wIBTuZsCWN3LyhA+IvV7L79LOggoZGpWXoB/GqGSKRY3qOVwTBqTFo7G8tO1kDthAsnF
X-Gm-Gg: AR+sD12/+C3xwpVZ0+fQ44HjQaCzMEwKeokgTLm3v+HinpGufJ7sVJj2Z1sZrT7bcQ7
	TXMsNWSzR1gK63y10Jx0OmjFtUlZZmE1yhg16PeqFU87aRVZHy/gb9eiA19scHgtfCzvt8l6Fsy
	Y3dDWWWergv6RKkfRXseyn+ADEh0iiSBlUiO2ToCv9NEBr8bdw2i4ix7ZR+RkVLZxfa26roJSfY
	byH3I1YaiIj9K80Ks0palpG/qv+jdzOVK4SCeJQInVjV0EcddUxoWip6yrsohffIrs1+oln+N63
	MV04xalehkJ3jO0vIytEVV4GVVJd4u/fruijcPLOv5J2TIWGhtGHt/tKOTricncceUfLl0su8cD
	LSWKIamknQHjunDmKhB0uknKpaPvJvin9W8iozvbybmYsZFTufjW2IPInhnrSB1haLvIYekqIz5
	SCu0BywhNty7s3qkAx+RwdM83PMeM/eySnA2Ve5nki+wOZepNSSAyUvVZZKpjyZskSHyqeab01B
	Z41T0HI4N+mNO3nL4jC0UZV0jJXJhHbZzYlqh/q2GDQLzsY0+llgXZ+DhZQQT3W7vZ31c2ONYIi
	JfJVwA==
X-Received: by 2002:a05:6000:2703:b0:461:e27d:5690 with SMTP id ffacd0b85a97d-481607acf59mr6874946f8f.26.1786715227265;
        Fri, 14 Aug 2026 06:47:07 -0700 (PDT)
Received: from PeakBook-Mini.tail8e484.ts.net ([178.197.218.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815f2c129dsm8326893f8f.26.2026.08.14.06.47.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Aug 2026 06:47:06 -0700 (PDT)
From: Doruk Tan Ozturk <doruk@0sec.ai>
To: briannorris@chromium.org
Cc: francesco@dolcini.it,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Doruk Tan Ozturk <doruk@0sec.ai>
Subject: [PATCH v3] wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length
Date: Fri, 14 Aug 2026 15:47:04 +0200
Message-ID: <20260814134704.85902-1-doruk@0sec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mwifiex_search_oui_in_ie() reads a pairwise-cipher (PTK) count from a
beacon/probe-response RSN or WPA information element and then walks that
many 4-byte OUIs, comparing each with memcmp(). The count comes straight
from the (attacker-supplied) IE and is never checked against the
element's own length, and the callers admit the element on element_id
alone (has_ieee_hdr() / has_vendor_hdr(), no length check). A crafted
RSN/WPA IE with a large pairwise count therefore makes the walk read up
to 255 * 4 bytes past the element -- an out-of-bounds read of the
kmemdup()'d beacon buffer, reachable from any AP whose beacon/probe
response is processed during scan-result parsing.

Pass the number of IE bytes available at the OUI list and bound the walk
to the element. Keep the length signed and reject a negative value
before any unsigned arithmetic, so a small or zero IE length cannot
underflow to a large size_t and defeat the bound.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
---

Changes in v3 (per Brian Norris's review of v2):
 - Keep ie_len signed and explicitly reject a negative (underflowed)
   length before any unsigned arithmetic. The v2 bound added the count
   to the offset and compared against (size_t)ie_len, so a small or zero
   IE length that underflowed ie_len wrapped to a large size_t and the
   bound would not fire.

Changes in v2 (per Francesco Dolcini's review of v1):
 - Store offsetof(struct ie_body, ptk_body) in a named variable
   (ptk_body_offset) and reuse it in both bounds checks; no functional
   change.
 - Switch the Assisted-by trailer to 0sec:multi-model.

 drivers/net/wireless/marvell/mwifiex/scan.c | 25 ++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 97c0ec3b822e7..473f4623ea199 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -104,12 +104,24 @@ has_vendor_hdr(struct ieee_types_vendor_specific *ie, u8 key)
  * a given oui in PTK.
  */
 static u8
-mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
+mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui, int ie_len)
 {
+	const size_t ptk_body_offset = offsetof(struct ie_body, ptk_body);
 	u8 count;
 
+	/* ie_len is the number of bytes available at iebody. Keep it signed
+	 * and reject a negative (underflowed) length before the unsigned
+	 * comparisons below, so a small or zero IE length cannot wrap.
+	 */
+	if (ie_len < 0 || (size_t)ie_len < ptk_body_offset)
+		return MWIFIEX_OUI_NOT_PRESENT;
+
 	count = iebody->ptk_cnt[0];
 
+	/* Reject an OUI count whose list would run past the element. */
+	if (ptk_body_offset + count * sizeof(iebody->ptk_body) > (size_t)ie_len)
+		return MWIFIEX_OUI_NOT_PRESENT;
+
 	/* There could be multiple OUIs for PTK hence
 	   1) Take the length.
 	   2) Check all the OUIs for AES.
@@ -143,11 +155,14 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN)) {
+		int ie_len = (int)bss_desc->bcn_rsn_ie->ieee_hdr.len -
+			RSN_GTK_OUI_OFFSET;
+
 		iebody = (struct ie_body *)
 			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
 			  RSN_GTK_OUI_OFFSET);
 		oui = &mwifiex_rsn_oui[cipher][0];
-		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
 		if (ret)
 			return ret;
 	}
@@ -169,10 +184,14 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
+		int ie_len = (int)bss_desc->bcn_wpa_ie->vend_hdr.len -
+			(int)sizeof(bss_desc->bcn_wpa_ie->vend_hdr.oui) -
+			WPA_GTK_OUI_OFFSET;
+
 		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
 					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
-		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
 		if (ret)
 			return ret;
 	}
-- 
2.43.0

