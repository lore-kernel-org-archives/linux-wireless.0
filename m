Received: from mail-08.mail-europe.com (mail-08.mail-europe.com [57.129.93.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F98C4D90A6
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.93.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449219; cv=none; b=Fi0dohTibC3w5mqzsfTAOmGb70whGi+Mq8Kc8Gxek2XeyolcExB94ZHDQc/LvAdoNwHpKIzNKIqAaCAQXacImWFqUW7k72MgQ1aTi+ZfuDNYYcbIgjLLVJMcXvJ6fsu8f3ohF9j7B0YIfhFV4W53vvBEZheoTZmm9nUTlyXA63E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449219; c=relaxed/simple;
	bh=tRdKtSDhM8B0bKuS5cPQ4EBJYq6RJ0rjT47wLv8M25I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g6QjvT4I8hujik/7vymgt7Bl0a5rcfeguKU43szPQYkY6AVQ5Tx7yYewq5M4eGgUvs7q02ZtWoHxKsl+viZWtELDLn9eX1PxEbYMLKv4wEr0OarpuXGU7YGHtBKyx2T8QbsIrRKQVOKoinsC3p7m84z9rZoLARANFFnzgWxyKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ipust.net; spf=pass smtp.mailfrom=ipust.net; dkim=pass (1024-bit key) header.d=ipust.net header.i=@ipust.net header.b=wwLE8T84; arc=none smtp.client-ip=57.129.93.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ipust.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ipust.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ipust.net header.i=@ipust.net header.b="wwLE8T84"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipust.net;
	s=protonmail; t=1788449200; x=1788708400;
	bh=3xBIzbhOS/AH6v8O5Eezqk+PH1+CkOpknoTuBUPSIQw=;
	h=From:To:Cc:Subject:Date:Message-Id:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=wwLE8T84F6+LaPAQd/AFHY9JcpViPbk4X84z8RLxkfgvEJc/fRDYQEbxTAlrGcpLv
	 szwl1WJCGhDslTg/MWK/lr3qGH+3Ph7pKm4JioaYvmMKuS5zPoCciPXZECkeVTZivz
	 LsXw9fMOorqJ3pywd/X0FG1C6WHIWsaK0fVFAauA=
X-Pm-Submission-Id: 4hbNjm4srCz2SdHf
From: Ivan Pustogarov <ivan@ipust.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Masashi Honma <masashi.honma@gmail.com>,
	Ivan Pustogarov <ivan@ipust.net>,
	stable@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: avoid out-of-bounds read for empty PREQ elements
Date: Thu,  3 Sep 2026 17:26:16 +0200
Message-Id: <20260903152616.1646637-1-ivan@ipust.net>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_mesh_preq_size_ok() derives the location of the PREQ bottom
fields before checking whether the element contains even the fixed
header. ieee80211_mesh_hwmp_preq_get_bottom() reads the flags byte to
account for the optional Address Extension field. Consequently, an
empty PREQ element causes a one-byte read beyond its declared payload.

Move the helper call after both size checks, so the bottom fields are
only accessed when they are present.

Fixes: 8b40b1d24a60 ("wifi: mac80211: Fix overread in PREQ frame processing")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Pustogarov <ivan@ipust.net>
---
 include/linux/ieee80211-mesh.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211-mesh.h b/include/linux/ieee80211-mesh.h
index 7eb15834531c..9e548b9173df 100644
--- a/include/linux/ieee80211-mesh.h
+++ b/include/linux/ieee80211-mesh.h
@@ -361,8 +361,7 @@ ieee80211_mesh_hwmp_perr_get_rcode(const u8 *ie, u8 dst_idx)
 /* IEEE Std 802.11-2016 9.4.2.113 PREQ element */
 static inline bool ieee80211_mesh_preq_size_ok(const u8 *pos, u8 elen)
 {
-	struct ieee80211_mesh_hwmp_preq_bottom *preq_elem_bottom =
-		ieee80211_mesh_hwmp_preq_get_bottom(pos);
+	struct ieee80211_mesh_hwmp_preq_bottom *preq_elem_bottom;
 	u8 target_count;
 	int needed;
 
@@ -378,6 +377,7 @@ static inline bool ieee80211_mesh_preq_size_ok(const u8 *pos, u8 elen)
 	if (elen < needed)
 		return false;
 
+	preq_elem_bottom = ieee80211_mesh_hwmp_preq_get_bottom(pos);
 	target_count = preq_elem_bottom->target_count;
 	/* IEEE Std 802.11-2016 Table 14-10 to 14-16 */
 	if (target_count < 1)

base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
-- 
2.39.5

