Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34833 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcGFA27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 20:28:59 -0400
From: Masashi Honma <masashi.honma@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com
Cc: davem@davemloft.net, johannes@sipsolutions.net,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	dledford@redhat.com, sean.hefty@intel.com,
	hal.rosenstock@gmail.com, paul@paul-moore.com, eparis@redhat.com,
	zbr@ioremap.net, pshelar@nicira.com, ccaulfie@redhat.com,
	teigland@redhat.com, bsingharora@gmail.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [RFC 0/7] netlink: Add allocation flag to netlink_unicast()
Date: Wed,  6 Jul 2016 09:28:29 +0900
Message-Id: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com> (sfid-20160706_022909_472417_6093121F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Though netlink_broadcast() has allocation flag which can specify
memory allocation type (ex. GFP_KERNEL/GFP_ATOMIC), netlink_unicast()
does not have it. This can cause "BUG: sleeping function called from
invalid context at" with CONFIG_DEBUG_ATOMIC_SLEEP enabled kernel when
calling netlink_unicast() inside RCU read-side section and not in IRQ.

Though currently such a use case was not found, to solve potential
issue we will add an allocation flag to netlink_unicast(). Previously
netlink_unicast() have used gfp_any() as a flag. We replaced it to
GFP_KERNEL or GFP_ATOMIC or etc by guessing based on context. If we
could not determine the value, we remain it gfp_any(). We welcome
comments like "this gfp_any() should be GFP_KERNEL". Of course other
comments are welcome as well.

This series of patches are not tested.
This is a RFC because this does not fix existing issue.

Masashi Honma (7):
  netlink: Add allocation flag to netlink_unicast()
  netfilter: Add allocation flag to nfnetlink_unicast()
  netlink: Add allocation flag to nlmsg_unicast()
  infiniband: Add allocation flag to ibnl_unicast()
  net: Add allocation flag to rtnl_unicast()
  genetlink: Add allocation flag to genlmsg_unicast()
  genetlink: Add allocation flag to genlmsg_reply()

 crypto/crypto_user.c                  |  3 ++-
 drivers/block/drbd/drbd_nl.c          |  2 +-
 drivers/connector/connector.c         |  2 +-
 drivers/infiniband/core/iwpm_msg.c    |  6 ++---
 drivers/infiniband/core/iwpm_util.c   |  5 ++--
 drivers/infiniband/core/iwpm_util.h   |  1 +
 drivers/infiniband/core/netlink.c     |  4 ++--
 drivers/net/gtp.c                     |  3 ++-
 drivers/net/team/team.c               |  5 ++--
 drivers/net/wireless/mac80211_hwsim.c |  4 ++--
 fs/dlm/netlink.c                      |  2 +-
 include/linux/netfilter/nfnetlink.h   |  2 +-
 include/linux/netlink.h               |  3 ++-
 include/linux/rtnetlink.h             |  3 ++-
 include/net/genetlink.h               | 13 +++++++----
 include/net/netlink.h                 |  6 +++--
 include/rdma/rdma_netlink.h           |  3 ++-
 kernel/audit.c                        |  9 ++++----
 kernel/taskstats.c                    |  4 ++--
 net/core/devlink.c                    | 12 +++++-----
 net/core/net_namespace.c              |  2 +-
 net/core/rtnetlink.c                  | 12 ++++++----
 net/dcb/dcbnl.c                       |  2 +-
 net/decnet/dn_route.c                 |  3 ++-
 net/hsr/hsr_netlink.c                 |  6 +++--
 net/ieee802154/ieee802154.h           |  3 ++-
 net/ieee802154/netlink.c              |  5 ++--
 net/ieee802154/nl-mac.c               |  4 ++--
 net/ieee802154/nl-phy.c               |  6 ++---
 net/ieee802154/nl802154.c             |  4 ++--
 net/ipv4/devinet.c                    |  2 +-
 net/ipv4/fib_frontend.c               |  2 +-
 net/ipv4/fou.c                        |  2 +-
 net/ipv4/inet_diag.c                  |  2 +-
 net/ipv4/ipmr.c                       |  6 +++--
 net/ipv4/route.c                      |  2 +-
 net/ipv4/tcp_metrics.c                |  2 +-
 net/ipv4/udp_diag.c                   |  2 +-
 net/ipv6/addrconf.c                   |  4 ++--
 net/ipv6/addrlabel.c                  |  2 +-
 net/ipv6/ila/ila_xlat.c               |  2 +-
 net/ipv6/ip6mr.c                      |  6 +++--
 net/ipv6/route.c                      |  2 +-
 net/irda/irnetlink.c                  |  2 +-
 net/l2tp/l2tp_netlink.c               |  8 ++++---
 net/netfilter/ipset/ip_set_core.c     | 11 +++++----
 net/netfilter/ipvs/ip_vs_ctl.c        |  2 +-
 net/netfilter/nf_conntrack_netlink.c  |  9 +++++---
 net/netfilter/nf_tables_api.c         | 10 ++++----
 net/netfilter/nfnetlink.c             |  4 ++--
 net/netfilter/nfnetlink_acct.c        |  2 +-
 net/netfilter/nfnetlink_cthelper.c    |  2 +-
 net/netfilter/nfnetlink_cttimeout.c   |  5 ++--
 net/netfilter/nfnetlink_log.c         |  4 ++--
 net/netfilter/nfnetlink_queue.c       |  3 ++-
 net/netfilter/nft_compat.c            |  4 ++--
 net/netlabel/netlabel_cipso_v4.c      |  2 +-
 net/netlabel/netlabel_mgmt.c          |  4 ++--
 net/netlabel/netlabel_unlabeled.c     |  2 +-
 net/netlink/af_netlink.c              | 14 +++++++-----
 net/netlink/genetlink.c               |  2 +-
 net/nfc/netlink.c                     |  6 ++---
 net/openvswitch/datapath.c            |  9 ++++----
 net/sched/act_api.c                   |  2 +-
 net/sctp/sctp_diag.c                  |  2 +-
 net/tipc/bearer.c                     |  4 ++--
 net/tipc/netlink_compat.c             |  2 +-
 net/tipc/node.c                       |  2 +-
 net/unix/diag.c                       |  2 +-
 net/wireless/nl80211.c                | 43 ++++++++++++++++++-----------------
 net/xfrm/xfrm_user.c                  | 15 +++++++-----
 samples/connector/cn_test.c           |  2 +-
 72 files changed, 199 insertions(+), 155 deletions(-)

-- 
2.7.4

