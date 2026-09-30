Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14C84B8291
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767735; cv=none; b=L7T2ATrXzp70uzTl81JAOKVZrsT/NplRz1JxCjdlDuGtasCF9XdqQnaSBd2mfo6vobRe91Cs1rI9jPGNf9PQm6JiGhTcy9nLKP5eXFjj6xAmeORuaU9SDmJu/RZZdpCQ3C0e32xJKKFlQ+7DZJ345w9MINVKx+HOCyY2UEI4jxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767735; c=relaxed/simple;
	bh=J4YIhr6q+3AS5ntNtvceLfzAJMVxCCPGKCSXFzs2IPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mHdxsxPkTavQb/ch2GurS/+UzES4k7EqrpKm5HvCaD5b6m3JYRLH/oUtwDRsAVOiRFOQ7w66LqJsAYCSJQMfzq+2s0ZrebeKecfvuEbFvL1DEKIfP4FhyF7K9WoVVXa0eMgHWm+NeIKgVMzOp5vvRP83zmUskc3xKqO7QQJz1j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NlM4LrhW; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlM4LrhW"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc78dd54610so1880401a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 04:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790767732; x=1791372532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W95egx8pFKKWIh3QqRcpXbUl3vpXtESg6OoCBWEgnaw=;
        b=NlM4LrhW6jK3D5HRy2Ay/X/VS+toq/bBz/SSm2VHRykxL0p/fIa5EwJGERONRdeUG9
         VWS0ZyfiSPK5U6pzDcksirmxriSqiEepw4T5ZdZPA82gTxSsaEi1EiovPxULiNN/Z3yr
         gzTdymaz1xuosXuR13fotYBF915XtWA0Az996v3CDGsp/M1p4u2P0yKkvrpDsfZAVDGC
         s3EuPwM+wdf9uKdRu7eFPfHGV3W92cFulLx448G1Fr8GgIIOSlPI69/3aBX01EvtWj0b
         AJORmqRofTQ8N/gGrLgu93GvFyhWlRsryeClUs3KSVYFu+NcTnuVl/T1H0J78ngaFnxi
         tlqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767732; x=1791372532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W95egx8pFKKWIh3QqRcpXbUl3vpXtESg6OoCBWEgnaw=;
        b=ABg+Vjz0qdKw95wfNP/f+C5Sy/dV8HIcBdsCp1MOEcvqvUxaR5hOJSR/3bdqc5lXRI
         vUt3gOtxNA4xK4RT6W/bS+7CRxx/tT+5Znal7GregAitX70PeIa+WQzBCN7Qp/xwl4kk
         aQtYlAFeKg1iz13bkEHZ6op/RtPazdvgzSlPewZLWK/FoyjzoyVD5ewKnYvP9zBQHzmk
         kSYFTjlyn16YmemNKzn4f+J8iADVLq2V6wx0NddWqbwCvFusrKBAy0ac1mC0gnpmKu2/
         4iXfJIL8ZHxmVsi+oTXqSQRjWaq8ck/KrjAf4TDpMgtVhIiC2bl+evUtRXi1tq3OxjnI
         tDwA==
X-Forwarded-Encrypted: i=1; AKwUvBxW3bEiXAl54q1aPd8YthiwCCOGjlBuRP1lXRQWIFSfclxdTtZYqm9S3NWY1DQyTqNbzeXQzZzsuICxPkwPfA==@vger.kernel.org
X-Gm-Message-State: AFuF++nzxJhG3LxIcKWbM0SupULbnV/PKGQZh0eb0J/RukFkuKyUIYCC
	3sEo7DR1Wk324cetJ28T+lKrj1SQK9h2FtUEDGchIQ2MujGjrISuRs2T
X-Gm-Gg: AYBFou0vpr8qiWoVA6mlWzVsxyR7J4GmCt0yA0BJeGySgEIbZOj7wjXs7CVpsxMs5LJ
	ITp4dTrsa/4ibwrldoZmAldjuz1lS8uv/IRbXcY4Y3LZFabz7FVeh4B6rL/9jYnw3rix2zOJuCW
	/vThx/+BEqdSz7G3iz4g3YHFi/ttBTKWVP/FUhGL+hKzfzW/XBtua52PAagZBr2u+eiVLqSO/e0
	5AxXOlp8Am6+lpURELbkcqk75gbkvURJU8bIiBeBUcp1N0wGPQYE3GygnlbQQW+TDUjppnPklG/
	eIdLxoZELvFcOi6JzW9vs/KXvJKk463f/Hvhzk8Yjb4ADsxIkVi54Vbs0fL4ZgdhRKN1Y9AgGnU
	t2EG+hMhRAa156tSX7fraG9bGj4uEriFyqUT285Ahh/5CECUEcvYtU454qXZ6ZkwPMzGncJ2GgF
	4Ke6Bus3gFlk30toQEOSyPv9WRuOG2w2EUEfaKkYQIP/Fjfff5MIscgcuKqDuRPsixjNfyZD/Q8
	r95vLWrarRXbJdJAxmRgNwD1qKmy6u9GaEqYht/Qbrj
X-Received: by 2002:a05:6a20:c896:b0:3de:7c83:26cf with SMTP id adf61e73a8af0-3de9e8444e1mr1074603637.19.1790767731855;
        Wed, 30 Sep 2026 04:28:51 -0700 (PDT)
Received: from m-upc-A520M-HDV.lan ([2400:2410:3f60:500:3fb:270c:7df4:18f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm712637a12.31.2026.09.30.04.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:28:51 -0700 (PDT)
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
Subject: [PATCH net-next v9 0/6] rtnetlink: dump link-layer multicast addresses
Date: Wed, 30 Sep 2026 20:28:36 +0900
Message-ID: <20260930112842.21323-1-sigefriedhyy@gmail.com>
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

 Documentation/netlink/specs/rt-addr.yaml      |  20 +-
 .../net/ethernet/cavium/octeon/octeon_mgmt.c  |   4 +-
 .../net/wireless/microchip/wilc1000/netdev.c  |   8 +-
 include/linux/netdevice.h                     |  11 +-
 include/net/net_namespace.h                   |   1 +
 include/uapi/linux/if_addr.h                  |   1 +
 net/core/dev_addr_lists.c                     | 259 +++++++++++++++++-
 net/core/dev_addr_lists_test.c                |  18 +-
 net/core/rtnetlink.c                          |   2 +
 net/mac80211/driver-ops.h                     |   2 +-
 tools/testing/selftests/net/rtnetlink.py      |  73 ++++-
 11 files changed, 364 insertions(+), 35 deletions(-)

-- 
2.43.0

