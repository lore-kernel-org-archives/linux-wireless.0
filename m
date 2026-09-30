Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1F4D5965
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767775; cv=none; b=rT5/2YOnoxjspli3HIQmUNHada/TsmoKlgx7jJx2SuEYs2w8o9KiIaxCt09olKe3tNJw+bMX+Ya+ivCR6WmC3k1kDYq1d02JDz645tJxbf4gHNzOfF57XR2qryYzMjdtK5fydZZAIr2ihIh7ggY5GGSnxuFRoil3qGqqD32W9mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767775; c=relaxed/simple;
	bh=6I9/o2fsb95RZ/cdcrjocTXvh86feiHHlbzI4OFSZMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnKv3EMCuf3LBCy3mD/+u9f86XVYc1FuInRSzb+3Lp59+oNquYxctOxngrBix6CpNTq+udyLiVy4akrIVOg3lyXzvu7cEzzaRyRRDju2WDj7xvR2fz/eK+xhv74vfMG3LUya2RKq3ChRvwnmkhhFI6LtPQYTYQoFa9ZqD6N4Nus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhouW3A1; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhouW3A1"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e69so1726564a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 04:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767773; x=1791372573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8tVHCGk2Xwqu+yf2mIq4Pai4+4x8BJRwBsQH1o/snK8=;
        b=RhouW3A1HoH73HAXMBtDC8A87acGjfD6grYWDwNGBDdrMe8U2NoWq453YYgCWB/EFG
         GPomUPqtEQSVXek1CDxjIOTxEA2iqMbtsCWl4btj6Df8An4q0F6gsfG19RZ8GzJJu5CP
         JZjnyjeYcvDxrYtC6isah2QuRSoDajCTWmY96jDye4sIoSTFZOWWTEqal/kuojdW9AO7
         d8u7adNeEwFcmW0JzsTn2xa/rYGOW0DjHK9xmUZ8f5dQwd5EAUbjIHwVAybe2yCI+3gk
         Bn0hFuQ8hb2bN6GHJ75LOqVDgDdGiowyztRyE9d3Kht3M+s1rrg//yvXcYO8Sx3mDhEY
         b1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767773; x=1791372573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8tVHCGk2Xwqu+yf2mIq4Pai4+4x8BJRwBsQH1o/snK8=;
        b=XkN5vB0+lqigU3uDu7P8e+5pfGowR5kfRLih0TjTipDE6t4KYYj3f7SHqF2HUN7QR3
         /ueP24Zr2Sd1VPUtIZkFPnFXc+RDXWbQ5VW7Qi76oJpfPrz17q/CJ+f9G2cY1Xb950AC
         DjRlymifPH/MgZ/YyzDgT+ROfN+6IvZfp4aw4XEL2fjWhMbsKEFzVu2M3pgPwBuJzv59
         Xa/jM1LTmhkw5OuEqkRUi5ElRg5Zwkkg7yGf0a6pkSiFMdbwX8MZfucBaJM6RcxozwL9
         ftymvUYzVN1g5Vf3ZUykHc//fy1XxqldZFC5rJ5vicVU8w6e6bMSxjtbbtg8QYbrFS+X
         1FEA==
X-Forwarded-Encrypted: i=1; AKwUvBxAbA7oW91D6PHDqaQqEti3F6K16GyZOV1aEdNaadMsvSAJCSprYYUpOG1GBXcGFeMUZ68meDAmD4SHxnHMhA==@vger.kernel.org
X-Gm-Message-State: AFuF++mUAVBLuxPpBN/KqeZJKLdn1VJqdzFn0T9C2ZNyafQYmefPnuGC
	djmObRm1w+979yILeBTLazvTaFU2154z+Mvt/FgZ0IaebuNeGV6tQe3w
X-Gm-Gg: AYBFou2JrVJfYh42nJVvRyLn5C+9j2EOP4kTpcI04ns+oS0LHiGzZ3XE7LXLkL/tEaN
	u1LPiCMT0Iya8tyUxWPWEUjL0Q7IEZet0MjQEB1mQ/21Klg1bdJlybivsad4YuIQgW1oc30dKjV
	GTU2jh+FRPYWETCLWfLia+dS16eSZyYrBgPhDqov5gNFcn7Ga03FS2Beg8n1EIBJQzmOZDWaR8Z
	oVuDYxCnnDDRP2/apiGu8e8n73bsaCoHg6zV7Wl6asGgJ2oM0yKhrp3c6heIlsN5jxf7b7DIJJ0
	UCDEn9zKWig6OB1hMOuN8IsPcwUpRjVjPzD/ozJ1x35MbNrqLCMhQvCB5JaY01jEZMnJVGoFFy5
	rrdIU9E7HIU/jTanc3x01VXOKa2NteIVe8dFkJGJzIQKpvEbBa7+QPED6bHem69Yej8V2P2RZ8c
	yaBfhdsViNVEfFtwAowpirvyb+TYGaIF3PHRVNlKKb7NtTV6/NYOyeElhU3PqT2I/q9+IQAmdI7
	w8dp7h0iPeOZutCOte8LQAIh0a3t8btjEPzkS06EOOQ
X-Received: by 2002:a05:6a21:32a2:b0:3dd:a197:735c with SMTP id adf61e73a8af0-3de9e84e31cmr980963637.53.1790767773292;
        Wed, 30 Sep 2026 04:29:33 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan ([2400:2410:3f60:500:3fb:270c:7df4:18f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm712637a12.31.2026.09.30.04.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:29:32 -0700 (PDT)
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
Subject: [PATCH net-next v9 6/6] selftests: net: test AF_PACKET multicast dumps
Date: Wed, 30 Sep 2026 20:28:42 +0900
Message-ID: <20260930112842.21323-7-sigefriedhyy@gmail.com>
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

Dump the link-layer multicast addresses of a dummy device and verify
that ifa_index restricts the dump to that device, that the all-hosts
address joined on link up is listed without IFA_F_GLOBAL, that an
address added with SIOCADDMULTI is listed with IFA_F_GLOBAL and
IFA_MC_USERS, and that IFA_TARGET_NETNSID dumps another netns.

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 tools/testing/selftests/net/rtnetlink.py | 73 +++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/rtnetlink.py b/tools/testing/selftests/net/rtnetlink.py
index dc8c77db48974..5534ade056a5c 100755
--- a/tools/testing/selftests/net/rtnetlink.py
+++ b/tools/testing/selftests/net/rtnetlink.py
@@ -5,13 +5,18 @@ import socket
 import struct
 import time
 from lib.py import bkg, ip, ksft_exit, ksft_run, ksft_eq, ksft_ge, ksft_true, KsftSkipEx
-from lib.py import ksft_not_in, ksft_not_none
+from lib.py import ksft_in, ksft_not_in, ksft_not_none
 from lib.py import CmdExitFailure, NetNS, NetNSEnter, RtnlAddrFamily, RtnlRouteFamily
 from lib.py import defer
 
 IPV4_ALL_HOSTS_MULTICAST = b'\xe0\x00\x00\x01'
 IPV4_TEST_MULTICAST = b'\xef\x01\x01\x01'
 IPV6_TEST_MULTICAST = bytes.fromhex('ff020000000000000000000000000123')
+ETH_ALL_HOSTS_MULTICAST = bytes.fromhex('01005e000001')
+ETH_TEST_MULTICAST_STR = '01:00:5e:01:01:01'
+ETH_TEST_MULTICAST = bytes.fromhex(ETH_TEST_MULTICAST_STR.replace(':', ''))
+ETH_PEER_MULTICAST_STR = '01:00:5e:02:02:02'
+ETH_PEER_MULTICAST = bytes.fromhex(ETH_PEER_MULTICAST_STR.replace(':', ''))
 
 
 def _users_for(rtnl: RtnlAddrFamily, family: int, grp: bytes, ifindex: int):
@@ -105,6 +110,69 @@ def dump_mcaddr6_check() -> None:
                 s2.close()
 
 
+def dump_mcaddr_l2_check() -> None:
+    """
+    Verify link-layer multicast addresses in an AF_PACKET RTM_GETMULTICAST
+    dump: the ifa-index filter, mc-users, the global flag and
+    target-netnsid.
+    """
+
+    with NetNS() as ns, NetNSEnter(str(ns)):
+        for ifname in ("dummy1", "dummy2"):
+            ip(f"link add name {ifname} type dummy")
+            ip(f"link set {ifname} up")
+        dev_idx = socket.if_nametoindex("dummy1")
+        ip(f"maddr add {ETH_TEST_MULTICAST_STR} dev dummy1")
+
+        rtnl = RtnlAddrFamily()
+        defer(rtnl.close)
+        addresses = rtnl.getmulticast(
+            {"ifa-family": socket.AF_PACKET, "ifa-index": dev_idx},
+            dump=True)
+
+        # dummy2 has entries as well, only dummy1 may be listed
+        ksft_eq({addr['ifa-index'] for addr in addresses}, {dev_idx},
+                "AF_PACKET multicast dump ignored ifa-index filter")
+
+        entries = {addr['multicast']: addr for addr in addresses}
+
+        # Bringing an Ethernet device up joins 224.0.0.1, which maps
+        # to 01:00:5e:00:00:01 in the device multicast list.
+        all_hosts = entries.get(ETH_ALL_HOSTS_MULTICAST)
+        ksft_not_none(all_hosts,
+                      "dummy1 does not have the all-hosts link-layer address")
+        if all_hosts is not None:
+            ksft_not_in('global', all_hosts['flags'],
+                        "protocol entry is global")
+
+        static = entries.get(ETH_TEST_MULTICAST)
+        ksft_not_none(static, "dummy1 does not have the SIOCADDMULTI address")
+        if static is not None:
+            ksft_eq(static['mc-users'], 1,
+                    "unexpected mc-users for the SIOCADDMULTI address")
+            ksft_in('global', static['flags'],
+                    "SIOCADDMULTI entry is not global")
+
+        # target-netnsid dumps another netns, ifa-index is relative to it
+        with NetNS() as peer:
+            ip(f"netns set {peer} 5")
+            ip("link add name dummy3 type dummy", ns=peer)
+            ip("link set dummy3 up", ns=peer)
+            ip(f"maddr add {ETH_PEER_MULTICAST_STR} dev dummy3", ns=peer)
+            peer_idx = ip("link show dummy3", json=True, ns=peer)[0]['ifindex']
+
+            addresses = rtnl.getmulticast(
+                {"ifa-family": socket.AF_PACKET, "target-netnsid": 5,
+                 "ifa-index": peer_idx}, dump=True)
+            ksft_eq({(addr['ifa-index'], addr['target-netnsid'])
+                     for addr in addresses}, {(peer_idx, 5)},
+                    "target-netnsid did not dump the peer netns")
+            # dummy1 in this netns can have the same ifindex as dummy3
+            ksft_in(ETH_PEER_MULTICAST,
+                    {addr['multicast'] for addr in addresses},
+                    "target-netnsid did not dump the peer device")
+
+
 def ipv4_devconf_notify() -> None:
     """
     Configure an interface and set ipv4-devconf values through netlink
@@ -424,7 +492,8 @@ def ipv6_verify_inter_scope_addr_order() -> None:
 
 
 def main() -> None:
-    ksft_run([dump_mcaddr_check, dump_mcaddr6_check, ipv4_devconf_notify,
+    ksft_run([dump_mcaddr_check, dump_mcaddr6_check, dump_mcaddr_l2_check,
+              ipv4_devconf_notify,
               ipv6_route_del_reason_expired,
               ipv6_route_del_reason_ra_withdrawn,
               ipv6_route_del_reason_absent,
-- 
2.43.0

