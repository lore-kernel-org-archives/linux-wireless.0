Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC422370A
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787657133; cv=none; b=DRAR8sOZF6Wh/yLM+I9P4Lws54lDI61Qol7dwagcTFsf352x9kIJtk6EllUQD2NlgjFZydPwbJlr13NZeIJT8a2ALZCtuAJ3yq8lMkCvwtPstXI8KOvOk1Vpv+bKU19tWw25vuK1JgQ0ii3bCqNGv794ALzGaoV8E8+6JyawGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787657133; c=relaxed/simple;
	bh=QAx9UwZc966QvaW1bHnvqvofEVuYy1Q2vCksFrWoe/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpfLOFiClmFetOv8nEk9Kh1YHhSV9cJKI46JH6Ez1Nso2pHf/DNBZXzdqTkbKkJVnZTLF/EzcK3JyTYv8JVmB3ya/Zt8m+DgFE1aLP7X6VPBUwuU3r20yWmsi/x3yLsu0QUGUC5hvA4rD+1cOlMKEkeyur69Mj3lmGeRVZjjC20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcaAeMr1; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcaAeMr1"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d01663d816so37224245ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 04:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787657132; x=1788261932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z3XeY/668kVDZ4xfNnAVG7jTvY2qaZfXTD8D/1tCfTw=;
        b=QcaAeMr1+e5SXe0Tkz1PcjxL3K5KcaiKYFz2BlN2b5/ZRqjHU1BCzmhTJJkUA3S2i+
         3nBQniYt0H9uyYKhl0k/6yhDe0aVtUnfvW43OAfqGdvcoVNQtPKVe9qhWXVfgcIlT96q
         fFdFjWg6PGjsCEZaN5WSyZGxygIhXEDodAEohnKGsEJVlSwx32MdiaYwZL8OYKZXfKZI
         jbAayVRtMIuqk+aCvEyCOATLuzqUuPXZMf1inQHg+1kp/jOeon8yUCfwsL1waasg9dwM
         UB1j27ALO5j60EWzcnpWkaU7dsNIClaGSd+WPf5Y4k9GG6Wq1ezR1faL1L7jaUQ4Nu5c
         rj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787657132; x=1788261932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z3XeY/668kVDZ4xfNnAVG7jTvY2qaZfXTD8D/1tCfTw=;
        b=jN1+lCCgcHWVfWIb/Wz3W9990+A1cEYCFr6ut3BteePWkDQGXgOSVlcwLxM6Os7317
         wkajv1ezgp4MriJUsHD9eJRilI7S+LzQ9Cl4FSv9e1WLwn10N4x3e+chZMZXqvHp6Mn3
         ua1k4oiKTMG1rm12R3QwyUn9ypbRQp0bsMdDzXRg6g5YlDoQKUFiRJ/lnMcwmxOBjAP3
         NlEoEdarqccH9ildbNHXjwdCSznZG5t2YeZZsH6W+Ft8VvxMfVqdWIeBnUmnOwQ9PLVd
         aKKaCaU2smOH0SYQB5XxGy3SOkdaBmJAwDu3mDUNdaTlLmEkD8fAQLD/VF+ZPIAKas9E
         PoQg==
X-Gm-Message-State: AFuF++lFyWm3kFeElQ4ijhWhnYVyVp7yjQ4MPKFyV1EP+2qGSG6H+F4y
	L259Qte19Uq+GDk22NAjHqcVGK0tRiT1yu/avBgTcYZTM7ubq/4YW7HoZfTDzowDb1v98g==
X-Gm-Gg: AR+sD12r8P4OXgBsQKLuy1nsln4c47TbOk4Zqoh1yVDacDZ3Ij09W15+3IxUqN5AVRS
	GUBIdWn9KtVMKL42Ig9FcX9yq/pgMNq8OmPzynbok4YEJl04nxWlXTkfq6a4lH8AOu7ZH+aVTOF
	aNm4rY6zorDUWr6dhaSg/0RROKFQeQbf7c6+DKR86UUTKkI0g2+Q+qqjLoWFr32ComQFzHOI206
	TwIUm+jMJjmk0kUoBwGqKad1uNo00OmPNrz0gLXV9wJNlMvk0uxJx30bQeMMrLQUFi5fPRM51I5
	9X8MN++ywaxRFTbes8C42Qx1w8jmq2HFSsjOfQe38XXgAk4IIBOwokruwWLW7ApJu9ylQRFsbRG
	T3LXoTkQjmCWKHwaww61pF7hCewSxgrmIPci/zBlzLsWxoheWmutHvH0Ub8eDEe9r4t1U3lfE1C
	iqOi7lWfBP/JzUiZ0s3U2ftC0lweIsOI/fJG5HShbXoRW7tEPxy8gwxoPG5DaVXTGyq6ds2Lah1
	yiI+qA7BAQFt0WaTGicVIo2DXP1ch/5Mw3mRw==
X-Received: by 2002:a17:90a:c10f:b0:392:7f74:58c9 with SMTP id 98e67ed59e1d1-396465b298amr12936259a91.15.1787657131399;
        Tue, 25 Aug 2026 04:25:31 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f8e2a730sm38172287eec.0.2026.08.25.04.25.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 04:25:30 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Kees Cook <kees@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Avinash Patil <patila@marvell.com>,
	linville@tuxdriver.com,
	Cathy Luo <cluo@marvell.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4] wifi: mwifiex: validate action frame fixed fields
Date: Tue, 25 Aug 2026 19:25:23 +0800
Message-ID: <20260825112523.95774-1-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <anuWyiPQja6_5vly@google.com>
References: <20260723011013.76968-1-enderaoelyther@gmail.com> <20260723202257.688-1-enderaoelyther@gmail.com> <anuWyiPQja6_5vly@google.com>
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
frame equal to sizeof(struct ieee80211_hdr).

For action frames, the parser reads the category byte immediately after
that header and, for a public action frame, reads the following action
code byte without verifying that either field is present. A truncated frame
can therefore make the parser consume up to two bytes past the
firmware-declared frame length. If those bytes look like a TDLS discovery
response, the malformed frame can spuriously update peer signal state.

Require the category and public action-code fields before reading them.
Use sizeof(*ieee_hdr) so the checks and field accesses directly match the
firmware four-address layout being parsed before address4 is removed.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Suggested-by: Brian Norris <briannorris@chromium.org>
Fixes: 72e5aa8d2a6d ("mwifiex: support for parsing TDLS discovery frames")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/66f148d83eb9f0970b9abbccc85d1b61244e54ad.camel@sipsolutions.net/
Link: https://lore.kernel.org/all/20260708195911.84365-8-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/20260723011013.76968-1-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/20260723202257.688-1-enderaoelyther@gmail.com/
Link: https://lore.kernel.org/all/anuWyiPQja6_5vly@google.com/
Assisted-by: Codex:gpt-5
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
Changes in v4:
- Match the actual four-address parser layout with sizeof(*ieee_hdr) + 1
  and sizeof(*ieee_hdr) + 2, as suggested by Brian.
- Use sizeof(*ieee_hdr) consistently for the corresponding field reads.
- Audit the firmware-length containment concern: both callers reject an
  rx_pkt_offset plus rx_pkt_length beyond skb->len before entering this
  helper, so no redundant check is added here.
- Describe the out-of-frame read and possible TDLS signal-state update
  precisely.

Changes in v3:
- Drop the redundant parser-local header check; the caller already
  guarantees the complete four-address header after removing the two-byte
  firmware prefix.

Changes in v2:
- Express the action-field sizes with IEEE80211_MIN_ACTION_SIZE(),
  accounting for the firmware four-address layout.
---
 drivers/net/wireless/marvell/mwifiex/util.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 7d3631d21223..71305efb77ac 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -317,10 +317,16 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 
 	switch (stype) {
 	case IEEE80211_STYPE_ACTION:
-		category = *(payload + sizeof(struct ieee80211_hdr));
+		if (len < sizeof(*ieee_hdr) + 1)
+			return -1;
+
+		category = *(payload + sizeof(*ieee_hdr));
 		switch (category) {
 		case WLAN_CATEGORY_PUBLIC:
-			action_code = *(payload + sizeof(struct ieee80211_hdr)
+			if (len < sizeof(*ieee_hdr) + 2)
+				return -1;
+
+			action_code = *(payload + sizeof(*ieee_hdr)
 					+ 1);
 			if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
 				addr2 = ieee_hdr->addr2;
-- 
2.50.1 (Apple Git-155)
