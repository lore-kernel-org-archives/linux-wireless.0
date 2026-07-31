Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF744C65B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512975; cv=none; b=u0L+B3AYpV0Hhi64+h7lD3jN6slYVfSm/WuVGmkzLu0Qr60wa3iG7FFDWg3AjUUdoRVbPckhFI9epA4kd6zPrlEdZmOBODewJW7Y9k3Bc910GXfXHF6d6giVvslMT8exxPSKngf9HQkf8mgQ3D9cXaD8+pQkdxRUVm+Xs+QKeCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512975; c=relaxed/simple;
	bh=/RZ3/Y/ZlOJg5G1yVeQGiGHh8zDUuB5gPSaN4Pn9iwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKFlT3gfSjNLQKIxF8MrbcB3EQZO9coGI+HBR6FflWV79n54egAdwWH1ObAzcKfBZJ4azHTkrVRg2Y9ZRUP4nfDvSNN8qGE4tXijM0Q0daGU9O33H/uGydc5ciz3DlJtmGpU/d8LKPZw1wdFAwSuIoUiU4AYl5R6bkmPcUcxEec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=prCfQF4C; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="prCfQF4C"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cad85b7b5aso1021225ad.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512974; x=1786117774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rtE+fcyTa/nEHTvbkkFzvfqX94g1NeErZWdBjlXHpz8=;
        b=prCfQF4Cw7OWxaJPDxrTn6vvTO0Q+IrSY4RYaRd497q8OHEB6yjpX9V5+VfokNmdRn
         6VL5xeSXManjLzcvGl5bj0M++h5XQ1mQDI84NBxJJbsSRI/x9+1riBL5b6+gx4fSY89W
         FpqdSMKAekKD731M8KfNKwYdVPcEpNKDn2kBJh2A4TbXF8nZoJt/OEOAD7TrqVnZm7Y2
         4YYLouBJZ+C0rHa+n77p1biRWxihsIMt/vTM2erran+o8+tUGx2E5c4PB24jLyE5ajNA
         K1BhEEQ5SxP80TDbGTyQ/a2rlI4O1X1MR7fK27/DAu6MDzQaZtw32G9yftsIc9/QIi9M
         /05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512974; x=1786117774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rtE+fcyTa/nEHTvbkkFzvfqX94g1NeErZWdBjlXHpz8=;
        b=qXgdCVh/smpEVhMQdGa/PRVBXxCYdG1NI2buOsr91Nb3pUERlhWAlqXmmnKArO8ECA
         7oz59MF4e8pvPUxIW234JdTZ9wSLbFzYMUsf8oaww5wJIiXu3NROupZJXI0hJnRN2Bv4
         pNrrSchP3Ouixl9yiG30FsiPw35PTOh0Us9MfS4eEsGGFGSHqLH+rh80OY15rAKg/tQ0
         m5AFVKiMipTB/xYWA4OZ9ZYCFJKuk1SDqzQc1w4rRZR71hTycJQFfUi/XxF0ZWlhB0FU
         66LPd3JujK2lVdPFHH8UV3QBgXtT9D7/m9pawUkZc+7LRKmScE0BR/bvOQRVbC7XsLRY
         2k1Q==
X-Gm-Message-State: AOJu0YwwSb5p0buQ7/D3tZNThJPJ7nuKE9zK+NQzn3TvMmSt8YaBpgZi
	bVqbdITw4IqMkzeZ/ppZ3sldkPoEC6SQx5frA7uS/tIxtckoJkJaK5Q8
X-Gm-Gg: AR+sD13Dt3HqUpznngTyfxFlRQ8il64INpRDhCB6upcSErHnZ+a1RVj6Xl/mQj3WYu8
	w58uXJD9nScUSuY1kj2ceU/J2onxYVAQ5p82ULMurer1tOR5BQJBji+oCfc12I5EfPVQWBrDYAT
	kqpKZRrMMsVRWBeguAK6nASKbQhf4byqeRRsGIlezAaijI2zr9Dh7YkovIJvUmLwCrjvL28TDEq
	X0obvAfBVybI7MwFw3aaJvUsP0WiKx/XuNaiJPlhalvpllIF4VzsPJB0JBh26VJ3ZWySNhISL47
	H6kyLTyZNYVR3XKQtB8AvQg8NuzvE5MGaS++PaXclYAiELZ1q6GblYkbw9M0bYtQra1vbok8iH5
	NjsSmLC7UNPgZYGhzk9gLLAKC7xQpxkhp93Pu1N7ZGPeUHsFlu8bdLo5xKUozcZqYSepItwRwvv
	oPJdBEbro+DgHFQMqhi6rKTxqudzsuU4BD0Mrs5JegWXynOQ2KmiFo9jrB2Y9WBEZ6fDPu26P+m
	JyicGr1S7GYZQ==
X-Received: by 2002:a17:90b:3cce:b0:383:5a16:bd67 with SMTP id 98e67ed59e1d1-38fbc58abc2mr441543a91.4.1785512973970;
        Fri, 31 Jul 2026 08:49:33 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:33 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 8/8] wifi: brcmsmac: ampdu: clarify standard compliance on QoS change
Date: Fri, 31 Jul 2026 15:48:40 +0000
Message-ID: <20260731154901.1822-9-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Updates XXX comment to properly reference IEEE 802.11n requirements
that all MPDUs in an A-MPDU must share the same TID.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index fc7a5dd2e5d8..3fd8bdbd35e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -516,12 +516,11 @@ int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
 			return -ENOSPC;
 
 		/*
-		 * We aren't really out of space if the new frame is of
-		 * a different priority, but we want the same behaviour
-		 * so return -ENOSPC anyway.
-		 *
-		 * XXX: The old AMPDU code did this, but is it really
-		 * necessary?
+		 * IEEE 802.11n standard requires that all MPDUs within an
+		 * A-MPDU belong to the same TID (Traffic Identifier).
+		 * Since priority maps to TID, a different priority means
+		 * we must close the current aggregate and start a new one,
+		 * so we return -ENOSPC here.
 		 */
 		first = skb_peek(&session->skb_list);
 		if (p->priority != first->priority)
-- 
2.53.0

