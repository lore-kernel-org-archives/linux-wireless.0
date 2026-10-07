Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78524439F62
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374355; cv=none; b=otNPOUqi0yWOj7PYZf9AlDknGm//6S2WmuFJENyg0QYYSVbh1LkrqWro7IXuTog92pkiPPOlbex29gEhEwj8bZBLndZJkEJpVe6/QEhNLZJAG4VioRHeFyrWhenBujOD8pvxqIh45dwx5LlRr1CwwAqQax+r0ZRO5goTix3e3kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374355; c=relaxed/simple;
	bh=USMYquWjDSlhNyRAuuQZlk822YJxe0sgKgXXZbTaiuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkK1eSd0GbF6m6GfZVWVEJB4m/xUSAtjbYzNh+Z2jfVjGAC6WzBwxOeSMSf8cHm8bXxdGw5xEadGrLxpoppRPKPpk5Mc0fBUWf6FtuxFx9awhLUT4wOUeSXFgyOGzSRb2M9w/iKAmGRYxKxifk6dm8r5+mtVtyVJqYlDwn9fOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ir3Y+PfV; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ir3Y+PfV"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1650673a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374344; x=1791979144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RNJQaLaUPhfizQ3mt3ZckrLpssIZdRd+0u34vIFrxiI=;
        b=ir3Y+PfVvkQz2sPu/v4KfKcdRpBs11xY/pwU06eR/s6le1VMzV77ABFUFCMkVmKyT/
         rQ34l2rcnM7aBPCum6XHA0nVIFVdIPaeou9V9SC0axANiq1GykxCW/L69GdQKqf6bi9F
         JC3qwez6aTH8xl6TpJuvhUaxtVuxvFuWQkjhrjZGJuGdNsE0jBygLbmA66q7iqhG/jZi
         UQN6CZ4+Wu8FLBT1bqkwF4jpoJ5rBQS/8pPyf4StHg5bYzAt0FAwESvWlH65Pq1BTLCh
         zUJVyNviNIP2hC+TaJNArB0RKOpqcA/bkIG+k4JZOrT6GWjfJM5F2ramV0AzkQN+kHH4
         irHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374344; x=1791979144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RNJQaLaUPhfizQ3mt3ZckrLpssIZdRd+0u34vIFrxiI=;
        b=yQv1CvcwEDQOyHnAxlimL76+wtsP7tjZtTWBumzkTgxCaEsTsqUzG5IGc86ay3hyYa
         fWnvP/vk9uTlcTwCAyAW0xErNo1M45nlaYEX6gdiKhonK4JO3ubypu+HYvWdO3p2boji
         ibl3KzM5WEgHk63HZ1QJFHwTWHXTZq5PvyGB8Matyb4JrciZhIg7uKLWRoiDx5UqLazC
         zQAA5WKZqpyqPR9JHh+2NMeTEd1a/rr1z55uTCq/8cmT59oC2o+4mvTO0pBAIlCk/fhW
         wWqqQ3BXuDRMndHquDOEbXcS2wxcOdVJCUW2J/em2VZ0TZV5TIeKxU5d00paciWdNX2Z
         YnpQ==
X-Forwarded-Encrypted: i=1; AKwUvBz6KjhmS1OcvzM0mJ3NSIaWwY6KQcYNb9LlTZ/T8Az+0rdFhWryFp4RvglHX1h1fPjhp8/Ng/Cl/maYyxylQA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKJ7hb/pX6khr8fPig5KtIVGv8KapmdrnQl3wgdeTTkYmjrcpmd
	rzBdxGRjDuwpZH326zkf3/kr/K4GVhNbCboMbqP6ZtLbPZRKUq2IZgiy
X-Gm-Gg: AYBFou2dpNnl9gSCyQV0EKVd7ljKadbkhPWG5Mk8rkq3lBjv8qTNzttSLE58RgP+Rqw
	8MmwzwQpBdtjrb1Gn/y5s6zuvXCfjZ6SjUu3gXXHUr3pAjnghAj+RU8vJY+tYCIq3m1zLENvmUe
	S7J9peGWLiKWfs1RRTfo/ypzPcZ+Ug0MIavZjRZR59VxccYK/vWGQIOAX4wgOQWBOQGLUQK9syw
	uL+sF2GQShaR45SVglFVIUvNnVrjUV3pBJpvEMc1DiBI+aZLZH+upHJxK5jSgLwAZJxN1q1Isvh
	IS9GjMustdJlXKGYLrnhHSvWOmIbrRsJFl/c9Sun9sUIFewF/uLl03ewmyhPiSM+WQXj6cHELUJ
	Crg8ZAsmD2qV6My/Ehr8PTqSgCdqPJrrp2D+MKA3iM+LuiTEyOJu7NasmmGHzU38F7FXRqvejry
	xV7CIMioqT8tWs3qDDEED0R/x/RA0h4WeitvI3OGCbC1ErnH0IcvSxV2clY1qOQy+qrogO1tc3s
	hsEEsZxq3cMXHCAEsSfattYS91nO7Agow799mvhu9+NI8CdVpDUBQH5qqou9e6O+6fuWS2SXuu4
X-Received: by 2002:a17:90b:1dc2:b0:3a8:545f:520d with SMTP id 98e67ed59e1d1-3a8a1ae940cmr1539624a91.32.1791374343687;
        Wed, 07 Oct 2026 04:59:03 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8987b09e2sm4456582a91.2.2026.10.07.04.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 04:59:03 -0700 (PDT)
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
Subject: [PATCH net-next v10 5/6] netlink: specs: rt-addr: document AF_PACKET multicast dumps
Date: Wed,  7 Oct 2026 20:58:20 +0900
Message-ID: <20261007115821.11332-6-sigefriedhyy@gmail.com>
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

