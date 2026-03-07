Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374030E855
	for <linux-wireless@vger.kernel.org>; Sat,  7 Mar 2026 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.28.215.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772902939; cv=none; b=HbehFJ2zIRTVJRGP2MQ8NebeP2XVzr3JzjIQXwCJPJNc7pao1YR7JRtD0ugX93XhXW/Zf34lMvjMxHUKjfSgXsM1pIw2JP2TLE5nO6jMcXKuNQqD7k7OzhDDVNKQbVV3DNPsAhVv8siBjkff3jEzzpNM/EUNXa/i90ctQN8yH+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772902939; c=relaxed/simple;
	bh=TclSBEt5dS3x5a/anAkj11J970g9pgxMbAO7/7FgK/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s2IrSlwqSuZFlW+GDvWyLNXXMDomQS2UT2X6rUPOhekjOmWZxRHz17aGw+l5UJEoLgaO/8ZejVbev0gPElMFmjje9m0k+d/bNsudLSLyzqzCsbirB3w0Z3OWifUw+ReqG0HF8t88VXpvyGjHyWtADeKN/ti1RQMvEr8M2P9lVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com; dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b=ttdjNwnO; arc=none smtp.client-ip=149.28.215.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b="ttdjNwnO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ubuntu.com;
 h=Content-Transfer-Encoding: MIME-Version: Message-ID: Date: Subject: Cc:
 To: From; q=dns/txt; s=fe-953a8a3ca9; t=1772902931;
 bh=NFVlUbKudwsd2RoRt8SZg7LHgZtBORvUOp+m1jsIKrw=;
 b=ttdjNwnOanARB+lhb0NPJNEvFZ7YlZs8WI0pIyfJmVMBVWFn8NS2PsD1QO39Ys6d33MNbUoO9
 3I/TDhZZn7jLFSkwOGzDToPwIWxMitHqCF2iYN0QBko7UJJVOHikywpVIpbC8qA4QIc7+K3fT3C
 k+wOEVWxoLYR/h8GnIZNFKql3LZAS5/Bqi5sYlNNJO3EGgNrLwAhc1TGFD9w6969FJft9923t/V
 NpFNl1Bt0edK1DZFZxcny2E8hNONg37U2oh9OSEqNP3L0Rv8/mYkYynxxOHFTYPfiqIvnYusZS0
 FlgnPgWv5Xz4xsK+fFHiXmi71nNI6eCmdc+F3/NMdVxw==
X-Forward-Email-ID: 69ac5a116f9862d9de0d97b5
X-Forward-Email-Sender: rfc822; jpeisach@ubuntu.com, smtp.forwardemail.net,
 149.28.215.223
X-Forward-Email-Version: 2.6.44
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
From: Joshua Peisach <jpeisach@ubuntu.com>
To: linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Cc: Johan Hovold <johan@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Joshua Peisach <jpeisach@ubuntu.com>
Subject: [PATCH] wifi: b43: use register definitions in nphy_op_software_rfkill
Date: Sat,  7 Mar 2026 12:01:35 -0500
Message-ID: <20260307170135.167460-1-jpeisach@ubuntu.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replaces uses of hardcoded register addresses with proper definitions,
for readability.

Signed-off-by: Joshua Peisach <jpeisach@ubuntu.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 26 +++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index bbc30cbad..22359bd9d 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -6566,19 +6566,19 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 
 			b43_radio_mask(dev, 0x09, ~0x2);
 
-			b43_radio_write(dev, 0x204D, 0);
-			b43_radio_write(dev, 0x2053, 0);
-			b43_radio_write(dev, 0x2058, 0);
-			b43_radio_write(dev, 0x205E, 0);
-			b43_radio_mask(dev, 0x2062, ~0xF0);
-			b43_radio_write(dev, 0x2064, 0);
-
-			b43_radio_write(dev, 0x304D, 0);
-			b43_radio_write(dev, 0x3053, 0);
-			b43_radio_write(dev, 0x3058, 0);
-			b43_radio_write(dev, 0x305E, 0);
-			b43_radio_mask(dev, 0x3062, ~0xF0);
-			b43_radio_write(dev, 0x3064, 0);
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_PADA_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_PADG_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_PGAA_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_PGAG_BOOST_TUNE, 0);
+			b43_radio_mask(dev, B2056_TX0 | B2056_TX_MIXA_BOOST_TUNE, ~0xF0);
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_MIXG_BOOST_TUNE, 0);
+
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_PADA_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_PADG_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_PGAA_BOOST_TUNE, 0);
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_PGAG_BOOST_TUNE, 0);
+			b43_radio_mask(dev, B2056_TX1 | B2056_TX_MIXA_BOOST_TUNE, ~0xF0);
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_MIXG_BOOST_TUNE, 0);
 		}
 	} else {
 		if (phy->rev >= 19) {
-- 
2.51.0

