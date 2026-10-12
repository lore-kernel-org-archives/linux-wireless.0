Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7463750BE
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 01:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767868; cv=none; b=lStacotzpwRUIVacEp944dAoKZgq/2E3VjlQbLEIBjh5I+2WRgXR5Erc7GjwMslgaiDvJNG206ZtglqcA95uQJeT6KHGVHDRX3u4QQaqa8HHPRHmJDaxyWb6YapN9hXf8VCCWFWuEA82GgkmiVC7iHJ82zTTOcl3p6X/7QY/WUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767868; c=relaxed/simple;
	bh=USMYquWjDSlhNyRAuuQZlk822YJxe0sgKgXXZbTaiuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVQ0BWtnNDECtNu2zu/UgQK2cecaBNYg2YDMflSUyQrEJKDTQxD4Vl+7xtulCSLWrXveK1Mm1c/J9VAyF/y+vpfy6MvNq/JmsBCVoYt/pExR4i+GyjIHf7Q8beFs4qt81IwrIt+IiNjqjpQI28GL/rliNwJ4DeuhkDJt4cEdNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BiqNsmzn; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiqNsmzn"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so379235a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 18:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791767867; x=1792372667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RNJQaLaUPhfizQ3mt3ZckrLpssIZdRd+0u34vIFrxiI=;
        b=BiqNsmzn2Bw1P9Z9RyN0iJgNZZW4ZGR8j8fR76uTOFpgO59/sb0vysH4MqXa9XeCTC
         GVMB4x2Q/jYvqbDWMcxTw+/fYo+x8nvfnn7q5gfnHfEl+jVxnJZqdKvLfRSWN7IM96oi
         1LOAx4euHhj3fXwkEIFQyoLDsChP6U7KnEREVCvgtDYtsaF3FvQDhxX4eF/deNEU2z2Q
         ZCWSd4TWruvnzwWoR955RmK78MWzsS+skbTLpP0oE2j2/962MlpaGAz+q4a11oLXkNvl
         E2xNUb6NqiR+6uB1kMbx71/VNOqCMFb+9ZP6tbSE/gNF0hInQrKUHlXE0GbgZucalBPt
         hhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791767867; x=1792372667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RNJQaLaUPhfizQ3mt3ZckrLpssIZdRd+0u34vIFrxiI=;
        b=MJIxQW4kWM8CKKRoTIOPgF9Y45AsXSBxprYwFPmEZ8XlS/H9PcXCvPBF0sJMoaE0ZD
         olRLnjdqpiQUAs01Yl0wvxjMjo8aMk1heY/ZUI2wJaLVaB4XY1jzoGFFgsDGU9XgapdR
         EbFb96XlTkgJ5e0Zro2LSVJS/of3HktKlTryOmK9pL5ggpPXn9wftkWHO6ExDRDAFteC
         fIKq+QfzT2WjyhOjMVwsU+HDA44YrYrJQ5DX/Us1Mi3e++KM0nWpjkWkIm7xHsw7s3z/
         xGN8jwlxPTeSFN4cFBgz8GNArmWNb38PDSQQh1hJQH9pauSZpkmtqPkaPblcvGvX+A5e
         nf8w==
X-Forwarded-Encrypted: i=1; AKwUvBxAf9o5mot2Apj8I58dXacAXvb2xfXfzarP0SjkI5RLLtSn5ThSFi//kTsC7xGvJp19Ryt86xc0SmfIjEUcBA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLjPre3qdlGdNSygVwr0c1tAl4EmOFCd6vUsDw0ciBEqKSC8/w7
	1OLlOdj6RT3JLg8jObkYWDw0hhPmQG+cxN55NcS+FUtwjK/p4ViL5aU3
X-Gm-Gg: AYBFou3G7NCMB5Vo5Sr8h21qEYWht1HIwPoLUrCO7WdsK3MdMED12KVCqHmCHOuK9SM
	6rMkRTbo/MfRb8yJH/WqN7bR0xfFG0yWKQyAQCMp0yCxcDbZQiFokwGXychXkd0ZAZZgOg+fccv
	tlDipt49Q+TsinlRl6NKsQ6pk2ycSK3MEya348CtC1IsW+H4bvtmURQmFTTzohlPFE1Kdm0/+P7
	/O0VsHhLyZuXTjhwUhluXxMnj08uP3H+DJp9DkbXZYCyi/4SEfuvLWpnOHFutd9ljkeycN/u/Lq
	hhNUglkoJKt0JCZOudh6bcqbWlP6VYFhoudhcjtS7AnGBHln504ISycBMERUWKvPwiLITR7J143
	J0v2NGf/Sz/n4UzotsHzs2VKo42q/1Ya6BlpYdVeXxe+3Lw1/3uE15AEYLG9RcpuyK7EF4wMGmp
	Ze0ixqY3XDCNHNowhFT4dF8O2sc75jBRiDvRVImXy1PmUni8pSRkKEa8xboPIt0CqZ6vO/AAlhu
	EyIm2fF5jHUu1mFpteYNVDRoaECPHambpFhlvcD0JU77CLHXIRMSqQ51Vd09tOCpqeFXlWb8mqo
X-Received: by 2002:a17:90b:4fcb:b0:3a6:dc2f:f07f with SMTP id 98e67ed59e1d1-3ab3a609f14mr6808753a91.10.1791767866883;
        Sun, 11 Oct 2026 18:17:46 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38dd5864sm13743307a91.8.2026.10.11.18.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:17:46 -0700 (PDT)
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
Subject: [PATCH net-next v11 5/6] netlink: specs: rt-addr: document AF_PACKET multicast dumps
Date: Mon, 12 Oct 2026 10:17:06 +0900
Message-ID: <20261012011707.3378-6-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012011707.3378-1-sigefriedhyy@gmail.com>
References: <20261012011707.3378-1-sigefriedhyy@gmail.com>
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
 Documentation/netlink/specs/rt-addr.yaml | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/rt-addr.yaml b/Documentation/netlink/specs/rt-addr.yaml
index 17ead22034515..cccfccf49cc11 100644
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
@@ -168,7 +170,17 @@ operations:
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
+        AF_INET6 apply this and target-netnsid with NETLINK_GET_STRICT_CHK
+        only.
       attribute-set: addr-attrs
       fixed-header: ifaddrmsg
       do:
@@ -181,10 +193,13 @@ operations:
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

