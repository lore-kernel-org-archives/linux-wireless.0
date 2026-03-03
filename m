Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D8D42315F
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548485; cv=none; b=nFY/D8LoptFjV6oNs9gIbExAEh9lfPzO9E8Ikc3jejSqZjCwGcn1Hv32MfjvP+gtqrZW9PFzxpokLo6XDH73fFUIepDWgCGxM6SyfsdnVD3OgmOUmIfga6WK/zKgvf5QyBImSV934d5Jk6b+KEyCvAeA3MvCsRY1dclOFr0ga0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548485; c=relaxed/simple;
	bh=bsfJR3zX4sI6OF6Ukh6RgBdoVHGOiRaLQEjQRdm88hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuuMxStL5LfBVO6ZUa5QfCngDjzG/Nh589jUhWZND/BUzroZolSBjdKJGl4LUn0GpHgjXJcnKmBRhAY6f6F8GkgkNAiTyzEf9iMjwVGExLsEy+qtyEt/2QBuoN22XmSKOJo4ObpqLmiZFU0j3k9D819tvpa84WiHtmsOSvzA11c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=x3SCZL07; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="x3SCZL07"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=rQNfz7rpck7S95dsnx76Ii153MKjgK9EHOREnnm2UWU=;
	t=1772548484; x=1773758084; b=x3SCZL078Ke9KyM5og9q4SUHLljvhfBuOY1UXjuK0dX6iLz
	f9E0i1l3McLSdPtkLzb7zaz3ssnkfUe+pyOedO0c1XPiU6E9MXM9V9aLyBlCygK7wUy1LWl6/OP/P
	bSkQ79m9MyxBgUUnIP2K0lb9b/xgnq5LqtZqHxyYvUdpuLEDtagMm9m4Lpz/vf384BnspwjDigg2v
	jsDJNhi3963FVcsFo8ffEsbCMv/2DdD5dqPJS+XWluS/mzQY7ejH6MGBeoFdBaEiwPunCCjsZ431R
	RcdoL34+cJb6B2CK+IbT7qstyGWX0obXe7HQwdQ+lXFXRelihoi0JY7sNAyO9sTQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxQpd-00000007A1T-10GU;
	Tue, 03 Mar 2026 15:34:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC wireless-next 5/8] wifi: mac80211: add NPCA to chandef tracing
Date: Tue,  3 Mar 2026 15:27:00 +0100
Message-ID: <20260303153435.cb818701a36e.I4b3728e594710dd01f7f154faddf7d98d898a45f@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303143434.273141-10-johannes@sipsolutions.net>
References: <20260303143434.273141-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add the NPCA parameters (NPCA primary channel and puncturing bitmap)
to the chandef tracing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 1f0c07eaad1b..c897d9968399 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -44,7 +44,9 @@
 			__field(u32, n##center_freq1)					\
 			__field(u32, n##freq1_offset)					\
 			__field(u32, n##center_freq2)					\
-			__field(u16, n##punctured)
+			__field(u16, n##punctured)					\
+			__field(u32, n##npca_pri_freq)					\
+			__field(u16, n##npca_punctured)
 #define __CHANDEF_ASSIGN(n, c)								\
 			__entry->n##control_freq = (c) && (c)->chan ?			\
 				(c)->chan->center_freq : 0;				\
@@ -54,14 +56,18 @@
 			__entry->n##center_freq1 = (c) ? (c)->center_freq1 : 0;		\
 			__entry->n##freq1_offset = (c) ? (c)->freq1_offset : 0;		\
 			__entry->n##center_freq2 = (c) ? (c)->center_freq2 : 0;		\
-			__entry->n##punctured = (c) ? (c)->punctured : 0;
+			__entry->n##punctured = (c) ? (c)->punctured : 0;		\
+			__entry->n##npca_pri_freq = (c) && (c)->npca_chan ?		\
+				(c)->npca_chan->center_freq : 0;			\
+			__entry->n##npca_punctured = (c) ? (c)->npca_punctured : 0;
 #define __CHANDEF_PR_FMT(n)								\
-	" " #n "(%d.%03d MHz,width:%d,center: %d.%03d/%d MHz, punct:0x%x)"
+	" " #n "(%d.%03d MHz,width:%d,center: %d.%03d/%d MHz, punct:0x%x, npca:%u, npca_punct:0x%x)"
 #define __CHANDEF_PR_ARG(n)								\
 			__entry->n##control_freq, __entry->n##freq_offset,		\
 			__entry->n##chan_width, __entry->n##center_freq1,		\
 			__entry->n##freq1_offset, __entry->n##center_freq2,		\
-			__entry->n##punctured
+			__entry->n##punctured, __entry->n##npca_pri_freq,		\
+			__entry->n##npca_punctured
 
 #define CHANDEF_ENTRY		__CHANDEF_ENTRY()
 #define CHANDEF_ASSIGN(c)	__CHANDEF_ASSIGN(, c)
-- 
2.53.0

