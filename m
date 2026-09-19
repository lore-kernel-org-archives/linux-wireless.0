Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B947831A55B
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 09:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789809906; cv=none; b=Es8fdW1cMvHtORgUgNtoK/ufOf+Vqxi2/1utbc7st17AHxyi+KAJrTy2au+gU8X2+DtVcX9z1RGDCoRPELL7rkgizU0+xa+d0y9CysVDsdoAWyJ2IKOkyccqbEaCQ3qzSan5LFKcoZP0r9dva+bt+t/PCvVXj2eXiQJqplHDB20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789809906; c=relaxed/simple;
	bh=x/YONXW+9hssyMVh9h5+emrO3N4ZAv+UIAf0SmsV/98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bLTTe0+N4SCHfVqtZNCcukGJAaPDWCX7gengySSRYJ+C+Nh9+GZ/+Y80FyVj8P8LuOL8KGOpjjPahTvz409qAEoiYDM+TN8uX+a81y9VfuLTcyiRdTgduiUG7crLU5sBbQHZm3zbiali4P1mJhMaPZAAc7lLWgMxQbFOtq2azcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=p65o3SyQ; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="p65o3SyQ"
Received: (wp-smtpd smtp.wp.pl 46909 invoked from network); 19 Sep 2026 11:24:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1789809894; bh=BgmMsDRWYnORo4d+nYSB+NpFslO8YdlyjcX5hM4nDrM=;
          h=From:To:Cc:Subject;
          b=p65o3SyQLNhZQbiGn5Cp3WenXC4EFF7Vfft7OCD2UegZih0eldWUYoabiPvscemnb
           8NJdvtNwQWnO2vU9YQZtaCiyLRKytfNdzhBz5kK9bc3IswK0Jah5jgCsWFtuSD6pzS
           JG02kH3+3YH6mAjUpuL71fZDyb2EDGjKi2YbX2iO3/d/qUxnueXUwuCp2SDK2Se6Sr
           U4thrsD/6Lbo/maVHyabYGEZUkbuIaASC9OoikOOdhX0jjsAB6dZOv+bsJzkpPYUjt
           fqm3prwEBvP6I+Q7HZF8/AidgcIv6y50GV22qnf7lKzFTkl1Ov0YGBGnJmBbarI8N1
           Xpiz4H80bP5nw==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <johannes@sipsolutions.net>; 19 Sep 2026 11:24:54 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Roopni Devanathan <quic_rdevanat@quicinc.com>
Subject: [PATCH wireless] wifi: cfg80211: fix RTS threshold setting for single-radio PHY
Date: Sat, 19 Sep 2026 11:24:54 +0200
Message-Id: <20260919092454.50266-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1a09da3af4d9075bf9bcd1033330197e
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YYPF]                               

Due to an incorrect old_radio_rts_threshold check, we do not set
rdev->wiphy.rts_threshold for a single-radio PHY, and the threshold
value is not propagated to lower layers.

Cc: stable@vger.kernel.org
Fixes: 264637941cf4 ("wifi: cfg80211: Add Support to Set RTS Threshold for each Radio")
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 net/wireless/nl80211.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 899b6374c550..f75206332eaa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4563,12 +4563,13 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.retry_long = retry_long;
 		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
 			rdev->wiphy.frag_threshold = frag_threshold;
-		if ((changed & WIPHY_PARAM_RTS_THRESHOLD) &&
-		    old_radio_rts_threshold) {
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 			rdev->wiphy.rts_threshold = rts_threshold;
-			for (i = 0 ; i < rdev->wiphy.n_radio; i++)
-				rdev->wiphy.radio_cfg[i].rts_threshold =
-					rdev->wiphy.rts_threshold;
+			if (old_radio_rts_threshold) {
+				for (i = 0; i < rdev->wiphy.n_radio; i++)
+					rdev->wiphy.radio_cfg[i].rts_threshold =
+						rdev->wiphy.rts_threshold;
+			}
 		}
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;
-- 
2.50.1

