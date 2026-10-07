Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5158C3CC303
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374324; cv=none; b=kFzYP2QCeq+Yy9Ll+DJIx0FnMi0fNH8unfzzf11zgWnCricujbg1EbPmLEBXyz7m2Vv7vHZRHl7XnPkiBl7jTIbcVFSZ8VD8MwCUNRq5qnbSLdSLixBGgr41VmIW94Kwwd++zdotTcR3Ayuus7xUsU/ojcT+7MBW9aP3sGGJKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374324; c=relaxed/simple;
	bh=1QxYc7EDHNuG4nVpYQSE/XwKYhWItsefX+0U1GWt1t0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raqy6VvivpcLPgCXWSKObVI7ewhHdxhSKUFwYY/4jWKzD9t6BJjTv8OnCuvgcXgoM5c6HcpI6ktZinC+8tEl3tKdKpIdTiKUWG6V/i5VMvYovGKl5qTVazwEDQXNpnu9Z7xXo5LEpL9h+V4tJZougiA/arND8QgR3HqNXbMiofY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTRASdET; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTRASdET"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a80e169311so1335746a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374312; x=1791979112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mfZX49TMx4xg+lBfGFXkga09/sEL5fzSy7qIyNAFXaM=;
        b=jTRASdETGYrYAyXHMFtukoGW8V7FFznYjaGX5NTopcvA5xbiNmoar+Ii91gBSi2XkM
         7cDqcZNTHCEXrQSMOCF/paxyngsPwLUT9EsNSu6LQr0wrbTRnOcxeqV3Nn0E8A5Pj8E6
         dLt5fZWbwoBcGlZhaQzxaxzGTb5SRbiojkP64ROVpTm0pneFYtTDEnEOddpItSx9W4G6
         6ryw3AxPlUnVjhQM0Dn8iblrN0RKx6UNKEoTrlvCmEVYWT9+Ym+lDwODN3Mbc7GDGXtB
         1dsur9cluA8yGW2Q+Tsx/IHU9GYu5g1CZLtGykB+r3+eaCsHkdDojaxybCzZtXbJXPef
         HLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374312; x=1791979112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mfZX49TMx4xg+lBfGFXkga09/sEL5fzSy7qIyNAFXaM=;
        b=CvysyZSjmrPlLRg2es6EXFYekMZGHSm/OYv6pOiXzQMmyw0PqbgQdDiKSUKStSOt77
         ocS1DJ4cApWYVocP0dqTBvUQ31MCOwN3ZY+DeaB448A/sFOjdqDxsDireG/DqVU5zhmA
         iA7RIdt2vJC1BYt4B5DwFPlJ4/C50D0SXVZf9nXIGuRQ/YwMQ+tfLZvIW1O7khhT3fhq
         9/df58UqF2hsLvp7BqTPJ9nb0x8uMLfJK5ukaKvhcArpHO+l0d4+Nffe2LxwHlnwY9K5
         FvwAmAs13N0V6GKayTEI9hqEmpf9smmG7KfgRa/RCR14mo1bOm2J0+3UVbQ/KjFfjvC7
         ZvNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwpCHHWkxzfstp60cx50s6lOYJAtvustpm0uCSmr6zjbWbE9bfkXzvY4Y3RcosnifPk7czVv1ERzeiiFII0eg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLbgIEvCK4aV3dcey3fjPceE1FfcUt/TteVbMoRn/ipeKocvHHf
	y2LN2TGLDgLGV7IqcsHWiL8jzfAl3tEasP/OgwALn/VUDJYSc85pINIn
X-Gm-Gg: AYBFou3ojv5UeQnaKyY6wx0KJmnI8Z9+pTrSTX/AQITJs/O7jVdYk8YsHdIYQ9ykwUy
	WaKu7PYJYIw/2ajdOrgSGzKrTPFpojB6KJ1YXR4v+p/nannGO582/XbV8K+NL62oysLaP1JCB7b
	9jhokyarOo7igxUXEtqOc2vpFI9QhzS156H7+nUKQWyJjtH4nRB2hvaWNLx7kG1YK05u5f4+VIg
	TddDoE5TtCnvue/lLkKD0dCXh8HnqPH4l4kYSmY6h2wJcVsq0zkOjNRNvS0F0bEELf2qaYsoxmA
	RSrta05zb6HLcGDMV3u4PUGy+iZ3ZSKau043essBSok2mPlf8OLXc6DeT1hwB/fL4LbM1D0MhTR
	cn0rd8Ag+8lHHRNiwijCeS5/6HDNckFqarZqt/2pFAXgy91wDNv9uZhgZ+rFmYzpAgPmGuNH/px
	YPMgOAJ/F6GVTDqpGqWyxX1aR/R55bSU02cK6clMV9G57BA/+RiJm1k3jq44ru1J6B4+Dt4mUbL
	EWEVWFrPxLL4hDfRyt3QJwADRKMN+t2ZvUTllj3ic95BmmC2eOAcf1QjYPZCkTTYB4Dwv37n0pj
	toHoKlS9yYc=
X-Received: by 2002:a17:90b:3143:b0:3a8:6e99:8044 with SMTP id 98e67ed59e1d1-3a89e8e2f3fmr1586403a91.0.1791374312103;
        Wed, 07 Oct 2026 04:58:32 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan (oki-109-236-14-10.jptransit.net. [109.236.14.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8987b09e2sm4456582a91.2.2026.10.07.04.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 04:58:31 -0700 (PDT)
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
Subject: [PATCH net-next v10 0/6] rtnetlink: dump link-layer multicast addresses
Date: Wed,  7 Oct 2026 20:58:15 +0900
Message-ID: <20261007115821.11332-1-sigefriedhyy@gmail.com>
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
 net/core/dev_addr_lists.c                     | 245 +++++++++++++++++-
 net/core/dev_addr_lists_test.c                |  18 +-
 net/core/rtnetlink.c                          |   2 +
 net/mac80211/driver-ops.h                     |   2 +-
 tools/testing/selftests/net/rtnetlink.py      |  73 +++++-
 11 files changed, 351 insertions(+), 35 deletions(-)

-- 
2.43.0

