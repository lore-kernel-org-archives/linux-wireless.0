Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EECC10F0E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E519206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfDDGyb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55732 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfDDGya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGN-0003Pn-BK; Thu, 04 Apr 2019 08:54:15 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] netlink: make validation more configurable for future strictness
Date:   Thu,  4 Apr 2019 08:54:04 +0200
Message-Id: <20190404065408.5864-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We currently have two levels of strict validation:

 1) liberal (default)
     - undefined (type >= max) & NLA_UNSPEC attributes accepted
     - attribute length >= expected accepted
     - garbage at end of message accepted
 2) strict (opt-in)
     - NLA_UNSPEC attributes accepted
     - attribute length >= expected accepted

Split out parsing strictness into five different options:
 * TRAILING     - check that there's no trailing data after parsing
                  attributes (in message or nested)
 * MAXTYPE      - reject attrs > max known type
 * UNSPEC       - reject attributes with NLA_UNSPEC policy entries
 * POLICY       - reject everything if no policy is given
 * STRICT_ATTRS - strictly validate attribute size

The default for future things should be *everything*.
The current *_strict() is a combination of TRAILING and MAXTYPE,
and is renamed to _deprecated_strict().
The current regular parsing has none of this, and is renamed to
*_parse_deprecated().

Additionally it allows us to selectively set one of the new flags
even on old policies. Notably, the UNSPEC flag could be useful in
this case, since it can be arranged (by filling in the policy) to
not be an incompatible userspace ABI change, but would then going
forward prevent forgetting attribute entries. Similar can apply
to the POLICY flag.

We end up with the following renames:
 * nla_parse           -> nla_parse_deprecated
 * nlmsg_parse         -> nlmsg_parse_deprecated
 * nlmsg_parse_strict  -> nlmsg_parse_deprecated_strict
 * nla_parse_nested    -> nla_parse_nested_deprecated
 * nla_validate_nested -> nla_validate_nested_deprecated

Using spatch, of course:
    @@
    expression TB, MAX, HEAD, LEN, POL, EXT;
    @@
    -nla_parse(TB, MAX, HEAD, LEN, POL, EXT)
    +nla_parse_deprecated(TB, MAX, HEAD, LEN, POL, EXT)

    @@
    expression NLH, HDRLEN, TB, MAX, POL, EXT;
    @@
    -nlmsg_parse(NLH, HDRLEN, TB, MAX, POL, EXT)
    +nlmsg_parse_deprecated(NLH, HDRLEN, TB, MAX, POL, EXT)

    @@
    expression NLH, HDRLEN, TB, MAX, POL, EXT;
    @@
    -nlmsg_parse_strict(NLH, HDRLEN, TB, MAX, POL, EXT)
    +nlmsg_parse_deprecated_strict(NLH, HDRLEN, TB, MAX, POL, EXT)

    @@
    expression TB, MAX, NLA, POL, EXT;
    @@
    -nla_parse_nested(TB, MAX, NLA, POL, EXT)
    +nla_parse_nested_deprecated(TB, MAX, NLA, POL, EXT)

    @@
    expression START, MAX, POL, EXT;
    @@
    -nla_validate_nested(START, MAX, POL, EXT)
    +nla_validate_nested_deprecated(START, MAX, POL, EXT)

    @@
    expression NLH, HDRLEN, MAX, POL, EXT;
    @@
    -nlmsg_validate(NLH, HDRLEN, MAX, POL, EXT)
    +nlmsg_validate_deprecated(NLH, HDRLEN, MAX, POL, EXT)

For this patch, don't actually add the strict, non-renamed versions
yet so that it breaks compile if I get it wrong.

Also, while at it, make nla_validate and nla_parse go down to a
common __nla_validate_parse() function to avoid code duplication.

Ultimately, this allows us to have very strict validation for every
new caller of nla_parse()/nlmsg_parse() etc as re-introduced in the
next patch, while existing things will continue to work as is.

In effect then, this adds fully strict validation for any new command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 crypto/crypto_user_base.c                     |   4 +-
 drivers/block/drbd/drbd_nla.c                 |   3 +-
 drivers/block/nbd.c                           |  12 +-
 drivers/infiniband/core/addr.c                |   4 +-
 drivers/infiniband/core/iwpm_util.c           |   8 +-
 drivers/infiniband/core/nldev.c               |  36 +--
 drivers/infiniband/core/sa_query.c            |   8 +-
 drivers/net/ieee802154/mac802154_hwsim.c      |  12 +-
 drivers/net/macsec.c                          |   8 +-
 drivers/net/team/team.c                       |   8 +-
 drivers/net/wireless/ath/ath10k/testmode.c    |   4 +-
 drivers/net/wireless/ath/ath6kl/testmode.c    |   4 +-
 drivers/net/wireless/ath/wcn36xx/testmode.c   |   4 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  24 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 +-
 drivers/net/wireless/mac80211_hwsim.c         |   8 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   |   4 +-
 drivers/net/wireless/ti/wlcore/testmode.c     |   4 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c   |   8 +-
 include/net/genetlink.h                       |  16 +-
 include/net/netlink.h                         | 216 ++++++++++++++----
 kernel/taskstats.c                            |   5 +-
 lib/nlattr.c                                  | 174 +++++++-------
 net/8021q/vlan_netlink.c                      |   4 +-
 net/bridge/br_mdb.c                           |   4 +-
 net/bridge/br_netlink.c                       |   6 +-
 net/bridge/br_netlink_tunnel.c                |   4 +-
 net/can/gw.c                                  |   4 +-
 net/core/devlink.c                            |   7 +-
 net/core/fib_rules.c                          |   6 +-
 net/core/lwt_bpf.c                            |   7 +-
 net/core/neighbour.c                          |  25 +-
 net/core/net_namespace.c                      |  19 +-
 net/core/rtnetlink.c                          | 107 +++++----
 net/dcb/dcbnl.c                               |  90 +++++---
 net/decnet/dn_dev.c                           |   8 +-
 net/decnet/dn_fib.c                           |   8 +-
 net/decnet/dn_route.c                         |   4 +-
 net/ieee802154/nl802154.c                     |  46 ++--
 net/ipv4/devinet.c                            |  27 ++-
 net/ipv4/fib_frontend.c                       |   8 +-
 net/ipv4/ip_tunnel_core.c                     |   8 +-
 net/ipv4/ipmr.c                               |  12 +-
 net/ipv4/route.c                              |   8 +-
 net/ipv6/addrconf.c                           |  36 +--
 net/ipv6/addrlabel.c                          |  12 +-
 net/ipv6/ila/ila_lwt.c                        |   3 +-
 net/ipv6/route.c                              |  12 +-
 net/ipv6/seg6_iptunnel.c                      |   4 +-
 net/ipv6/seg6_local.c                         |   9 +-
 net/mpls/af_mpls.c                            |  26 ++-
 net/mpls/mpls_iptunnel.c                      |   4 +-
 net/ncsi/ncsi-netlink.c                       |   4 +-
 net/netfilter/ipset/ip_set_core.c             |  36 ++-
 net/netfilter/ipvs/ip_vs_ctl.c                |  13 +-
 net/netfilter/nf_conntrack_netlink.c          |  45 ++--
 net/netfilter/nf_conntrack_proto_dccp.c       |   4 +-
 net/netfilter/nf_conntrack_proto_sctp.c       |   4 +-
 net/netfilter/nf_conntrack_proto_tcp.c        |   4 +-
 net/netfilter/nf_nat_core.c                   |   7 +-
 net/netfilter/nf_tables_api.c                 |  48 ++--
 net/netfilter/nfnetlink.c                     |  15 +-
 net/netfilter/nfnetlink_acct.c                |   4 +-
 net/netfilter/nfnetlink_cthelper.c            |  22 +-
 net/netfilter/nfnetlink_cttimeout.c           |   7 +-
 net/netfilter/nfnetlink_queue.c               |   5 +-
 net/netfilter/nft_compat.c                    |   4 +-
 net/netfilter/nft_ct.c                        |   8 +-
 net/netfilter/nft_tunnel.c                    |  21 +-
 net/netlabel/netlabel_cipso_v4.c              |  36 +--
 net/netlink/genetlink.c                       |   5 +-
 net/nfc/netlink.c                             |  12 +-
 net/openvswitch/datapath.c                    |   4 +-
 net/openvswitch/flow_netlink.c                |   9 +-
 net/openvswitch/meter.c                       |   6 +-
 net/openvswitch/vport-vxlan.c                 |   4 +-
 net/phonet/pn_netlink.c                       |   8 +-
 net/qrtr/qrtr.c                               |   3 +-
 net/sched/act_api.c                           |  26 ++-
 net/sched/act_bpf.c                           |   3 +-
 net/sched/act_connmark.c                      |   4 +-
 net/sched/act_csum.c                          |   3 +-
 net/sched/act_gact.c                          |   3 +-
 net/sched/act_ife.c                           |   8 +-
 net/sched/act_ipt.c                           |   3 +-
 net/sched/act_mirred.c                        |   3 +-
 net/sched/act_nat.c                           |   3 +-
 net/sched/act_pedit.c                         |   8 +-
 net/sched/act_police.c                        |   3 +-
 net/sched/act_sample.c                        |   3 +-
 net/sched/act_simple.c                        |   3 +-
 net/sched/act_skbedit.c                       |   3 +-
 net/sched/act_skbmod.c                        |   3 +-
 net/sched/act_tunnel_key.c                    |  13 +-
 net/sched/act_vlan.c                          |   3 +-
 net/sched/cls_api.c                           |  20 +-
 net/sched/cls_basic.c                         |   4 +-
 net/sched/cls_bpf.c                           |   4 +-
 net/sched/cls_cgroup.c                        |   5 +-
 net/sched/cls_flow.c                          |   3 +-
 net/sched/cls_flower.c                        |  25 +-
 net/sched/cls_fw.c                            |   3 +-
 net/sched/cls_matchall.c                      |   4 +-
 net/sched/cls_route.c                         |   3 +-
 net/sched/cls_rsvp.h                          |   3 +-
 net/sched/cls_tcindex.c                       |   3 +-
 net/sched/cls_u32.c                           |   3 +-
 net/sched/em_ipt.c                            |   4 +-
 net/sched/em_meta.c                           |   3 +-
 net/sched/ematch.c                            |   3 +-
 net/sched/sch_api.c                           |  19 +-
 net/sched/sch_atm.c                           |   3 +-
 net/sched/sch_cake.c                          |   3 +-
 net/sched/sch_cbq.c                           |   6 +-
 net/sched/sch_cbs.c                           |   3 +-
 net/sched/sch_choke.c                         |   3 +-
 net/sched/sch_codel.c                         |   3 +-
 net/sched/sch_drr.c                           |   3 +-
 net/sched/sch_dsmark.c                        |   6 +-
 net/sched/sch_etf.c                           |   3 +-
 net/sched/sch_fq.c                            |   3 +-
 net/sched/sch_fq_codel.c                      |   4 +-
 net/sched/sch_gred.c                          |  17 +-
 net/sched/sch_hfsc.c                          |   3 +-
 net/sched/sch_hhf.c                           |   3 +-
 net/sched/sch_htb.c                           |   6 +-
 net/sched/sch_mqprio.c                        |   5 +-
 net/sched/sch_netem.c                         |   5 +-
 net/sched/sch_pie.c                           |   3 +-
 net/sched/sch_qfq.c                           |   4 +-
 net/sched/sch_red.c                           |   3 +-
 net/sched/sch_sfb.c                           |   3 +-
 net/sched/sch_taprio.c                        |  19 +-
 net/sched/sch_tbf.c                           |   3 +-
 net/tipc/bearer.c                             |  42 ++--
 net/tipc/link.c                               |   4 +-
 net/tipc/net.c                                |   6 +-
 net/tipc/netlink.c                            |   4 +-
 net/tipc/netlink_compat.c                     |  63 ++---
 net/tipc/node.c                               |  38 +--
 net/tipc/socket.c                             |   6 +-
 net/tipc/udp_media.c                          |  13 +-
 net/wireless/nl80211.c                        | 191 +++++++++-------
 net/wireless/pmsr.c                           |  18 +-
 net/xfrm/xfrm_user.c                          |  10 +-
 145 files changed, 1214 insertions(+), 933 deletions(-)

diff --git a/crypto/crypto_user_base.c b/crypto/crypto_user_base.c
index f25d3f32c9c2..e48da3b75c71 100644
--- a/crypto/crypto_user_base.c
+++ b/crypto/crypto_user_base.c
@@ -465,8 +465,8 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 	}
 
-	err = nlmsg_parse(nlh, crypto_msg_min[type], attrs, CRYPTOCFGA_MAX,
-			  crypto_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, crypto_msg_min[type], attrs,
+				     CRYPTOCFGA_MAX, crypto_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/block/drbd/drbd_nla.c b/drivers/block/drbd/drbd_nla.c
index 8e261cb5198b..6a09b0b98018 100644
--- a/drivers/block/drbd/drbd_nla.c
+++ b/drivers/block/drbd/drbd_nla.c
@@ -35,7 +35,8 @@ int drbd_nla_parse_nested(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 
 	err = drbd_nla_check_mandatory(maxtype, nla);
 	if (!err)
-		err = nla_parse_nested(tb, maxtype, nla, policy, NULL);
+		err = nla_parse_nested_deprecated(tb, maxtype, nla, policy,
+						  NULL);
 
 	return err;
 }
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 92b8aafb8bb4..91cff60f2839 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1797,8 +1797,10 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 				ret = -EINVAL;
 				goto out;
 			}
-			ret = nla_parse_nested(socks, NBD_SOCK_MAX, attr,
-					       nbd_sock_policy, info->extack);
+			ret = nla_parse_nested_deprecated(socks, NBD_SOCK_MAX,
+							  attr,
+							  nbd_sock_policy,
+							  info->extack);
 			if (ret != 0) {
 				printk(KERN_ERR "nbd: error processing sock list\n");
 				ret = -EINVAL;
@@ -1968,8 +1970,10 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
 				ret = -EINVAL;
 				goto out;
 			}
-			ret = nla_parse_nested(socks, NBD_SOCK_MAX, attr,
-					       nbd_sock_policy, info->extack);
+			ret = nla_parse_nested_deprecated(socks, NBD_SOCK_MAX,
+							  attr,
+							  nbd_sock_policy,
+							  info->extack);
 			if (ret != 0) {
 				printk(KERN_ERR "nbd: error processing sock list\n");
 				ret = -EINVAL;
diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 2649e0f2ff65..967a2f8be8a3 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -86,8 +86,8 @@ static inline bool ib_nl_is_good_ip_resp(const struct nlmsghdr *nlh)
 	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
 		return false;
 
-	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
-			nlmsg_len(nlh), ib_nl_addr_policy, NULL);
+	ret = nla_parse_deprecated(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+				   nlmsg_len(nlh), ib_nl_addr_policy, NULL);
 	if (ret)
 		return false;
 
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index a5d2a20ee697..41929bb83739 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -506,14 +506,14 @@ int iwpm_parse_nlmsg(struct netlink_callback *cb, int policy_max,
 	int ret;
 	const char *err_str = "";
 
-	ret = nlmsg_validate(cb->nlh, nlh_len, policy_max - 1, nlmsg_policy,
-			     NULL);
+	ret = nlmsg_validate_deprecated(cb->nlh, nlh_len, policy_max - 1,
+					nlmsg_policy, NULL);
 	if (ret) {
 		err_str = "Invalid attribute";
 		goto parse_nlmsg_error;
 	}
-	ret = nlmsg_parse(cb->nlh, nlh_len, nltb, policy_max - 1,
-			  nlmsg_policy, NULL);
+	ret = nlmsg_parse_deprecated(cb->nlh, nlh_len, nltb, policy_max - 1,
+				     nlmsg_policy, NULL);
 	if (ret) {
 		err_str = "Unable to parse the nlmsg";
 		goto parse_nlmsg_error;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 11ed58d3fce5..bbb95cc5a095 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -607,8 +607,8 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 index;
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
@@ -652,8 +652,8 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 index;
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
@@ -721,8 +721,8 @@ static int nldev_port_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 port;
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (err ||
 	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
 	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
@@ -777,8 +777,8 @@ static int nldev_port_get_dumpit(struct sk_buff *skb,
 	int err;
 	unsigned int p;
 
-	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, NULL);
+	err = nlmsg_parse_deprecated(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, NULL);
 	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
@@ -832,8 +832,8 @@ static int nldev_res_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 index;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	ret = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
@@ -981,8 +981,8 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct sk_buff *msg;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	ret = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !fe->id || !tb[fe->id])
 		return -EINVAL;
 
@@ -1070,8 +1070,8 @@ static int res_get_common_dumpit(struct sk_buff *skb,
 	u32 index, port = 0;
 	bool filled = false;
 
-	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, NULL);
+	err = nlmsg_parse_deprecated(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, NULL);
 	/*
 	 * Right now, we are expecting the device index to get res information,
 	 * but it is possible to extend this code to return all devices in
@@ -1249,8 +1249,8 @@ static int nldev_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	char type[IFNAMSIZ];
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (err || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
 	    !tb[RDMA_NLDEV_ATTR_LINK_TYPE] || !tb[RDMA_NLDEV_ATTR_NDEV_NAME])
 		return -EINVAL;
@@ -1293,8 +1293,8 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 index;
 	int err;
 
-	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+				     nldev_policy, extack);
 	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
 		return -EINVAL;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 7925e45ea88a..bb534959abf0 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1028,8 +1028,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	    !(NETLINK_CB(skb).sk))
 		return -EPERM;
 
-	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
-			nlmsg_len(nlh), ib_nl_policy, NULL);
+	ret = nla_parse_deprecated(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+				   nlmsg_len(nlh), ib_nl_policy, NULL);
 	attr = (const struct nlattr *)tb[LS_NLA_TYPE_TIMEOUT];
 	if (ret || !attr)
 		goto settimeout_out;
@@ -1080,8 +1080,8 @@ static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
 	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
 		return 0;
 
-	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
-			nlmsg_len(nlh), ib_nl_policy, NULL);
+	ret = nla_parse_deprecated(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+				   nlmsg_len(nlh), ib_nl_policy, NULL);
 	if (ret)
 		return 0;
 
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 707285953750..fa323e9ab616 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -428,9 +428,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-	if (nla_parse_nested(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX,
-			     info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE],
-			     hwsim_edge_policy, NULL))
+	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
 	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID])
@@ -492,9 +490,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-	if (nla_parse_nested(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX,
-			     info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE],
-			     hwsim_edge_policy, NULL))
+	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
 	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID])
@@ -542,9 +538,7 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-	if (nla_parse_nested(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX,
-			     info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE],
-			     hwsim_edge_policy, NULL))
+	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
 	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] &&
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 263bfafdb004..c569ecf1a118 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1611,9 +1611,7 @@ static int parse_sa_config(struct nlattr **attrs, struct nlattr **tb_sa)
 	if (!attrs[MACSEC_ATTR_SA_CONFIG])
 		return -EINVAL;
 
-	if (nla_parse_nested(tb_sa, MACSEC_SA_ATTR_MAX,
-			     attrs[MACSEC_ATTR_SA_CONFIG],
-			     macsec_genl_sa_policy, NULL))
+	if (nla_parse_nested_deprecated(tb_sa, MACSEC_SA_ATTR_MAX, attrs[MACSEC_ATTR_SA_CONFIG], macsec_genl_sa_policy, NULL))
 		return -EINVAL;
 
 	return 0;
@@ -1624,9 +1622,7 @@ static int parse_rxsc_config(struct nlattr **attrs, struct nlattr **tb_rxsc)
 	if (!attrs[MACSEC_ATTR_RXSC_CONFIG])
 		return -EINVAL;
 
-	if (nla_parse_nested(tb_rxsc, MACSEC_RXSC_ATTR_MAX,
-			     attrs[MACSEC_ATTR_RXSC_CONFIG],
-			     macsec_genl_rxsc_policy, NULL))
+	if (nla_parse_nested_deprecated(tb_rxsc, MACSEC_RXSC_ATTR_MAX, attrs[MACSEC_ATTR_RXSC_CONFIG], macsec_genl_rxsc_policy, NULL))
 		return -EINVAL;
 
 	return 0;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index a622ec33453a..456771687a04 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2477,9 +2477,11 @@ static int team_nl_cmd_options_set(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 			goto team_put;
 		}
-		err = nla_parse_nested(opt_attrs, TEAM_ATTR_OPTION_MAX,
-				       nl_option, team_nl_option_policy,
-				       info->extack);
+		err = nla_parse_nested_deprecated(opt_attrs,
+						  TEAM_ATTR_OPTION_MAX,
+						  nl_option,
+						  team_nl_option_policy,
+						  info->extack);
 		if (err)
 			goto team_put;
 		if (!opt_attrs[TEAM_ATTR_OPTION_NAME] ||
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 6433ff10d80e..a29cfb9c72c2 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -416,8 +416,8 @@ int ath10k_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct nlattr *tb[ATH10K_TM_ATTR_MAX + 1];
 	int ret;
 
-	ret = nla_parse(tb, ATH10K_TM_ATTR_MAX, data, len, ath10k_tm_policy,
-			NULL);
+	ret = nla_parse_deprecated(tb, ATH10K_TM_ATTR_MAX, data, len,
+				   ath10k_tm_policy, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index d8dcacda9add..f3906dbe5495 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -74,8 +74,8 @@ int ath6kl_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 	int err, buf_len;
 	void *buf;
 
-	err = nla_parse(tb, ATH6KL_TM_ATTR_MAX, data, len, ath6kl_tm_policy,
-			NULL);
+	err = nla_parse_deprecated(tb, ATH6KL_TM_ATTR_MAX, data, len,
+				   ath6kl_tm_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.c b/drivers/net/wireless/ath/wcn36xx/testmode.c
index 51a038022c8b..7ae14b4d2d0e 100644
--- a/drivers/net/wireless/ath/wcn36xx/testmode.c
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.c
@@ -132,8 +132,8 @@ int wcn36xx_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	unsigned short attr;
 
 	wcn36xx_dbg_dump(WCN36XX_DBG_TESTMODE_DUMP, "Data:", data, len);
-	ret = nla_parse(tb, WCN36XX_TM_ATTR_MAX, data, len,
-			wcn36xx_tm_policy, NULL);
+	ret = nla_parse_deprecated(tb, WCN36XX_TM_ATTR_MAX, data, len,
+				   wcn36xx_tm_policy, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index a1e226652b4a..cd6a68334807 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -2620,8 +2620,8 @@ static int wil_rf_sector_get_cfg(struct wiphy *wiphy,
 	if (!test_bit(WMI_FW_CAPABILITY_RF_SECTORS, wil->fw_capabilities))
 		return -EOPNOTSUPP;
 
-	rc = nla_parse(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data, data_len,
-		       wil_rf_sector_policy, NULL);
+	rc = nla_parse_deprecated(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data,
+				  data_len, wil_rf_sector_policy, NULL);
 	if (rc) {
 		wil_err(wil, "Invalid rf sector ATTR\n");
 		return rc;
@@ -2740,8 +2740,8 @@ static int wil_rf_sector_set_cfg(struct wiphy *wiphy,
 	if (!test_bit(WMI_FW_CAPABILITY_RF_SECTORS, wil->fw_capabilities))
 		return -EOPNOTSUPP;
 
-	rc = nla_parse(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data, data_len,
-		       wil_rf_sector_policy, NULL);
+	rc = nla_parse_deprecated(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data,
+				  data_len, wil_rf_sector_policy, NULL);
 	if (rc) {
 		wil_err(wil, "Invalid rf sector ATTR\n");
 		return rc;
@@ -2773,9 +2773,11 @@ static int wil_rf_sector_set_cfg(struct wiphy *wiphy,
 	cmd.sector_type = sector_type;
 	nla_for_each_nested(nl_cfg, tb[QCA_ATTR_DMG_RF_SECTOR_CFG],
 			    tmp) {
-		rc = nla_parse_nested(tb2, QCA_ATTR_DMG_RF_SECTOR_CFG_MAX,
-				      nl_cfg, wil_rf_sector_cfg_policy,
-				      NULL);
+		rc = nla_parse_nested_deprecated(tb2,
+						 QCA_ATTR_DMG_RF_SECTOR_CFG_MAX,
+						 nl_cfg,
+						 wil_rf_sector_cfg_policy,
+						 NULL);
 		if (rc) {
 			wil_err(wil, "invalid sector cfg\n");
 			return -EINVAL;
@@ -2847,8 +2849,8 @@ static int wil_rf_sector_get_selected(struct wiphy *wiphy,
 	if (!test_bit(WMI_FW_CAPABILITY_RF_SECTORS, wil->fw_capabilities))
 		return -EOPNOTSUPP;
 
-	rc = nla_parse(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data, data_len,
-		       wil_rf_sector_policy, NULL);
+	rc = nla_parse_deprecated(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data,
+				  data_len, wil_rf_sector_policy, NULL);
 	if (rc) {
 		wil_err(wil, "Invalid rf sector ATTR\n");
 		return rc;
@@ -2955,8 +2957,8 @@ static int wil_rf_sector_set_selected(struct wiphy *wiphy,
 	if (!test_bit(WMI_FW_CAPABILITY_RF_SECTORS, wil->fw_capabilities))
 		return -EOPNOTSUPP;
 
-	rc = nla_parse(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data, data_len,
-		       wil_rf_sector_policy, NULL);
+	rc = nla_parse_deprecated(tb, QCA_ATTR_DMG_RF_SECTOR_MAX, data,
+				  data_len, wil_rf_sector_policy, NULL);
 	if (rc) {
 		wil_err(wil, "Invalid rf sector ATTR\n");
 		return rc;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a92c09d4692..fc45306c1efe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4391,8 +4391,8 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 	int err;
 	u32 noa_duration;
 
-	err = nla_parse(tb, IWL_MVM_TM_ATTR_MAX, data, len, iwl_mvm_tm_policy,
-			NULL);
+	err = nla_parse_deprecated(tb, IWL_MVM_TM_ATTR_MAX, data, len,
+				   iwl_mvm_tm_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4cc7b222859c..4138858ed604 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -409,8 +409,8 @@ static int mac80211_hwsim_vendor_cmd_test(struct wiphy *wiphy,
 	int err;
 	u32 val;
 
-	err = nla_parse(tb, QCA_WLAN_VENDOR_ATTR_MAX, data, data_len,
-			hwsim_vendor_test_policy, NULL);
+	err = nla_parse_deprecated(tb, QCA_WLAN_VENDOR_ATTR_MAX, data,
+				   data_len, hwsim_vendor_test_policy, NULL);
 	if (err)
 		return err;
 	if (!tb[QCA_WLAN_VENDOR_ATTR_TEST])
@@ -1936,8 +1936,8 @@ static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 	struct sk_buff *skb;
 	int err, ps;
 
-	err = nla_parse(tb, HWSIM_TM_ATTR_MAX, data, len,
-			hwsim_testmode_policy, NULL);
+	err = nla_parse_deprecated(tb, HWSIM_TM_ATTR_MAX, data, len,
+				   hwsim_testmode_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c46f0a54a0c7..73901926b94d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4059,8 +4059,8 @@ static int mwifiex_tm_cmd(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!priv)
 		return -EINVAL;
 
-	err = nla_parse(tb, MWIFIEX_TM_ATTR_MAX, data, len, mwifiex_tm_policy,
-			NULL);
+	err = nla_parse_deprecated(tb, MWIFIEX_TM_ATTR_MAX, data, len,
+				   mwifiex_tm_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index dcb2c8b0feb6..affefaaea1ea 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -372,8 +372,8 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u32 nla_cmd;
 	int err;
 
-	err = nla_parse(tb, WL1271_TM_ATTR_MAX, data, len, wl1271_tm_policy,
-			NULL);
+	err = nla_parse_deprecated(tb, WL1271_TM_ATTR_MAX, data, len,
+				   wl1271_tm_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
index 7f34ec077ee5..75756fb8e7b0 100644
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -41,8 +41,8 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 	if (!data)
 		return -EINVAL;
 
-	ret = nla_parse(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
-			wlcore_vendor_attr_policy, NULL);
+	ret = nla_parse_deprecated(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
+				   wlcore_vendor_attr_policy, NULL);
 	if (ret)
 		return ret;
 
@@ -122,8 +122,8 @@ wlcore_vendor_cmd_smart_config_set_group_key(struct wiphy *wiphy,
 	if (!data)
 		return -EINVAL;
 
-	ret = nla_parse(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
-			wlcore_vendor_attr_policy, NULL);
+	ret = nla_parse_deprecated(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
+				   wlcore_vendor_attr_policy, NULL);
 	if (ret)
 		return ret;
 
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 6850c7b1a3a6..897cdba13569 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -165,7 +165,7 @@ static inline struct nlmsghdr *genlmsg_nlhdr(void *user_hdr)
 }
 
 /**
- * genlmsg_parse - parse attributes of a genetlink message
+ * genlmsg_parse_deprecated - parse attributes of a genetlink message
  * @nlh: netlink message header
  * @family: genetlink message family
  * @tb: destination array with maxtype+1 elements
@@ -173,14 +173,14 @@ static inline struct nlmsghdr *genlmsg_nlhdr(void *user_hdr)
  * @policy: validation policy
  * @extack: extended ACK report struct
  */
-static inline int genlmsg_parse(const struct nlmsghdr *nlh,
-				const struct genl_family *family,
-				struct nlattr *tb[], int maxtype,
-				const struct nla_policy *policy,
-				struct netlink_ext_ack *extack)
+static inline int genlmsg_parse_deprecated(const struct nlmsghdr *nlh,
+					   const struct genl_family *family,
+					   struct nlattr *tb[], int maxtype,
+					   const struct nla_policy *policy,
+					   struct netlink_ext_ack *extack)
 {
-	return nlmsg_parse(nlh, family->hdrsize + GENL_HDRLEN, tb, maxtype,
-			   policy, extack);
+	return __nlmsg_parse(nlh, family->hdrsize + GENL_HDRLEN, tb, maxtype,
+			     policy, NL_VALIDATE_LIBERAL, extack);
 }
 
 /**
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 06f8605b740c..58570462db6d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -369,21 +369,52 @@ struct nl_info {
 	bool			skip_notify;
 };
 
+/**
+ * enum netlink_validation - netlink message/attribute validation levels
+ * @NL_VALIDATE_LIBERAL: Old-style "be liberal" validation, not caring about
+ *	extra data at the end of the message, attributes being longer than
+ *	they should be, or unknown attributes being present.
+ * @NL_VALIDATE_TRAILING: Reject junk data encounted after attribute parsing.
+ * @NL_VALIDATE_MAXTYPE: Reject attributes > max type; Together with _TRAILING
+ *	this is equivalent to the old nla_parse_strict()/nlmsg_parse_strict().
+ * @NL_VALIDATE_UNSPEC: Reject attributes with NLA_UNSPEC in the policy.
+ *	This can safely be set by the kernel when the given policy has no
+ *	NLA_UNSPEC anymore, and can thus be used to ensure policy entries
+ *	are enforced going forward.
+ * @NL_VALIDATE_POLICY: Require that a policy is given, since much of the
+ *	parsing requires a policy.
+ * @NL_VALIDATE_STRICT_ATTRS: strict attribute policy parsing (e.g.
+ *	U8, U16, U32 must have exact size, etc.)
+ */
+enum netlink_validation {
+	NL_VALIDATE_LIBERAL = 0,
+	NL_VALIDATE_TRAILING = BIT(0),
+	NL_VALIDATE_MAXTYPE = BIT(1),
+	NL_VALIDATE_UNSPEC = BIT(2),
+	NL_VALIDATE_POLICY = BIT(3),
+	NL_VALIDATE_STRICT_ATTRS = BIT(4),
+};
+
+#define NL_VALIDATE_DEPRECATED_STRICT (NL_VALIDATE_TRAILING |\
+				       NL_VALIDATE_MAXTYPE)
+#define NL_VALIDATE_STRICT (NL_VALIDATE_TRAILING |\
+			    NL_VALIDATE_MAXTYPE |\
+			    NL_VALIDATE_UNSPEC |\
+			    NL_VALIDATE_POLICY |\
+			    NL_VALIDATE_STRICT_ATTRS)
+
 int netlink_rcv_skb(struct sk_buff *skb,
 		    int (*cb)(struct sk_buff *, struct nlmsghdr *,
 			      struct netlink_ext_ack *));
 int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		 unsigned int group, int report, gfp_t flags);
 
-int nla_validate(const struct nlattr *head, int len, int maxtype,
-		 const struct nla_policy *policy,
-		 struct netlink_ext_ack *extack);
-int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
-	      int len, const struct nla_policy *policy,
-	      struct netlink_ext_ack *extack);
-int nla_parse_strict(struct nlattr **tb, int maxtype, const struct nlattr *head,
-		     int len, const struct nla_policy *policy,
-		     struct netlink_ext_ack *extack);
+int __nla_validate(const struct nlattr *head, int len, int maxtype,
+		   const struct nla_policy *policy, unsigned int validate,
+		   struct netlink_ext_ack *extack);
+int __nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
+		int len, const struct nla_policy *policy, unsigned int validate,
+		struct netlink_ext_ack *extack);
 int nla_policy_len(const struct nla_policy *, int);
 struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
 size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
@@ -512,42 +543,95 @@ nlmsg_next(const struct nlmsghdr *nlh, int *remaining)
 }
 
 /**
- * nlmsg_parse - parse attributes of a netlink message
+ * nla_parse_deprecated - Parse a stream of attributes into a tb buffer
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @head: head of attribute stream
+ * @len: length of attribute stream
+ * @policy: validation policy
+ * @extack: extended ACK pointer
+ *
+ * Parses a stream of attributes and stores a pointer to each attribute in
+ * the tb array accessible via the attribute type. Attributes with a type
+ * exceeding maxtype will be ignored and attributes from the policy are not
+ * always strictly validated (only for new attributes).
+ *
+ * Returns 0 on success or a negative error code.
+ */
+static inline int nla_parse_deprecated(struct nlattr **tb, int maxtype,
+				       const struct nlattr *head, int len,
+				       const struct nla_policy *policy,
+				       struct netlink_ext_ack *extack)
+{
+	return __nla_parse(tb, maxtype, head, len, policy,
+			   NL_VALIDATE_LIBERAL, extack);
+}
+
+/**
+ * __nlmsg_parse - parse attributes of a netlink message
  * @nlh: netlink message header
  * @hdrlen: length of family specific header
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
+ * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * See nla_parse()
  */
-static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
-			      struct nlattr *tb[], int maxtype,
-			      const struct nla_policy *policy,
-			      struct netlink_ext_ack *extack)
+static inline int __nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
+				struct nlattr *tb[], int maxtype,
+				const struct nla_policy *policy,
+				unsigned int validate,
+				struct netlink_ext_ack *extack)
 {
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen)) {
 		NL_SET_ERR_MSG(extack, "Invalid header length");
 		return -EINVAL;
 	}
 
-	return nla_parse(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
-			 nlmsg_attrlen(nlh, hdrlen), policy, extack);
+	return __nla_parse(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
+			   nlmsg_attrlen(nlh, hdrlen), policy, validate,
+			   extack);
 }
 
-static inline int nlmsg_parse_strict(const struct nlmsghdr *nlh, int hdrlen,
-				     struct nlattr *tb[], int maxtype,
-				     const struct nla_policy *policy,
-				     struct netlink_ext_ack *extack)
+/**
+ * nlmsg_parse_deprecated - parse attributes of a netlink message
+ * @nlh: netlink message header
+ * @hdrlen: length of family specific header
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @extack: extended ACK report struct
+ *
+ * See nla_parse_deprecated()
+ */
+static inline int nlmsg_parse_deprecated(const struct nlmsghdr *nlh, int hdrlen,
+					 struct nlattr *tb[], int maxtype,
+					 const struct nla_policy *policy,
+					 struct netlink_ext_ack *extack)
 {
-	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen)) {
-		NL_SET_ERR_MSG(extack, "Invalid header length");
-		return -EINVAL;
-	}
+	return __nlmsg_parse(nlh, hdrlen, tb, maxtype, policy,
+			     NL_VALIDATE_LIBERAL, extack);
+}
 
-	return nla_parse_strict(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
-				nlmsg_attrlen(nlh, hdrlen), policy, extack);
+/**
+ * nlmsg_parse_deprecated_strict - parse attributes of a netlink message
+ * @nlh: netlink message header
+ * @hdrlen: length of family specific header
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @extack: extended ACK report struct
+ *
+ * See nla_parse_deprecated_strict()
+ */
+static inline int
+nlmsg_parse_deprecated_strict(const struct nlmsghdr *nlh, int hdrlen,
+			      struct nlattr *tb[], int maxtype,
+			      const struct nla_policy *policy,
+			      struct netlink_ext_ack *extack)
+{
+	return __nlmsg_parse(nlh, hdrlen, tb, maxtype, policy,
+			     NL_VALIDATE_DEPRECATED_STRICT, extack);
 }
 
 /**
@@ -566,26 +650,53 @@ static inline struct nlattr *nlmsg_find_attr(const struct nlmsghdr *nlh,
 }
 
 /**
- * nlmsg_validate - validate a netlink message including attributes
+ * nla_validate_deprecated - Validate a stream of attributes
+ * @head: head of attribute stream
+ * @len: length of attribute stream
+ * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
+ * @validate: validation strictness
+ * @extack: extended ACK report struct
+ *
+ * Validates all attributes in the specified attribute stream against the
+ * specified policy. Validation is done in liberal mode.
+ * See documenation of struct nla_policy for more details.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+static inline int nla_validate_deprecated(const struct nlattr *head, int len,
+					  int maxtype,
+					  const struct nla_policy *policy,
+					  struct netlink_ext_ack *extack)
+{
+	return __nla_validate(head, len, maxtype, policy, NL_VALIDATE_LIBERAL,
+			      extack);
+}
+
+
+/**
+ * nlmsg_validate_deprecated - validate a netlink message including attributes
  * @nlh: netlinket message header
  * @hdrlen: length of familiy specific header
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
  * @extack: extended ACK report struct
  */
-static inline int nlmsg_validate(const struct nlmsghdr *nlh,
-				 int hdrlen, int maxtype,
-				 const struct nla_policy *policy,
-				 struct netlink_ext_ack *extack)
+static inline int nlmsg_validate_deprecated(const struct nlmsghdr *nlh,
+					    int hdrlen, int maxtype,
+					    const struct nla_policy *policy,
+					    struct netlink_ext_ack *extack)
 {
 	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
 		return -EINVAL;
 
-	return nla_validate(nlmsg_attrdata(nlh, hdrlen),
-			    nlmsg_attrlen(nlh, hdrlen), maxtype, policy,
-			    extack);
+	return __nla_validate(nlmsg_attrdata(nlh, hdrlen),
+			      nlmsg_attrlen(nlh, hdrlen), maxtype,
+			      policy, NL_VALIDATE_LIBERAL, extack);
 }
 
+
+
 /**
  * nlmsg_report - need to report back to application?
  * @nlh: netlink message header
@@ -899,22 +1010,22 @@ nla_find_nested(const struct nlattr *nla, int attrtype)
 }
 
 /**
- * nla_parse_nested - parse nested attributes
+ * nla_parse_nested_deprecated - parse nested attributes
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
  * @nla: attribute containing the nested attributes
  * @policy: validation policy
  * @extack: extended ACK report struct
  *
- * See nla_parse()
+ * See nla_parse_deprecated()
  */
-static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
-				   const struct nlattr *nla,
-				   const struct nla_policy *policy,
-				   struct netlink_ext_ack *extack)
+static inline int nla_parse_nested_deprecated(struct nlattr *tb[], int maxtype,
+					      const struct nlattr *nla,
+					      const struct nla_policy *policy,
+					      struct netlink_ext_ack *extack)
 {
-	return nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
-			 extack);
+	return __nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
+			   NL_VALIDATE_LIBERAL, extack);
 }
 
 /**
@@ -1469,6 +1580,7 @@ static inline void nla_nest_cancel(struct sk_buff *skb, struct nlattr *start)
  * @start: container attribute
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
+ * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * Validates all attributes in the nested attribute stream against the
@@ -1477,12 +1589,22 @@ static inline void nla_nest_cancel(struct sk_buff *skb, struct nlattr *start)
  *
  * Returns 0 on success or a negative error code.
  */
-static inline int nla_validate_nested(const struct nlattr *start, int maxtype,
-				      const struct nla_policy *policy,
-				      struct netlink_ext_ack *extack)
+static inline int __nla_validate_nested(const struct nlattr *start, int maxtype,
+					const struct nla_policy *policy,
+					unsigned int validate,
+					struct netlink_ext_ack *extack)
+{
+	return __nla_validate(nla_data(start), nla_len(start), maxtype, policy,
+			      validate, extack);
+}
+
+static inline int
+nla_validate_nested_deprecated(const struct nlattr *start, int maxtype,
+			       const struct nla_policy *policy,
+			       struct netlink_ext_ack *extack)
 {
-	return nla_validate(nla_data(start), nla_len(start), maxtype, policy,
-			    extack);
+	return __nla_validate_nested(start, maxtype, policy,
+				     NL_VALIDATE_LIBERAL, extack);
 }
 
 /**
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 1b942a7caf26..779fea7416ca 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -677,8 +677,9 @@ static int taskstats_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	return nlmsg_validate(info->nlhdr, GENL_HDRLEN, TASKSTATS_CMD_ATTR_MAX,
-			      policy, info->extack);
+	return nlmsg_validate_deprecated(info->nlhdr, GENL_HDRLEN,
+					 TASKSTATS_CMD_ATTR_MAX, policy,
+					 info->extack);
 }
 
 static struct genl_family family __ro_after_init = {
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 465c9e8ef8a5..3ba54904256a 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -69,7 +69,8 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 
 static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			      const struct nla_policy *policy,
-			      struct netlink_ext_ack *extack)
+			      struct netlink_ext_ack *extack,
+			      unsigned int validate)
 {
 	const struct nlattr *entry;
 	int rem;
@@ -86,8 +87,8 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 			return -ERANGE;
 		}
 
-		ret = nla_validate(nla_data(entry), nla_len(entry),
-				   maxtype, policy, extack);
+		ret = __nla_validate(nla_data(entry), nla_len(entry),
+				     maxtype, policy, validate, extack);
 		if (ret < 0)
 			return ret;
 	}
@@ -154,7 +155,7 @@ static int nla_validate_int_range(const struct nla_policy *pt,
 }
 
 static int validate_nla(const struct nlattr *nla, int maxtype,
-			const struct nla_policy *policy,
+			const struct nla_policy *policy, unsigned int validate,
 			struct netlink_ext_ack *extack)
 {
 	const struct nla_policy *pt;
@@ -172,6 +173,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	    (pt->type == NLA_EXACT_LEN_WARN && attrlen != pt->len)) {
 		pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
 				    current->comm, type);
+		if (validate & NL_VALIDATE_STRICT_ATTRS) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "invalid attribute length");
+			return -EINVAL;
+		}
 	}
 
 	switch (pt->type) {
@@ -244,8 +250,9 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (attrlen < NLA_HDRLEN)
 			goto out_err;
 		if (pt->validation_data) {
-			err = nla_validate(nla_data(nla), nla_len(nla), pt->len,
-					   pt->validation_data, extack);
+			err = __nla_validate(nla_data(nla), nla_len(nla), pt->len,
+					     pt->validation_data, validate,
+					     extack);
 			if (err < 0) {
 				/*
 				 * return directly to preserve the inner
@@ -268,7 +275,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 			err = nla_validate_array(nla_data(nla), nla_len(nla),
 						 pt->len, pt->validation_data,
-						 extack);
+						 extack, validate);
 			if (err < 0) {
 				/*
 				 * return directly to preserve the inner
@@ -280,6 +287,12 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		break;
 
 	case NLA_UNSPEC:
+		if (validate & NL_VALIDATE_UNSPEC) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "Attribute not understood");
+			return -EINVAL;
+		}
+		/* fall through */
 	case NLA_MIN_LEN:
 		if (attrlen < pt->len)
 			goto out_err;
@@ -322,37 +335,78 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	return err;
 }
 
+static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
+				const struct nla_policy *policy,
+				unsigned int validate,
+				struct netlink_ext_ack *extack,
+				struct nlattr **tb)
+{
+	const struct nlattr *nla;
+	int rem;
+
+	if (WARN_ON(validate & NL_VALIDATE_POLICY && !policy))
+		return -EINVAL;
+
+	if (tb)
+		memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
+
+	nla_for_each_attr(nla, head, len, rem) {
+		u16 type = nla_type(nla);
+
+		if (type == 0 || type > maxtype) {
+			if (validate & NL_VALIDATE_MAXTYPE) {
+				NL_SET_ERR_MSG(extack, "Unknown attribute type");
+				return -EINVAL;
+			}
+			continue;
+		}
+		if (policy) {
+			int err = validate_nla(nla, maxtype, policy,
+					       validate, extack);
+
+			if (err < 0)
+				return err;
+		}
+
+		if (tb)
+			tb[type] = (struct nlattr *)nla;
+	}
+
+	if (unlikely(rem > 0)) {
+		pr_warn_ratelimited("netlink: %d bytes leftover after parsing attributes in process `%s'.\n",
+				    rem, current->comm);
+		NL_SET_ERR_MSG(extack, "bytes leftover after parsing attributes");
+		if (validate & NL_VALIDATE_TRAILING)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
- * nla_validate - Validate a stream of attributes
+ * __nla_validate - Validate a stream of attributes
  * @head: head of attribute stream
  * @len: length of attribute stream
  * @maxtype: maximum attribute type to be expected
  * @policy: validation policy
+ * @validate: validation strictness
  * @extack: extended ACK report struct
  *
  * Validates all attributes in the specified attribute stream against the
- * specified policy. Attributes with a type exceeding maxtype will be
- * ignored. See documenation of struct nla_policy for more details.
+ * specified policy. Validation depends on the validate flags passed, see
+ * &enum netlink_validation for more details on that.
+ * See documenation of struct nla_policy for more details.
  *
  * Returns 0 on success or a negative error code.
  */
-int nla_validate(const struct nlattr *head, int len, int maxtype,
-		 const struct nla_policy *policy,
-		 struct netlink_ext_ack *extack)
+int __nla_validate(const struct nlattr *head, int len, int maxtype,
+		   const struct nla_policy *policy, unsigned int validate,
+		   struct netlink_ext_ack *extack)
 {
-	const struct nlattr *nla;
-	int rem;
-
-	nla_for_each_attr(nla, head, len, rem) {
-		int err = validate_nla(nla, maxtype, policy, extack);
-
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
+	return __nla_validate_parse(head, len, maxtype, policy, validate,
+				    extack, NULL);
 }
-EXPORT_SYMBOL(nla_validate);
+EXPORT_SYMBOL(__nla_validate);
 
 /**
  * nla_policy_len - Determin the max. length of a policy
@@ -384,76 +438,30 @@ nla_policy_len(const struct nla_policy *p, int n)
 EXPORT_SYMBOL(nla_policy_len);
 
 /**
- * nla_parse - Parse a stream of attributes into a tb buffer
+ * __nla_parse - Parse a stream of attributes into a tb buffer
  * @tb: destination array with maxtype+1 elements
  * @maxtype: maximum attribute type to be expected
  * @head: head of attribute stream
  * @len: length of attribute stream
  * @policy: validation policy
+ * @validate: validation strictness
+ * @extack: extended ACK pointer
  *
  * Parses a stream of attributes and stores a pointer to each attribute in
- * the tb array accessible via the attribute type. Attributes with a type
- * exceeding maxtype will be silently ignored for backwards compatibility
- * reasons. policy may be set to NULL if no validation is required.
+ * the tb array accessible via the attribute type.
+ * Validation is controlled by the @validate parameter.
  *
  * Returns 0 on success or a negative error code.
  */
-static int __nla_parse(struct nlattr **tb, int maxtype,
-		       const struct nlattr *head, int len,
-		       bool strict, const struct nla_policy *policy,
-		       struct netlink_ext_ack *extack)
-{
-	const struct nlattr *nla;
-	int rem;
-
-	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
-
-	nla_for_each_attr(nla, head, len, rem) {
-		u16 type = nla_type(nla);
-
-		if (type == 0 || type > maxtype) {
-			if (strict) {
-				NL_SET_ERR_MSG(extack, "Unknown attribute type");
-				return -EINVAL;
-			}
-			continue;
-		}
-		if (policy) {
-			int err = validate_nla(nla, maxtype, policy, extack);
-
-			if (err < 0)
-				return err;
-		}
-
-		tb[type] = (struct nlattr *)nla;
-	}
-
-	if (unlikely(rem > 0)) {
-		pr_warn_ratelimited("netlink: %d bytes leftover after parsing attributes in process `%s'.\n",
-				    rem, current->comm);
-		NL_SET_ERR_MSG(extack, "bytes leftover after parsing attributes");
-		if (strict)
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
-int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
-	      int len, const struct nla_policy *policy,
-	      struct netlink_ext_ack *extack)
-{
-	return __nla_parse(tb, maxtype, head, len, false, policy, extack);
-}
-EXPORT_SYMBOL(nla_parse);
-
-int nla_parse_strict(struct nlattr **tb, int maxtype, const struct nlattr *head,
-		     int len, const struct nla_policy *policy,
-		     struct netlink_ext_ack *extack)
+int __nla_parse(struct nlattr **tb, int maxtype,
+		const struct nlattr *head, int len,
+		const struct nla_policy *policy, unsigned int validate,
+		struct netlink_ext_ack *extack)
 {
-	return __nla_parse(tb, maxtype, head, len, true, policy, extack);
+	return __nla_validate_parse(head, len, maxtype, policy, validate,
+				    extack, tb);
 }
-EXPORT_SYMBOL(nla_parse_strict);
+EXPORT_SYMBOL(__nla_parse);
 
 /**
  * nla_find - Find a specific attribute in a stream of attributes
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index 9b60c1e399e2..afbaae47489d 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -35,8 +35,8 @@ static inline int vlan_validate_qos_map(struct nlattr *attr)
 {
 	if (!attr)
 		return 0;
-	return nla_validate_nested(attr, IFLA_VLAN_QOS_MAX, vlan_map_policy,
-				   NULL);
+	return nla_validate_nested_deprecated(attr, IFLA_VLAN_QOS_MAX,
+					      vlan_map_policy, NULL);
 }
 
 static int vlan_validate(struct nlattr *tb[], struct nlattr *data[],
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index f69c8d91dc81..575336ef76d0 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -529,8 +529,8 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_device *dev;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*bpm), tb, MDBA_SET_ENTRY_MAX, NULL,
-			  NULL);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, NULL, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4f9f59eba8b4..19ab5ef5d8fa 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -880,8 +880,10 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 
 	if (p && protinfo) {
 		if (protinfo->nla_type & NLA_F_NESTED) {
-			err = nla_parse_nested(tb, IFLA_BRPORT_MAX, protinfo,
-					       br_port_policy, NULL);
+			err = nla_parse_nested_deprecated(tb, IFLA_BRPORT_MAX,
+							  protinfo,
+							  br_port_policy,
+							  NULL);
 			if (err)
 				return err;
 
diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index da8cb99fd259..5d8b0cbf9ba0 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -230,8 +230,8 @@ int br_parse_vlan_tunnel_info(struct nlattr *attr,
 
 	memset(tinfo, 0, sizeof(*tinfo));
 
-	err = nla_parse_nested(tb, IFLA_BRIDGE_VLAN_TUNNEL_MAX, attr,
-			       vlan_tunnel_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, IFLA_BRIDGE_VLAN_TUNNEL_MAX,
+					  attr, vlan_tunnel_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/can/gw.c b/net/can/gw.c
index 53859346dc9a..5275ddf580bc 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -662,8 +662,8 @@ static int cgw_parse_attr(struct nlmsghdr *nlh, struct cf_mod *mod,
 	/* initialize modification & checksum data space */
 	memset(mod, 0, sizeof(*mod));
 
-	err = nlmsg_parse(nlh, sizeof(struct rtcanmsg), tb, CGW_MAX,
-			  cgw_policy, NULL);
+	err = nlmsg_parse_deprecated(nlh, sizeof(struct rtcanmsg), tb,
+				     CGW_MAX, cgw_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index dc3a99148ee7..4846c6277216 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3661,9 +3661,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	if (!attrs)
 		return -ENOMEM;
 
-	err = nlmsg_parse(cb->nlh, GENL_HDRLEN + devlink_nl_family.hdrsize,
-			  attrs, DEVLINK_ATTR_MAX, devlink_nl_family.policy,
-			  cb->extack);
+	err = nlmsg_parse_deprecated(cb->nlh,
+				     GENL_HDRLEN + devlink_nl_family.hdrsize,
+				     attrs, DEVLINK_ATTR_MAX,
+				     devlink_nl_family.policy, cb->extack);
 	if (err)
 		goto out_free;
 
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index ffbb827723a2..18f8dd8329ed 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -746,7 +746,8 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = nlmsg_parse(nlh, sizeof(*frh), tb, FRA_MAX, ops->policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*frh), tb, FRA_MAX,
+				     ops->policy, extack);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Error parsing msg");
 		goto errout;
@@ -853,7 +854,8 @@ int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto errout;
 	}
 
-	err = nlmsg_parse(nlh, sizeof(*frh), tb, FRA_MAX, ops->policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*frh), tb, FRA_MAX,
+				     ops->policy, extack);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Error parsing msg");
 		goto errout;
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 3c5c24a5d9f5..87df433e37a9 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -343,8 +343,8 @@ static int bpf_parse_prog(struct nlattr *attr, struct bpf_lwt_prog *prog,
 	int ret;
 	u32 fd;
 
-	ret = nla_parse_nested(tb, LWT_BPF_PROG_MAX, attr, bpf_prog_policy,
-			       NULL);
+	ret = nla_parse_nested_deprecated(tb, LWT_BPF_PROG_MAX, attr,
+					  bpf_prog_policy, NULL);
 	if (ret < 0)
 		return ret;
 
@@ -385,7 +385,8 @@ static int bpf_build_state(struct nlattr *nla,
 	if (family != AF_INET && family != AF_INET6)
 		return -EAFNOSUPPORT;
 
-	ret = nla_parse_nested(tb, LWT_BPF_MAX, nla, bpf_nl_policy, extack);
+	ret = nla_parse_nested_deprecated(tb, LWT_BPF_MAX, nla, bpf_nl_policy,
+					  extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 30f6fd8f68e0..d48b004dc9f8 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1862,7 +1862,8 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 
 	ASSERT_RTNL();
-	err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX, nda_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX,
+				     nda_policy, extack);
 	if (err < 0)
 		goto out;
 
@@ -2176,8 +2177,8 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	bool found = false;
 	int err, tidx;
 
-	err = nlmsg_parse(nlh, sizeof(*ndtmsg), tb, NDTA_MAX,
-			  nl_neightbl_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ndtmsg), tb, NDTA_MAX,
+				     nl_neightbl_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -2214,8 +2215,9 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct neigh_parms *p;
 		int i, ifindex = 0;
 
-		err = nla_parse_nested(tbp, NDTPA_MAX, tb[NDTA_PARMS],
-				       nl_ntbl_parm_policy, extack);
+		err = nla_parse_nested_deprecated(tbp, NDTPA_MAX,
+						  tb[NDTA_PARMS],
+						  nl_ntbl_parm_policy, extack);
 		if (err < 0)
 			goto errout_tbl_lock;
 
@@ -2655,11 +2657,12 @@ static int neigh_valid_dump_req(const struct nlmsghdr *nlh,
 			return -EINVAL;
 		}
 
-		err = nlmsg_parse_strict(nlh, sizeof(struct ndmsg), tb, NDA_MAX,
-					 nda_policy, extack);
+		err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg),
+						    tb, NDA_MAX, nda_policy,
+						    extack);
 	} else {
-		err = nlmsg_parse(nlh, sizeof(struct ndmsg), tb, NDA_MAX,
-				  nda_policy, extack);
+		err = nlmsg_parse_deprecated(nlh, sizeof(struct ndmsg), tb,
+					     NDA_MAX, nda_policy, extack);
 	}
 	if (err < 0)
 		return err;
@@ -2759,8 +2762,8 @@ static int neigh_valid_get_req(const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct ndmsg), tb, NDA_MAX,
-				 nda_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg), tb,
+					    NDA_MAX, nda_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 17f36317363d..e41da4ddc046 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -681,8 +681,8 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *peer;
 	int nsid, err;
 
-	err = nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, NETNSA_MAX,
-			  rtnl_net_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(struct rtgenmsg), tb,
+				     NETNSA_MAX, rtnl_net_policy, extack);
 	if (err < 0)
 		return err;
 	if (!tb[NETNSA_NSID]) {
@@ -786,11 +786,13 @@ static int rtnl_net_valid_getid_req(struct sk_buff *skb,
 	int i, err;
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, NETNSA_MAX,
-				   rtnl_net_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(struct rtgenmsg),
+					      tb, NETNSA_MAX, rtnl_net_policy,
+					      extack);
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct rtgenmsg), tb, NETNSA_MAX,
-				 rtnl_net_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct rtgenmsg), tb,
+					    NETNSA_MAX, rtnl_net_policy,
+					    extack);
 	if (err)
 		return err;
 
@@ -928,8 +930,9 @@ static int rtnl_valid_dump_net_req(const struct nlmsghdr *nlh, struct sock *sk,
 	struct nlattr *tb[NETNSA_MAX + 1];
 	int err, i;
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct rtgenmsg), tb, NETNSA_MAX,
-				 rtnl_net_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct rtgenmsg), tb,
+					    NETNSA_MAX, rtnl_net_policy,
+					    extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f9b964fd4e4d..f4efc2b698fb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1797,8 +1797,7 @@ static const struct rtnl_link_ops *linkinfo_to_kind_ops(const struct nlattr *nla
 	const struct rtnl_link_ops *ops = NULL;
 	struct nlattr *linfo[IFLA_INFO_MAX + 1];
 
-	if (nla_parse_nested(linfo, IFLA_INFO_MAX, nla,
-			     ifla_info_policy, NULL) < 0)
+	if (nla_parse_nested_deprecated(linfo, IFLA_INFO_MAX, nla, ifla_info_policy, NULL) < 0)
 		return NULL;
 
 	if (linfo[IFLA_INFO_KIND]) {
@@ -1897,8 +1896,9 @@ static int rtnl_valid_dump_ifinfo_req(const struct nlmsghdr *nlh,
 			return -EINVAL;
 		}
 
-		return nlmsg_parse_strict(nlh, sizeof(*ifm), tb, IFLA_MAX,
-					  ifla_policy, extack);
+		return nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb,
+						     IFLA_MAX, ifla_policy,
+						     extack);
 	}
 
 	/* A hack to preserve kernel<->userspace interface.
@@ -1911,7 +1911,8 @@ static int rtnl_valid_dump_ifinfo_req(const struct nlmsghdr *nlh,
 	hdrlen = nlmsg_len(nlh) < sizeof(struct ifinfomsg) ?
 		 sizeof(struct rtgenmsg) : sizeof(struct ifinfomsg);
 
-	return nlmsg_parse(nlh, hdrlen, tb, IFLA_MAX, ifla_policy, extack);
+	return nlmsg_parse_deprecated(nlh, hdrlen, tb, IFLA_MAX, ifla_policy,
+				      extack);
 }
 
 static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
@@ -2019,7 +2020,8 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 int rtnl_nla_parse_ifla(struct nlattr **tb, const struct nlattr *head, int len,
 			struct netlink_ext_ack *exterr)
 {
-	return nla_parse(tb, IFLA_MAX, head, len, ifla_policy, exterr);
+	return nla_parse_deprecated(tb, IFLA_MAX, head, len, ifla_policy,
+				    exterr);
 }
 EXPORT_SYMBOL(rtnl_nla_parse_ifla);
 
@@ -2564,8 +2566,10 @@ static int do_setlink(const struct sk_buff *skb,
 				err = -EINVAL;
 				goto errout;
 			}
-			err = nla_parse_nested(vfinfo, IFLA_VF_MAX, attr,
-					       ifla_vf_policy, NULL);
+			err = nla_parse_nested_deprecated(vfinfo, IFLA_VF_MAX,
+							  attr,
+							  ifla_vf_policy,
+							  NULL);
 			if (err < 0)
 				goto errout;
 			err = do_setvfinfo(dev, vfinfo);
@@ -2592,8 +2596,10 @@ static int do_setlink(const struct sk_buff *skb,
 				err = -EINVAL;
 				goto errout;
 			}
-			err = nla_parse_nested(port, IFLA_PORT_MAX, attr,
-					       ifla_port_policy, NULL);
+			err = nla_parse_nested_deprecated(port, IFLA_PORT_MAX,
+							  attr,
+							  ifla_port_policy,
+							  NULL);
 			if (err < 0)
 				goto errout;
 			if (!port[IFLA_PORT_VF]) {
@@ -2612,9 +2618,9 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_PORT_SELF]) {
 		struct nlattr *port[IFLA_PORT_MAX+1];
 
-		err = nla_parse_nested(port, IFLA_PORT_MAX,
-				       tb[IFLA_PORT_SELF], ifla_port_policy,
-				       NULL);
+		err = nla_parse_nested_deprecated(port, IFLA_PORT_MAX,
+						  tb[IFLA_PORT_SELF],
+						  ifla_port_policy, NULL);
 		if (err < 0)
 			goto errout;
 
@@ -2661,8 +2667,9 @@ static int do_setlink(const struct sk_buff *skb,
 		struct nlattr *xdp[IFLA_XDP_MAX + 1];
 		u32 xdp_flags = 0;
 
-		err = nla_parse_nested(xdp, IFLA_XDP_MAX, tb[IFLA_XDP],
-				       ifla_xdp_policy, NULL);
+		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
+						  tb[IFLA_XDP],
+						  ifla_xdp_policy, NULL);
 		if (err < 0)
 			goto errout;
 
@@ -2716,8 +2723,8 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct nlattr *tb[IFLA_MAX+1];
 	char ifname[IFNAMSIZ];
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFLA_MAX,
+				     ifla_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -2813,7 +2820,8 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	int netnsid = -1;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFLA_MAX,
+				     ifla_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2990,7 +2998,8 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 #ifdef CONFIG_MODULES
 replay:
 #endif
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFLA_MAX,
+				     ifla_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -3024,9 +3033,9 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	if (tb[IFLA_LINKINFO]) {
-		err = nla_parse_nested(linkinfo, IFLA_INFO_MAX,
-				       tb[IFLA_LINKINFO], ifla_info_policy,
-				       NULL);
+		err = nla_parse_nested_deprecated(linkinfo, IFLA_INFO_MAX,
+						  tb[IFLA_LINKINFO],
+						  ifla_info_policy, NULL);
 		if (err < 0)
 			return err;
 	} else
@@ -3046,9 +3055,9 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -EINVAL;
 
 		if (ops->maxtype && linkinfo[IFLA_INFO_DATA]) {
-			err = nla_parse_nested(attr, ops->maxtype,
-					       linkinfo[IFLA_INFO_DATA],
-					       ops->policy, extack);
+			err = nla_parse_nested_deprecated(attr, ops->maxtype,
+							  linkinfo[IFLA_INFO_DATA],
+							  ops->policy, extack);
 			if (err < 0)
 				return err;
 			data = attr;
@@ -3067,9 +3076,11 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		if (m_ops->slave_maxtype &&
 		    linkinfo[IFLA_INFO_SLAVE_DATA]) {
-			err = nla_parse_nested(slave_attr, m_ops->slave_maxtype,
-					       linkinfo[IFLA_INFO_SLAVE_DATA],
-					       m_ops->slave_policy, extack);
+			err = nla_parse_nested_deprecated(slave_attr,
+							  m_ops->slave_maxtype,
+							  linkinfo[IFLA_INFO_SLAVE_DATA],
+							  m_ops->slave_policy,
+							  extack);
 			if (err < 0)
 				return err;
 			slave_data = slave_attr;
@@ -3250,8 +3261,8 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy,
-				   extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFLA_MAX,
+					      ifla_policy, extack);
 
 	ifm = nlmsg_data(nlh);
 	if (ifm->__ifi_pad || ifm->ifi_type || ifm->ifi_flags ||
@@ -3260,8 +3271,8 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy,
-				 extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFLA_MAX,
+					    ifla_policy, extack);
 	if (err)
 		return err;
 
@@ -3366,7 +3377,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	hdrlen = nlmsg_len(nlh) < sizeof(struct ifinfomsg) ?
 		 sizeof(struct rtgenmsg) : sizeof(struct ifinfomsg);
 
-	if (nlmsg_parse(nlh, hdrlen, tb, IFLA_MAX, ifla_policy, NULL) >= 0) {
+	if (nlmsg_parse_deprecated(nlh, hdrlen, tb, IFLA_MAX, ifla_policy, NULL) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
 	}
@@ -3639,7 +3650,8 @@ static int rtnl_fdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u16 vid;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX, NULL, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX, NULL,
+				     extack);
 	if (err < 0)
 		return err;
 
@@ -3749,7 +3761,8 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX, NULL, extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX, NULL,
+				     extack);
 	if (err < 0)
 		return err;
 
@@ -3898,8 +3911,8 @@ static int valid_fdb_dump_strict(const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct ndmsg), tb, NDA_MAX,
-				 NULL, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg), tb,
+					    NDA_MAX, NULL, extack);
 	if (err < 0)
 		return err;
 
@@ -3951,8 +3964,9 @@ static int valid_fdb_dump_legacy(const struct nlmsghdr *nlh,
 	     nla_attr_size(sizeof(u32)))) {
 		struct ifinfomsg *ifm;
 
-		err = nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
-				  ifla_policy, extack);
+		err = nlmsg_parse_deprecated(nlh, sizeof(struct ifinfomsg),
+					     tb, IFLA_MAX, ifla_policy,
+					     extack);
 		if (err < 0) {
 			return -EINVAL;
 		} else if (err == 0) {
@@ -4091,8 +4105,8 @@ static int valid_fdb_get_strict(const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct ndmsg), tb, NDA_MAX,
-				 nda_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct ndmsg), tb,
+					    NDA_MAX, nda_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -4354,11 +4368,14 @@ static int valid_bridge_getlink_req(const struct nlmsghdr *nlh,
 			return -EINVAL;
 		}
 
-		err = nlmsg_parse_strict(nlh, sizeof(struct ifinfomsg), tb,
-					 IFLA_MAX, ifla_policy, extack);
+		err = nlmsg_parse_deprecated_strict(nlh,
+						    sizeof(struct ifinfomsg),
+						    tb, IFLA_MAX, ifla_policy,
+						    extack);
 	} else {
-		err = nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb,
-				  IFLA_MAX, ifla_policy, extack);
+		err = nlmsg_parse_deprecated(nlh, sizeof(struct ifinfomsg),
+					     tb, IFLA_MAX, ifla_policy,
+					     extack);
 	}
 	if (err < 0)
 		return err;
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index a556cd708885..56d8d15afadd 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -241,8 +241,9 @@ static int dcbnl_getpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->getpfccfg)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_PFC_UP_ATTR_MAX,
-			       tb[DCB_ATTR_PFC_CFG], dcbnl_pfc_up_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_PFC_UP_ATTR_MAX,
+					  tb[DCB_ATTR_PFC_CFG],
+					  dcbnl_pfc_up_nest, NULL);
 	if (ret)
 		return ret;
 
@@ -299,8 +300,9 @@ static int dcbnl_getcap(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->getcap)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_CAP_ATTR_MAX, tb[DCB_ATTR_CAP],
-			       dcbnl_cap_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_CAP_ATTR_MAX,
+					  tb[DCB_ATTR_CAP], dcbnl_cap_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -343,8 +345,9 @@ static int dcbnl_getnumtcs(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->getnumtcs)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_NUMTCS_ATTR_MAX, tb[DCB_ATTR_NUMTCS],
-			       dcbnl_numtcs_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_NUMTCS_ATTR_MAX,
+					  tb[DCB_ATTR_NUMTCS],
+					  dcbnl_numtcs_nest, NULL);
 	if (ret)
 		return ret;
 
@@ -388,8 +391,9 @@ static int dcbnl_setnumtcs(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->setnumtcs)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_NUMTCS_ATTR_MAX, tb[DCB_ATTR_NUMTCS],
-			       dcbnl_numtcs_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_NUMTCS_ATTR_MAX,
+					  tb[DCB_ATTR_NUMTCS],
+					  dcbnl_numtcs_nest, NULL);
 	if (ret)
 		return ret;
 
@@ -447,8 +451,9 @@ static int dcbnl_getapp(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_APP])
 		return -EINVAL;
 
-	ret = nla_parse_nested(app_tb, DCB_APP_ATTR_MAX, tb[DCB_ATTR_APP],
-			       dcbnl_app_nest, NULL);
+	ret = nla_parse_nested_deprecated(app_tb, DCB_APP_ATTR_MAX,
+					  tb[DCB_ATTR_APP], dcbnl_app_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -515,8 +520,9 @@ static int dcbnl_setapp(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_APP])
 		return -EINVAL;
 
-	ret = nla_parse_nested(app_tb, DCB_APP_ATTR_MAX, tb[DCB_ATTR_APP],
-			       dcbnl_app_nest, NULL);
+	ret = nla_parse_nested_deprecated(app_tb, DCB_APP_ATTR_MAX,
+					  tb[DCB_ATTR_APP], dcbnl_app_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -573,8 +579,9 @@ static int __dcbnl_pg_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	    !netdev->dcbnl_ops->getpgbwgcfgrx)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(pg_tb, DCB_PG_ATTR_MAX, tb[DCB_ATTR_PG_CFG],
-			       dcbnl_pg_nest, NULL);
+	ret = nla_parse_nested_deprecated(pg_tb, DCB_PG_ATTR_MAX,
+					  tb[DCB_ATTR_PG_CFG], dcbnl_pg_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -593,8 +600,9 @@ static int __dcbnl_pg_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 			data = pg_tb[DCB_PG_ATTR_TC_ALL];
 		else
 			data = pg_tb[i];
-		ret = nla_parse_nested(param_tb, DCB_TC_ATTR_PARAM_MAX, data,
-				       dcbnl_tc_param_nest, NULL);
+		ret = nla_parse_nested_deprecated(param_tb,
+						  DCB_TC_ATTR_PARAM_MAX, data,
+						  dcbnl_tc_param_nest, NULL);
 		if (ret)
 			goto err_pg;
 
@@ -730,8 +738,9 @@ static int dcbnl_setpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->setpfccfg)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_PFC_UP_ATTR_MAX,
-			       tb[DCB_ATTR_PFC_CFG], dcbnl_pfc_up_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_PFC_UP_ATTR_MAX,
+					  tb[DCB_ATTR_PFC_CFG],
+					  dcbnl_pfc_up_nest, NULL);
 	if (ret)
 		return ret;
 
@@ -786,8 +795,9 @@ static int __dcbnl_pg_setcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	    !netdev->dcbnl_ops->setpgbwgcfgrx)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(pg_tb, DCB_PG_ATTR_MAX, tb[DCB_ATTR_PG_CFG],
-			       dcbnl_pg_nest, NULL);
+	ret = nla_parse_nested_deprecated(pg_tb, DCB_PG_ATTR_MAX,
+					  tb[DCB_ATTR_PG_CFG], dcbnl_pg_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -795,8 +805,10 @@ static int __dcbnl_pg_setcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		if (!pg_tb[i])
 			continue;
 
-		ret = nla_parse_nested(param_tb, DCB_TC_ATTR_PARAM_MAX,
-				       pg_tb[i], dcbnl_tc_param_nest, NULL);
+		ret = nla_parse_nested_deprecated(param_tb,
+						  DCB_TC_ATTR_PARAM_MAX,
+						  pg_tb[i],
+						  dcbnl_tc_param_nest, NULL);
 		if (ret)
 			return ret;
 
@@ -884,8 +896,9 @@ static int dcbnl_bcn_getcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	    !netdev->dcbnl_ops->getbcncfg)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(bcn_tb, DCB_BCN_ATTR_MAX, tb[DCB_ATTR_BCN],
-			       dcbnl_bcn_nest, NULL);
+	ret = nla_parse_nested_deprecated(bcn_tb, DCB_BCN_ATTR_MAX,
+					  tb[DCB_ATTR_BCN], dcbnl_bcn_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -943,8 +956,9 @@ static int dcbnl_bcn_setcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	    !netdev->dcbnl_ops->setbcnrp)
 		return -EOPNOTSUPP;
 
-	ret = nla_parse_nested(data, DCB_BCN_ATTR_MAX, tb[DCB_ATTR_BCN],
-			       dcbnl_pfc_up_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_BCN_ATTR_MAX,
+					  tb[DCB_ATTR_BCN], dcbnl_pfc_up_nest,
+					  NULL);
 	if (ret)
 		return ret;
 
@@ -1429,8 +1443,9 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_IEEE])
 		return -EINVAL;
 
-	err = nla_parse_nested(ieee, DCB_ATTR_IEEE_MAX, tb[DCB_ATTR_IEEE],
-			       dcbnl_ieee_policy, NULL);
+	err = nla_parse_nested_deprecated(ieee, DCB_ATTR_IEEE_MAX,
+					  tb[DCB_ATTR_IEEE],
+					  dcbnl_ieee_policy, NULL);
 	if (err)
 		return err;
 
@@ -1529,8 +1544,9 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_IEEE])
 		return -EINVAL;
 
-	err = nla_parse_nested(ieee, DCB_ATTR_IEEE_MAX, tb[DCB_ATTR_IEEE],
-			       dcbnl_ieee_policy, NULL);
+	err = nla_parse_nested_deprecated(ieee, DCB_ATTR_IEEE_MAX,
+					  tb[DCB_ATTR_IEEE],
+					  dcbnl_ieee_policy, NULL);
 	if (err)
 		return err;
 
@@ -1602,8 +1618,9 @@ static int dcbnl_getfeatcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_FEATCFG])
 		return -EINVAL;
 
-	ret = nla_parse_nested(data, DCB_FEATCFG_ATTR_MAX,
-			       tb[DCB_ATTR_FEATCFG], dcbnl_featcfg_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_FEATCFG_ATTR_MAX,
+					  tb[DCB_ATTR_FEATCFG],
+					  dcbnl_featcfg_nest, NULL);
 	if (ret)
 		return ret;
 
@@ -1646,8 +1663,9 @@ static int dcbnl_setfeatcfg(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!tb[DCB_ATTR_FEATCFG])
 		return -EINVAL;
 
-	ret = nla_parse_nested(data, DCB_FEATCFG_ATTR_MAX,
-			       tb[DCB_ATTR_FEATCFG], dcbnl_featcfg_nest, NULL);
+	ret = nla_parse_nested_deprecated(data, DCB_FEATCFG_ATTR_MAX,
+					  tb[DCB_ATTR_FEATCFG],
+					  dcbnl_featcfg_nest, NULL);
 
 	if (ret)
 		goto err;
@@ -1736,8 +1754,8 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if ((nlh->nlmsg_type == RTM_SETDCB) && !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	ret = nlmsg_parse(nlh, sizeof(*dcb), tb, DCB_ATTR_MAX,
-			  dcbnl_rtnl_policy, extack);
+	ret = nlmsg_parse_deprecated(nlh, sizeof(*dcb), tb, DCB_ATTR_MAX,
+				     dcbnl_rtnl_policy, extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 0962f9201baa..cca7ae712995 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -583,8 +583,8 @@ static int dn_nl_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!net_eq(net, &init_net))
 		goto errout;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, dn_ifa_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     dn_ifa_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -629,8 +629,8 @@ static int dn_nl_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!net_eq(net, &init_net))
 		return -EINVAL;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, dn_ifa_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     dn_ifa_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 6cd3737593a6..96be2df8c565 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -517,8 +517,8 @@ static int dn_fib_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!net_eq(net, &init_net))
 		return -EINVAL;
 
-	err = nlmsg_parse(nlh, sizeof(*r), attrs, RTA_MAX, rtm_dn_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*r), attrs, RTA_MAX,
+				     rtm_dn_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -544,8 +544,8 @@ static int dn_fib_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!net_eq(net, &init_net))
 		return -EINVAL;
 
-	err = nlmsg_parse(nlh, sizeof(*r), attrs, RTA_MAX, rtm_dn_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*r), attrs, RTA_MAX,
+				     rtm_dn_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 950613ee7881..664584763c36 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1651,8 +1651,8 @@ static int dn_cache_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	if (!net_eq(net, &init_net))
 		return -EINVAL;
 
-	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, rtm_dn_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+				     rtm_dn_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 308370cfd668..b392f824df15 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -247,9 +247,11 @@ nl802154_prepare_wpan_dev_dump(struct sk_buff *skb,
 	rtnl_lock();
 
 	if (!cb->args[0]) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl802154_fam.hdrsize,
-				  genl_family_attrbuf(&nl802154_fam),
-				  nl802154_fam.maxattr, nl802154_policy, NULL);
+		err = nlmsg_parse_deprecated(cb->nlh,
+					     GENL_HDRLEN + nl802154_fam.hdrsize,
+					     genl_family_attrbuf(&nl802154_fam),
+					     nl802154_fam.maxattr,
+					     nl802154_policy, NULL);
 		if (err)
 			goto out_unlock;
 
@@ -561,8 +563,10 @@ static int nl802154_dump_wpan_phy_parse(struct sk_buff *skb,
 					struct nl802154_dump_wpan_phy_state *state)
 {
 	struct nlattr **tb = genl_family_attrbuf(&nl802154_fam);
-	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl802154_fam.hdrsize, tb,
-			      nl802154_fam.maxattr, nl802154_policy, NULL);
+	int ret = nlmsg_parse_deprecated(cb->nlh,
+					 GENL_HDRLEN + nl802154_fam.hdrsize,
+					 tb, nl802154_fam.maxattr,
+					 nl802154_policy, NULL);
 
 	/* TODO check if we can handle error here,
 	 * we have no backward compatibility
@@ -1306,8 +1310,7 @@ ieee802154_llsec_parse_dev_addr(struct nlattr *nla,
 {
 	struct nlattr *attrs[NL802154_DEV_ADDR_ATTR_MAX + 1];
 
-	if (!nla || nla_parse_nested(attrs, NL802154_DEV_ADDR_ATTR_MAX, nla,
-				     nl802154_dev_addr_policy, NULL))
+	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_DEV_ADDR_ATTR_MAX, nla, nl802154_dev_addr_policy, NULL))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEV_ADDR_ATTR_PAN_ID] ||
@@ -1346,8 +1349,7 @@ ieee802154_llsec_parse_key_id(struct nlattr *nla,
 {
 	struct nlattr *attrs[NL802154_KEY_ID_ATTR_MAX + 1];
 
-	if (!nla || nla_parse_nested(attrs, NL802154_KEY_ID_ATTR_MAX, nla,
-				     nl802154_key_id_policy, NULL))
+	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_KEY_ID_ATTR_MAX, nla, nl802154_key_id_policy, NULL))
 		return -EINVAL;
 
 	if (!attrs[NL802154_KEY_ID_ATTR_MODE])
@@ -1562,9 +1564,7 @@ static int nl802154_add_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct ieee802154_llsec_key_id id = { };
 	u32 commands[NL802154_CMD_FRAME_NR_IDS / 32] = { };
 
-	if (nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
-			     info->attrs[NL802154_ATTR_SEC_KEY],
-			     nl802154_key_policy, info->extack))
+	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_KEY_ATTR_USAGE_FRAMES] ||
@@ -1612,9 +1612,7 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested(attrs, NL802154_KEY_ATTR_MAX,
-			     info->attrs[NL802154_ATTR_SEC_KEY],
-			     nl802154_key_policy, info->extack))
+	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
@@ -1728,8 +1726,7 @@ ieee802154_llsec_parse_device(struct nlattr *nla,
 {
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 
-	if (!nla || nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
-				     nla, nl802154_dev_policy, NULL))
+	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, nla, nl802154_dev_policy, NULL))
 		return -EINVAL;
 
 	memset(dev, 0, sizeof(*dev));
@@ -1780,9 +1777,7 @@ static int nl802154_del_llsec_dev(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
-			     info->attrs[NL802154_ATTR_SEC_DEVICE],
-			     nl802154_dev_policy, info->extack))
+	if (nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEV_ATTR_EXTENDED_ADDR])
@@ -1908,9 +1903,7 @@ static int nl802154_add_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	__le64 extended_addr;
 
 	if (!info->attrs[NL802154_ATTR_SEC_DEVKEY] ||
-	    nla_parse_nested(attrs, NL802154_DEVKEY_ATTR_MAX,
-			     info->attrs[NL802154_ATTR_SEC_DEVKEY],
-			     nl802154_devkey_policy, info->extack) < 0)
+	    nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack) < 0)
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEVKEY_ATTR_FRAME_COUNTER] ||
@@ -1940,9 +1933,7 @@ static int nl802154_del_llsec_devkey(struct sk_buff *skb, struct genl_info *info
 	struct ieee802154_llsec_device_key key;
 	__le64 extended_addr;
 
-	if (nla_parse_nested(attrs, NL802154_DEVKEY_ATTR_MAX,
-			     info->attrs[NL802154_ATTR_SEC_DEVKEY],
-			     nl802154_devkey_policy, info->extack))
+	if (nla_parse_nested_deprecated(attrs, NL802154_DEVKEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVKEY], nl802154_devkey_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEVKEY_ATTR_EXTENDED_ADDR])
@@ -2062,8 +2053,7 @@ llsec_parse_seclevel(struct nlattr *nla, struct ieee802154_llsec_seclevel *sl)
 {
 	struct nlattr *attrs[NL802154_SECLEVEL_ATTR_MAX + 1];
 
-	if (!nla || nla_parse_nested(attrs, NL802154_SECLEVEL_ATTR_MAX,
-				     nla, nl802154_seclevel_policy, NULL))
+	if (!nla || nla_parse_nested_deprecated(attrs, NL802154_SECLEVEL_ATTR_MAX, nla, nl802154_seclevel_policy, NULL))
 		return -EINVAL;
 
 	memset(sl, 0, sizeof(*sl));
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index eb514f312e6f..701c5d113a34 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -621,8 +621,8 @@ static int inet_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ASSERT_RTNL();
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_ipv4_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     ifa_ipv4_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -793,8 +793,8 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 	struct in_device *in_dev;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_ipv4_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     ifa_ipv4_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -1689,8 +1689,8 @@ static int inet_valid_dump_ifaddr_req(const struct nlmsghdr *nlh,
 		fillargs->flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
-				 ifa_ipv4_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
+					    ifa_ipv4_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -1906,7 +1906,8 @@ static int inet_validate_link_af(const struct net_device *dev,
 	if (dev && !__in_dev_get_rcu(dev))
 		return -EAFNOSUPPORT;
 
-	err = nla_parse_nested(tb, IFLA_INET_MAX, nla, inet_af_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla,
+					  inet_af_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -1934,7 +1935,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla)
 	if (!in_dev)
 		return -EAFNOSUPPORT;
 
-	if (nla_parse_nested(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
 		BUG();
 
 	if (tb[IFLA_INET_CONF]) {
@@ -2076,11 +2077,13 @@ static int inet_netconf_valid_get_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(struct netconfmsg), tb,
-				   NETCONFA_MAX, devconf_ipv4_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(struct netconfmsg),
+					      tb, NETCONFA_MAX,
+					      devconf_ipv4_policy, extack);
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct netconfmsg), tb,
-				 NETCONFA_MAX, devconf_ipv4_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct netconfmsg),
+					    tb, NETCONFA_MAX,
+					    devconf_ipv4_policy, extack);
 	if (err)
 		return err;
 
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index ffbe24397dbe..98f3d74658ae 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -672,8 +672,8 @@ static int rtm_to_fib_config(struct net *net, struct sk_buff *skb,
 	int err, remaining;
 	struct rtmsg *rtm;
 
-	err = nlmsg_validate(nlh, sizeof(*rtm), RTA_MAX, rtm_ipv4_policy,
-			     extack);
+	err = nlmsg_validate_deprecated(nlh, sizeof(*rtm), RTA_MAX,
+					rtm_ipv4_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -839,8 +839,8 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 	filter->rt_type  = rtm->rtm_type;
 	filter->table_id = rtm->rtm_table;
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_ipv4_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_ipv4_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index c3f3d28d1087..30c1c264bdfc 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -239,8 +239,8 @@ static int ip_tun_build_state(struct nlattr *attr,
 	struct nlattr *tb[LWTUNNEL_IP_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, LWTUNNEL_IP_MAX, attr, ip_tun_policy,
-			       extack);
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP_MAX, attr,
+					  ip_tun_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -356,8 +356,8 @@ static int ip6_tun_build_state(struct nlattr *attr,
 	struct nlattr *tb[LWTUNNEL_IP6_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, LWTUNNEL_IP6_MAX, attr, ip6_tun_policy,
-			       extack);
+	err = nla_parse_nested_deprecated(tb, LWTUNNEL_IP6_MAX, attr,
+					  ip6_tun_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2c931120c494..1d8d078fde81 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2499,8 +2499,8 @@ static int ipmr_rtm_valid_getroute_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX,
-				   rtm_ipv4_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					      rtm_ipv4_policy, extack);
 
 	rtm = nlmsg_data(nlh);
 	if ((rtm->rtm_src_len && rtm->rtm_src_len != 32) ||
@@ -2511,8 +2511,8 @@ static int ipmr_rtm_valid_getroute_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_ipv4_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_ipv4_policy, extack);
 	if (err)
 		return err;
 
@@ -2675,8 +2675,8 @@ static int rtm_to_ipmr_mfcc(struct net *net, struct nlmsghdr *nlh,
 	struct rtmsg *rtm;
 	int ret, rem;
 
-	ret = nlmsg_validate(nlh, sizeof(*rtm), RTA_MAX, rtm_ipmr_policy,
-			     extack);
+	ret = nlmsg_validate_deprecated(nlh, sizeof(*rtm), RTA_MAX,
+					rtm_ipmr_policy, extack);
 	if (ret < 0)
 		goto out;
 	rtm = nlmsg_data(nlh);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 7977514d90f5..15a393a0366f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2793,8 +2793,8 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX,
-				   rtm_ipv4_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					      rtm_ipv4_policy, extack);
 
 	rtm = nlmsg_data(nlh);
 	if ((rtm->rtm_src_len && rtm->rtm_src_len != 32) ||
@@ -2812,8 +2812,8 @@ static int inet_rtm_valid_getroute_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_ipv4_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_ipv4_policy, extack);
 	if (err)
 		return err;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2e8d1d2d8d3d..deec3b3dbe73 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -611,11 +611,13 @@ static int inet6_netconf_valid_get_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(struct netconfmsg), tb,
-				   NETCONFA_MAX, devconf_ipv6_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(struct netconfmsg),
+					      tb, NETCONFA_MAX,
+					      devconf_ipv6_policy, extack);
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct netconfmsg), tb,
-				 NETCONFA_MAX, devconf_ipv6_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct netconfmsg),
+					    tb, NETCONFA_MAX,
+					    devconf_ipv6_policy, extack);
 	if (err)
 		return err;
 
@@ -4565,8 +4567,8 @@ inet6_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 ifa_flags;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_ipv6_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     ifa_ipv6_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -4729,8 +4731,8 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ifa6_config cfg;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_ipv6_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     ifa_ipv6_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -5086,8 +5088,8 @@ static int inet6_valid_dump_ifaddr_req(const struct nlmsghdr *nlh,
 		fillargs->flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
-				 ifa_ipv6_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
+					    ifa_ipv6_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -5237,11 +5239,11 @@ static int inet6_rtm_valid_getaddr_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX,
-				   ifa_ipv6_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+					      ifa_ipv6_policy, extack);
 
-	err = nlmsg_parse_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
-				 ifa_ipv6_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
+					    ifa_ipv6_policy, extack);
 	if (err)
 		return err;
 
@@ -5667,8 +5669,8 @@ static int inet6_validate_link_af(const struct net_device *dev,
 	if (dev && !__in6_dev_get(dev))
 		return -EAFNOSUPPORT;
 
-	return nla_parse_nested(tb, IFLA_INET6_MAX, nla, inet6_af_policy,
-				NULL);
+	return nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla,
+					   inet6_af_policy, NULL);
 }
 
 static int check_addr_gen_mode(int mode)
@@ -5700,7 +5702,7 @@ static int inet6_set_link_af(struct net_device *dev, const struct nlattr *nla)
 	if (!idev)
 		return -EAFNOSUPPORT;
 
-	if (nla_parse_nested(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb, IFLA_INET6_MAX, nla, NULL, NULL) < 0)
 		BUG();
 
 	if (tb[IFLA_INET6_TOKEN]) {
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index d43d076c98f5..ae81f4183489 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -383,8 +383,8 @@ static int ip6addrlbl_newdel(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 label;
 	int err = 0;
 
-	err = nlmsg_parse(nlh, sizeof(*ifal), tb, IFAL_MAX, ifal_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifal), tb, IFAL_MAX,
+				     ifal_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -537,8 +537,8 @@ static int ip6addrlbl_valid_get_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*ifal), tb, IFAL_MAX,
-				   ifal_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifal), tb,
+					      IFAL_MAX, ifal_policy, extack);
 
 	ifal = nlmsg_data(nlh);
 	if (ifal->__ifal_reserved || ifal->ifal_flags || ifal->ifal_seq) {
@@ -546,8 +546,8 @@ static int ip6addrlbl_valid_get_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*ifal), tb, IFAL_MAX,
-				 ifal_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifal), tb, IFAL_MAX,
+					    ifal_policy, extack);
 	if (err)
 		return err;
 
diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 3d56a2fb6f86..422dcc691f71 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -146,7 +146,8 @@ static int ila_build_state(struct nlattr *nla,
 	if (family != AF_INET6)
 		return -EINVAL;
 
-	ret = nla_parse_nested(tb, ILA_ATTR_MAX, nla, ila_nl_policy, extack);
+	ret = nla_parse_nested_deprecated(tb, ILA_ATTR_MAX, nla,
+					  ila_nl_policy, extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e0ee30cbd079..fd6d0283c96c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4156,8 +4156,8 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 	unsigned int pref;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, rtm_ipv6_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+				     rtm_ipv6_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -4864,8 +4864,8 @@ static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX,
-				   rtm_ipv6_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					      rtm_ipv6_policy, extack);
 
 	rtm = nlmsg_data(nlh);
 	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
@@ -4881,8 +4881,8 @@ static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_ipv6_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_ipv6_policy, extack);
 	if (err)
 		return err;
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ee5403cbe655..7a525fda8978 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -396,8 +396,8 @@ static int seg6_build_state(struct nlattr *nla,
 	if (family != AF_INET && family != AF_INET6)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, SEG6_IPTUNNEL_MAX, nla,
-			       seg6_iptunnel_policy, extack);
+	err = nla_parse_nested_deprecated(tb, SEG6_IPTUNNEL_MAX, nla,
+					  seg6_iptunnel_policy, extack);
 
 	if (err < 0)
 		return err;
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 60325dbfe88b..5817ea6a065c 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -823,8 +823,9 @@ static int parse_nla_bpf(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	int ret;
 	u32 fd;
 
-	ret = nla_parse_nested(tb, SEG6_LOCAL_BPF_PROG_MAX,
-			       attrs[SEG6_LOCAL_BPF], bpf_prog_policy, NULL);
+	ret = nla_parse_nested_deprecated(tb, SEG6_LOCAL_BPF_PROG_MAX,
+					  attrs[SEG6_LOCAL_BPF],
+					  bpf_prog_policy, NULL);
 	if (ret < 0)
 		return ret;
 
@@ -959,8 +960,8 @@ static int seg6_local_build_state(struct nlattr *nla, unsigned int family,
 	if (family != AF_INET6)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, SEG6_LOCAL_MAX, nla, seg6_local_policy,
-			       extack);
+	err = nla_parse_nested_deprecated(tb, SEG6_LOCAL_MAX, nla,
+					  seg6_local_policy, extack);
 
 	if (err < 0)
 		return err;
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 8120e04f15e4..8f73d0aa6578 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1223,11 +1223,13 @@ static int mpls_netconf_valid_get_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(struct netconfmsg), tb,
-				   NETCONFA_MAX, devconf_mpls_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(struct netconfmsg),
+					      tb, NETCONFA_MAX,
+					      devconf_mpls_policy, extack);
 
-	err = nlmsg_parse_strict(nlh, sizeof(struct netconfmsg), tb,
-				 NETCONFA_MAX, devconf_mpls_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(struct netconfmsg),
+					    tb, NETCONFA_MAX,
+					    devconf_mpls_policy, extack);
 	if (err)
 		return err;
 
@@ -1788,8 +1790,8 @@ static int rtm_to_route_config(struct sk_buff *skb,
 	int index;
 	int err;
 
-	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, rtm_mpls_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+				     rtm_mpls_policy, extack);
 	if (err < 0)
 		goto errout;
 
@@ -2106,8 +2108,8 @@ static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_mpls_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_mpls_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2290,8 +2292,8 @@ static int mpls_valid_getroute_req(struct sk_buff *skb,
 	}
 
 	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX,
-				   rtm_mpls_policy, extack);
+		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					      rtm_mpls_policy, extack);
 
 	rtm = nlmsg_data(nlh);
 	if ((rtm->rtm_dst_len && rtm->rtm_dst_len != 20) ||
@@ -2306,8 +2308,8 @@ static int mpls_valid_getroute_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	err = nlmsg_parse_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-				 rtm_mpls_policy, extack);
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_mpls_policy, extack);
 	if (err)
 		return err;
 
diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index f3a8557494d6..6874d2c63365 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -174,8 +174,8 @@ static int mpls_build_state(struct nlattr *nla,
 	u8 n_labels;
 	int ret;
 
-	ret = nla_parse_nested(tb, MPLS_IPTUNNEL_MAX, nla,
-			       mpls_iptunnel_policy, extack);
+	ret = nla_parse_nested_deprecated(tb, MPLS_IPTUNNEL_MAX, nla,
+					  mpls_iptunnel_policy, extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index 367b2f6513e0..be23644ec7ef 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -220,8 +220,8 @@ static int ncsi_pkg_info_all_nl(struct sk_buff *skb,
 	void *hdr;
 	int rc;
 
-	rc = genlmsg_parse(cb->nlh, &ncsi_genl_family, attrs, NCSI_ATTR_MAX,
-			   ncsi_genl_policy, NULL);
+	rc = genlmsg_parse_deprecated(cb->nlh, &ncsi_genl_family, attrs, NCSI_ATTR_MAX,
+				      ncsi_genl_policy, NULL);
 	if (rc)
 		return rc;
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 45a257695bef..3f4a4936f63c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -299,8 +299,7 @@ ip_set_get_ipaddr4(struct nlattr *nla,  __be32 *ipaddr)
 
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
-	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
-			     ipaddr_policy, NULL))
+	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV4)))
 		return -IPSET_ERR_PROTOCOL;
@@ -318,8 +317,7 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 	if (unlikely(!flag_nested(nla)))
 		return -IPSET_ERR_PROTOCOL;
 
-	if (nla_parse_nested(tb, IPSET_ATTR_IPADDR_MAX, nla,
-			     ipaddr_policy, NULL))
+	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_IPADDR_MAX, nla, ipaddr_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_IPADDR_IPV6)))
 		return -IPSET_ERR_PROTOCOL;
@@ -939,8 +937,7 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 
 	/* Without holding any locks, create private part. */
 	if (attr[IPSET_ATTR_DATA] &&
-	    nla_parse_nested(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA],
-			     set->type->create_policy, NULL)) {
+	    nla_parse_nested_deprecated(tb, IPSET_ATTR_CREATE_MAX, attr[IPSET_ATTR_DATA], set->type->create_policy, NULL)) {
 		ret = -IPSET_ERR_PROTOCOL;
 		goto put_out;
 	}
@@ -1298,8 +1295,9 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	ip_set_id_t index;
 
 	/* Second pass, so parser can't fail */
-	nla_parse(cda, IPSET_ATTR_CMD_MAX, attr, nlh->nlmsg_len - min_len,
-		  ip_set_setname_policy, NULL);
+	nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
+			     nlh->nlmsg_len - min_len, ip_set_setname_policy,
+			     NULL);
 
 	cb->args[IPSET_CB_PROTO] = nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
@@ -1546,8 +1544,9 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-			  nlh->nlmsg_len - min_len, ip_set_adt_policy, NULL);
+		nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+				     nlh->nlmsg_len - min_len,
+				     ip_set_adt_policy, NULL);
 
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
@@ -1592,9 +1591,7 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
 	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX,
-				     attr[IPSET_ATTR_DATA],
-				     set->type->adt_policy, NULL))
+		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
 		ret = call_ad(ctnl, skb, set, tb, IPSET_ADD, flags,
 			      use_lineno);
@@ -1605,8 +1602,7 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			memset(tb, 0, sizeof(tb));
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
-			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
-					     set->type->adt_policy, NULL))
+			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
 			ret = call_ad(ctnl, skb, set, tb, IPSET_ADD,
 				      flags, use_lineno);
@@ -1647,9 +1643,7 @@ static int ip_set_udel(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 	use_lineno = !!attr[IPSET_ATTR_LINENO];
 	if (attr[IPSET_ATTR_DATA]) {
-		if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX,
-				     attr[IPSET_ATTR_DATA],
-				     set->type->adt_policy, NULL))
+		if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
 		ret = call_ad(ctnl, skb, set, tb, IPSET_DEL, flags,
 			      use_lineno);
@@ -1660,8 +1654,7 @@ static int ip_set_udel(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			memset(tb, 0, sizeof(*tb));
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
-			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
-					     set->type->adt_policy, NULL))
+			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
 			ret = call_ad(ctnl, skb, set, tb, IPSET_DEL,
 				      flags, use_lineno);
@@ -1692,8 +1685,7 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	if (!set)
 		return -ENOENT;
 
-	if (nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA],
-			     set->type->adt_policy, NULL))
+	if (nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, attr[IPSET_ATTR_DATA], set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 
 	rcu_read_lock_bh();
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 4b933669fd83..38cdebae322d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3095,8 +3095,7 @@ static int ip_vs_genl_parse_service(struct netns_ipvs *ipvs,
 
 	/* Parse mandatory identifying service fields first */
 	if (nla == NULL ||
-	    nla_parse_nested(attrs, IPVS_SVC_ATTR_MAX, nla,
-			     ip_vs_svc_policy, NULL))
+	    nla_parse_nested_deprecated(attrs, IPVS_SVC_ATTR_MAX, nla, ip_vs_svc_policy, NULL))
 		return -EINVAL;
 
 	nla_af		= attrs[IPVS_SVC_ATTR_AF];
@@ -3254,8 +3253,7 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
 	mutex_lock(&__ip_vs_mutex);
 
 	/* Try to find the service for which to dump destinations */
-	if (nlmsg_parse(cb->nlh, GENL_HDRLEN, attrs, IPVS_CMD_ATTR_MAX,
-			ip_vs_cmd_policy, cb->extack))
+	if (nlmsg_parse_deprecated(cb->nlh, GENL_HDRLEN, attrs, IPVS_CMD_ATTR_MAX, ip_vs_cmd_policy, cb->extack))
 		goto out_err;
 
 
@@ -3291,8 +3289,7 @@ static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
 
 	/* Parse mandatory identifying destination fields first */
 	if (nla == NULL ||
-	    nla_parse_nested(attrs, IPVS_DEST_ATTR_MAX, nla,
-			     ip_vs_dest_policy, NULL))
+	    nla_parse_nested_deprecated(attrs, IPVS_DEST_ATTR_MAX, nla, ip_vs_dest_policy, NULL))
 		return -EINVAL;
 
 	nla_addr	= attrs[IPVS_DEST_ATTR_ADDR];
@@ -3528,9 +3525,7 @@ static int ip_vs_genl_set_daemon(struct sk_buff *skb, struct genl_info *info)
 		struct nlattr *daemon_attrs[IPVS_DAEMON_ATTR_MAX + 1];
 
 		if (!info->attrs[IPVS_CMD_ATTR_DAEMON] ||
-		    nla_parse_nested(daemon_attrs, IPVS_DAEMON_ATTR_MAX,
-				     info->attrs[IPVS_CMD_ATTR_DAEMON],
-				     ip_vs_daemon_policy, info->extack))
+		    nla_parse_nested_deprecated(daemon_attrs, IPVS_DAEMON_ATTR_MAX, info->attrs[IPVS_CMD_ATTR_DAEMON], ip_vs_daemon_policy, info->extack))
 			goto out;
 
 		if (cmd == IPVS_CMD_NEW_DAEMON)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 66c596d287a5..888fc83adbd4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1017,12 +1017,12 @@ static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
 	struct nlattr *tb[CTA_IP_MAX+1];
 	int ret = 0;
 
-	ret = nla_parse_nested(tb, CTA_IP_MAX, attr, NULL, NULL);
+	ret = nla_parse_nested_deprecated(tb, CTA_IP_MAX, attr, NULL, NULL);
 	if (ret < 0)
 		return ret;
 
-	ret = nla_validate_nested(attr, CTA_IP_MAX,
-				  cta_ip_nla_policy, NULL);
+	ret = nla_validate_nested_deprecated(attr, CTA_IP_MAX,
+					     cta_ip_nla_policy, NULL);
 	if (ret)
 		return ret;
 
@@ -1049,8 +1049,8 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	struct nlattr *tb[CTA_PROTO_MAX+1];
 	int ret = 0;
 
-	ret = nla_parse_nested(tb, CTA_PROTO_MAX, attr, proto_nla_policy,
-			       NULL);
+	ret = nla_parse_nested_deprecated(tb, CTA_PROTO_MAX, attr,
+					  proto_nla_policy, NULL);
 	if (ret < 0)
 		return ret;
 
@@ -1062,8 +1062,9 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	l4proto = nf_ct_l4proto_find(tuple->dst.protonum);
 
 	if (likely(l4proto->nlattr_to_tuple)) {
-		ret = nla_validate_nested(attr, CTA_PROTO_MAX,
-					  l4proto->nla_policy, NULL);
+		ret = nla_validate_nested_deprecated(attr, CTA_PROTO_MAX,
+						     l4proto->nla_policy,
+						     NULL);
 		if (ret == 0)
 			ret = l4proto->nlattr_to_tuple(tb, tuple);
 	}
@@ -1126,8 +1127,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 
 	memset(tuple, 0, sizeof(*tuple));
 
-	err = nla_parse_nested(tb, CTA_TUPLE_MAX, cda[type], tuple_nla_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_TUPLE_MAX, cda[type],
+					  tuple_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -1177,7 +1178,8 @@ static int ctnetlink_parse_help(const struct nlattr *attr, char **helper_name,
 	int err;
 	struct nlattr *tb[CTA_HELP_MAX+1];
 
-	err = nla_parse_nested(tb, CTA_HELP_MAX, attr, help_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_HELP_MAX, attr,
+					  help_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -1717,8 +1719,8 @@ static int ctnetlink_change_protoinfo(struct nf_conn *ct,
 	struct nlattr *tb[CTA_PROTOINFO_MAX+1];
 	int err = 0;
 
-	err = nla_parse_nested(tb, CTA_PROTOINFO_MAX, attr, protoinfo_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_PROTOINFO_MAX, attr,
+					  protoinfo_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -1741,7 +1743,8 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	int err;
 	struct nlattr *cda[CTA_SEQADJ_MAX+1];
 
-	err = nla_parse_nested(cda, CTA_SEQADJ_MAX, attr, seqadj_policy, NULL);
+	err = nla_parse_nested_deprecated(cda, CTA_SEQADJ_MAX, attr,
+					  seqadj_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -1818,8 +1821,9 @@ static int ctnetlink_change_synproxy(struct nf_conn *ct,
 	if (!synproxy)
 		return 0;
 
-	err = nla_parse_nested(tb, CTA_SYNPROXY_MAX, cda[CTA_SYNPROXY],
-			       synproxy_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_SYNPROXY_MAX,
+					  cda[CTA_SYNPROXY], synproxy_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
@@ -2549,7 +2553,8 @@ ctnetlink_glue_parse(const struct nlattr *attr, struct nf_conn *ct)
 	struct nlattr *cda[CTA_MAX+1];
 	int ret;
 
-	ret = nla_parse_nested(cda, CTA_MAX, attr, ct_nla_policy, NULL);
+	ret = nla_parse_nested_deprecated(cda, CTA_MAX, attr, ct_nla_policy,
+					  NULL);
 	if (ret < 0)
 		return ret;
 
@@ -2582,8 +2587,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	struct nf_conntrack_expect *exp;
 	int err;
 
-	err = nla_parse_nested(cda, CTA_EXPECT_MAX, attr, exp_nla_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(cda, CTA_EXPECT_MAX, attr,
+					  exp_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -3185,8 +3190,8 @@ ctnetlink_parse_expect_nat(const struct nlattr *attr,
 	struct nf_conntrack_tuple nat_tuple = {};
 	int err;
 
-	err = nla_parse_nested(tb, CTA_EXPECT_NAT_MAX, attr,
-			       exp_nat_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_EXPECT_NAT_MAX, attr,
+					  exp_nat_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 6fca80587505..1b033495b310 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -639,8 +639,8 @@ static int nlattr_to_dccp(struct nlattr *cda[], struct nf_conn *ct)
 	if (!attr)
 		return 0;
 
-	err = nla_parse_nested(tb, CTA_PROTOINFO_DCCP_MAX, attr,
-			       dccp_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_PROTOINFO_DCCP_MAX, attr,
+					  dccp_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index a7818101ad80..4483ec169ec3 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -563,8 +563,8 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 	if (!attr)
 		return 0;
 
-	err = nla_parse_nested(tb, CTA_PROTOINFO_SCTP_MAX, attr,
-			       sctp_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_PROTOINFO_SCTP_MAX, attr,
+					  sctp_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a06875a466a4..78766fc298e0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1248,8 +1248,8 @@ static int nlattr_to_tcp(struct nlattr *cda[], struct nf_conn *ct)
 	if (!pattr)
 		return 0;
 
-	err = nla_parse_nested(tb, CTA_PROTOINFO_TCP_MAX, pattr,
-			       tcp_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_PROTOINFO_TCP_MAX, pattr,
+					  tcp_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af7dc6537758..da6ec6691d28 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -885,8 +885,8 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 	struct nlattr *tb[CTA_PROTONAT_MAX+1];
 	int err;
 
-	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr,
-			       protonat_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_PROTONAT_MAX, attr,
+					  protonat_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -944,7 +944,8 @@ nfnetlink_parse_nat(const struct nlattr *nat,
 
 	memset(range, 0, sizeof(*range));
 
-	err = nla_parse_nested(tb, CTA_NAT_MAX, nat, nat_nla_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, CTA_NAT_MAX, nat,
+					  nat_nla_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7772e976cc..ffa171a41478 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1421,8 +1421,8 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	struct nft_stats *stats;
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_COUNTER_MAX, attr, nft_counter_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_COUNTER_MAX, attr,
+					  nft_counter_policy, NULL);
 	if (err < 0)
 		return ERR_PTR(err);
 
@@ -1526,8 +1526,9 @@ static int nft_chain_parse_hook(struct net *net,
 	lockdep_assert_held(&net->nft.commit_mutex);
 	lockdep_nfnl_nft_mutex_not_held();
 
-	err = nla_parse_nested(ha, NFTA_HOOK_MAX, nla[NFTA_CHAIN_HOOK],
-			       nft_hook_policy, NULL);
+	err = nla_parse_nested_deprecated(ha, NFTA_HOOK_MAX,
+					  nla[NFTA_CHAIN_HOOK],
+					  nft_hook_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -2105,7 +2106,8 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	struct nlattr *tb[NFTA_EXPR_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_EXPR_MAX, nla, nft_expr_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_EXPR_MAX, nla,
+					  nft_expr_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -2114,8 +2116,9 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 		return PTR_ERR(type);
 
 	if (tb[NFTA_EXPR_DATA]) {
-		err = nla_parse_nested(info->tb, type->maxattr,
-				       tb[NFTA_EXPR_DATA], type->policy, NULL);
+		err = nla_parse_nested_deprecated(info->tb, type->maxattr,
+						  tb[NFTA_EXPR_DATA],
+						  type->policy, NULL);
 		if (err < 0)
 			goto err1;
 	} else
@@ -3446,8 +3449,8 @@ static int nf_tables_set_desc_parse(const struct nft_ctx *ctx,
 	struct nlattr *da[NFTA_SET_DESC_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(da, NFTA_SET_DESC_MAX, nla,
-			       nft_set_desc_policy, NULL);
+	err = nla_parse_nested_deprecated(da, NFTA_SET_DESC_MAX, nla,
+					  nft_set_desc_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -4174,8 +4177,8 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	void *priv;
 	int err;
 
-	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
-			       nft_set_elem_policy, NULL);
+	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
+					  nft_set_elem_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -4406,8 +4409,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	u8 ulen;
 	int err;
 
-	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
-			       nft_set_elem_policy, NULL);
+	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
+					  nft_set_elem_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -4700,8 +4703,8 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	void *priv;
 	int err;
 
-	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
-			       nft_set_elem_policy, NULL);
+	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
+					  nft_set_elem_policy, NULL);
 	if (err < 0)
 		goto err1;
 
@@ -4975,8 +4978,8 @@ static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
 		goto err1;
 
 	if (attr) {
-		err = nla_parse_nested(tb, type->maxattr, attr, type->policy,
-				       NULL);
+		err = nla_parse_nested_deprecated(tb, type->maxattr, attr,
+						  type->policy, NULL);
 		if (err < 0)
 			goto err2;
 	} else {
@@ -5552,8 +5555,8 @@ static int nf_tables_flowtable_parse_hook(const struct nft_ctx *ctx,
 	int hooknum, priority;
 	int err, n = 0, i;
 
-	err = nla_parse_nested(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
-			       nft_flowtable_hook_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_FLOWTABLE_HOOK_MAX, attr,
+					  nft_flowtable_hook_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -7210,8 +7213,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 	struct nft_chain *chain;
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_VERDICT_MAX, nla, nft_verdict_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_VERDICT_MAX, nla,
+					  nft_verdict_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -7341,7 +7344,8 @@ int nft_data_init(const struct nft_ctx *ctx,
 	struct nlattr *tb[NFTA_DATA_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_DATA_MAX, nla, nft_data_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_DATA_MAX, nla,
+					  nft_data_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 916913454624..92077d459109 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -206,8 +206,9 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENOMEM;
 		}
 
-		err = nla_parse(cda, ss->cb[cb_id].attr_count, attr, attrlen,
-				ss->cb[cb_id].policy, extack);
+		err = nla_parse_deprecated(cda, ss->cb[cb_id].attr_count,
+					   attr, attrlen,
+					   ss->cb[cb_id].policy, extack);
 		if (err < 0) {
 			rcu_read_unlock();
 			return err;
@@ -421,8 +422,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 				goto ack;
 			}
 
-			err = nla_parse(cda, ss->cb[cb_id].attr_count, attr,
-					attrlen, ss->cb[cb_id].policy, NULL);
+			err = nla_parse_deprecated(cda,
+						   ss->cb[cb_id].attr_count,
+						   attr, attrlen,
+						   ss->cb[cb_id].policy, NULL);
 			if (err < 0)
 				goto ack;
 
@@ -520,8 +523,8 @@ static void nfnetlink_rcv_skb_batch(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (skb->len < NLMSG_HDRLEN + sizeof(struct nfgenmsg))
 		return;
 
-	err = nla_parse(cda, NFNL_BATCH_MAX, attr, attrlen, nfnl_batch_policy,
-			NULL);
+	err = nla_parse_deprecated(cda, NFNL_BATCH_MAX, attr, attrlen,
+				   nfnl_batch_policy, NULL);
 	if (err < 0) {
 		netlink_ack(skb, nlh, err, NULL);
 		return;
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 8fa8bf7c48e6..02c877432d71 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -248,8 +248,8 @@ static int nfnl_acct_start(struct netlink_callback *cb)
 	if (!attr)
 		return 0;
 
-	err = nla_parse_nested(tb, NFACCT_FILTER_MAX, attr, filter_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, NFACCT_FILTER_MAX, attr,
+					  filter_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index e5d27b2e4eba..01a51df83975 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -78,8 +78,8 @@ nfnl_cthelper_parse_tuple(struct nf_conntrack_tuple *tuple,
 	int err;
 	struct nlattr *tb[NFCTH_TUPLE_MAX+1];
 
-	err = nla_parse_nested(tb, NFCTH_TUPLE_MAX, attr,
-			       nfnl_cthelper_tuple_pol, NULL);
+	err = nla_parse_nested_deprecated(tb, NFCTH_TUPLE_MAX, attr,
+					  nfnl_cthelper_tuple_pol, NULL);
 	if (err < 0)
 		return err;
 
@@ -139,8 +139,8 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 	int err;
 	struct nlattr *tb[NFCTH_POLICY_MAX+1];
 
-	err = nla_parse_nested(tb, NFCTH_POLICY_MAX, attr,
-			       nfnl_cthelper_expect_pol, NULL);
+	err = nla_parse_nested_deprecated(tb, NFCTH_POLICY_MAX, attr,
+					  nfnl_cthelper_expect_pol, NULL);
 	if (err < 0)
 		return err;
 
@@ -176,8 +176,9 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
 	struct nlattr *tb[NFCTH_POLICY_SET_MAX+1];
 	unsigned int class_max;
 
-	ret = nla_parse_nested(tb, NFCTH_POLICY_SET_MAX, attr,
-			       nfnl_cthelper_expect_policy_set, NULL);
+	ret = nla_parse_nested_deprecated(tb, NFCTH_POLICY_SET_MAX, attr,
+					  nfnl_cthelper_expect_policy_set,
+					  NULL);
 	if (ret < 0)
 		return ret;
 
@@ -289,8 +290,8 @@ nfnl_cthelper_update_policy_one(const struct nf_conntrack_expect_policy *policy,
 	struct nlattr *tb[NFCTH_POLICY_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFCTH_POLICY_MAX, attr,
-			       nfnl_cthelper_expect_pol, NULL);
+	err = nla_parse_nested_deprecated(tb, NFCTH_POLICY_MAX, attr,
+					  nfnl_cthelper_expect_pol, NULL);
 	if (err < 0)
 		return err;
 
@@ -361,8 +362,9 @@ static int nfnl_cthelper_update_policy(struct nf_conntrack_helper *helper,
 	unsigned int class_max;
 	int err;
 
-	err = nla_parse_nested(tb, NFCTH_POLICY_SET_MAX, attr,
-			       nfnl_cthelper_expect_policy_set, NULL);
+	err = nla_parse_nested_deprecated(tb, NFCTH_POLICY_SET_MAX, attr,
+					  nfnl_cthelper_expect_policy_set,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index c69b11ca5aad..6b677a8813f7 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -59,8 +59,11 @@ ctnl_timeout_parse_policy(void *timeout,
 	if (!tb)
 		return -ENOMEM;
 
-	ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max, attr,
-			       l4proto->ctnl_timeout.nla_policy, NULL);
+	ret = nla_parse_nested_deprecated(tb,
+					  l4proto->ctnl_timeout.nlattr_max,
+					  attr,
+					  l4proto->ctnl_timeout.nla_policy,
+					  NULL);
 	if (ret < 0)
 		goto err;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0dcc3592d053..e13cb6dcbf2e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1139,8 +1139,9 @@ static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 		struct nlattr *tb[NFQA_VLAN_MAX + 1];
 		int err;
 
-		err = nla_parse_nested(tb, NFQA_VLAN_MAX, nfqa[NFQA_VLAN],
-				       nfqa_vlan_policy, NULL);
+		err = nla_parse_nested_deprecated(tb, NFQA_VLAN_MAX,
+						  nfqa[NFQA_VLAN],
+						  nfqa_vlan_policy, NULL);
 		if (err < 0)
 			return err;
 
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 469f9da5073b..276f1f2d6de1 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -198,8 +198,8 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	u32 flags;
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_RULE_COMPAT_MAX, attr,
-			       nft_rule_compat_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_RULE_COMPAT_MAX, attr,
+					  nft_rule_compat_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 7b717fad6cdc..95cb98c0a07e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -797,9 +797,11 @@ nft_ct_timeout_parse_policy(void *timeouts,
 	if (!tb)
 		return -ENOMEM;
 
-	ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max,
-			       attr, l4proto->ctnl_timeout.nla_policy,
-			       NULL);
+	ret = nla_parse_nested_deprecated(tb,
+					  l4proto->ctnl_timeout.nlattr_max,
+					  attr,
+					  l4proto->ctnl_timeout.nla_policy,
+					  NULL);
 	if (ret < 0)
 		goto err;
 
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index b113fcac94e1..25703c4ed3c7 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -166,8 +166,8 @@ static int nft_tunnel_obj_ip_init(const struct nft_ctx *ctx,
 	struct nlattr *tb[NFTA_TUNNEL_KEY_IP_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_IP_MAX, attr,
-			       nft_tunnel_ip_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_IP_MAX, attr,
+					  nft_tunnel_ip_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -195,8 +195,8 @@ static int nft_tunnel_obj_ip6_init(const struct nft_ctx *ctx,
 	struct nlattr *tb[NFTA_TUNNEL_KEY_IP6_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_IP6_MAX, attr,
-			       nft_tunnel_ip6_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_IP6_MAX, attr,
+					  nft_tunnel_ip6_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -231,8 +231,8 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 	struct nlattr *tb[NFTA_TUNNEL_KEY_VXLAN_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_VXLAN_MAX, attr,
-			       nft_tunnel_opts_vxlan_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_VXLAN_MAX, attr,
+					  nft_tunnel_opts_vxlan_policy, NULL);
 	if (err < 0)
 		return err;
 
@@ -260,8 +260,9 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	uint8_t hwid, dir;
 	int err, version;
 
-	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_ERSPAN_MAX, attr,
-			       nft_tunnel_opts_erspan_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_ERSPAN_MAX,
+					  attr, nft_tunnel_opts_erspan_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
@@ -309,8 +310,8 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1];
 	int err;
 
-	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_OPTS_MAX, attr,
-			       nft_tunnel_opts_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_OPTS_MAX, attr,
+					  nft_tunnel_opts_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index ba7800f94ccc..142aac44705b 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -99,9 +99,10 @@ static int netlbl_cipsov4_add_common(struct genl_info *info,
 
 	doi_def->doi = nla_get_u32(info->attrs[NLBL_CIPSOV4_A_DOI]);
 
-	if (nla_validate_nested(info->attrs[NLBL_CIPSOV4_A_TAGLST],
-				NLBL_CIPSOV4_A_MAX,
-				netlbl_cipsov4_genl_policy, NULL) != 0)
+	if (nla_validate_nested_deprecated(info->attrs[NLBL_CIPSOV4_A_TAGLST],
+					   NLBL_CIPSOV4_A_MAX,
+					   netlbl_cipsov4_genl_policy,
+					   NULL) != 0)
 		return -EINVAL;
 
 	nla_for_each_nested(nla, info->attrs[NLBL_CIPSOV4_A_TAGLST], nla_rem)
@@ -146,9 +147,10 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 	    !info->attrs[NLBL_CIPSOV4_A_MLSLVLLST])
 		return -EINVAL;
 
-	if (nla_validate_nested(info->attrs[NLBL_CIPSOV4_A_MLSLVLLST],
-				NLBL_CIPSOV4_A_MAX,
-				netlbl_cipsov4_genl_policy, NULL) != 0)
+	if (nla_validate_nested_deprecated(info->attrs[NLBL_CIPSOV4_A_MLSLVLLST],
+					   NLBL_CIPSOV4_A_MAX,
+					   netlbl_cipsov4_genl_policy,
+					   NULL) != 0)
 		return -EINVAL;
 
 	doi_def = kmalloc(sizeof(*doi_def), GFP_KERNEL);
@@ -170,9 +172,10 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 			    info->attrs[NLBL_CIPSOV4_A_MLSLVLLST],
 			    nla_a_rem)
 		if (nla_type(nla_a) == NLBL_CIPSOV4_A_MLSLVL) {
-			if (nla_validate_nested(nla_a, NLBL_CIPSOV4_A_MAX,
-						netlbl_cipsov4_genl_policy,
-						NULL) != 0)
+			if (nla_validate_nested_deprecated(nla_a,
+							   NLBL_CIPSOV4_A_MAX,
+							   netlbl_cipsov4_genl_policy,
+							   NULL) != 0)
 				goto add_std_failure;
 			nla_for_each_nested(nla_b, nla_a, nla_b_rem)
 				switch (nla_type(nla_b)) {
@@ -234,19 +237,20 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 
 	if (info->attrs[NLBL_CIPSOV4_A_MLSCATLST]) {
-		if (nla_validate_nested(info->attrs[NLBL_CIPSOV4_A_MLSCATLST],
-					NLBL_CIPSOV4_A_MAX,
-					netlbl_cipsov4_genl_policy, NULL) != 0)
+		if (nla_validate_nested_deprecated(info->attrs[NLBL_CIPSOV4_A_MLSCATLST],
+						   NLBL_CIPSOV4_A_MAX,
+						   netlbl_cipsov4_genl_policy,
+						   NULL) != 0)
 			goto add_std_failure;
 
 		nla_for_each_nested(nla_a,
 				    info->attrs[NLBL_CIPSOV4_A_MLSCATLST],
 				    nla_a_rem)
 			if (nla_type(nla_a) == NLBL_CIPSOV4_A_MLSCAT) {
-				if (nla_validate_nested(nla_a,
-							NLBL_CIPSOV4_A_MAX,
-							netlbl_cipsov4_genl_policy,
-							NULL) != 0)
+				if (nla_validate_nested_deprecated(nla_a,
+								   NLBL_CIPSOV4_A_MAX,
+								   netlbl_cipsov4_genl_policy,
+								   NULL) != 0)
 					goto add_std_failure;
 				nla_for_each_nested(nla_b, nla_a, nla_b_rem)
 					switch (nla_type(nla_b)) {
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 288456090710..bcd3867bd52e 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -577,8 +577,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 		attrbuf = family->attrbuf;
 
 	if (attrbuf) {
-		err = nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
-				  family->policy, extack);
+		err = nlmsg_parse_deprecated(nlh, hdrlen, attrbuf,
+					     family->maxattr, family->policy,
+					     extack);
 		if (err < 0)
 			goto out;
 	}
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 4d9f3ac8d562..5f66b9dd85e5 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -119,9 +119,10 @@ static struct nfc_dev *__get_device_from_cb(struct netlink_callback *cb)
 	int rc;
 	u32 idx;
 
-	rc = nlmsg_parse(cb->nlh, GENL_HDRLEN + nfc_genl_family.hdrsize,
-			 attrbuf, nfc_genl_family.maxattr, nfc_genl_policy,
-			 NULL);
+	rc = nlmsg_parse_deprecated(cb->nlh,
+				    GENL_HDRLEN + nfc_genl_family.hdrsize,
+				    attrbuf, nfc_genl_family.maxattr,
+				    nfc_genl_policy, NULL);
 	if (rc < 0)
 		return ERR_PTR(rc);
 
@@ -1177,8 +1178,9 @@ static int nfc_genl_llc_sdreq(struct sk_buff *skb, struct genl_info *info)
 	tlvs_len = 0;
 
 	nla_for_each_nested(attr, info->attrs[NFC_ATTR_LLC_SDP], rem) {
-		rc = nla_parse_nested(sdp_attrs, NFC_SDP_ATTR_MAX, attr,
-				      nfc_sdp_genl_policy, info->extack);
+		rc = nla_parse_nested_deprecated(sdp_attrs, NFC_SDP_ATTR_MAX,
+						 attr, nfc_sdp_genl_policy,
+						 info->extack);
 
 		if (rc != 0) {
 			rc = -EINVAL;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index a64d3eb1f9a9..361d8d175f74 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1374,8 +1374,8 @@ static int ovs_flow_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	u32 ufid_flags;
 	int err;
 
-	err = genlmsg_parse(cb->nlh, &dp_flow_genl_family, a,
-			    OVS_FLOW_ATTR_MAX, flow_policy, NULL);
+	err = genlmsg_parse_deprecated(cb->nlh, &dp_flow_genl_family, a,
+				       OVS_FLOW_ATTR_MAX, flow_policy, NULL);
 	if (err)
 		return err;
 	ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index bd019058fc6f..5b7e9a2a3c8a 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2853,8 +2853,8 @@ static int validate_userspace(const struct nlattr *attr)
 	struct nlattr *a[OVS_USERSPACE_ATTR_MAX + 1];
 	int error;
 
-	error = nla_parse_nested(a, OVS_USERSPACE_ATTR_MAX, attr,
-				 userspace_policy, NULL);
+	error = nla_parse_nested_deprecated(a, OVS_USERSPACE_ATTR_MAX, attr,
+					    userspace_policy, NULL);
 	if (error)
 		return error;
 
@@ -2884,8 +2884,9 @@ static int validate_and_copy_check_pkt_len(struct net *net,
 	int nested_acts_start;
 	int start, err;
 
-	err = nla_parse_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX, nla_data(attr),
-			       nla_len(attr), cpl_policy, NULL);
+	err = nla_parse_deprecated_strict(a, OVS_CHECK_PKT_LEN_ATTR_MAX,
+					  nla_data(attr), nla_len(attr),
+					  cpl_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 0be3d097ae01..1e9fe14d5ea6 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -227,9 +227,9 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
 		struct nlattr *attr[OVS_BAND_ATTR_MAX + 1];
 		u32 band_max_delta_t;
 
-		err = nla_parse((struct nlattr **)&attr, OVS_BAND_ATTR_MAX,
-				nla_data(nla), nla_len(nla), band_policy,
-				NULL);
+		err = nla_parse_deprecated((struct nlattr **)&attr,
+					   OVS_BAND_ATTR_MAX, nla_data(nla),
+					   nla_len(nla), band_policy, NULL);
 		if (err)
 			goto exit_free_meter;
 
diff --git a/net/openvswitch/vport-vxlan.c b/net/openvswitch/vport-vxlan.c
index 8f16f11f7ad3..76e7c38d8dc9 100644
--- a/net/openvswitch/vport-vxlan.c
+++ b/net/openvswitch/vport-vxlan.c
@@ -70,8 +70,8 @@ static int vxlan_configure_exts(struct vport *vport, struct nlattr *attr,
 	if (nla_len(attr) < sizeof(struct nlattr))
 		return -EINVAL;
 
-	err = nla_parse_nested(exts, OVS_VXLAN_EXT_MAX, attr, exts_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(exts, OVS_VXLAN_EXT_MAX, attr,
+					  exts_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 871eaf2cb85e..be92d936b5d5 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -79,8 +79,8 @@ static int addr_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ASSERT_RTNL();
 
-	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_phonet_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				     ifa_phonet_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -246,8 +246,8 @@ static int route_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ASSERT_RTNL();
 
-	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, rtm_phonet_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+				     rtm_phonet_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b37e6e0a1026..ca3f1acfe48f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1093,7 +1093,8 @@ static int qrtr_addr_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	ASSERT_RTNL();
 
-	rc = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, qrtr_policy, extack);
+	rc = nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+				    qrtr_policy, extack);
 	if (rc < 0)
 		return rc;
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5a87e271d35a..1c630da4be0d 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -849,7 +849,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	int err;
 
 	if (name == NULL) {
-		err = nla_parse_nested(tb, TCA_ACT_MAX, nla, NULL, extack);
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL,
+						  extack);
 		if (err < 0)
 			goto err_out;
 		err = -EINVAL;
@@ -964,7 +965,8 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	int err;
 	int i;
 
-	err = nla_parse_nested(tb, TCA_ACT_MAX_PRIO, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
+					  extack);
 	if (err < 0)
 		return err;
 
@@ -1099,7 +1101,7 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 	int index;
 	int err;
 
-	err = nla_parse_nested(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1153,7 +1155,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 
 	b = skb_tail_pointer(skb);
 
-	err = nla_parse_nested(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1282,7 +1284,8 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 	size_t attr_size = 0;
 	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
 
-	ret = nla_parse_nested(tb, TCA_ACT_MAX_PRIO, nla, NULL, extack);
+	ret = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
+					  extack);
 	if (ret < 0)
 		return ret;
 
@@ -1384,8 +1387,8 @@ static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
 	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	ret = nlmsg_parse(n, sizeof(struct tcamsg), tca, TCA_ROOT_MAX, NULL,
-			  extack);
+	ret = nlmsg_parse_deprecated(n, sizeof(struct tcamsg), tca,
+				     TCA_ROOT_MAX, NULL, extack);
 	if (ret < 0)
 		return ret;
 
@@ -1436,13 +1439,12 @@ static struct nlattr *find_dump_kind(struct nlattr **nla)
 	if (tb1 == NULL)
 		return NULL;
 
-	if (nla_parse(tb, TCA_ACT_MAX_PRIO, nla_data(tb1),
-		      NLMSG_ALIGN(nla_len(tb1)), NULL, NULL) < 0)
+	if (nla_parse_deprecated(tb, TCA_ACT_MAX_PRIO, nla_data(tb1), NLMSG_ALIGN(nla_len(tb1)), NULL, NULL) < 0)
 		return NULL;
 
 	if (tb[1] == NULL)
 		return NULL;
-	if (nla_parse_nested(tb2, TCA_ACT_MAX, tb[1], NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], NULL, NULL) < 0)
 		return NULL;
 	kind = tb2[TCA_ACT_KIND];
 
@@ -1466,8 +1468,8 @@ static int tc_dump_action(struct sk_buff *skb, struct netlink_callback *cb)
 	u32 msecs_since = 0;
 	u32 act_count = 0;
 
-	ret = nlmsg_parse(cb->nlh, sizeof(struct tcamsg), tb, TCA_ROOT_MAX,
-			  tcaa_policy, cb->extack);
+	ret = nlmsg_parse_deprecated(cb->nlh, sizeof(struct tcamsg), tb,
+				     TCA_ROOT_MAX, tcaa_policy, cb->extack);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 3841156aa09f..a0c77faca04b 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -293,7 +293,8 @@ static int tcf_bpf_init(struct net *net, struct nlattr *nla,
 	if (!nla)
 		return -EINVAL;
 
-	ret = nla_parse_nested(tb, TCA_ACT_BPF_MAX, nla, act_bpf_policy, NULL);
+	ret = nla_parse_nested_deprecated(tb, TCA_ACT_BPF_MAX, nla,
+					  act_bpf_policy, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 32ae0cd6e31c..8838575cd536 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -111,8 +111,8 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
 	if (!nla)
 		return -EINVAL;
 
-	ret = nla_parse_nested(tb, TCA_CONNMARK_MAX, nla, connmark_policy,
-			       NULL);
+	ret = nla_parse_nested_deprecated(tb, TCA_CONNMARK_MAX, nla,
+					  connmark_policy, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 0c77e7bdf6d5..14bb525e355e 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -61,7 +61,8 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_CSUM_MAX, nla, csum_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_CSUM_MAX, nla, csum_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index e540e31069d7..75492b07f324 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -74,7 +74,8 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_GACT_MAX, nla, gact_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_GACT_MAX, nla, gact_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 31c6ffb6abe7..b1c0e4aac20c 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -486,7 +486,8 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	int ret = 0;
 	int err;
 
-	err = nla_parse_nested(tb, TCA_IFE_MAX, nla, ife_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_IFE_MAX, nla, ife_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
@@ -567,8 +568,9 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 		INIT_LIST_HEAD(&ife->metalist);
 
 	if (tb[TCA_IFE_METALST]) {
-		err = nla_parse_nested(tb2, IFE_META_MAX, tb[TCA_IFE_METALST],
-				       NULL, NULL);
+		err = nla_parse_nested_deprecated(tb2, IFE_META_MAX,
+						  tb[TCA_IFE_METALST], NULL,
+						  NULL);
 		if (err)
 			goto metadata_parse_err;
 		err = populate_metalist(ife, tb2, exists, rtnl_held);
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 04a0b5c61194..ae6e28ab1cd7 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -113,7 +113,8 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_IPT_MAX, nla, ipt_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_IPT_MAX, nla, ipt_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 17cc6bd4c57c..c329390342f4 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -111,7 +111,8 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		NL_SET_ERR_MSG_MOD(extack, "Mirred requires attributes to be passed");
 		return -EINVAL;
 	}
-	ret = nla_parse_nested(tb, TCA_MIRRED_MAX, nla, mirred_policy, extack);
+	ret = nla_parse_nested_deprecated(tb, TCA_MIRRED_MAX, nla,
+					  mirred_policy, extack);
 	if (ret < 0)
 		return ret;
 	if (!tb[TCA_MIRRED_PARMS]) {
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index e91bb8eb81ec..51bd1ba02380 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -52,7 +52,8 @@ static int tcf_nat_init(struct net *net, struct nlattr *nla, struct nlattr *est,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_NAT_MAX, nla, nat_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_NAT_MAX, nla, nat_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 287793abfaf9..163dafcfec33 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -70,8 +70,9 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 			goto err_out;
 		}
 
-		err = nla_parse_nested(tb, TCA_PEDIT_KEY_EX_MAX, ka,
-				       pedit_key_ex_policy, NULL);
+		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
+						  ka, pedit_key_ex_policy,
+						  NULL);
 		if (err)
 			goto err_out;
 
@@ -157,7 +158,8 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_PEDIT_MAX, nla, pedit_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_PEDIT_MAX, nla,
+					  pedit_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 2b8581f6ab51..b48e40c69ad0 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -100,7 +100,8 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_POLICE_MAX, nla, police_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_POLICE_MAX, nla,
+					  police_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 4060b0955c97..b5d8ff95dd9f 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -53,7 +53,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 
 	if (!nla)
 		return -EINVAL;
-	ret = nla_parse_nested(tb, TCA_SAMPLE_MAX, nla, sample_policy, NULL);
+	ret = nla_parse_nested_deprecated(tb, TCA_SAMPLE_MAX, nla,
+					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
 	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 23c8ca5615e5..ead480e6014c 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -104,7 +104,8 @@ static int tcf_simp_init(struct net *net, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_DEF_MAX, nla, simple_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_DEF_MAX, nla, simple_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 7e1d261a31d2..7ec159b95364 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -114,7 +114,8 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	if (nla == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_SKBEDIT_MAX, nla, skbedit_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_SKBEDIT_MAX, nla,
+					  skbedit_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 1d4c324d0a42..186ef98c828f 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -102,7 +102,8 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	if (!nla)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_SKBMOD_MAX, nla, skbmod_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_SKBMOD_MAX, nla,
+					  skbmod_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index d5aaf90a3971..75ef734edfc1 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -76,8 +76,9 @@ tunnel_key_copy_geneve_opt(const struct nlattr *nla, void *dst, int dst_len,
 	int err, data_len, opt_len;
 	u8 *data;
 
-	err = nla_parse_nested(tb, TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX,
-			       nla, geneve_opt_policy, extack);
+	err = nla_parse_nested_deprecated(tb,
+					  TCA_TUNNEL_KEY_ENC_OPT_GENEVE_MAX,
+					  nla, geneve_opt_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -125,8 +126,8 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 	int err, rem, opt_len, len = nla_len(nla), opts_len = 0;
 	const struct nlattr *attr, *head = nla_data(nla);
 
-	err = nla_validate(head, len, TCA_TUNNEL_KEY_ENC_OPTS_MAX,
-			   enc_opts_policy, extack);
+	err = nla_validate_deprecated(head, len, TCA_TUNNEL_KEY_ENC_OPTS_MAX,
+				      enc_opts_policy, extack);
 	if (err)
 		return err;
 
@@ -235,8 +236,8 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_TUNNEL_KEY_MAX, nla, tunnel_key_policy,
-			       extack);
+	err = nla_parse_nested_deprecated(tb, TCA_TUNNEL_KEY_MAX, nla,
+					  tunnel_key_policy, extack);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Failed to parse nested tunnel key attributes");
 		return err;
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 0f40d0a74423..39bd9fa3e455 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -124,7 +124,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	if (!nla)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_VLAN_MAX, nla, vlan_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_VLAN_MAX, nla, vlan_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9115f053883f..6f3c68b3b35c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2006,7 +2006,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 replay:
 	tp_created = 0;
 
-	err = nlmsg_parse(n, sizeof(*t), tca, TCA_MAX, rtm_tca_policy, extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2217,7 +2218,8 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse(n, sizeof(*t), tca, TCA_MAX, rtm_tca_policy, extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2366,7 +2368,8 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	int err;
 	bool rtnl_held = false;
 
-	err = nlmsg_parse(n, sizeof(*t), tca, TCA_MAX, rtm_tca_policy, extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2558,8 +2561,8 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nlmsg_len(cb->nlh) < sizeof(*tcm))
 		return skb->len;
 
-	err = nlmsg_parse(cb->nlh, sizeof(*tcm), tca, TCA_MAX, NULL,
-			  cb->extack);
+	err = nlmsg_parse_deprecated(cb->nlh, sizeof(*tcm), tca, TCA_MAX,
+				     NULL, cb->extack);
 	if (err)
 		return err;
 
@@ -2806,7 +2809,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
 		return -EPERM;
 
 replay:
-	err = nlmsg_parse(n, sizeof(*t), tca, TCA_MAX, rtm_tca_policy, extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -2937,8 +2941,8 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 	if (nlmsg_len(cb->nlh) < sizeof(*tcm))
 		return skb->len;
 
-	err = nlmsg_parse(cb->nlh, sizeof(*tcm), tca, TCA_MAX, rtm_tca_policy,
-			  cb->extack);
+	err = nlmsg_parse_deprecated(cb->nlh, sizeof(*tcm), tca, TCA_MAX,
+				     rtm_tca_policy, cb->extack);
 	if (err)
 		return err;
 
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 687b0af67878..76ae20e10e0e 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -185,8 +185,8 @@ static int basic_change(struct net *net, struct sk_buff *in_skb,
 	if (tca[TCA_OPTIONS] == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_BASIC_MAX, tca[TCA_OPTIONS],
-			       basic_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_BASIC_MAX, tca[TCA_OPTIONS],
+					  basic_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index b4ac58039cb1..ef7c892da768 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -468,8 +468,8 @@ static int cls_bpf_change(struct net *net, struct sk_buff *in_skb,
 	if (tca[TCA_OPTIONS] == NULL)
 		return -EINVAL;
 
-	ret = nla_parse_nested(tb, TCA_BPF_MAX, tca[TCA_OPTIONS], bpf_policy,
-			       NULL);
+	ret = nla_parse_nested_deprecated(tb, TCA_BPF_MAX, tca[TCA_OPTIONS],
+					  bpf_policy, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 4c1567854f95..d8699d029b52 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -104,8 +104,9 @@ static int cls_cgroup_change(struct net *net, struct sk_buff *in_skb,
 		goto errout;
 	new->handle = handle;
 	new->tp = tp;
-	err = nla_parse_nested(tb, TCA_CGROUP_MAX, tca[TCA_OPTIONS],
-			       cgroup_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_CGROUP_MAX,
+					  tca[TCA_OPTIONS], cgroup_policy,
+					  NULL);
 	if (err < 0)
 		goto errout;
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index eece1ee26930..9a42e1deb3fd 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -408,7 +408,8 @@ static int flow_change(struct net *net, struct sk_buff *in_skb,
 	if (opt == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_FLOW_MAX, opt, flow_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FLOW_MAX, opt, flow_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0638f17ac5ab..ff215af0e6d2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -883,8 +883,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX,
-			       nla, geneve_opt_policy, extack);
+	err = nla_parse_nested_deprecated(tb,
+					  TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX,
+					  nla, geneve_opt_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -946,18 +947,18 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
 	const struct nlattr *nla_enc_key, *nla_opt_key, *nla_opt_msk = NULL;
 	int err, option_len, key_depth, msk_depth = 0;
 
-	err = nla_validate_nested(tb[TCA_FLOWER_KEY_ENC_OPTS],
-				  TCA_FLOWER_KEY_ENC_OPTS_MAX,
-				  enc_opts_policy, extack);
+	err = nla_validate_nested_deprecated(tb[TCA_FLOWER_KEY_ENC_OPTS],
+					     TCA_FLOWER_KEY_ENC_OPTS_MAX,
+					     enc_opts_policy, extack);
 	if (err)
 		return err;
 
 	nla_enc_key = nla_data(tb[TCA_FLOWER_KEY_ENC_OPTS]);
 
 	if (tb[TCA_FLOWER_KEY_ENC_OPTS_MASK]) {
-		err = nla_validate_nested(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK],
-					  TCA_FLOWER_KEY_ENC_OPTS_MAX,
-					  enc_opts_policy, extack);
+		err = nla_validate_nested_deprecated(tb[TCA_FLOWER_KEY_ENC_OPTS_MASK],
+						     TCA_FLOWER_KEY_ENC_OPTS_MAX,
+						     enc_opts_policy, extack);
 		if (err)
 			return err;
 
@@ -1489,8 +1490,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		goto errout_mask_alloc;
 	}
 
-	err = nla_parse_nested(tb, TCA_FLOWER_MAX, tca[TCA_OPTIONS],
-			       fl_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FLOWER_MAX,
+					  tca[TCA_OPTIONS], fl_policy, NULL);
 	if (err < 0)
 		goto errout_tb;
 
@@ -1794,8 +1795,8 @@ static void *fl_tmplt_create(struct net *net, struct tcf_chain *chain,
 	tb = kcalloc(TCA_FLOWER_MAX + 1, sizeof(struct nlattr *), GFP_KERNEL);
 	if (!tb)
 		return ERR_PTR(-ENOBUFS);
-	err = nla_parse_nested(tb, TCA_FLOWER_MAX, tca[TCA_OPTIONS],
-			       fl_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FLOWER_MAX,
+					  tca[TCA_OPTIONS], fl_policy, NULL);
 	if (err)
 		goto errout_tb;
 
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index ad036b00427d..7b10563d5ab4 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -263,7 +263,8 @@ static int fw_change(struct net *net, struct sk_buff *in_skb,
 	if (!opt)
 		return handle ? -EINVAL : 0; /* Succeed if it is old method. */
 
-	err = nla_parse_nested(tb, TCA_FW_MAX, opt, fw_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FW_MAX, opt, fw_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 459921bd3d87..c24c76657325 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -176,8 +176,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 	if (head)
 		return -EEXIST;
 
-	err = nla_parse_nested(tb, TCA_MATCHALL_MAX, tca[TCA_OPTIONS],
-			       mall_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_MATCHALL_MAX,
+					  tca[TCA_OPTIONS], mall_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index f006af23b64a..d68b8174d9ba 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -484,7 +484,8 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 
-	err = nla_parse_nested(tb, TCA_ROUTE4_MAX, opt, route4_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_ROUTE4_MAX, opt,
+					  route4_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 0719a21d9c41..e523684fe28a 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -497,7 +497,8 @@ static int rsvp_change(struct net *net, struct sk_buff *in_skb,
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 
-	err = nla_parse_nested(tb, TCA_RSVP_MAX, opt, rsvp_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_RSVP_MAX, opt, rsvp_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 24e0a62a65cc..9915a7172ecb 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -510,7 +510,8 @@ tcindex_change(struct net *net, struct sk_buff *in_skb,
 	if (!opt)
 		return 0;
 
-	err = nla_parse_nested(tb, TCA_TCINDEX_MAX, opt, tcindex_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_TCINDEX_MAX, opt,
+					  tcindex_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 48e76a3acf8a..3adf4d015bbd 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -884,7 +884,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
-	err = nla_parse_nested(tb, TCA_U32_MAX, opt, u32_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_U32_MAX, opt, u32_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index a5f34e930eff..60c26b8294b5 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -120,8 +120,8 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 	struct xt_match *match;
 	int mdata_len, ret;
 
-	ret = nla_parse(tb, TCA_EM_IPT_MAX, data, data_len, em_ipt_policy,
-			NULL);
+	ret = nla_parse_deprecated(tb, TCA_EM_IPT_MAX, data, data_len,
+				   em_ipt_policy, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index d6e97115500b..28dfa8f2a4ea 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -912,7 +912,8 @@ static int em_meta_change(struct net *net, void *data, int len,
 	struct tcf_meta_hdr *hdr;
 	struct meta_match *meta = NULL;
 
-	err = nla_parse(tb, TCA_EM_META_MAX, data, len, meta_policy, NULL);
+	err = nla_parse_deprecated(tb, TCA_EM_META_MAX, data, len,
+				   meta_policy, NULL);
 	if (err < 0)
 		goto errout;
 
diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index 1331a4c2d8ff..e66b6acc64f4 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -314,7 +314,8 @@ int tcf_em_tree_validate(struct tcf_proto *tp, struct nlattr *nla,
 	if (!nla)
 		return 0;
 
-	err = nla_parse_nested(tb, TCA_EMATCH_TREE_MAX, nla, em_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_EMATCH_TREE_MAX, nla,
+					  em_policy, NULL);
 	if (err < 0)
 		goto errout;
 
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index fb8f138b9776..537552f6dc3a 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -479,7 +479,8 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 	u16 *tab = NULL;
 	int err;
 
-	err = nla_parse_nested(tb, TCA_STAB_MAX, opt, stab_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_STAB_MAX, opt, stab_policy,
+					  extack);
 	if (err < 0)
 		return ERR_PTR(err);
 	if (!tb[TCA_STAB_BASE]) {
@@ -1410,8 +1411,8 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, rtm_tca_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -1495,8 +1496,8 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 
 replay:
 	/* Reinit, just in case something touches this. */
-	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, rtm_tca_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -1730,8 +1731,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 	idx = 0;
 	ASSERT_RTNL();
 
-	err = nlmsg_parse(nlh, sizeof(struct tcmsg), tca, TCA_MAX,
-			  rtm_tca_policy, cb->extack);
+	err = nlmsg_parse_deprecated(nlh, sizeof(struct tcmsg), tca, TCA_MAX,
+				     rtm_tca_policy, cb->extack);
 	if (err < 0)
 		return err;
 
@@ -1959,8 +1960,8 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, rtm_tca_policy,
-			  extack);
+	err = nlmsg_parse_deprecated(n, sizeof(*tcm), tca, TCA_MAX,
+				     rtm_tca_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index d714d3747bcb..9c1f2d44ea93 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -223,7 +223,8 @@ static int atm_tc_change(struct Qdisc *sch, u32 classid, u32 parent,
 	if (opt == NULL)
 		return -EINVAL;
 
-	error = nla_parse_nested(tb, TCA_ATM_MAX, opt, atm_policy, NULL);
+	error = nla_parse_nested_deprecated(tb, TCA_ATM_MAX, opt, atm_policy,
+					    NULL);
 	if (error < 0)
 		return error;
 
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index acc9b9da985f..84bc7af10737 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2520,7 +2520,8 @@ static int cake_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_CAKE_MAX, opt, cake_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_CAKE_MAX, opt, cake_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 4dc05409e3fb..a8bcf800ab36 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1149,7 +1149,8 @@ static int cbq_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_CBQ_MAX, opt, cbq_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
@@ -1471,7 +1472,8 @@ cbq_change_class(struct Qdisc *sch, u32 classid, u32 parentid, struct nlattr **t
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_CBQ_MAX, opt, cbq_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_CBQ_MAX, opt, cbq_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index c6a502933fe7..f94d802b077d 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -303,7 +303,8 @@ static int cbs_change(struct Qdisc *sch, struct nlattr *opt,
 	struct tc_cbs_qopt *qopt;
 	int err;
 
-	err = nla_parse_nested(tb, TCA_CBS_MAX, opt, cbs_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_CBS_MAX, opt, cbs_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index eafc0d17d174..e3795ac66684 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -358,7 +358,8 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	if (opt == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_CHOKE_MAX, opt, choke_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_CHOKE_MAX, opt,
+					  choke_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 17cd81f84b5d..b4dab563737b 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -141,7 +141,8 @@ static int codel_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_CODEL_MAX, opt, codel_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_CODEL_MAX, opt,
+					  codel_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 09b800991065..f72524362390 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -79,7 +79,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_DRR_MAX, opt, drr_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_DRR_MAX, opt, drr_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 42471464ded3..f22bffa10701 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -132,7 +132,8 @@ static int dsmark_change(struct Qdisc *sch, u32 classid, u32 parent,
 	if (!opt)
 		goto errout;
 
-	err = nla_parse_nested(tb, TCA_DSMARK_MAX, opt, dsmark_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_DSMARK_MAX, opt,
+					  dsmark_policy, NULL);
 	if (err < 0)
 		goto errout;
 
@@ -353,7 +354,8 @@ static int dsmark_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	err = nla_parse_nested(tb, TCA_DSMARK_MAX, opt, dsmark_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_DSMARK_MAX, opt,
+					  dsmark_policy, NULL);
 	if (err < 0)
 		goto errout;
 
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index 1150f22983df..3241123905c3 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -351,7 +351,8 @@ static int etf_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_ETF_MAX, opt, etf_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ETF_MAX, opt, etf_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 1a662f2bb7bb..3936f17a402c 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -684,7 +684,8 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_FQ_MAX, opt, fq_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FQ_MAX, opt, fq_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index cd04d40c30b6..adb27c6fc518 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -387,8 +387,8 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_FQ_CODEL_MAX, opt, fq_codel_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_FQ_CODEL_MAX, opt,
+					  fq_codel_policy, NULL);
 	if (err < 0)
 		return err;
 	if (tb[TCA_FQ_CODEL_FLOWS]) {
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 234afbf9115b..b4e425c696f0 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -538,7 +538,8 @@ static void gred_vq_apply(struct gred_sched *table, const struct nlattr *entry)
 	struct nlattr *tb[TCA_GRED_VQ_MAX + 1];
 	u32 dp;
 
-	nla_parse_nested(tb, TCA_GRED_VQ_MAX, entry, gred_vq_policy, NULL);
+	nla_parse_nested_deprecated(tb, TCA_GRED_VQ_MAX, entry,
+				    gred_vq_policy, NULL);
 
 	dp = nla_get_u32(tb[TCA_GRED_VQ_DP]);
 
@@ -568,8 +569,8 @@ static int gred_vq_validate(struct gred_sched *table, u32 cdp,
 	int err;
 	u32 dp;
 
-	err = nla_parse_nested(tb, TCA_GRED_VQ_MAX, entry, gred_vq_policy,
-			       extack);
+	err = nla_parse_nested_deprecated(tb, TCA_GRED_VQ_MAX, entry,
+					  gred_vq_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -610,8 +611,8 @@ static int gred_vqs_validate(struct gred_sched *table, u32 cdp,
 	const struct nlattr *attr;
 	int rem, err;
 
-	err = nla_validate_nested(vqs, TCA_GRED_VQ_ENTRY_MAX,
-				  gred_vqe_policy, extack);
+	err = nla_validate_nested_deprecated(vqs, TCA_GRED_VQ_ENTRY_MAX,
+					     gred_vqe_policy, extack);
 	if (err < 0)
 		return err;
 
@@ -650,7 +651,8 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
 	if (opt == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_GRED_MAX, opt, gred_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_GRED_MAX, opt, gred_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
@@ -737,7 +739,8 @@ static int gred_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_GRED_MAX, opt, gred_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_GRED_MAX, opt, gred_policy,
+					  extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 24cc220a3218..bc858468b736 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -936,7 +936,8 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (opt == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_HFSC_MAX, opt, hfsc_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_HFSC_MAX, opt, hfsc_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index 9d6a47697406..9493d4933546 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -518,7 +518,8 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_HHF_MAX, opt, hhf_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_HHF_MAX, opt, hhf_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 30f9da7e1076..1b3aaba9d914 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1012,7 +1012,8 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	err = nla_parse_nested(tb, TCA_HTB_MAX, opt, htb_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_HTB_MAX, opt, htb_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
@@ -1316,7 +1317,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	if (!opt)
 		goto failure;
 
-	err = nla_parse_nested(tb, TCA_HTB_MAX, opt, htb_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_HTB_MAX, opt, htb_policy,
+					  NULL);
 	if (err < 0)
 		goto failure;
 
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index d364e63c396d..2e3a726c74eb 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -125,8 +125,9 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	int nested_len = nla_len(nla) - NLA_ALIGN(len);
 
 	if (nested_len >= nla_attr_size(0))
-		return nla_parse(tb, maxtype, nla_data(nla) + NLA_ALIGN(len),
-				 nested_len, policy, NULL);
+		return nla_parse_deprecated(tb, maxtype,
+					    nla_data(nla) + NLA_ALIGN(len),
+					    nested_len, policy, NULL);
 
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 	return 0;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index cc9d8133afcd..39a9c4f8a80d 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -935,8 +935,9 @@ static int parse_attr(struct nlattr *tb[], int maxtype, struct nlattr *nla,
 	}
 
 	if (nested_len >= nla_attr_size(0))
-		return nla_parse(tb, maxtype, nla_data(nla) + NLA_ALIGN(len),
-				 nested_len, policy, NULL);
+		return nla_parse_deprecated(tb, maxtype,
+					    nla_data(nla) + NLA_ALIGN(len),
+					    nested_len, policy, NULL);
 
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 	return 0;
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 1cc0c7b74aa3..6dead0add2aa 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -216,7 +216,8 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_PIE_MAX, opt, pie_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_PIE_MAX, opt, pie_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 29f5c4a24688..62a9fae4a66b 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -419,8 +419,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS], qfq_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
+					  qfq_policy, NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 9df9942340ea..8840fd54bad1 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -205,7 +205,8 @@ static int red_change(struct Qdisc *sch, struct nlattr *opt,
 	if (opt == NULL)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, TCA_RED_MAX, opt, red_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_RED_MAX, opt, red_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index bab506b01a32..6242bb7016fc 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -499,7 +499,8 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
 	int err;
 
 	if (opt) {
-		err = nla_parse_nested(tb, TCA_SFB_MAX, opt, sfb_policy, NULL);
+		err = nla_parse_nested_deprecated(tb, TCA_SFB_MAX, opt,
+						  sfb_policy, NULL);
 		if (err < 0)
 			return -EINVAL;
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 206e4dbed12f..ae7f2a625c8a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -302,8 +302,8 @@ static int parse_sched_entry(struct nlattr *n, struct sched_entry *entry,
 	struct nlattr *tb[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = { };
 	int err;
 
-	err = nla_parse_nested(tb, TCA_TAPRIO_SCHED_ENTRY_MAX, n,
-			       entry_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_SCHED_ENTRY_MAX, n,
+					  entry_policy, NULL);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
 		return -EINVAL;
@@ -326,8 +326,8 @@ static int parse_sched_single_entry(struct nlattr *n,
 	u32 index;
 	int err;
 
-	err = nla_parse_nested(tb_list, TCA_TAPRIO_SCHED_MAX,
-			       n, entry_list_policy, NULL);
+	err = nla_parse_nested_deprecated(tb_list, TCA_TAPRIO_SCHED_MAX, n,
+					  entry_list_policy, NULL);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
 		return -EINVAL;
@@ -338,9 +338,10 @@ static int parse_sched_single_entry(struct nlattr *n,
 		return -EINVAL;
 	}
 
-	err = nla_parse_nested(tb_entry, TCA_TAPRIO_SCHED_ENTRY_MAX,
-			       tb_list[TCA_TAPRIO_SCHED_ENTRY],
-			       entry_policy, NULL);
+	err = nla_parse_nested_deprecated(tb_entry,
+					  TCA_TAPRIO_SCHED_ENTRY_MAX,
+					  tb_list[TCA_TAPRIO_SCHED_ENTRY],
+					  entry_policy, NULL);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Could not parse nested entry");
 		return -EINVAL;
@@ -587,8 +588,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	s64 link_speed;
 	ktime_t start;
 
-	err = nla_parse_nested(tb, TCA_TAPRIO_ATTR_MAX, opt,
-			       taprio_policy, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_TAPRIO_ATTR_MAX, opt,
+					  taprio_policy, extack);
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 7f272a9070c5..53d5e17a47b9 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -308,7 +308,8 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	s64 buffer, mtu;
 	u64 rate64 = 0, prate64 = 0;
 
-	err = nla_parse_nested(tb, TCA_TBF_MAX, opt, tbf_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, TCA_TBF_MAX, opt, tbf_policy,
+					  NULL);
 	if (err < 0)
 		return err;
 
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index d27f30a9a01d..ee8b9a6b84c2 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -776,9 +776,9 @@ int tipc_nl_bearer_get(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_BEARER_MAX,
-			       info->attrs[TIPC_NLA_BEARER],
-			       tipc_nl_bearer_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_BEARER_MAX,
+					  info->attrs[TIPC_NLA_BEARER],
+					  tipc_nl_bearer_policy, info->extack);
 	if (err)
 		return err;
 
@@ -825,9 +825,9 @@ int __tipc_nl_bearer_disable(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_BEARER_MAX,
-			       info->attrs[TIPC_NLA_BEARER],
-			       tipc_nl_bearer_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_BEARER_MAX,
+					  info->attrs[TIPC_NLA_BEARER],
+					  tipc_nl_bearer_policy, info->extack);
 	if (err)
 		return err;
 
@@ -870,9 +870,9 @@ int __tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_BEARER_MAX,
-			       info->attrs[TIPC_NLA_BEARER],
-			       tipc_nl_bearer_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_BEARER_MAX,
+					  info->attrs[TIPC_NLA_BEARER],
+					  tipc_nl_bearer_policy, info->extack);
 	if (err)
 		return err;
 
@@ -921,9 +921,9 @@ int tipc_nl_bearer_add(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_BEARER_MAX,
-			       info->attrs[TIPC_NLA_BEARER],
-			       tipc_nl_bearer_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_BEARER_MAX,
+					  info->attrs[TIPC_NLA_BEARER],
+					  tipc_nl_bearer_policy, info->extack);
 	if (err)
 		return err;
 
@@ -964,9 +964,9 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_BEARER_MAX,
-			       info->attrs[TIPC_NLA_BEARER],
-			       tipc_nl_bearer_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_BEARER_MAX,
+					  info->attrs[TIPC_NLA_BEARER],
+					  tipc_nl_bearer_policy, info->extack);
 	if (err)
 		return err;
 
@@ -1107,9 +1107,9 @@ int tipc_nl_media_get(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_MEDIA])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_MEDIA_MAX,
-			       info->attrs[TIPC_NLA_MEDIA],
-			       tipc_nl_media_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_MEDIA_MAX,
+					  info->attrs[TIPC_NLA_MEDIA],
+					  tipc_nl_media_policy, info->extack);
 	if (err)
 		return err;
 
@@ -1155,9 +1155,9 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_MEDIA])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_MEDIA_MAX,
-			       info->attrs[TIPC_NLA_MEDIA],
-			       tipc_nl_media_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_MEDIA_MAX,
+					  info->attrs[TIPC_NLA_MEDIA],
+					  tipc_nl_media_policy, info->extack);
 
 	if (!attrs[TIPC_NLA_MEDIA_NAME])
 		return -EINVAL;
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 52d23b3ffaf5..09925e9620e6 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1972,8 +1972,8 @@ int tipc_nl_parse_link_prop(struct nlattr *prop, struct nlattr *props[])
 {
 	int err;
 
-	err = nla_parse_nested(props, TIPC_NLA_PROP_MAX, prop,
-			       tipc_nl_prop_policy, NULL);
+	err = nla_parse_nested_deprecated(props, TIPC_NLA_PROP_MAX, prop,
+					  tipc_nl_prop_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 7ce1e86b024f..2b8537879faf 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -245,9 +245,9 @@ int __tipc_nl_net_set(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_NET])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_NET_MAX,
-			       info->attrs[TIPC_NLA_NET], tipc_nl_net_policy,
-			       info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_NET_MAX,
+					  info->attrs[TIPC_NLA_NET],
+					  tipc_nl_net_policy, info->extack);
 
 	if (err)
 		return err;
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 2d178df0a89f..3d5d0fb5b37c 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -255,8 +255,8 @@ int tipc_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr ***attr)
 	if (!*attr)
 		return -EOPNOTSUPP;
 
-	return nlmsg_parse(nlh, GENL_HDRLEN, *attr, maxattr, tipc_nl_policy,
-			   NULL);
+	return nlmsg_parse_deprecated(nlh, GENL_HDRLEN, *attr, maxattr,
+				      tipc_nl_policy, NULL);
 }
 
 int __init tipc_netlink_start(void)
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 4ad3586da8f0..f48e11f61444 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -322,9 +322,9 @@ static int __tipc_nl_compat_doit(struct tipc_nl_compat_cmd_doit *cmd,
 	if (err)
 		goto doit_out;
 
-	err = nla_parse(attrbuf, tipc_genl_family.maxattr,
-			(const struct nlattr *)trans_buf->data,
-			trans_buf->len, NULL, NULL);
+	err = nla_parse_deprecated(attrbuf, tipc_genl_family.maxattr,
+				   (const struct nlattr *)trans_buf->data,
+				   trans_buf->len, NULL, NULL);
 	if (err)
 		goto doit_out;
 
@@ -372,8 +372,8 @@ static int tipc_nl_compat_bearer_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_BEARER])
 		return -EINVAL;
 
-	err = nla_parse_nested(bearer, TIPC_NLA_BEARER_MAX,
-			       attrs[TIPC_NLA_BEARER], NULL, NULL);
+	err = nla_parse_nested_deprecated(bearer, TIPC_NLA_BEARER_MAX,
+					  attrs[TIPC_NLA_BEARER], NULL, NULL);
 	if (err)
 		return err;
 
@@ -503,24 +503,26 @@ static int tipc_nl_compat_link_stat_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_LINK])
 		return -EINVAL;
 
-	err = nla_parse_nested(link, TIPC_NLA_LINK_MAX, attrs[TIPC_NLA_LINK],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(link, TIPC_NLA_LINK_MAX,
+					  attrs[TIPC_NLA_LINK], NULL, NULL);
 	if (err)
 		return err;
 
 	if (!link[TIPC_NLA_LINK_PROP])
 		return -EINVAL;
 
-	err = nla_parse_nested(prop, TIPC_NLA_PROP_MAX,
-			       link[TIPC_NLA_LINK_PROP], NULL, NULL);
+	err = nla_parse_nested_deprecated(prop, TIPC_NLA_PROP_MAX,
+					  link[TIPC_NLA_LINK_PROP], NULL,
+					  NULL);
 	if (err)
 		return err;
 
 	if (!link[TIPC_NLA_LINK_STATS])
 		return -EINVAL;
 
-	err = nla_parse_nested(stats, TIPC_NLA_STATS_MAX,
-			       link[TIPC_NLA_LINK_STATS], NULL, NULL);
+	err = nla_parse_nested_deprecated(stats, TIPC_NLA_STATS_MAX,
+					  link[TIPC_NLA_LINK_STATS], NULL,
+					  NULL);
 	if (err)
 		return err;
 
@@ -634,8 +636,8 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_LINK])
 		return -EINVAL;
 
-	err = nla_parse_nested(link, TIPC_NLA_LINK_MAX, attrs[TIPC_NLA_LINK],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(link, TIPC_NLA_LINK_MAX,
+					  attrs[TIPC_NLA_LINK], NULL, NULL);
 	if (err)
 		return err;
 
@@ -853,16 +855,18 @@ static int tipc_nl_compat_name_table_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_NAME_TABLE])
 		return -EINVAL;
 
-	err = nla_parse_nested(nt, TIPC_NLA_NAME_TABLE_MAX,
-			       attrs[TIPC_NLA_NAME_TABLE], NULL, NULL);
+	err = nla_parse_nested_deprecated(nt, TIPC_NLA_NAME_TABLE_MAX,
+					  attrs[TIPC_NLA_NAME_TABLE], NULL,
+					  NULL);
 	if (err)
 		return err;
 
 	if (!nt[TIPC_NLA_NAME_TABLE_PUBL])
 		return -EINVAL;
 
-	err = nla_parse_nested(publ, TIPC_NLA_PUBL_MAX,
-			       nt[TIPC_NLA_NAME_TABLE_PUBL], NULL, NULL);
+	err = nla_parse_nested_deprecated(publ, TIPC_NLA_PUBL_MAX,
+					  nt[TIPC_NLA_NAME_TABLE_PUBL], NULL,
+					  NULL);
 	if (err)
 		return err;
 
@@ -921,8 +925,8 @@ static int __tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_PUBL])
 		return -EINVAL;
 
-	err = nla_parse_nested(publ, TIPC_NLA_PUBL_MAX, attrs[TIPC_NLA_PUBL],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(publ, TIPC_NLA_PUBL_MAX,
+					  attrs[TIPC_NLA_PUBL], NULL, NULL);
 	if (err)
 		return err;
 
@@ -991,8 +995,8 @@ static int tipc_nl_compat_sk_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_SOCK])
 		return -EINVAL;
 
-	err = nla_parse_nested(sock, TIPC_NLA_SOCK_MAX, attrs[TIPC_NLA_SOCK],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(sock, TIPC_NLA_SOCK_MAX,
+					  attrs[TIPC_NLA_SOCK], NULL, NULL);
 	if (err)
 		return err;
 
@@ -1003,8 +1007,9 @@ static int tipc_nl_compat_sk_dump(struct tipc_nl_compat_msg *msg,
 		u32 node;
 		struct nlattr *con[TIPC_NLA_CON_MAX + 1];
 
-		err = nla_parse_nested(con, TIPC_NLA_CON_MAX,
-				       sock[TIPC_NLA_SOCK_CON], NULL, NULL);
+		err = nla_parse_nested_deprecated(con, TIPC_NLA_CON_MAX,
+						  sock[TIPC_NLA_SOCK_CON],
+						  NULL, NULL);
 
 		if (err)
 			return err;
@@ -1043,8 +1048,8 @@ static int tipc_nl_compat_media_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_MEDIA])
 		return -EINVAL;
 
-	err = nla_parse_nested(media, TIPC_NLA_MEDIA_MAX,
-			       attrs[TIPC_NLA_MEDIA], NULL, NULL);
+	err = nla_parse_nested_deprecated(media, TIPC_NLA_MEDIA_MAX,
+					  attrs[TIPC_NLA_MEDIA], NULL, NULL);
 	if (err)
 		return err;
 
@@ -1063,8 +1068,8 @@ static int tipc_nl_compat_node_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_NODE])
 		return -EINVAL;
 
-	err = nla_parse_nested(node, TIPC_NLA_NODE_MAX, attrs[TIPC_NLA_NODE],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(node, TIPC_NLA_NODE_MAX,
+					  attrs[TIPC_NLA_NODE], NULL, NULL);
 	if (err)
 		return err;
 
@@ -1110,8 +1115,8 @@ static int tipc_nl_compat_net_dump(struct tipc_nl_compat_msg *msg,
 	if (!attrs[TIPC_NLA_NET])
 		return -EINVAL;
 
-	err = nla_parse_nested(net, TIPC_NLA_NET_MAX, attrs[TIPC_NLA_NET],
-			       NULL, NULL);
+	err = nla_parse_nested_deprecated(net, TIPC_NLA_NET_MAX,
+					  attrs[TIPC_NLA_NET], NULL, NULL);
 	if (err)
 		return err;
 
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 3469b5d4ed32..8e60532c2c43 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1884,9 +1884,9 @@ int tipc_nl_peer_rm(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_NET])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_NET_MAX,
-			       info->attrs[TIPC_NLA_NET], tipc_nl_net_policy,
-			       info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_NET_MAX,
+					  info->attrs[TIPC_NLA_NET],
+					  tipc_nl_net_policy, info->extack);
 	if (err)
 		return err;
 
@@ -2042,9 +2042,9 @@ int tipc_nl_node_set_link(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_LINK])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_LINK_MAX,
-			       info->attrs[TIPC_NLA_LINK],
-			       tipc_nl_link_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_LINK_MAX,
+					  info->attrs[TIPC_NLA_LINK],
+					  tipc_nl_link_policy, info->extack);
 	if (err)
 		return err;
 
@@ -2118,9 +2118,9 @@ int tipc_nl_node_get_link(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_LINK])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_LINK_MAX,
-			       info->attrs[TIPC_NLA_LINK],
-			       tipc_nl_link_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_LINK_MAX,
+					  info->attrs[TIPC_NLA_LINK],
+					  tipc_nl_link_policy, info->extack);
 	if (err)
 		return err;
 
@@ -2183,9 +2183,9 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_LINK])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_LINK_MAX,
-			       info->attrs[TIPC_NLA_LINK],
-			       tipc_nl_link_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_LINK_MAX,
+					  info->attrs[TIPC_NLA_LINK],
+					  tipc_nl_link_policy, info->extack);
 	if (err)
 		return err;
 
@@ -2323,9 +2323,10 @@ int tipc_nl_node_set_monitor(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[TIPC_NLA_MON])
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, TIPC_NLA_MON_MAX,
-			       info->attrs[TIPC_NLA_MON],
-			       tipc_nl_monitor_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, TIPC_NLA_MON_MAX,
+					  info->attrs[TIPC_NLA_MON],
+					  tipc_nl_monitor_policy,
+					  info->extack);
 	if (err)
 		return err;
 
@@ -2443,9 +2444,10 @@ int tipc_nl_node_dump_monitor_peer(struct sk_buff *skb,
 		if (!attrs[TIPC_NLA_MON])
 			return -EINVAL;
 
-		err = nla_parse_nested(mon, TIPC_NLA_MON_MAX,
-				       attrs[TIPC_NLA_MON],
-				       tipc_nl_monitor_policy, NULL);
+		err = nla_parse_nested_deprecated(mon, TIPC_NLA_MON_MAX,
+						  attrs[TIPC_NLA_MON],
+						  tipc_nl_monitor_policy,
+						  NULL);
 		if (err)
 			return err;
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 8ac8ddf1e324..1cded416d49a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3596,9 +3596,9 @@ int tipc_nl_publ_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!attrs[TIPC_NLA_SOCK])
 			return -EINVAL;
 
-		err = nla_parse_nested(sock, TIPC_NLA_SOCK_MAX,
-				       attrs[TIPC_NLA_SOCK],
-				       tipc_nl_sock_policy, NULL);
+		err = nla_parse_nested_deprecated(sock, TIPC_NLA_SOCK_MAX,
+						  attrs[TIPC_NLA_SOCK],
+						  tipc_nl_sock_policy, NULL);
 		if (err)
 			return err;
 
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 6f166fbbfff1..3421cd9e902d 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -451,9 +451,9 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!attrs[TIPC_NLA_BEARER])
 			return -EINVAL;
 
-		err = nla_parse_nested(battrs, TIPC_NLA_BEARER_MAX,
-				       attrs[TIPC_NLA_BEARER],
-				       tipc_nl_bearer_policy, NULL);
+		err = nla_parse_nested_deprecated(battrs, TIPC_NLA_BEARER_MAX,
+						  attrs[TIPC_NLA_BEARER],
+						  tipc_nl_bearer_policy, NULL);
 		if (err)
 			return err;
 
@@ -605,8 +605,7 @@ int tipc_udp_nl_bearer_add(struct tipc_bearer *b, struct nlattr *attr)
 	struct nlattr *opts[TIPC_NLA_UDP_MAX + 1];
 	struct udp_media_addr *dst;
 
-	if (nla_parse_nested(opts, TIPC_NLA_UDP_MAX, attr,
-			     tipc_nl_udp_policy, NULL))
+	if (nla_parse_nested_deprecated(opts, TIPC_NLA_UDP_MAX, attr, tipc_nl_udp_policy, NULL))
 		return -EINVAL;
 
 	if (!opts[TIPC_NLA_UDP_REMOTE])
@@ -659,9 +658,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	if (!attrs[TIPC_NLA_BEARER_UDP_OPTS])
 		goto err;
 
-	if (nla_parse_nested(opts, TIPC_NLA_UDP_MAX,
-			     attrs[TIPC_NLA_BEARER_UDP_OPTS],
-			     tipc_nl_udp_policy, NULL))
+	if (nla_parse_nested_deprecated(opts, TIPC_NLA_UDP_MAX, attrs[TIPC_NLA_BEARER_UDP_OPTS], tipc_nl_udp_policy, NULL))
 		goto err;
 
 	if (!opts[TIPC_NLA_UDP_LOCAL] || !opts[TIPC_NLA_UDP_REMOTE]) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33408ba1d7ee..3700c9609411 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -688,9 +688,11 @@ int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 	int err;
 
 	if (!cb->args[0]) {
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  genl_family_attrbuf(&nl80211_fam),
-				  nl80211_fam.maxattr, nl80211_policy, NULL);
+		err = nlmsg_parse_deprecated(cb->nlh,
+					     GENL_HDRLEN + nl80211_fam.hdrsize,
+					     genl_family_attrbuf(&nl80211_fam),
+					     nl80211_fam.maxattr,
+					     nl80211_policy, NULL);
 		if (err)
 			return err;
 
@@ -910,8 +912,9 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 				 struct key_parse *k)
 {
 	struct nlattr *tb[NL80211_KEY_MAX + 1];
-	int err = nla_parse_nested(tb, NL80211_KEY_MAX, key,
-				   nl80211_key_policy, info->extack);
+	int err = nla_parse_nested_deprecated(tb, NL80211_KEY_MAX, key,
+					      nl80211_key_policy,
+					      info->extack);
 	if (err)
 		return err;
 
@@ -947,10 +950,11 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 	if (tb[NL80211_KEY_DEFAULT_TYPES]) {
 		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
 
-		err = nla_parse_nested(kdt, NUM_NL80211_KEY_DEFAULT_TYPES - 1,
-				       tb[NL80211_KEY_DEFAULT_TYPES],
-				       nl80211_key_default_policy,
-				       info->extack);
+		err = nla_parse_nested_deprecated(kdt,
+						  NUM_NL80211_KEY_DEFAULT_TYPES - 1,
+						  tb[NL80211_KEY_DEFAULT_TYPES],
+						  nl80211_key_default_policy,
+						  info->extack);
 		if (err)
 			return err;
 
@@ -994,11 +998,11 @@ static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
 
 	if (info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES]) {
 		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
-		int err = nla_parse_nested(kdt,
-					   NUM_NL80211_KEY_DEFAULT_TYPES - 1,
-					   info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES],
-					   nl80211_key_default_policy,
-					   info->extack);
+		int err = nla_parse_nested_deprecated(kdt,
+						      NUM_NL80211_KEY_DEFAULT_TYPES - 1,
+						      info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES],
+						      nl80211_key_default_policy,
+						      info->extack);
 		if (err)
 			return err;
 
@@ -2289,8 +2293,10 @@ static int nl80211_dump_wiphy_parse(struct sk_buff *skb,
 				    struct nl80211_dump_wiphy_state *state)
 {
 	struct nlattr **tb = genl_family_attrbuf(&nl80211_fam);
-	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize, tb,
-			      nl80211_fam.maxattr, nl80211_policy, NULL);
+	int ret = nlmsg_parse_deprecated(cb->nlh,
+					 GENL_HDRLEN + nl80211_fam.hdrsize,
+					 tb, nl80211_fam.maxattr,
+					 nl80211_policy, NULL);
 	/* ignore parse errors for backward compatibility */
 	if (ret)
 		return 0;
@@ -2733,10 +2739,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
-			result = nla_parse_nested(tb, NL80211_TXQ_ATTR_MAX,
-						  nl_txq_params,
-						  txq_params_policy,
-						  info->extack);
+			result = nla_parse_nested_deprecated(tb,
+							     NL80211_TXQ_ATTR_MAX,
+							     nl_txq_params,
+							     txq_params_policy,
+							     info->extack);
 			if (result)
 				return result;
 			result = parse_txq_params(tb, &txq_params);
@@ -3193,8 +3200,7 @@ static int parse_monitor_flags(struct nlattr *nla, u32 *mntrflags)
 	if (!nla)
 		return -EINVAL;
 
-	if (nla_parse_nested(flags, NL80211_MNTR_FLAG_MAX, nla,
-			     mntr_flags_policy, NULL))
+	if (nla_parse_nested_deprecated(flags, NL80211_MNTR_FLAG_MAX, nla, mntr_flags_policy, NULL))
 		return -EINVAL;
 
 	for (flag = 1; flag <= NL80211_MNTR_FLAG_MAX; flag++)
@@ -4054,8 +4060,10 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 		sband = rdev->wiphy.bands[band];
 		if (sband == NULL)
 			return -EINVAL;
-		err = nla_parse_nested(tb, NL80211_TXRATE_MAX, tx_rates,
-				       nl80211_txattr_policy, info->extack);
+		err = nla_parse_nested_deprecated(tb, NL80211_TXRATE_MAX,
+						  tx_rates,
+						  nl80211_txattr_policy,
+						  info->extack);
 		if (err)
 			return err;
 		if (tb[NL80211_TXRATE_LEGACY]) {
@@ -4223,9 +4231,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 	if (attrs[NL80211_ATTR_FTM_RESPONDER]) {
 		struct nlattr *tb[NL80211_FTM_RESP_ATTR_MAX + 1];
 
-		err = nla_parse_nested(tb, NL80211_FTM_RESP_ATTR_MAX,
-				       attrs[NL80211_ATTR_FTM_RESPONDER],
-				       NULL, NULL);
+		err = nla_parse_nested_deprecated(tb,
+						  NL80211_FTM_RESP_ATTR_MAX,
+						  attrs[NL80211_ATTR_FTM_RESPONDER],
+						  NULL, NULL);
 		if (err)
 			return err;
 
@@ -4633,8 +4642,7 @@ static int parse_station_flags(struct genl_info *info,
 	if (!nla)
 		return 0;
 
-	if (nla_parse_nested(flags, NL80211_STA_FLAG_MAX, nla,
-			     sta_flags_policy, info->extack))
+	if (nla_parse_nested_deprecated(flags, NL80211_STA_FLAG_MAX, nla, sta_flags_policy, info->extack))
 		return -EINVAL;
 
 	/*
@@ -5300,8 +5308,9 @@ static int nl80211_parse_sta_wme(struct genl_info *info,
 		return 0;
 
 	nla = info->attrs[NL80211_ATTR_STA_WME];
-	err = nla_parse_nested(tb, NL80211_STA_WME_MAX, nla,
-			       nl80211_sta_wme_policy, info->extack);
+	err = nla_parse_nested_deprecated(tb, NL80211_STA_WME_MAX, nla,
+					  nl80211_sta_wme_policy,
+					  info->extack);
 	if (err)
 		return err;
 
@@ -6403,9 +6412,7 @@ do {									\
 
 	if (!info->attrs[NL80211_ATTR_MESH_CONFIG])
 		return -EINVAL;
-	if (nla_parse_nested(tb, NL80211_MESHCONF_ATTR_MAX,
-			     info->attrs[NL80211_ATTR_MESH_CONFIG],
-			     nl80211_meshconf_params_policy, info->extack))
+	if (nla_parse_nested_deprecated(tb, NL80211_MESHCONF_ATTR_MAX, info->attrs[NL80211_ATTR_MESH_CONFIG], nl80211_meshconf_params_policy, info->extack))
 		return -EINVAL;
 
 	/* This makes sure that there aren't more than 32 mesh config
@@ -6538,9 +6545,7 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 
 	if (!info->attrs[NL80211_ATTR_MESH_SETUP])
 		return -EINVAL;
-	if (nla_parse_nested(tb, NL80211_MESH_SETUP_ATTR_MAX,
-			     info->attrs[NL80211_ATTR_MESH_SETUP],
-			     nl80211_mesh_setup_params_policy, info->extack))
+	if (nla_parse_nested_deprecated(tb, NL80211_MESH_SETUP_ATTR_MAX, info->attrs[NL80211_ATTR_MESH_SETUP], nl80211_mesh_setup_params_policy, info->extack))
 		return -EINVAL;
 
 	if (tb[NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC])
@@ -6927,9 +6932,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			    rem_reg_rules) {
-		r = nla_parse_nested(tb, NL80211_REG_RULE_ATTR_MAX,
-				     nl_reg_rule, reg_rule_policy,
-				     info->extack);
+		r = nla_parse_nested_deprecated(tb, NL80211_REG_RULE_ATTR_MAX,
+						nl_reg_rule, reg_rule_policy,
+						info->extack);
 		if (r)
 			goto bad_reg;
 		r = parse_reg_rule(tb, &rd->reg_rules[rule_idx]);
@@ -7000,8 +7005,9 @@ static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
 	if (!nla_ok(nest, nla_len(nest)))
 		return -EINVAL;
 
-	err = nla_parse_nested(attr, NL80211_BSS_SELECT_ATTR_MAX, nest,
-			       nl80211_bss_select_policy, NULL);
+	err = nla_parse_nested_deprecated(attr, NL80211_BSS_SELECT_ATTR_MAX,
+					  nest, nl80211_bss_select_policy,
+					  NULL);
 	if (err)
 		return err;
 
@@ -7494,8 +7500,10 @@ nl80211_parse_sched_scan_plans(struct wiphy *wiphy, int n_plans,
 		if (WARN_ON(i >= n_plans))
 			return -EINVAL;
 
-		err = nla_parse_nested(plan, NL80211_SCHED_SCAN_PLAN_MAX,
-				       attr, nl80211_plan_policy, NULL);
+		err = nla_parse_nested_deprecated(plan,
+						  NL80211_SCHED_SCAN_PLAN_MAX,
+						  attr, nl80211_plan_policy,
+						  NULL);
 		if (err)
 			return err;
 
@@ -7581,10 +7589,11 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				    tmp) {
 			struct nlattr *rssi;
 
-			err = nla_parse_nested(tb,
-					       NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
-					       attr, nl80211_match_policy,
-					       NULL);
+			err = nla_parse_nested_deprecated(tb,
+							  NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+							  attr,
+							  nl80211_match_policy,
+							  NULL);
 			if (err)
 				return ERR_PTR(err);
 
@@ -7768,10 +7777,11 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				    tmp) {
 			struct nlattr *ssid, *bssid, *rssi;
 
-			err = nla_parse_nested(tb,
-					       NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
-					       attr, nl80211_match_policy,
-					       NULL);
+			err = nla_parse_nested_deprecated(tb,
+							  NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+							  attr,
+							  nl80211_match_policy,
+							  NULL);
 			if (err)
 				goto out_free;
 			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
@@ -8143,9 +8153,9 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	err = nla_parse_nested(csa_attrs, NL80211_ATTR_MAX,
-			       info->attrs[NL80211_ATTR_CSA_IES],
-			       nl80211_policy, info->extack);
+	err = nla_parse_nested_deprecated(csa_attrs, NL80211_ATTR_MAX,
+					  info->attrs[NL80211_ATTR_CSA_IES],
+					  nl80211_policy, info->extack);
 	if (err)
 		return err;
 
@@ -9420,9 +9430,10 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 	} else {
 		struct nlattr **attrbuf = genl_family_attrbuf(&nl80211_fam);
 
-		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-				  attrbuf, nl80211_fam.maxattr,
-				  nl80211_policy, NULL);
+		err = nlmsg_parse_deprecated(cb->nlh,
+					     GENL_HDRLEN + nl80211_fam.hdrsize,
+					     attrbuf, nl80211_fam.maxattr,
+					     nl80211_policy, NULL);
 		if (err)
 			goto out_err;
 
@@ -10546,8 +10557,9 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 	if (!cqm)
 		return -EINVAL;
 
-	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, cqm,
-			       nl80211_attr_cqm_policy, info->extack);
+	err = nla_parse_nested_deprecated(attrs, NL80211_ATTR_CQM_MAX, cqm,
+					  nl80211_attr_cqm_policy,
+					  info->extack);
 	if (err)
 		return err;
 
@@ -10982,8 +10994,8 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 	if (!rdev->wiphy.wowlan->tcp)
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, MAX_NL80211_WOWLAN_TCP, attr,
-			       nl80211_wowlan_tcp_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, MAX_NL80211_WOWLAN_TCP, attr,
+					  nl80211_wowlan_tcp_policy, NULL);
 	if (err)
 		return err;
 
@@ -11128,8 +11140,8 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 		goto out;
 	}
 
-	err = nla_parse_nested(tb, NL80211_ATTR_MAX, attr, nl80211_policy,
-			       NULL);
+	err = nla_parse_nested_deprecated(tb, NL80211_ATTR_MAX, attr,
+					  nl80211_policy, NULL);
 	if (err)
 		goto out;
 
@@ -11164,9 +11176,9 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		goto set_wakeup;
 	}
 
-	err = nla_parse_nested(tb, MAX_NL80211_WOWLAN_TRIG,
-			       info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS],
-			       nl80211_wowlan_policy, info->extack);
+	err = nla_parse_nested_deprecated(tb, MAX_NL80211_WOWLAN_TRIG,
+					  info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS],
+					  nl80211_wowlan_policy, info->extack);
 	if (err)
 		return err;
 
@@ -11248,9 +11260,11 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 				    rem) {
 			u8 *mask_pat;
 
-			err = nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
-					       nl80211_packet_pattern_policy,
-					       info->extack);
+			err = nla_parse_nested_deprecated(pat_tb,
+							  MAX_NL80211_PKTPAT,
+							  pat,
+							  nl80211_packet_pattern_policy,
+							  info->extack);
 			if (err)
 				goto error;
 
@@ -11463,8 +11477,8 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 	int rem, pat_len, mask_len, pkt_offset, n_patterns = 0;
 	struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
 
-	err = nla_parse_nested(tb, NL80211_ATTR_COALESCE_RULE_MAX, rule,
-			       nl80211_coalesce_policy, NULL);
+	err = nla_parse_nested_deprecated(tb, NL80211_ATTR_COALESCE_RULE_MAX,
+					  rule, nl80211_coalesce_policy, NULL);
 	if (err)
 		return err;
 
@@ -11499,8 +11513,10 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 			    rem) {
 		u8 *mask_pat;
 
-		err = nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
-				       nl80211_packet_pattern_policy, NULL);
+		err = nla_parse_nested_deprecated(pat_tb, MAX_NL80211_PKTPAT,
+						  pat,
+						  nl80211_packet_pattern_policy,
+						  NULL);
 		if (err)
 			return err;
 
@@ -11622,9 +11638,9 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_REKEY_DATA])
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, MAX_NL80211_REKEY_DATA,
-			       info->attrs[NL80211_ATTR_REKEY_DATA],
-			       nl80211_rekey_policy, info->extack);
+	err = nla_parse_nested_deprecated(tb, MAX_NL80211_REKEY_DATA,
+					  info->attrs[NL80211_ATTR_REKEY_DATA],
+					  nl80211_rekey_policy, info->extack);
 	if (err)
 		return err;
 
@@ -11936,9 +11952,10 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
 		return -EINVAL;
 
-	err = nla_parse_nested(tb, NL80211_NAN_FUNC_ATTR_MAX,
-			       info->attrs[NL80211_ATTR_NAN_FUNC],
-			       nl80211_nan_func_policy, info->extack);
+	err = nla_parse_nested_deprecated(tb, NL80211_NAN_FUNC_ATTR_MAX,
+					  info->attrs[NL80211_ATTR_NAN_FUNC],
+					  nl80211_nan_func_policy,
+					  info->extack);
 	if (err)
 		return err;
 
@@ -12034,9 +12051,11 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (tb[NL80211_NAN_FUNC_SRF]) {
 		struct nlattr *srf_tb[NUM_NL80211_NAN_SRF_ATTR];
 
-		err = nla_parse_nested(srf_tb, NL80211_NAN_SRF_ATTR_MAX,
-				       tb[NL80211_NAN_FUNC_SRF],
-				       nl80211_nan_srf_policy, info->extack);
+		err = nla_parse_nested_deprecated(srf_tb,
+						  NL80211_NAN_SRF_ATTR_MAX,
+						  tb[NL80211_NAN_FUNC_SRF],
+						  nl80211_nan_srf_policy,
+						  info->extack);
 		if (err)
 			goto out;
 
@@ -12567,8 +12586,10 @@ static int nl80211_prepare_vendor_dump(struct sk_buff *skb,
 		return 0;
 	}
 
-	err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize, attrbuf,
-			  nl80211_fam.maxattr, nl80211_policy, NULL);
+	err = nlmsg_parse_deprecated(cb->nlh,
+				     GENL_HDRLEN + nl80211_fam.hdrsize,
+				     attrbuf, nl80211_fam.maxattr,
+				     nl80211_policy, NULL);
 	if (err)
 		return err;
 
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 5e2ab01d325c..c2138fd97c42 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -25,7 +25,8 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 	}
 
 	/* no validation needed - was already done via nested policy */
-	nla_parse_nested(tb, NL80211_PMSR_FTM_REQ_ATTR_MAX, ftmreq, NULL, NULL);
+	nla_parse_nested_deprecated(tb, NL80211_PMSR_FTM_REQ_ATTR_MAX, ftmreq,
+				    NULL, NULL);
 
 	if (tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE])
 		preamble = nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]);
@@ -139,7 +140,8 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 	int err, rem;
 
 	/* no validation needed - was already done via nested policy */
-	nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer, NULL, NULL);
+	nla_parse_nested_deprecated(tb, NL80211_PMSR_PEER_ATTR_MAX, peer,
+				    NULL, NULL);
 
 	if (!tb[NL80211_PMSR_PEER_ATTR_ADDR] ||
 	    !tb[NL80211_PMSR_PEER_ATTR_CHAN] ||
@@ -154,9 +156,9 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 	/* reuse info->attrs */
 	memset(info->attrs, 0, sizeof(*info->attrs) * (NL80211_ATTR_MAX + 1));
 	/* need to validate here, we don't want to have validation recursion */
-	err = nla_parse_nested(info->attrs, NL80211_ATTR_MAX,
-			       tb[NL80211_PMSR_PEER_ATTR_CHAN],
-			       nl80211_policy, info->extack);
+	err = nla_parse_nested_deprecated(info->attrs, NL80211_ATTR_MAX,
+					  tb[NL80211_PMSR_PEER_ATTR_CHAN],
+					  nl80211_policy, info->extack);
 	if (err)
 		return err;
 
@@ -165,9 +167,9 @@ static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
 		return err;
 
 	/* no validation needed - was already done via nested policy */
-	nla_parse_nested(req, NL80211_PMSR_REQ_ATTR_MAX,
-			 tb[NL80211_PMSR_PEER_ATTR_REQ],
-			 NULL, NULL);
+	nla_parse_nested_deprecated(req, NL80211_PMSR_REQ_ATTR_MAX,
+				    tb[NL80211_PMSR_PEER_ATTR_REQ], NULL,
+				    NULL);
 
 	if (!req[NL80211_PMSR_REQ_ATTR_DATA]) {
 		NL_SET_ERR_MSG_ATTR(info->extack,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index a131f9ff979e..d7cb16f0df5b 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1006,8 +1006,8 @@ static int xfrm_dump_sa(struct sk_buff *skb, struct netlink_callback *cb)
 		u8 proto = 0;
 		int err;
 
-		err = nlmsg_parse(cb->nlh, 0, attrs, XFRMA_MAX, xfrma_policy,
-				  cb->extack);
+		err = nlmsg_parse_deprecated(cb->nlh, 0, attrs, XFRMA_MAX,
+					     xfrma_policy, cb->extack);
 		if (err < 0)
 			return err;
 
@@ -2656,9 +2656,9 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	err = nlmsg_parse(nlh, xfrm_msg_min[type], attrs,
-			  link->nla_max ? : XFRMA_MAX,
-			  link->nla_pol ? : xfrma_policy, extack);
+	err = nlmsg_parse_deprecated(nlh, xfrm_msg_min[type], attrs,
+				     link->nla_max ? : XFRMA_MAX,
+				     link->nla_pol ? : xfrma_policy, extack);
 	if (err < 0)
 		return err;
 
-- 
2.17.2

