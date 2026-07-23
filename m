Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D001836655D
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838190; cv=none; b=GPFqY/O7m6NkoMnjrS4eydNaBXOiprhS2udiUXQXNnsy7i49TmX++NoUKHORDF0kaYEEhETQ+Wr+D+PlJ4/46WH74qeR+Oh6EzHxLCQWPBAHf/j7/PRVRJIQQjY4UzVHtH7P+U6MXnY8rpwPvIbr+lQ1nWlNy8FBMdAhCp+1cpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838190; c=relaxed/simple;
	bh=a9sQmebtMT/rKN/M4el8HrGMyfFyyhWYzm3WPDgjCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc+xtqhUwQ1idkvwV5hhriFV2kvm2ekxdjQoPgWjFWSSUuVn7Lv88vZ94MOc3xkXeyVm2wUYSm4+OB1Eo6+q3KeBDabWJccHYuJtXFhLKnL+OWNq1EPX3s22uPYL/yZTBiAk0z4tRVHzL2pF/U2IUGmMbjcqaAx6BByTBtWrepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bCVxdkCQ; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCVxdkCQ"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso1156970a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784838188; x=1785442988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+R4wtSNZnUCU9FPYzMZaddP+ee/LgfHZwSutE9tQVFg=;
        b=bCVxdkCQKoqbJ5QIUmtqFJ8e0qNsJnh9weT46M63cDsVpUudUH745j5KVYnMCbu6Lw
         Ugtd61YSZsQUWOJMvyFAmgDask4ubX0AFtb5gEBfPxpfp8j1zi8/8T8qwepFy0/4Zytf
         gmlAAY4IK7dg9vcdzTw5kRY3H9Xa/wbEd8EP95V3XsLTbLy+kcuK/Q2rp5yhUGhDfC6Z
         Ez6UzGNjMAHtrrxdroTVyjN8oW/UhMuRCSHzFWbxQL+RJPi3kDjkC6H9PbyvxN0XdY7S
         zLREJC8lkQJQf72g1Ayyp1Qbo4jPnaSVqjn/pwaZe23Y5kWQcZ8ZvVh3qSgP3P2dPfwn
         +Cog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838188; x=1785442988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+R4wtSNZnUCU9FPYzMZaddP+ee/LgfHZwSutE9tQVFg=;
        b=cwjfXTbdDidD3Kz4FR4wt3+M750Ci/q+8DvnnRnLMRAQB3ayeSOYQy83QIRCtRrIau
         dP2vGCNg3h4lxSsLNJWnhg8WOVnYR0EzhqGwomqpNZ5eb2l3ZPjBFZclw9d7ZAeTy6g7
         FPwQx0DgXEshBRvptCjBYRTri7615FIwvrssqsvDDqAhTRn0tfjOeuobgBJNcbWqC3tZ
         k37PNuqrm6+dfFOTSG+4ypAd+KIMuUljaCjp1pMSNCOBaMQzLkephFzMMsZ28nXz9Mwz
         eeaFeuipHp8kllmHotZGlE6zu2WeuDxz0rMw4cxq/GL9T6GuXCWMEp1JDj+l06PthVhD
         mYJw==
X-Gm-Message-State: AOJu0YyRHqJALU2wuzhoT8+taHSq3F2gFI6DGQqoPWXRCPxaBPzO+th+
	lJoTJZI4qZiqK/3p2/K6Y/fZE1mITG9IW4100lrYkqbYizVkYDcso4TuUzckhgzFaYAxhQ==
X-Gm-Gg: AR+sD114gLChqJ/2CXMQT9s2Tcgq19ZsJKBMEZ89ybCmQyamAs0lWG6OUZdt9tBJrVj
	jO1WRmG0nr3eeUnifd4L+FawC3WPJr02Ru9wK7EqNyllrS4chuhCOp6M4W3VhyJR4UevFqHr6wH
	mmdFsyqetIiLwoJWrKtQjE8S9zVIgtZ5bgcJEhN2MCH5PjTiCF546TSeF3gyRtGL6Yz4wzfQFCW
	sfFF1+zTsbvEbuXQbuPIP0UpvX9l60ky9MLptOmHWOB34oWC9Ozr9qeAE9VHeQE6J3MYAP91+3z
	8YKva16/6hijEjzFkQJc5Ra2Za9mcEXHgjplRI4i7Feu2n1ZHGe3qGrltXU/Vv//T3oPVXxPxJ+
	yDJ4JxAVcZKbngf43TIemHaslU7fnYzq1o1GP0WrK3lqiH/NjVL0h1VUsoy6bSx/mmsGiiE6wTH
	w+hz+m7N2LXCIh6wTCNISvbPmMjI4EA+WEFUL/hisDNxm7+1+ALw==
X-Received: by 2002:a17:90a:c88d:b0:37f:9ce1:cdb2 with SMTP id 98e67ed59e1d1-38ec65ad624mr5066440a91.32.1784838188033;
        Thu, 23 Jul 2026 13:23:08 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([120.234.91.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03adb16esm417883a91.1.2026.07.23.13.23.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jul 2026 13:23:07 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	briannorris@chromium.org,
	francesco@dolcini.it,
	linville@tuxdriver.com,
	patila@marvell.com,
	cluo@marvell.com,
	Zhao Li <enderaoelyther@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] wifi: mwifiex: validate action frame fixed fields
Date: Fri, 24 Jul 2026 04:22:57 +0800
Message-ID: <20260723202257.688-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260723011013.76968-1-enderaoelyther@gmail.com>
References: <20260723011013.76968-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mwifiex_process_mgmt_packet() accepts an rx_pkt_length as small as a
four-address struct ieee80211_hdr plus the two-byte firmware length prefix.
After stripping the prefix, mwifiex_parse_mgmt_packet() can receive a
buffer equal to sizeof(struct ieee80211_hdr).

For action frames, the parser reads the category byte immediately after
that header and, for a public action frame, reads the following action
code byte without verifying that either field is present. A minimal frame
therefore reads one or two bytes beyond the RX buffer.

Require the category and public action-code fields before reading them.
mwifiex parses the firmware four-address layout before removing addr4,
so add ETH_ALEN to the standard IEEE80211_MIN_ACTION_SIZE() offsets.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: 72e5aa8d2a6d ("mwifiex: support for parsing TDLS discovery frames")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/66f148d83eb9f0970b9abbccc85d1b61244e54ad.camel@sipsolutions.net/
Link: https://lore.kernel.org/all/20260708195911.84365-8-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/20260723011013.76968-1-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v3:
- Drop the redundant parser-local header check; the caller already
  guarantees the complete four-address header after removing the two-byte
  firmware prefix.

Changes in v2:
- Express the action-field sizes with IEEE80211_MIN_ACTION_SIZE(),
  accounting for the firmware four-address layout.
---
 drivers/net/wireless/marvell/mwifiex/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 7d3631d21223..e54a86ecaa33 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -317,9 +317,15 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 
 	switch (stype) {
 	case IEEE80211_STYPE_ACTION:
+		if (len < IEEE80211_MIN_ACTION_SIZE(category) + ETH_ALEN)
+			return -1;
+
 		category = *(payload + sizeof(struct ieee80211_hdr));
 		switch (category) {
 		case WLAN_CATEGORY_PUBLIC:
+			if (len < IEEE80211_MIN_ACTION_SIZE(action_code) + ETH_ALEN)
+				return -1;
+
 			action_code = *(payload + sizeof(struct ieee80211_hdr)
 					+ 1);
 			if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
-- 
2.50.1 (Apple Git-155)

