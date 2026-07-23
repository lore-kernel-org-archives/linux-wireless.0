Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457D1C3F0C
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769022; cv=none; b=qngnP73utffz50Dj56TLc1r73YCW8BbwnFmIMGdLeIWv38LBTXQPvXsCq0LxlRP8S+M08tbaa5RYh+ISJn3PincvLmuXYuHf/sCWQBkzHqwrELlx+qFHxYu7nY1FSFRMA66NAXg8nHGMOmUfhT59ktm2+Fk9zu/hlJrirHI9mRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769022; c=relaxed/simple;
	bh=SHYCWBQRYcbeMUNkhNZcYPbpD/drfADhAkDqNrEPbEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OxU77dOall9gtyh9g1uRScrrE4xd+ayJaa/Dxc5yI7D1n8cRW0Ag1XYHTc8fm61AQLd+X9jriqmzMl7x09e/W5yeUvzvy6DtS29pnwRysUQFlucqbKUqBpmUVnUTyRI1MB07NtozLaAdUeKn1hV9Vkw5EqDrLDlYXeqLOtc+euo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMucKhLN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMucKhLN"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so1682815ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 18:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784769021; x=1785373821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7X81Rbyibvh6xqN/yaT9IUi74PeKJQjUFG+D5wQw2cc=;
        b=kMucKhLN8ovOfgt9ctkB/RtC9+bsZFd6T4hGXfcWml1GFhql+crjEOA9zWOdgZvmP2
         +lgd9MYLkcja7/0TYJyjc/4atolEPAZozJ7LwQfCvI7K+xuqii98BRRiYOwN/i4nAy+W
         9RpN+W7Xsd0uknMbVs/hCwGAnskCWDGNCcDGjLJBJMsaNAU9pAcdmHo2aGxPUfNugZ6G
         YZBUjPL4NWF9TXy4TKZmus1GorBkd3Ny/cuwOghJncKKErBekOBvoZCdvU19Iv7+U7DC
         eUcsi0MQJ5vC+lgRDrB1WtPEFQflYYgc0VFEVNHIHKE7mJJlXthYNXhOOo4ImS+ZEwAE
         lFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784769021; x=1785373821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7X81Rbyibvh6xqN/yaT9IUi74PeKJQjUFG+D5wQw2cc=;
        b=DzQaO+Hx00T+hOyveDWYxEPeGShRiCPovMDynQuQoEBJtO+hwKJyQVHPU9YMyLStgL
         IHX2FiPPw7zYDZQjHkodbHhLcgNB1kd92dPAFeO+R0raHCUN7p6db2mvNeki6P1LYnQK
         JxWJ5W08NDdCvTTC5iWrSUrSvUoIWbG/l71nbt6L9u0X+/lasfoH/QPAnmoAgsZVwUrd
         Zt9L0Ccibdsl0iUpNVCZ5Lb5Ndl4UMEukg/CCu15VZCivarHp8xTrF+CP3coHHqGW4CT
         05I0XGG6gqIX87aY49HSr5M8myk9W6eiW2USIwjpY487nWD57agobwWDQrAkSy7OCaI+
         NX+w==
X-Gm-Message-State: AOJu0Ywc1oND1p0mC6J6oqve2a3euJuId2xh2J5MQ9vsO6hBBXhamQpf
	GKlMLZD32lGFn4FEOfCm0NZB788YjKsjkve6LenHS7MRxMJIzuCtmk3M+hJhlnGkj9q73w==
X-Gm-Gg: AR+sD10UruYRbVQ431Kw35Vdf/2OiMYwfrrGicPAmvuI8kS0tvuYSiwCNk85+SC5DL4
	Bo3SmR2FGOtFlGae3pjuXfnd8ZBgSVidk6uWS0DREbCMfY/gKWx611S7MQ6s9XpX0GrqmeuFC2k
	iHJ9iijwE8lsL0gEolBojKS9rQZfrshFr/hGWnjB/vddvTtqSj1pBY9Kd6EXqWW3emxdeHa+Z3T
	aNEFAYzy5qgEanJP3f12YJU89+eyjVB+WZZEGYQt4be4SSOkO6Zsk44LfkUBca7IJIPnPSMSLSD
	Ea/GspxrvPXPmvondSW4x5DtEcKVAE4C6IN6ITfcKXNq9xdNbPyENtcOT5+yf5xxpSjjsocui/i
	26DIVBOXlXJGrRzUDKnZ3oBUdGG7M4Vs+ti/mdwDGf1lK39GrcNHUR0xr8dVKet234aN1FR4bxt
	XoM4TxSAe3cMVVm17WMFeuVWLOr+zgz1bGOXZkQ27hJqzE/6R9WCU=
X-Received: by 2002:a17:903:2c08:b0:2ca:d31e:ac50 with SMTP id d9443c01a7336-2cfa71d95c0mr14363935ad.17.1784769020838;
        Wed, 22 Jul 2026 18:10:20 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efd828asm23053005ad.19.2026.07.22.18.10.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Jul 2026 18:10:20 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	briannorris@chromium.org,
	francesco@dolcini.it,
	Zhao Li <enderaoelyther@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] wifi: mwifiex: validate action frame fixed fields
Date: Thu, 23 Jul 2026 09:10:13 +0800
Message-ID: <20260723011013.76968-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
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

For action frames, the parser reads the category immediately after that
header and, for a public action frame, reads the following action code
without verifying that either field is present. A minimal frame therefore
reads one or two bytes beyond the RX buffer.

Validate the header and require the category and public action-code fields
before reading them. mwifiex parses the firmware four-address layout before
removing addr4, so add ETH_ALEN to the standard
IEEE80211_MIN_ACTION_SIZE() offsets.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: 72e5aa8d2a6d ("mwifiex: support for parsing TDLS discovery frames")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/66f148d83eb9f0970b9abbccc85d1b61244e54ad.camel@sipsolutions.net/
Link: https://lore.kernel.org/all/20260708195911.84365-8-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v2:
  - Add a local header check and express the action field sizes with
    IEEE80211_MIN_ACTION_SIZE(), accounting for the firmware layout.

 drivers/net/wireless/marvell/mwifiex/util.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 7d3631d212236..4043590137391 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -313,13 +313,22 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 	u8 category, action_code, *addr2;
 	struct ieee80211_hdr *ieee_hdr = (void *)payload;
 
+	if (len < sizeof(*ieee_hdr))
+		return -1;
+
 	stype = (le16_to_cpu(ieee_hdr->frame_control) & IEEE80211_FCTL_STYPE);
 
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
