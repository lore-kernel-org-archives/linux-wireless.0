Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55769 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbcDZIGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:39 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com
Subject: [PATCH net-next 0/8] netlink: align attributes when needed (patchset #3)
Date: Tue, 26 Apr 2016 10:06:10 +0200
Message-Id: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_100906_632980_A1DE873E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is the continuation (series #3) of the work done to align netlink
attributes when these attributes contain some 64-bit fields.

It's the last patchset from what I've seen.

The last user of nla_put_u64() is block/drbd. This module does not use
standard netlink API (see all the stuff in include/linux/genl_magic_struct.h
and include/linux/genl_magic_func.h). I didn't modify it because it's seems
hard to do it whithout testing and fully understanding the context (for
example, why include/linux/drbd_genl.h is not part of uapi?).
Any thoughts?

 Documentation/networking/gen_stats.txt  |   6 +-
 drivers/net/macsec.c                    | 121 +++++++++++++++++++++++---------
 drivers/net/wireless/mac80211_hwsim.c   |   2 +-
 drivers/net/wireless/mac80211_hwsim.h   |   1 +
 fs/quota/netlink.c                      |  12 ++--
 include/net/gen_stats.h                 |   6 +-
 include/uapi/linux/gen_stats.h          |   1 +
 include/uapi/linux/if_link.h            |   1 +
 include/uapi/linux/if_macsec.h          |   6 ++
 include/uapi/linux/inet_diag.h          |   4 +-
 include/uapi/linux/openvswitch.h        |   2 +
 include/uapi/linux/pkt_cls.h            |   2 +
 include/uapi/linux/quota.h              |   1 +
 include/uapi/linux/rtnetlink.h          |   1 +
 include/uapi/linux/tc_act/tc_bpf.h      |   1 +
 include/uapi/linux/tc_act/tc_connmark.h |   1 +
 include/uapi/linux/tc_act/tc_csum.h     |   1 +
 include/uapi/linux/tc_act/tc_defact.h   |   1 +
 include/uapi/linux/tc_act/tc_gact.h     |   1 +
 include/uapi/linux/tc_act/tc_ife.h      |   1 +
 include/uapi/linux/tc_act/tc_ipt.h      |   1 +
 include/uapi/linux/tc_act/tc_mirred.h   |   1 +
 include/uapi/linux/tc_act/tc_nat.h      |   1 +
 include/uapi/linux/tc_act/tc_pedit.h    |   1 +
 include/uapi/linux/tc_act/tc_skbedit.h  |   1 +
 include/uapi/linux/tc_act/tc_vlan.h     |   1 +
 net/core/gen_stats.c                    |  35 +++++----
 net/core/neighbour.c                    |   3 +-
 net/core/rtnetlink.c                    |   4 +-
 net/core/sock_diag.c                    |   2 +-
 net/ipv4/inet_diag.c                    |   9 ++-
 net/openvswitch/datapath.c              |  27 +++----
 net/sched/act_api.c                     |   7 +-
 net/sched/act_bpf.c                     |   3 +-
 net/sched/act_connmark.c                |   3 +-
 net/sched/act_csum.c                    |   2 +-
 net/sched/act_gact.c                    |   2 +-
 net/sched/act_ife.c                     |   2 +-
 net/sched/act_ipt.c                     |   2 +-
 net/sched/act_mirred.c                  |   2 +-
 net/sched/act_nat.c                     |   2 +-
 net/sched/act_pedit.c                   |   2 +-
 net/sched/act_simple.c                  |   2 +-
 net/sched/act_skbedit.c                 |   2 +-
 net/sched/act_vlan.c                    |   2 +-
 net/sched/cls_u32.c                     |   7 +-
 net/sched/sch_api.c                     |   6 +-
 net/sctp/sctp_diag.c                    |   5 +-
 48 files changed, 211 insertions(+), 98 deletions(-)

Comments are welcomed,
Regards,
Nicolas

