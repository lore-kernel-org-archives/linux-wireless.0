Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9464D0CF9
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767768; cv=none; b=O9qkTL5pD+dM/WV0x2LZ6ijF2jIgwVdjLubWc9tdhfwsNrKFiWOP30T9llONy9peCzVIaG7TUXVDRZYe2CSXMNRKUiFCRSN6KflFiTW6xqTmAOpUQVaXYQLu4TSSe9oHO7l18P2vMTaYrhZhQkJj0ItdC7HpuZDUbb3u8eRCq/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767768; c=relaxed/simple;
	bh=MtRgZIL0ejzkv81A5uoXkUOIGYLKSnfs4/MRbrb/dH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8KMeU7xNyL3fBwE0YYlEwFtmKMjeeJY4rrniw+qUMTVaCgjqNBczkjWGuY8s9KGYR0TKctqGL0XGxcSKLR9uQKFGJJ37H88Ov90dZ8vBlOzkk331BpnZbl5WN4A/G/OhYwE3QZGhh/N/jxEeS13kYwB376MIHxexvo1fk9s0IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNKiX4ki; arc=none smtp.client-ip=74.125.227.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNKiX4ki"
Received: by mail-pj2-f38.google.com with SMTP id 98e67ed59e1d1-3a4c6bfce73so402753a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 04:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767767; x=1791372567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eDtomUq8zw6nK1KObwDR6CCREpvglQp6A+WXvBo8Gzs=;
        b=TNKiX4kiUPdsvOWP9SceCTouK6sy9iUYNjo1F8p9Mjxl7+lwcdssD7ZKzSS0/xNJt5
         uXpVEDEEwiMs13xJSNvz5v5hIoas9TJqjepmu9rU2fJ/zR2OZgiby+dfL1Fjw75rYGC5
         QLmvrPGdCnVtrJMiyoZUk8qDvZ62TUQujP8MY9ys/usdldL3pDj31Cy6lx/ZumGiYwtN
         Z5T8oLTuX9zLVZUpQoIGJg8POp4DjP6tvZThArmXEphubZSTQw6nwtz/Ib8SDNj9/KOi
         d2/VsFm1E0Rdl1jb66V4QHR3THJ2wM6nbdDoxMMc6qUtKY/6jZHFDcOVOZrMydY9b2Zi
         didg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767767; x=1791372567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eDtomUq8zw6nK1KObwDR6CCREpvglQp6A+WXvBo8Gzs=;
        b=LYXQHSu++htfpj5L213eu4/0FiUQ8grRh8+vDW2qLyCOYaBVb+7hMlJr1b+TVX5Piy
         X/iQmlEu0vA4AW5a9bWJAID2QyCKJWgosrB1PX5KlKTIKrnJsPPro3IvbGC0BcuvGWl8
         ABNqK6JI3se6A0bn3Hk76Qc5y4bKPHQsMdMfHQnCvgn/nZIq2x/R6QFpBXmkPq3AMxba
         puXv5rlyTdr+nPdraOEEwsvltTBt9XYb7B0MsULI557Dl+Y2c3uE/9FJiD/z3ZDGc+Gd
         VHyGoErwlDAEyU+a6U8TIvdkkKAs55w69U76m3DrqT+LHMN9F2hlwDfvMYdTbtkkztTn
         M3fQ==
X-Forwarded-Encrypted: i=1; AKwUvBy+JNuN3MluyDYpyvcbQa3pGZJFzd831VosHX1CPG6y3riPCBT7Cmv6QLCmCU1/Tm7QxGA/Wm+KhdIzvBczvA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLMgvlFIRosQ6Fio5CYW79oi1vCM52sk57CaA6hMBWpZ9ddTG/Q
	XhZSD0xV3YB7mP+Y/Qxedjm9O1EjxxjykxK2pARwZC+2qBYDPO+Y5QmW
X-Gm-Gg: AYBFou2IQiUmN6RX2tj3iM8U6rmz+w4K8mjyK35DSSASZW9WFHIZEM9JVDBhOjCsn79
	td69j4lZ7JwW6BSwEN2ZLT8k/9Q88IcBMPQ+j9/cVMg+VD5J7CQ478oCmg4L0okDwPBAw4HYW6K
	IUIa8Qh44b+aaoQsZdBeSI5Od1GlHAkJIXSae+brkNspok02b9xg7Ecln5eJ9z+7HuJxMR2wLmC
	wojRJFqRBKkIhH8Vcc7bFDJxIAXWqyvJ8ArMOV+DLZamoyxUjFazPPi+g8TRi8YzCtAfESreFId
	nvANYfiNyMes7xyCMaRTXvU4Lk1068MR1Q/5yRuqnVarbD6Za50CU11iWjj0P35x464Rbc4r7rq
	b3yUQynbNdgRJmvsp2si+J3JQBqRwRsdvS9xhG10t02hLhyE1+xSS0xjEWVc0vuY0diJqhBQUcK
	8LGwb173Fy04AghMHo04D7W3kR/SSZwRh+J4EHHb11hGyx0gBCaXnkiJjXyhICoJBnSzWWphLVJ
	5EVe1xdbXtsneUIm6xuuaHMUe1BPqXNL1oJkiPAmcmJ
X-Received: by 2002:a17:90b:2787:b0:3a0:e76e:ae10 with SMTP id 98e67ed59e1d1-3a4d175ddcamr1003462a91.28.1790767766632;
        Wed, 30 Sep 2026 04:29:26 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan ([2400:2410:3f60:500:3fb:270c:7df4:18f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm712637a12.31.2026.09.30.04.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:29:26 -0700 (PDT)
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
Subject: [PATCH net-next v9 5/6] netlink: specs: rt-addr: document AF_PACKET multicast dumps
Date: Wed, 30 Sep 2026 20:28:41 +0900
Message-ID: <20260930112842.21323-6-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930112842.21323-1-sigefriedhyy@gmail.com>
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the global flag, list the attributes the AF_PACKET dump uses and
describe how ifa-family selects IPv4, IPv6 or link-layer output for
RTM_GETMULTICAST.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/netlink/specs/rt-addr.yaml | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
index 17ead22034515..1bd1184d1e202 100644
--- a/Documentation/netlink/specs/rt-addr.yaml
+++ b/Documentation/netlink/specs/rt-addr.yaml
@@ -77,6 +77,8 @@ definitions:
         name: mcautojoin
       -
         name: stable-privacy
+      -
+        name: global
 
 attribute-sets:
   -
@@ -168,7 +170,16 @@ operations:
           attributes: *ifaddr-all
     -
       name: getmulticast
-      doc: Get / dump IPv4/IPv6 multicast addresses.
+      doc: |
+        Get / dump multicast addresses. ifa-family must select the address
+        family: AF_INET or AF_INET6 for the IP multicast groups joined on
+        a device, AF_PACKET for the link-layer multicast addresses in the
+        device filter. Link-layer entries added explicitly, e.g. with
+        SIOCADDMULTI or "bridge fdb add ... self", rather than by a
+        protocol join are reported with the global flag set. For AF_PACKET
+        a non-zero ifa-index restricts the dump to that device and
+        ifa-prefixlen, ifa-flags and ifa-scope must be zero, AF_INET and
+        AF_INET6 apply this with NETLINK_GET_STRICT_CHK only.
       attribute-set: addr-attrs
       fixed-header: ifaddrmsg
       do:
@@ -181,10 +192,13 @@ operations:
             - multicast
             - mc-users
             - cacheinfo
+            - flags
+            - target-netnsid
       dump:
         request:
           value: 58
-          attributes: []
+          attributes:
+            - target-netnsid
         reply:
           value: 58
           attributes: *mcaddr-attrs
-- 
2.43.0

