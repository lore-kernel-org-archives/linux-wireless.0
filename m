Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C881BD00C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 01:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767839; cv=none; b=mqFemR90+EwGZGMmkLgPbtQBTbGU1A0E1yCbZQv2ZSDdo/yz9e5yjLn79giL8LXHBUn1HfXkjYfcyaLEg1YjsrYS0Ov0fnUKpCJ3B/zQBxeP0T5u2WtuBVC2qXxcfIHXci6ew3mQ/o5EhT9p1k6TD9CUiocBX29PP9SmQKAcZpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767839; c=relaxed/simple;
	bh=f9OqVQRTl+RsOTJdCEieHRhe20rLRHVgPk2WCcq/hCk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZQrWLq9Daqbz6y2esdXkcXazUzkjRZyc6JO206Xt4EE4qmgWl0UC/EiXo1GSB2ATk4C4wJmOQHf/Ac2cWI5EzFRgDt7x3GuSckO9AkKPAc6n3d7bvy3g5P1bUwAnAswjWxZfS6agc1jsy2hWa5KIap3HZdgG4gVVtpPxQ6wVpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D5ntySTK; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5ntySTK"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso519199a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 18:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791767836; x=1792372636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HVAtScMA0Gu/eshIKxcJc5e1pXYr3Zfr1cY3+NzAluM=;
        b=D5ntySTKjsCKR9SWPN5mC0aJGtfG1mongNfzmqMze+dEp4bgg5KGHxyg5MTDnhVQYN
         pgD0rR1wWRshCKSSZvzeRXORLc6AZr0J8Ylil7waBNsgCHoGnLp6cObdtV2/sQTFAB1I
         X0OCwxpgDwDxCWrjWXjnnngyvOfBrAMrUVDMQVM7MUTQfYqQlf0gtl4cKGElHmt2JHtj
         sAm4+QtflqQPfZlJ7+NS3yl+TXA5+Cnqix4/PgS4R2G/cbAHKQIT6LfKvg68QQs1NhDk
         nOFpQ3t6NSYspvRPn0OCt5XBjHiaEchYwgq4TYWdTcA/2OWlugm1J34Nxj9BE0HoT7bj
         KA0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791767836; x=1792372636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVAtScMA0Gu/eshIKxcJc5e1pXYr3Zfr1cY3+NzAluM=;
        b=uGBCm2rs5Eq42qX9XYxCvrAnfzfMoEPfDiGY29iWK7sIwb3FH7QFe+QJ8XcVGiGWCg
         Zj8/B7dgdNRdooNttvtmIOD4p2e/ROa2eIrw8catUiNCXmofQi2FGvenxtNIG3iUrCEu
         ZDVKjvDotgeTnrdirzNcBBiPnp7Ms50e1wsBmNQC4Ur3dixe7bkhuDjkqdMtmySdsaop
         ttMktpDAqrCYU0iX6bKd9sGVgyRIIw8ea+tRLuMAKRHhVnaja0SXAQazOvMSdSO1ZT9b
         jCu4NQQceIXZUbnXKaRTp0h6jIJK7bp0aSAY9zePDGu77CunaJhP7vKcbmN5QZAcGl7w
         V53Q==
X-Forwarded-Encrypted: i=1; AKwUvBy6DHL5lseJbM3h5PWnV/RF6P8apm/AAEPrlPXrsClODZm+wJkx7leNC3HhhpKUZlA5nnhi5hQ3E3XwVuDMpw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKjM4AxuaOVceEVNYCouvVsz5CI6qadRo5Ml4lD20LLj9B1wJ1T
	Oe/gRT8if6IEpw2nQaHxVu9TLx3wZzQkK2T0SA6RdCka9dcdCx9HDjFqcV8sMoOL
X-Gm-Gg: AYBFou1/JrX2KsSEoH3KeU9oSsAph11wFuzoNWl5NmsNdf89eeeYH+q7CnboDRuI+zi
	wRDE3xKxw3d/wvqIuhx2GAQ578Bmuj1VEw9lEDHlyNmL48Gy7Bitk97L/oy5I+yhCn1iBR+N0Pt
	aNri6+YEvxsoLHnjl+zpYC/Ek+ztkAooBmRLyEYhLcwfYxjQPFQ70g5zJ2CkYyG/BxCqRNHuwz+
	gcLJWOw0K+utMkZUpnhtdMTENArShKfOe1+btTUDLBVdUQZNFEsy35ZkShHJ3Tx8B3yi9yuJCUc
	Qg4Po2ayWDLFdUbDMQFtZWjRnc8xEQpSfdxoDluj1Qe09frllxBCTmg2NeyTMacoJqFbQQPDLDE
	od81p0biwbQGQ8EEsr/scHAD6gE4uC9o9E1xo5qa6ZqDvIde/x7tTqRMfWUvN0h+GYn50+MH7Hi
	d+OUxucTthpgLsSeTm9CBq+6KvlFkV9iweVCYXEUfRzHJiKvrbWiXx29vNW+J3b3Q5Ypz1XBB6t
	+k5uCJEEQwvWZZSBw6z5FJDZPvv77NLhVHDGKTis2jUKTuSMGD60SPzi/y/4iqHh8PQJbnc4xDD
	N8DECUKc03M=
X-Received: by 2002:a17:90b:3b84:b0:3a9:8482:420 with SMTP id 98e67ed59e1d1-3ab3a8e55aamr6706622a91.40.1791767836191;
        Sun, 11 Oct 2026 18:17:16 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38dd5864sm13743307a91.8.2026.10.11.18.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:17:15 -0700 (PDT)
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
Subject: [PATCH net-next v11 0/6] rtnetlink: dump link-layer multicast addresses
Date: Mon, 12 Oct 2026 10:17:01 +0900
Message-ID: <20261012011707.3378-1-sigefriedhyy@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"ip maddr show" prints link-layer, IPv4 and IPv6 entries. The IPv4 and
IPv6 ones come over netlink today, with IFA_MC_USERS for the user count.
The link-layer list, dev->mc, is only exported via /proc/net/dev_mcast,
so iproute2 and other users still parse procfs for it.

This series adds the AF_PACKET family to RTM_GETMULTICAST so that the
link-layer multicast addresses are reported the same way. Patch 4 dumps
dev->mc in the ifaddrmsg format of the IPv4 and IPv6 dumps: IFA_MULTICAST
carries the address, IFA_MC_USERS the reference count and a new
IFA_F_GLOBAL flag marks entries added explicitly, the "static" column of
/proc/net/dev_mcast. ifa_index limits the dump to one device and
IFA_TARGET_NETNSID selects another netns. Patches 2 and 3 add a
generation counter for dev->mc changes so a multi-part dump reports
NLM_F_DUMP_INTR like the IPv4 and IPv6 ones. Patches 1 and 5 update the
rt-addr spec and patch 6 adds a selftest.

AF_PACKET dumps returned -EOPNOTSUPP before, so iproute2 can keep the
procfs fallback for older kernels. The iproute2 side is ready and will
be posted once this is in.

Changes in v11:
- Sample cb->seq before each round and again after it, and skip the
  check in a round without a message, so a change after the walk or
  before an empty round sets NLM_F_DUMP_INTR

Changes in v10:
- Rename the list owner to mc_dev and set it for dev->mc only
- Sample cb->seq once after the walk and check it once per round,
  like rtnl_dump_ifinfo()
- Read the count through netdev_hw_addr_list_count() in the helpers
  file, note the init exception in the _count comment
- Fix the FDB remark in the dump message, bridge and macvlan use the
  default FDB dump
- Say in the spec doc that AF_INET and AF_INET6 honour target-netnsid
  with NETLINK_GET_STRICT_CHK only
- Drop the Reviewed-by tags of patches 3 and 4 after the rework

Changes in v9:
- Change the count of a netdev_hw_addr_list through helpers only and
  rename it to _count, as its own patch
- Use the count helpers in __hw_addr_splice() too
- Note in the spec doc that the header checks are unconditional for
  AF_PACKET only

Changes in v8:
- Set the owner of every list a device has, not only dev->mc, and
  check for dev->mc in one place when bumping the counter
- Add __hw_addr_count_inc/dec/reset() so a change of list->count and
  the counter bump stay together

Changes in v7:
- Add a per netns generation counter bumped on dev->mc changes and fold
  it into cb->seq, dev_base_seq alone did not cover the dumped entries
- Sample cb->seq under the address lock of each device and again when a
  dump round ends, so the NLMSG_DONE check sees a change too

Changes in v6:
- Move the dump to net/core/dev_addr_lists.c next to the dev->mc
  helpers
- Stamp cb->seq from dev_base_seq and check dump consistency
- Let an unexpected dump error propagate instead of skipping
- Check for an address only present in the peer netns in the
  target-netnsid selftest, the peer and local ifindex can be equal
- Document the ifa-index filter and the zero header fields in the spec

Changes in v5:
- Filter the target-netnsid selftest dump by ifa-index, a new netns
  also contains the fallback tunnel devices

Changes in v4:
- Reset the resume offset when the device the dump stopped at is gone
- Use a tracked netns reference (put_net_track)
- Say ifa-family must be set in the spec doc, drop the AF_UNSPEC remark
- Close the netlink socket and guard the checks in the selftest
- Drop the Fixes tag

Changes in v3:
- Report the static bit as a new IFA_F_GLOBAL flag in IFA_FLAGS
  instead of IFA_F_PERMANENT
- Support IFA_TARGET_NETNSID and test it
- Describe global_use accurately, it is also set by dev_mc_add_excl()
- Fix the target-netnsid type in the rt-addr spec, as its own patch

Changes in v2:
- Always validate the request header, not only with strict checking
- Use a single "with" statement in the selftest (ruff)

Yuyang Huang (6):
  netlink: specs: rt-addr: fix the type of target-netnsid
  net: change netdev_hw_addr_list count through helpers
  net: add a generation counter for dev->mc changes
  net: add AF_PACKET multicast dumps
  netlink: specs: rt-addr: document AF_PACKET multicast dumps
  selftests: net: test AF_PACKET multicast dumps

 Documentation/netlink/specs/rt-addr.yaml      |  21 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |   4 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |   8 +-
 include/linux/netdevice.h                     |  11 +-
 include/net/net_namespace.h                   |   1 +
 include/uapi/linux/if_addr.h                  |   1 +
 net/core/dev_addr_lists.c                     | 251 +++++++++++++++++-
 net/core/dev_addr_lists_test.c                |  18 +-
 net/core/rtnetlink.c                          |   2 +
 net/mac80211/driver-ops.h                     |   2 +-
 tools/testing/selftests/net/rtnetlink.py      |  73 ++++-
 11 files changed, 357 insertions(+), 35 deletions(-)

-- 
2.43.0

