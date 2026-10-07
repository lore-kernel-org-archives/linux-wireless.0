Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D88E46D551
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374329; cv=none; b=m0DhGzj8m3x+8oBo+xjgUOIX8WayQVLhz0hzhQwM4SuNFI0tTLeY5QKI197ffTY0OLIQSafkVvvV9+rA9L26tY09dPHh4ZFYm+BXuWj0UyqSiVUipij5gleccWo7jm8ztcXJVjHT0CETJVnH3Jzfd1XX8yVWDw+/6aydgfIdZtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374329; c=relaxed/simple;
	bh=s7RHTsXfEOg+gwqThuTUUiknVQDtwJu49s4s8eAwliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfvgI0vmoUSu21u2LrEmZv3DbmLtIoZD0JTY+8gNIsRy8GoU76GkaRn+wheXYICvWWx0oQQEQGC3z7+IwAk3hoKkYSC0LthoIkfItSWekyiwCvoQnG/Y3U7AqGtY0FhzdPB2I0mCnAyam+Dlw7QYyCnzCEXjz52QSnbo1NiSFC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIzPxpTI; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIzPxpTI"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so949565a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374319; x=1791979119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEgFM2qnyZ26U72V739p3+vOc5ZxhizwkmlzBdho0QE=;
        b=SIzPxpTIhtpspFxN5a67mVTrA/+OHpoJoUQTDH/zBZoeC5U/NCOzsR7FHRHKdWrhXt
         +A57W8WxQAZQbtAgcdGCV5fgz9v8/LjRSldDsf3x3hQd9Ww0FdVvz7h2oyKt/Hj97FlO
         JudV/Jduycabm0zwjatpQjw5PaSPTrCcoDZxvEFArkGDT5AusE2yOAw2YtdgN9DR61fC
         iXHzK80TjLPgV7gJQGS7GjCWxtobW8F4d3pqWUZZSvZwayLpbi0aVY0CBFMgeLajxuMc
         sgPzx0HQfw0xIwrimjvgyj+owx8LhkGzwg7a0yD1Rb+OLvsnTi17E8xKaapDaqtFRarf
         AESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374319; x=1791979119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IEgFM2qnyZ26U72V739p3+vOc5ZxhizwkmlzBdho0QE=;
        b=jc3vfkzW+qKYJXUehZz97fVfQlWyWAU7rOijqj7FJ2T0BypPVub/z9/ANi5L4Ws98i
         ciIk8KDiMaAX1wpouA3HnSHDjzeVkBTX7K7yum3vnJ1Bdosk5PGjbV2EFeMSrFRjLBe+
         Mk4TEb1BVlbhT1MhZALtKxittEnLpauY12O9nwLvaw4ThpzkRTTgAjEXUzLsEdEl5Deq
         74HUZmEEeR4DNA+W8C0XptckMrF1Ot+V0ep+NRgMWPlvvNqMgDQrVeGUQ2987EGQ6m9c
         ttDSTOnYhZrcfLkO6o0MVZb3H/HgplNWnSK+WQ46zcL/lgvegk2c7fEs0ZkShYj5QGGj
         xCRA==
X-Forwarded-Encrypted: i=1; AKwUvByJ7why/xemVA/3Xl/umQy5AxNcHQrqjeaTO+U/EFwpngtNLEn9UyhpRQZRXcYEu3zLGPWrmkeAbcJja3V3sg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJyw52ddeeoCA8eXE8AnJLOAn8I3Al44llZk9TS/9eIfSDSLVcE
	12//nh+3rNnV0bm8zu2N7KEvPSV7szugba8JpQrZskDC/+gj4Xef3A4Q
X-Gm-Gg: AYBFou2BfPB3c9Dop02tHOTkUCtvBw1CYhISu0Yj3V9hZ0HrAuqfkKEzKx+2ETscrKV
	1iEQZOsucALnfm+G2jy9eaGoWajMVwOthtorUueAxvMspcZJ8cunwBTMCTLblQ8XB+eipylzE48
	Ep59tvi2jIgGWMxl8clKlByPqyRgdURxXEHP+lZGpF0qkSM+f40IIr6IQYQD1z9Yz6TSpMA3XOV
	bsv1P2PrJHRzTozwf8Ora+LwQFSaY5gLV3FRUU4HW0dWekhj9zddQXVYaBkmvkhayk48k7TUWSc
	5i941G8KegIq0qgnOZnh0YZCBE5EpOd5FXOniZs19QhHoDs0mh4E1X6UDa2lhOXv0Zq8y6U4Pg1
	7ruqP7WjG0J6CvrwXChWhAWP6rP5K5L6ovtJ8NQ3DM1psqRUCbIoAqHLmRXUb9/hMoDMIYWYh2J
	2i0OaC9j8hxzsfhvu7tGCbHk+OgWmwVda/QPAaZOANzsBoFgYg1KEI2duKMweNUKE3uzPaxSyKv
	QiO/bxbW35vDZ35dtCiubQ5UgRCCqMu3BBqOPd/XW4L0XAO5tmwkN6+J8ri1DuAHGjh7Xmywyeh
	FELtbagUlWE=
X-Received: by 2002:a17:90b:534c:b0:3a2:bb9f:f87d with SMTP id 98e67ed59e1d1-3a8a0e2bad1mr1081798a91.21.1791374318558;
        Wed, 07 Oct 2026 04:58:38 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8987b09e2sm4456582a91.2.2026.10.07.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 04:58:37 -0700 (PDT)
Sender: Yuyang Huang <uyoko90@gmail.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
To: Yuyang Huang <sigefriedhyy@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Nikolaos Gkarlis <nickgarlis@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Shuah Khan <shuah@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v10 1/6] netlink: specs: rt-addr: fix the type of target-netnsid
Date: Wed,  7 Oct 2026 20:58:16 +0900
Message-ID: <20261007115821.11332-2-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007115821.11332-1-sigefriedhyy@gmail.com>
References: <20261007115821.11332-1-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel parses IFA_TARGET_NETNSID as NLA_S32 and rt-link.yaml
declares its target-netnsid as s32, but rt-addr.yaml has it as binary.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 Documentation/netlink/specs/rt-addr.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
index 0ecbd24c890c6..17ead22034515 100644
--- a/Documentation/netlink/specs/rt-addr.yaml
+++ b/Documentation/netlink/specs/rt-addr.yaml
@@ -119,7 +119,7 @@ attribute-sets:
         type: u32
       -
         name: target-netnsid
-        type: binary
+        type: s32
       -
         name: proto
         type: u8
-- 
2.43.0

