Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BCBC10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27EE20855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfDDGy2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:28 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55746 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfDDGy1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGO-0003Pn-US; Thu, 04 Apr 2019 08:54:17 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] genetlink: optionally validate strictly/dumps
Date:   Thu,  4 Apr 2019 08:54:07 +0200
Message-Id: <20190404065408.5864-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add options to strictly validate messages and dump messages,
sometimes perhaps validating dump messages non-strictly may
be required, so add an option for that as well.

Since none of this can really be applied to existing commands,
set the options everwhere using the following spatch:

    @@
    identifier ops;
    expression X;
    @@
    struct genl_ops ops[] = {
    ...,
     {
            .cmd = X,
    +       .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
            ...
     },
    ...
    };

For new commands one should just not copy the .validate 'opt-out'
flags and thus get strict validation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/block/nbd.c                      |   4 +
 drivers/net/gtp.c                        |   3 +
 drivers/net/ieee802154/mac802154_hwsim.c |   6 ++
 drivers/net/macsec.c                     |  10 +++
 drivers/net/team/team.c                  |   4 +
 drivers/net/wireless/mac80211_hwsim.c    |   6 ++
 drivers/target/target_core_user.c        |   4 +
 fs/dlm/netlink.c                         |   1 +
 include/net/genetlink.h                  |  12 +++
 kernel/taskstats.c                       |   2 +
 net/batman-adv/netlink.c                 |  18 ++++
 net/core/devlink.c                       |  38 +++++++++
 net/core/drop_monitor.c                  |   3 +
 net/hsr/hsr_netlink.c                    |   2 +
 net/ieee802154/nl802154.c                |  29 +++++++
 net/ipv4/fou.c                           |   3 +
 net/ipv4/tcp_metrics.c                   |   2 +
 net/ipv6/ila/ila_main.c                  |   4 +
 net/ipv6/seg6.c                          |   4 +
 net/l2tp/l2tp_netlink.c                  |   9 ++
 net/ncsi/ncsi-netlink.c                  |   6 ++
 net/netfilter/ipvs/ip_vs_ctl.c           |  16 ++++
 net/netlabel/netlabel_calipso.c          |   4 +
 net/netlabel/netlabel_cipso_v4.c         |   4 +
 net/netlabel/netlabel_mgmt.c             |   8 ++
 net/netlabel/netlabel_unlabeled.c        |   8 ++
 net/netlink/genetlink.c                  |  46 +++++++---
 net/nfc/netlink.c                        |  19 +++++
 net/openvswitch/conntrack.c              |   3 +
 net/openvswitch/datapath.c               |  13 +++
 net/openvswitch/meter.c                  |   4 +
 net/psample/psample.c                    |   1 +
 net/smc/smc_pnet.c                       |   4 +
 net/tipc/netlink.c                       |  21 +++++
 net/tipc/netlink_compat.c                |   1 +
 net/wimax/stack.c                        |   4 +
 net/wireless/nl80211.c                   | 104 +++++++++++++++++++++++
 37 files changed, 420 insertions(+), 10 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 91cff60f2839..569c92520150 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2003,18 +2003,22 @@ static int nbd_genl_reconfigure(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops nbd_connect_genl_ops[] = {
 	{
 		.cmd	= NBD_CMD_CONNECT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= nbd_genl_connect,
 	},
 	{
 		.cmd	= NBD_CMD_DISCONNECT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= nbd_genl_disconnect,
 	},
 	{
 		.cmd	= NBD_CMD_RECONFIGURE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= nbd_genl_reconfigure,
 	},
 	{
 		.cmd	= NBD_CMD_STATUS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= nbd_genl_status,
 	},
 };
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c06e31747288..eaf4311b4004 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1270,16 +1270,19 @@ static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
 static const struct genl_ops gtp_genl_ops[] = {
 	{
 		.cmd = GTP_CMD_NEWPDP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = gtp_genl_new_pdp,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = GTP_CMD_DELPDP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = gtp_genl_del_pdp,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = GTP_CMD_GETPDP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = gtp_genl_get_pdp,
 		.dumpit = gtp_genl_dump_pdp,
 		.flags = GENL_ADMIN_PERM,
diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index fa323e9ab616..a69dc9ed75fc 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -592,31 +592,37 @@ static const struct nla_policy hwsim_genl_policy[MAC802154_HWSIM_ATTR_MAX + 1] =
 static const struct genl_ops hwsim_nl_ops[] = {
 	{
 		.cmd = MAC802154_HWSIM_CMD_NEW_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_new_radio_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = MAC802154_HWSIM_CMD_DEL_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_del_radio_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = MAC802154_HWSIM_CMD_GET_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_get_radio_nl,
 		.dumpit = hwsim_dump_radio_nl,
 	},
 	{
 		.cmd = MAC802154_HWSIM_CMD_NEW_EDGE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_new_edge_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = MAC802154_HWSIM_CMD_DEL_EDGE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_del_edge_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = MAC802154_HWSIM_CMD_SET_EDGE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_set_edge_lqi,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c569ecf1a118..63c54208072c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2634,50 +2634,60 @@ static int macsec_dump_txsc(struct sk_buff *skb, struct netlink_callback *cb)
 static const struct genl_ops macsec_genl_ops[] = {
 	{
 		.cmd = MACSEC_CMD_GET_TXSC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = macsec_dump_txsc,
 	},
 	{
 		.cmd = MACSEC_CMD_ADD_RXSC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_add_rxsc,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_DEL_RXSC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_del_rxsc,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_UPD_RXSC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_upd_rxsc,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_ADD_TXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_add_txsa,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_DEL_TXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_del_txsa,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_UPD_TXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_upd_txsa,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_ADD_RXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_add_rxsa,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_DEL_RXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_del_rxsa,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = MACSEC_CMD_UPD_RXSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = macsec_upd_rxsa,
 		.flags = GENL_ADMIN_PERM,
 	},
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 456771687a04..d37fe5e1192e 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2724,20 +2724,24 @@ static int team_nl_cmd_port_list_get(struct sk_buff *skb,
 static const struct genl_ops team_nl_ops[] = {
 	{
 		.cmd = TEAM_CMD_NOOP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = team_nl_cmd_noop,
 	},
 	{
 		.cmd = TEAM_CMD_OPTIONS_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = team_nl_cmd_options_set,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = TEAM_CMD_OPTIONS_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = team_nl_cmd_options_get,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = TEAM_CMD_PORT_LIST_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = team_nl_cmd_port_list_get,
 		.flags = GENL_ADMIN_PERM,
 	},
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4138858ed604..77bce2d27841 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3620,29 +3620,35 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 static const struct genl_ops hwsim_ops[] = {
 	{
 		.cmd = HWSIM_CMD_REGISTER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_register_received_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = HWSIM_CMD_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_cloned_frame_received_nl,
 	},
 	{
 		.cmd = HWSIM_CMD_TX_INFO_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_tx_info_frame_received_nl,
 	},
 	{
 		.cmd = HWSIM_CMD_NEW_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_new_radio_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = HWSIM_CMD_DEL_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_del_radio_nl,
 		.flags = GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd = HWSIM_CMD_GET_RADIO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = hwsim_get_radio_nl,
 		.dumpit = hwsim_dump_radio_nl,
 	},
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 481d371c4b01..40b29ca5a98d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -441,21 +441,25 @@ static int tcmu_genl_set_features(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops tcmu_genl_ops[] = {
 	{
 		.cmd	= TCMU_CMD_SET_FEATURES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= tcmu_genl_set_features,
 	},
 	{
 		.cmd	= TCMU_CMD_ADDED_DEVICE_DONE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= tcmu_genl_add_dev_done,
 	},
 	{
 		.cmd	= TCMU_CMD_REMOVED_DEVICE_DONE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= tcmu_genl_rm_dev_done,
 	},
 	{
 		.cmd	= TCMU_CMD_RECONFIG_DEVICE_DONE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= tcmu_genl_reconfig_dev_done,
 	},
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 43a96c330570..d8e27defa89f 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -68,6 +68,7 @@ static int user_cmd(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops dlm_nl_ops[] = {
 	{
 		.cmd	= DLM_CMD_HELLO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= user_cmd,
 	},
 };
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 68de579cfe5e..f1b3a9c98e12 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -121,6 +121,12 @@ static inline int genl_err_attr(struct genl_info *info, int err,
 	return err;
 }
 
+enum genl_validate_flags {
+	GENL_DONT_VALIDATE_STRICT		= BIT(0),
+	GENL_DONT_VALIDATE_DUMP			= BIT(1),
+	GENL_DONT_VALIDATE_DUMP_STRICT		= BIT(2),
+};
+
 /**
  * struct genl_ops - generic netlink operations
  * @cmd: command identifier
@@ -141,6 +147,12 @@ struct genl_ops {
 	u8			cmd;
 	u8			internal_flags;
 	u8			flags;
+	u8			validate;
+};
+
+struct genl_dump_data {
+	const struct genl_ops *ops;
+	const struct genl_family *family;
 };
 
 int genl_register_family(struct genl_family *family);
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 779fea7416ca..7f3ab8708c27 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -649,12 +649,14 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 static const struct genl_ops taskstats_ops[] = {
 	{
 		.cmd		= TASKSTATS_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= taskstats_user_cmd,
 		/* policy enforced later */
 		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_HASPOL,
 	},
 	{
 		.cmd		= CGROUPSTATS_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= cgroupstats_user_cmd,
 		/* policy enforced later */
 		.flags		= GENL_CMD_CAP_HASPOL,
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index e7907308b331..a67720fad46c 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1343,29 +1343,34 @@ static void batadv_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 static const struct genl_ops batadv_netlink_ops[] = {
 	{
 		.cmd = BATADV_CMD_GET_MESH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* can be retrieved by unprivileged users */
 		.doit = batadv_netlink_get_mesh,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_TP_METER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = batadv_netlink_tp_meter_start,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_TP_METER_CANCEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = batadv_netlink_tp_meter_cancel,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_GET_ROUTING_ALGOS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_algo_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_HARDIF,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* can be retrieved by unprivileged users */
 		.dumpit = batadv_netlink_dump_hardif,
 		.doit = batadv_netlink_get_hardif,
@@ -1374,57 +1379,68 @@ static const struct genl_ops batadv_netlink_ops[] = {
 	},
 	{
 		.cmd = BATADV_CMD_GET_TRANSTABLE_LOCAL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_tt_local_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_TRANSTABLE_GLOBAL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_tt_global_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_ORIGINATORS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_orig_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_NEIGHBORS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_hardif_neigh_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_GATEWAYS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_gw_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_BLA_CLAIM,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_bla_claim_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_BLA_BACKBONE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_bla_backbone_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_DAT_CACHE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_dat_cache_dump,
 	},
 	{
 		.cmd = BATADV_CMD_GET_MCAST_FLAGS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.dumpit = batadv_mcast_flags_dump,
 	},
 	{
 		.cmd = BATADV_CMD_SET_MESH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = batadv_netlink_set_mesh,
 		.internal_flags = BATADV_FLAG_NEED_MESH,
 	},
 	{
 		.cmd = BATADV_CMD_SET_HARDIF,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = batadv_netlink_set_hardif,
 		.internal_flags = BATADV_FLAG_NEED_MESH |
@@ -1432,6 +1448,7 @@ static const struct genl_ops batadv_netlink_ops[] = {
 	},
 	{
 		.cmd = BATADV_CMD_GET_VLAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* can be retrieved by unprivileged users */
 		.doit = batadv_netlink_get_vlan,
 		.internal_flags = BATADV_FLAG_NEED_MESH |
@@ -1439,6 +1456,7 @@ static const struct genl_ops batadv_netlink_ops[] = {
 	},
 	{
 		.cmd = BATADV_CMD_SET_VLAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = batadv_netlink_set_vlan,
 		.internal_flags = BATADV_FLAG_NEED_MESH |
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4846c6277216..f028e8a24906 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4934,6 +4934,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 static const struct genl_ops devlink_nl_ops[] = {
 	{
 		.cmd = DEVLINK_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_get_doit,
 		.dumpit = devlink_nl_cmd_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
@@ -4941,6 +4942,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_get_doit,
 		.dumpit = devlink_nl_cmd_port_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
@@ -4948,12 +4950,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_SPLIT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_split_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -4961,6 +4965,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_UNSPLIT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_unsplit_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -4968,6 +4973,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_get_doit,
 		.dumpit = devlink_nl_cmd_sb_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -4976,6 +4982,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_POOL_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_get_doit,
 		.dumpit = devlink_nl_cmd_sb_pool_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -4984,6 +4991,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_POOL_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -4991,6 +4999,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_PORT_POOL_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_get_doit,
 		.dumpit = devlink_nl_cmd_sb_port_pool_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
@@ -4999,6 +5008,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_PORT_POOL_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
@@ -5006,6 +5016,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_get_doit,
 		.dumpit = devlink_nl_cmd_sb_tc_pool_bind_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
@@ -5014,6 +5025,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT |
@@ -5021,6 +5033,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_OCC_SNAPSHOT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_occ_snapshot_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5028,6 +5041,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_OCC_MAX_CLEAR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_occ_max_clear_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5035,12 +5049,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_get_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5048,42 +5064,49 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_TABLE_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_table_get,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_ENTRIES_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_entries_get,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_HEADERS_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_headers_get,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_TABLE_COUNTERS_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_dpipe_table_counters_set,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_RESOURCE_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_resource_set,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_RESOURCE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_resource_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_RELOAD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5091,6 +5114,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_get_doit,
 		.dumpit = devlink_nl_cmd_param_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
@@ -5098,12 +5122,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_PARAM_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_param_get_doit,
 		.dumpit = devlink_nl_cmd_port_param_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
@@ -5111,12 +5137,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_PARAM_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_param_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_get_doit,
 		.dumpit = devlink_nl_cmd_region_get_dumpit,
 		.flags = GENL_ADMIN_PERM,
@@ -5124,18 +5152,21 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_del,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_REGION_READ,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = devlink_nl_cmd_region_read_dumpit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_INFO_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_info_get_doit,
 		.dumpit = devlink_nl_cmd_info_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
@@ -5143,6 +5174,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
@@ -5150,24 +5182,28 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_set_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_recover_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_diagnose_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_dump_get_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5175,6 +5211,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_dump_clear_doit,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK |
@@ -5182,6 +5219,7 @@ static const struct genl_ops devlink_nl_ops[] = {
 	},
 	{
 		.cmd = DEVLINK_CMD_FLASH_UPDATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_flash_update,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK,
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index c7785efeea57..d4ce0542acfa 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -355,14 +355,17 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 static const struct genl_ops dropmon_ops[] = {
 	{
 		.cmd = NET_DM_CMD_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_config,
 	},
 	{
 		.cmd = NET_DM_CMD_START,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_trace,
 	},
 	{
 		.cmd = NET_DM_CMD_STOP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = net_dm_cmd_trace,
 	},
 };
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index bcc04d3e724f..2169d4d43c45 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -448,12 +448,14 @@ static int hsr_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
 static const struct genl_ops hsr_ops[] = {
 	{
 		.cmd = HSR_C_GET_NODE_STATUS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,
 		.doit = hsr_get_node_status,
 		.dumpit = NULL,
 	},
 	{
 		.cmd = HSR_C_GET_NODE_LIST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,
 		.doit = hsr_get_node_list,
 		.dumpit = NULL,
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index b392f824df15..049a7ba86e45 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2207,6 +2207,7 @@ static void nl802154_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 static const struct genl_ops nl802154_ops[] = {
 	{
 		.cmd = NL802154_CMD_GET_WPAN_PHY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_get_wpan_phy,
 		.dumpit = nl802154_dump_wpan_phy,
 		.done = nl802154_dump_wpan_phy_done,
@@ -2216,6 +2217,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_GET_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_get_interface,
 		.dumpit = nl802154_dump_interface,
 		/* can be retrieved by unprivileged users */
@@ -2224,6 +2226,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_NEW_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_new_interface,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2231,6 +2234,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_DEL_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_del_interface,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_DEV |
@@ -2238,6 +2242,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_CHANNEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_channel,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2245,6 +2250,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_CCA_MODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_cca_mode,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2252,6 +2258,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_CCA_ED_LEVEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_cca_ed_level,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2259,6 +2266,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_TX_POWER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_tx_power,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2266,6 +2274,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_WPAN_PHY_NETNS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_wpan_phy_netns,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_WPAN_PHY |
@@ -2273,6 +2282,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_PAN_ID,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_pan_id,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2280,6 +2290,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_SHORT_ADDR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_short_addr,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2287,6 +2298,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_BACKOFF_EXPONENT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_backoff_exponent,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2294,6 +2306,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_MAX_CSMA_BACKOFFS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_max_csma_backoffs,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2301,6 +2314,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_MAX_FRAME_RETRIES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_max_frame_retries,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2308,6 +2322,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_LBT_MODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_lbt_mode,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2315,6 +2330,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_SET_ACKREQ_DEFAULT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_ackreq_default,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2323,6 +2339,7 @@ static const struct genl_ops nl802154_ops[] = {
 #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
 	{
 		.cmd = NL802154_CMD_SET_SEC_PARAMS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_set_llsec_params,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2330,6 +2347,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_GET_SEC_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* TODO .doit by matching key id? */
 		.dumpit = nl802154_dump_llsec_key,
 		.flags = GENL_ADMIN_PERM,
@@ -2338,6 +2356,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_NEW_SEC_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_add_llsec_key,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2345,6 +2364,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_DEL_SEC_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_del_llsec_key,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2353,6 +2373,7 @@ static const struct genl_ops nl802154_ops[] = {
 	/* TODO unique identifier must short+pan OR extended_addr */
 	{
 		.cmd = NL802154_CMD_GET_SEC_DEV,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* TODO .doit by matching extended_addr? */
 		.dumpit = nl802154_dump_llsec_dev,
 		.flags = GENL_ADMIN_PERM,
@@ -2361,6 +2382,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_NEW_SEC_DEV,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_add_llsec_dev,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2368,6 +2390,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_DEL_SEC_DEV,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_del_llsec_dev,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2376,6 +2399,7 @@ static const struct genl_ops nl802154_ops[] = {
 	/* TODO remove complete devkey, put it as nested? */
 	{
 		.cmd = NL802154_CMD_GET_SEC_DEVKEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* TODO doit by matching ??? */
 		.dumpit = nl802154_dump_llsec_devkey,
 		.flags = GENL_ADMIN_PERM,
@@ -2384,6 +2408,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_NEW_SEC_DEVKEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_add_llsec_devkey,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2391,6 +2416,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_DEL_SEC_DEVKEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_del_llsec_devkey,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2398,6 +2424,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_GET_SEC_LEVEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* TODO .doit by matching frame_type? */
 		.dumpit = nl802154_dump_llsec_seclevel,
 		.flags = GENL_ADMIN_PERM,
@@ -2406,6 +2433,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_NEW_SEC_LEVEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl802154_add_llsec_seclevel,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL802154_FLAG_NEED_NETDEV |
@@ -2413,6 +2441,7 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_DEL_SEC_LEVEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		/* TODO match frame_type only? */
 		.doit = nl802154_del_llsec_seclevel,
 		.flags = GENL_ADMIN_PERM,
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 100e63f57ea6..12c8ac94e7a0 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -913,16 +913,19 @@ static int fou_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 static const struct genl_ops fou_nl_ops[] = {
 	{
 		.cmd = FOU_CMD_ADD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = fou_nl_cmd_add_port,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = FOU_CMD_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = fou_nl_cmd_rm_port,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = FOU_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = fou_nl_cmd_get_port,
 		.dumpit = fou_nl_dump,
 	},
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 4ccec4c705f7..47a616816e4c 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -951,11 +951,13 @@ static int tcp_metrics_nl_cmd_del(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops tcp_metrics_nl_ops[] = {
 	{
 		.cmd = TCP_METRICS_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = tcp_metrics_nl_cmd_get,
 		.dumpit = tcp_metrics_nl_dump,
 	},
 	{
 		.cmd = TCP_METRICS_CMD_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = tcp_metrics_nl_cmd_del,
 		.flags = GENL_ADMIN_PERM,
 	},
diff --git a/net/ipv6/ila/ila_main.c b/net/ipv6/ila/ila_main.c
index 8d31a5066d0c..257d2b681246 100644
--- a/net/ipv6/ila/ila_main.c
+++ b/net/ipv6/ila/ila_main.c
@@ -16,21 +16,25 @@ static const struct nla_policy ila_nl_policy[ILA_ATTR_MAX + 1] = {
 static const struct genl_ops ila_nl_ops[] = {
 	{
 		.cmd = ILA_CMD_ADD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ila_xlat_nl_cmd_add_mapping,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = ILA_CMD_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ila_xlat_nl_cmd_del_mapping,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = ILA_CMD_FLUSH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ila_xlat_nl_cmd_flush,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = ILA_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ila_xlat_nl_cmd_get_mapping,
 		.start = ila_xlat_nl_dump_start,
 		.dumpit = ila_xlat_nl_dump,
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index ceff773471e7..0c5479ef9b38 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -398,11 +398,13 @@ static struct pernet_operations ip6_segments_ops = {
 static const struct genl_ops seg6_genl_ops[] = {
 	{
 		.cmd	= SEG6_CMD_SETHMAC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= seg6_genl_sethmac,
 		.flags	= GENL_ADMIN_PERM,
 	},
 	{
 		.cmd	= SEG6_CMD_DUMPHMAC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.start	= seg6_genl_dumphmac_start,
 		.dumpit	= seg6_genl_dumphmac,
 		.done	= seg6_genl_dumphmac_done,
@@ -410,11 +412,13 @@ static const struct genl_ops seg6_genl_ops[] = {
 	},
 	{
 		.cmd	= SEG6_CMD_SET_TUNSRC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= seg6_genl_set_tunsrc,
 		.flags	= GENL_ADMIN_PERM,
 	},
 	{
 		.cmd	= SEG6_CMD_GET_TUNSRC,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= seg6_genl_get_tunsrc,
 		.flags	= GENL_ADMIN_PERM,
 	},
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 77595fcc9f75..a8ca96988e36 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -915,47 +915,56 @@ static const struct nla_policy l2tp_nl_policy[L2TP_ATTR_MAX + 1] = {
 static const struct genl_ops l2tp_nl_ops[] = {
 	{
 		.cmd = L2TP_CMD_NOOP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_noop,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_CREATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_create,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_DELETE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_delete,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_MODIFY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_modify,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_TUNNEL_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_tunnel_get,
 		.dumpit = l2tp_nl_cmd_tunnel_dump,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_CREATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_create,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_DELETE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_delete,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_MODIFY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_modify,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = L2TP_CMD_SESSION_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = l2tp_nl_cmd_session_get,
 		.dumpit = l2tp_nl_cmd_session_dump,
 		.flags = GENL_ADMIN_PERM,
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index be23644ec7ef..40e7cfce9457 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -723,32 +723,38 @@ static int ncsi_set_channel_mask_nl(struct sk_buff *msg,
 static const struct genl_ops ncsi_ops[] = {
 	{
 		.cmd = NCSI_CMD_PKG_INFO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_pkg_info_nl,
 		.dumpit = ncsi_pkg_info_all_nl,
 		.flags = 0,
 	},
 	{
 		.cmd = NCSI_CMD_SET_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_set_interface_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NCSI_CMD_CLEAR_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_clear_interface_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NCSI_CMD_SEND_CMD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_send_cmd_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NCSI_CMD_SET_PACKAGE_MASK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_set_package_mask_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NCSI_CMD_SET_CHANNEL_MASK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = ncsi_set_channel_mask_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 38cdebae322d..ed58830eb6ca 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3769,82 +3769,98 @@ static int ip_vs_genl_get_cmd(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops ip_vs_genl_ops[] = {
 	{
 		.cmd	= IPVS_CMD_NEW_SERVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_SET_SERVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_DEL_SERVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_GET_SERVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_get_cmd,
 		.dumpit	= ip_vs_genl_dump_services,
 	},
 	{
 		.cmd	= IPVS_CMD_NEW_DEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_SET_DEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_DEL_DEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_GET_DEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.dumpit	= ip_vs_genl_dump_dests,
 	},
 	{
 		.cmd	= IPVS_CMD_NEW_DAEMON,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_daemon,
 	},
 	{
 		.cmd	= IPVS_CMD_DEL_DAEMON,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_daemon,
 	},
 	{
 		.cmd	= IPVS_CMD_GET_DAEMON,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.dumpit	= ip_vs_genl_dump_daemons,
 	},
 	{
 		.cmd	= IPVS_CMD_SET_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_GET_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_get_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_GET_INFO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_get_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_ZERO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
 	{
 		.cmd	= IPVS_CMD_FLUSH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags	= GENL_ADMIN_PERM,
 		.doit	= ip_vs_genl_set_cmd,
 	},
diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 80184513b2b2..1de87172885d 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -321,24 +321,28 @@ static int netlbl_calipso_remove(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops netlbl_calipso_ops[] = {
 	{
 	.cmd = NLBL_CALIPSO_C_ADD,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_calipso_add,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CALIPSO_C_REMOVE,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_calipso_remove,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CALIPSO_C_LIST,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = netlbl_calipso_list,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CALIPSO_C_LISTALL,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_calipso_listall,
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 142aac44705b..a7353c779db7 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -737,24 +737,28 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops netlbl_cipsov4_ops[] = {
 	{
 	.cmd = NLBL_CIPSOV4_C_ADD,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_cipsov4_add,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CIPSOV4_C_REMOVE,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_cipsov4_remove,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CIPSOV4_C_LIST,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = netlbl_cipsov4_list,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_CIPSOV4_C_LISTALL,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_cipsov4_listall,
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index a16eacfb2236..15ae341a1b08 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -772,48 +772,56 @@ static int netlbl_mgmt_version(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops netlbl_mgmt_genl_ops[] = {
 	{
 	.cmd = NLBL_MGMT_C_ADD,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_mgmt_add,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_MGMT_C_REMOVE,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_mgmt_remove,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_MGMT_C_LISTALL,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_mgmt_listall,
 	},
 	{
 	.cmd = NLBL_MGMT_C_ADDDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_mgmt_adddef,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_MGMT_C_REMOVEDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_mgmt_removedef,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_MGMT_C_LISTDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = netlbl_mgmt_listdef,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_MGMT_C_PROTOCOLS,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_mgmt_protocols,
 	},
 	{
 	.cmd = NLBL_MGMT_C_VERSION,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = netlbl_mgmt_version,
 	.dumpit = NULL,
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 6b1b6c2b5141..b87dd34e1835 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1317,48 +1317,56 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 static const struct genl_ops netlbl_unlabel_genl_ops[] = {
 	{
 	.cmd = NLBL_UNLABEL_C_STATICADD,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_unlabel_staticadd,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_STATICREMOVE,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_unlabel_staticremove,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_STATICLIST,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_unlabel_staticlist,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_STATICADDDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_unlabel_staticadddef,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_STATICREMOVEDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_unlabel_staticremovedef,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_STATICLISTDEF,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = NULL,
 	.dumpit = netlbl_unlabel_staticlistdef,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_ACCEPT,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = GENL_ADMIN_PERM,
 	.doit = netlbl_unlabel_accept,
 	.dumpit = NULL,
 	},
 	{
 	.cmd = NLBL_UNLABEL_C_LIST,
+	.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	.flags = 0,
 	.doit = netlbl_unlabel_list,
 	.dumpit = NULL,
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index bcd3867bd52e..5361e1a57735 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -460,8 +460,8 @@ EXPORT_SYMBOL(genlmsg_put);
 
 static int genl_lock_start(struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	struct genl_dump_data *data = cb->data;
+	const struct genl_ops *ops = data->ops;
 	int rc = 0;
 
 	if (ops->start) {
@@ -474,10 +474,27 @@ static int genl_lock_start(struct netlink_callback *cb)
 
 static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	struct genl_dump_data *data = cb->data;
+	const struct genl_ops *ops = data->ops;
+	const struct genl_family *family = data->family;
 	int rc;
 
+	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP)) {
+		enum netlink_validation validate = NL_VALIDATE_STRICT;
+		int hdrlen = GENL_HDRLEN + family->hdrsize;
+
+		if (ops->validate & GENL_DONT_VALIDATE_DUMP_STRICT)
+			validate = NL_VALIDATE_LIBERAL;
+
+		if (cb->nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
+			return -EINVAL;
+
+		return __nla_validate(nlmsg_attrdata(cb->nlh, hdrlen),
+				      nlmsg_attrlen(cb->nlh, hdrlen),
+				      family->maxattr, family->policy,
+				      validate, cb->extack);
+	}
+
 	genl_lock();
 	rc = ops->dumpit(skb, cb);
 	genl_unlock();
@@ -486,8 +503,8 @@ static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 
 static int genl_lock_done(struct netlink_callback *cb)
 {
-	/* our ops are always const - netlink API doesn't propagate that */
-	const struct genl_ops *ops = cb->data;
+	struct genl_dump_data *data = cb->data;
+	const struct genl_ops *ops = data->ops;
 	int rc = 0;
 
 	if (ops->done) {
@@ -537,10 +554,14 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 			return -EOPNOTSUPP;
 
 		if (!family->parallel_ops) {
+			struct genl_dump_data data = {
+				.ops = ops,
+				.family = family,
+			};
 			struct netlink_dump_control c = {
 				.module = family->module,
 				/* we have const, but the netlink API doesn't */
-				.data = (void *)ops,
+				.data = &data,
 				.start = genl_lock_start,
 				.dump = genl_lock_dumpit,
 				.done = genl_lock_done,
@@ -577,9 +598,13 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 		attrbuf = family->attrbuf;
 
 	if (attrbuf) {
-		err = nlmsg_parse_deprecated(nlh, hdrlen, attrbuf,
-					     family->maxattr, family->policy,
-					     extack);
+		enum netlink_validation validate = NL_VALIDATE_STRICT;
+
+		if (ops->validate & GENL_DONT_VALIDATE_STRICT)
+			validate = NL_VALIDATE_LIBERAL;
+
+		err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
+				    family->policy, validate, extack);
 		if (err < 0)
 			goto out;
 	}
@@ -939,6 +964,7 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 static const struct genl_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= ctrl_getfamily,
 		.dumpit		= ctrl_dumpfamily,
 	},
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 5f66b9dd85e5..49124d9f4b44 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1669,82 +1669,101 @@ EXPORT_SYMBOL(nfc_vendor_cmd_reply);
 static const struct genl_ops nfc_genl_ops[] = {
 	{
 		.cmd = NFC_CMD_GET_DEVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_get_device,
 		.dumpit = nfc_genl_dump_devices,
 		.done = nfc_genl_dump_devices_done,
 	},
 	{
 		.cmd = NFC_CMD_DEV_UP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dev_up,
 	},
 	{
 		.cmd = NFC_CMD_DEV_DOWN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dev_down,
 	},
 	{
 		.cmd = NFC_CMD_START_POLL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_start_poll,
 	},
 	{
 		.cmd = NFC_CMD_STOP_POLL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_stop_poll,
 	},
 	{
 		.cmd = NFC_CMD_DEP_LINK_UP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dep_link_up,
 	},
 	{
 		.cmd = NFC_CMD_DEP_LINK_DOWN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_dep_link_down,
 	},
 	{
 		.cmd = NFC_CMD_GET_TARGET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = nfc_genl_dump_targets,
 		.done = nfc_genl_dump_targets_done,
 	},
 	{
 		.cmd = NFC_CMD_LLC_GET_PARAMS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_llc_get_params,
 	},
 	{
 		.cmd = NFC_CMD_LLC_SET_PARAMS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_llc_set_params,
 	},
 	{
 		.cmd = NFC_CMD_LLC_SDREQ,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_llc_sdreq,
 	},
 	{
 		.cmd = NFC_CMD_FW_DOWNLOAD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_fw_download,
 	},
 	{
 		.cmd = NFC_CMD_ENABLE_SE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_enable_se,
 	},
 	{
 		.cmd = NFC_CMD_DISABLE_SE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_disable_se,
 	},
 	{
 		.cmd = NFC_CMD_GET_SE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = nfc_genl_dump_ses,
 		.done = nfc_genl_dump_ses_done,
 	},
 	{
 		.cmd = NFC_CMD_SE_IO,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_se_io,
 	},
 	{
 		.cmd = NFC_CMD_ACTIVATE_TARGET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_activate_target,
 	},
 	{
 		.cmd = NFC_CMD_VENDOR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_vendor_cmd,
 	},
 	{
 		.cmd = NFC_CMD_DEACTIVATE_TARGET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nfc_genl_deactivate_target,
 	},
 };
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0be3ab5bde26..ce113fcfe25b 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2186,16 +2186,19 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
 
 static struct genl_ops ct_limit_genl_ops[] = {
 	{ .cmd = OVS_CT_LIMIT_CMD_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
 					   * privilege. */
 		.doit = ovs_ct_limit_cmd_set,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
 					   * privilege. */
 		.doit = ovs_ct_limit_cmd_del,
 	},
 	{ .cmd = OVS_CT_LIMIT_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
 		.doit = ovs_ct_limit_cmd_get,
 	},
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 361d8d175f74..e444c4ebea2e 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -638,6 +638,7 @@ static const struct nla_policy packet_policy[OVS_PACKET_ATTR_MAX + 1] = {
 
 static const struct genl_ops dp_packet_genl_ops[] = {
 	{ .cmd = OVS_PACKET_CMD_EXECUTE,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_packet_cmd_execute
 	}
@@ -1423,19 +1424,23 @@ static const struct nla_policy flow_policy[OVS_FLOW_ATTR_MAX + 1] = {
 
 static const struct genl_ops dp_flow_genl_ops[] = {
 	{ .cmd = OVS_FLOW_CMD_NEW,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_flow_cmd_new
 	},
 	{ .cmd = OVS_FLOW_CMD_DEL,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_flow_cmd_del
 	},
 	{ .cmd = OVS_FLOW_CMD_GET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = 0,		    /* OK for unprivileged users. */
 	  .doit = ovs_flow_cmd_get,
 	  .dumpit = ovs_flow_cmd_dump
 	},
 	{ .cmd = OVS_FLOW_CMD_SET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_flow_cmd_set,
 	},
@@ -1813,19 +1818,23 @@ static const struct nla_policy datapath_policy[OVS_DP_ATTR_MAX + 1] = {
 
 static const struct genl_ops dp_datapath_genl_ops[] = {
 	{ .cmd = OVS_DP_CMD_NEW,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_dp_cmd_new
 	},
 	{ .cmd = OVS_DP_CMD_DEL,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_dp_cmd_del
 	},
 	{ .cmd = OVS_DP_CMD_GET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = 0,		    /* OK for unprivileged users. */
 	  .doit = ovs_dp_cmd_get,
 	  .dumpit = ovs_dp_cmd_dump
 	},
 	{ .cmd = OVS_DP_CMD_SET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_dp_cmd_set,
 	},
@@ -2253,19 +2262,23 @@ static const struct nla_policy vport_policy[OVS_VPORT_ATTR_MAX + 1] = {
 
 static const struct genl_ops dp_vport_genl_ops[] = {
 	{ .cmd = OVS_VPORT_CMD_NEW,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_vport_cmd_new
 	},
 	{ .cmd = OVS_VPORT_CMD_DEL,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_vport_cmd_del
 	},
 	{ .cmd = OVS_VPORT_CMD_GET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = 0,		    /* OK for unprivileged users. */
 	  .doit = ovs_vport_cmd_get,
 	  .dumpit = ovs_vport_cmd_dump
 	},
 	{ .cmd = OVS_VPORT_CMD_SET,
+	  .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 	  .flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN privilege. */
 	  .doit = ovs_vport_cmd_set,
 	},
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 1e9fe14d5ea6..e34475bc1a97 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -526,20 +526,24 @@ bool ovs_meter_execute(struct datapath *dp, struct sk_buff *skb,
 
 static struct genl_ops dp_meter_genl_ops[] = {
 	{ .cmd = OVS_METER_CMD_FEATURES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
 		.doit = ovs_meter_cmd_features
 	},
 	{ .cmd = OVS_METER_CMD_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
 					   *  privilege.
 					   */
 		.doit = ovs_meter_cmd_set,
 	},
 	{ .cmd = OVS_METER_CMD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = 0,		  /* OK for unprivileged users. */
 		.doit = ovs_meter_cmd_get,
 	},
 	{ .cmd = OVS_METER_CMD_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
 					   *  privilege.
 					   */
diff --git a/net/psample/psample.c b/net/psample/psample.c
index 64f95624f219..a107b2405668 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -100,6 +100,7 @@ static int psample_nl_cmd_get_group_dumpit(struct sk_buff *msg,
 static const struct genl_ops psample_nl_ops[] = {
 	{
 		.cmd = PSAMPLE_CMD_GET_GROUP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = psample_nl_cmd_get_group_dumpit,
 		/* can be retrieved by unprivileged users */
 	}
diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 3cdf81cf97a3..c8348bbb50fa 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -610,6 +610,7 @@ static int smc_pnet_flush(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops smc_pnet_ops[] = {
 	{
 		.cmd = SMC_PNETID_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_pnet_get,
 		.dumpit = smc_pnet_dump,
@@ -617,16 +618,19 @@ static const struct genl_ops smc_pnet_ops[] = {
 	},
 	{
 		.cmd = SMC_PNETID_ADD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_pnet_add
 	},
 	{
 		.cmd = SMC_PNETID_DEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_pnet_del
 	},
 	{
 		.cmd = SMC_PNETID_FLUSH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = smc_pnet_flush
 	}
diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 3d5d0fb5b37c..99bd166bccec 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -143,93 +143,114 @@ const struct nla_policy tipc_nl_udp_policy[TIPC_NLA_UDP_MAX + 1] = {
 static const struct genl_ops tipc_genl_v2_ops[] = {
 	{
 		.cmd	= TIPC_NL_BEARER_DISABLE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_bearer_disable,
 	},
 	{
 		.cmd	= TIPC_NL_BEARER_ENABLE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_bearer_enable,
 	},
 	{
 		.cmd	= TIPC_NL_BEARER_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_bearer_get,
 		.dumpit	= tipc_nl_bearer_dump,
 	},
 	{
 		.cmd	= TIPC_NL_BEARER_ADD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_bearer_add,
 	},
 	{
 		.cmd	= TIPC_NL_BEARER_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_bearer_set,
 	},
 	{
 		.cmd	= TIPC_NL_SOCK_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.start = tipc_dump_start,
 		.dumpit	= tipc_nl_sk_dump,
 		.done	= tipc_dump_done,
 	},
 	{
 		.cmd	= TIPC_NL_PUBL_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_nl_publ_dump,
 	},
 	{
 		.cmd	= TIPC_NL_LINK_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit   = tipc_nl_node_get_link,
 		.dumpit	= tipc_nl_node_dump_link,
 	},
 	{
 		.cmd	= TIPC_NL_LINK_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_node_set_link,
 	},
 	{
 		.cmd	= TIPC_NL_LINK_RESET_STATS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit   = tipc_nl_node_reset_link_stats,
 	},
 	{
 		.cmd	= TIPC_NL_MEDIA_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_media_get,
 		.dumpit	= tipc_nl_media_dump,
 	},
 	{
 		.cmd	= TIPC_NL_MEDIA_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_media_set,
 	},
 	{
 		.cmd	= TIPC_NL_NODE_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_nl_node_dump,
 	},
 	{
 		.cmd	= TIPC_NL_NET_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_nl_net_dump,
 	},
 	{
 		.cmd	= TIPC_NL_NET_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_net_set,
 	},
 	{
 		.cmd	= TIPC_NL_NAME_TABLE_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_nl_name_table_dump,
 	},
 	{
 		.cmd	= TIPC_NL_MON_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_node_set_monitor,
 	},
 	{
 		.cmd	= TIPC_NL_MON_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_node_get_monitor,
 		.dumpit	= tipc_nl_node_dump_monitor,
 	},
 	{
 		.cmd	= TIPC_NL_MON_PEER_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_nl_node_dump_monitor_peer,
 	},
 	{
 		.cmd	= TIPC_NL_PEER_REMOVE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit	= tipc_nl_peer_rm,
 	},
 #ifdef CONFIG_TIPC_MEDIA_UDP
 	{
 		.cmd	= TIPC_NL_UDP_GET_REMOTEIP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit	= tipc_udp_nl_dump_remoteip,
 	},
 #endif
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index f48e11f61444..7a28d403fa4e 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1289,6 +1289,7 @@ static int tipc_nl_compat_recv(struct sk_buff *skb, struct genl_info *info)
 static const struct genl_ops tipc_genl_compat_ops[] = {
 	{
 		.cmd		= TIPC_GENL_CMD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit		= tipc_nl_compat_recv,
 	},
 };
diff --git a/net/wimax/stack.c b/net/wimax/stack.c
index b7f571e55448..4969de672886 100644
--- a/net/wimax/stack.c
+++ b/net/wimax/stack.c
@@ -419,21 +419,25 @@ static const struct nla_policy wimax_gnl_policy[WIMAX_GNL_ATTR_MAX + 1] = {
 static const struct genl_ops wimax_gnl_ops[] = {
 	{
 		.cmd = WIMAX_GNL_OP_MSG_FROM_USER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = wimax_gnl_doit_msg_from_user,
 	},
 	{
 		.cmd = WIMAX_GNL_OP_RESET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = wimax_gnl_doit_reset,
 	},
 	{
 		.cmd = WIMAX_GNL_OP_RFKILL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = wimax_gnl_doit_rfkill,
 	},
 	{
 		.cmd = WIMAX_GNL_OP_STATE_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_ADMIN_PERM,
 		.doit = wimax_gnl_doit_state_get,
 	},
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3700c9609411..d8eaa161c308 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13386,6 +13386,7 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 static const struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_wiphy,
 		.dumpit = nl80211_dump_wiphy,
 		.done = nl80211_dump_wiphy_done,
@@ -13395,12 +13396,14 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_WIPHY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_wiphy,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_GET_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_interface,
 		.dumpit = nl80211_dump_interface,
 		/* can be retrieved by unprivileged users */
@@ -13409,6 +13412,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_interface,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13416,6 +13420,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_NEW_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_new_interface,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -13423,6 +13428,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_INTERFACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_interface,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV |
@@ -13430,6 +13436,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_key,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13437,6 +13444,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_key,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13445,6 +13453,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_NEW_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_new_key,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13453,6 +13462,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_key,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13460,6 +13470,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_BEACON,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = nl80211_set_beacon,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13467,6 +13478,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_START_AP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = nl80211_start_ap,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13474,6 +13486,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_STOP_AP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.doit = nl80211_stop_ap,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13481,6 +13494,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_STATION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_station,
 		.dumpit = nl80211_dump_station,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13488,6 +13502,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_STATION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_station,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13495,6 +13510,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_NEW_STATION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_new_station,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13502,6 +13518,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_STATION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_station,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13509,6 +13526,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_MPATH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_mpath,
 		.dumpit = nl80211_dump_mpath,
 		.flags = GENL_UNS_ADMIN_PERM,
@@ -13517,6 +13535,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_MPP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_mpp,
 		.dumpit = nl80211_dump_mpp,
 		.flags = GENL_UNS_ADMIN_PERM,
@@ -13525,6 +13544,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_MPATH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_mpath,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13532,6 +13552,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_NEW_MPATH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_new_mpath,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13539,6 +13560,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_MPATH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_mpath,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13546,6 +13568,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_BSS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_bss,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13553,6 +13576,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_REG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_reg_do,
 		.dumpit = nl80211_get_reg_dump,
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
@@ -13561,6 +13585,7 @@ static const struct genl_ops nl80211_ops[] = {
 #ifdef CONFIG_CFG80211_CRDA_SUPPORT
 	{
 		.cmd = NL80211_CMD_SET_REG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_reg,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_RTNL,
@@ -13568,16 +13593,19 @@ static const struct genl_ops nl80211_ops[] = {
 #endif
 	{
 		.cmd = NL80211_CMD_REQ_SET_REG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_req_set_reg,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NL80211_CMD_RELOAD_REGDB,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_reload_regdb,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NL80211_CMD_GET_MESH_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_mesh_config,
 		/* can be retrieved by unprivileged users */
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13585,6 +13613,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_MESH_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_update_mesh_config,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13592,6 +13621,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_TRIGGER_SCAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_trigger_scan,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13599,6 +13629,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_ABORT_SCAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_abort_scan,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13606,10 +13637,12 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_SCAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = nl80211_dump_scan,
 	},
 	{
 		.cmd = NL80211_CMD_START_SCHED_SCAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_start_sched_scan,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13617,6 +13650,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_STOP_SCHED_SCAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_stop_sched_scan,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13624,6 +13658,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_AUTHENTICATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_authenticate,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13632,6 +13667,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_ASSOCIATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_associate,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13639,6 +13675,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEAUTHENTICATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_deauthenticate,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13646,6 +13683,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DISASSOCIATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_disassociate,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13653,6 +13691,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_JOIN_IBSS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_join_ibss,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13660,6 +13699,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_LEAVE_IBSS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_leave_ibss,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13668,6 +13708,7 @@ static const struct genl_ops nl80211_ops[] = {
 #ifdef CONFIG_NL80211_TESTMODE
 	{
 		.cmd = NL80211_CMD_TESTMODE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_testmode_do,
 		.dumpit = nl80211_testmode_dump,
 		.flags = GENL_UNS_ADMIN_PERM,
@@ -13677,6 +13718,7 @@ static const struct genl_ops nl80211_ops[] = {
 #endif
 	{
 		.cmd = NL80211_CMD_CONNECT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_connect,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13684,6 +13726,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_UPDATE_CONNECT_PARAMS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_update_connect_params,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13691,6 +13734,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DISCONNECT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_disconnect,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13698,6 +13742,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_WIPHY_NETNS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_wiphy_netns,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -13705,10 +13750,12 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_SURVEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.dumpit = nl80211_dump_survey,
 	},
 	{
 		.cmd = NL80211_CMD_SET_PMKSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_setdel_pmksa,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13716,6 +13763,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMKSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_setdel_pmksa,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13723,6 +13771,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_FLUSH_PMKSA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_flush_pmksa,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13730,6 +13779,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_REMAIN_ON_CHANNEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_remain_on_channel,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13737,6 +13787,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_cancel_remain_on_channel,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13744,6 +13795,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_TX_BITRATE_MASK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_tx_bitrate_mask,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13751,6 +13803,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_REGISTER_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_register_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV |
@@ -13758,6 +13811,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13765,6 +13819,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_FRAME_WAIT_CANCEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_mgmt_cancel_wait,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13772,6 +13827,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_POWER_SAVE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_power_save,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13779,6 +13835,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_POWER_SAVE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_power_save,
 		/* can be retrieved by unprivileged users */
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13786,6 +13843,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_CQM,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_cqm,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13793,6 +13851,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_CHANNEL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_channel,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13800,6 +13859,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_WDS_PEER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_wds_peer,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13807,6 +13867,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_JOIN_MESH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_join_mesh,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13814,6 +13875,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_LEAVE_MESH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_leave_mesh,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13821,6 +13883,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_JOIN_OCB,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_join_ocb,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13828,6 +13891,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_LEAVE_OCB,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_leave_ocb,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13836,6 +13900,7 @@ static const struct genl_ops nl80211_ops[] = {
 #ifdef CONFIG_PM
 	{
 		.cmd = NL80211_CMD_GET_WOWLAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_wowlan,
 		/* can be retrieved by unprivileged users */
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -13843,6 +13908,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_WOWLAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_wowlan,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -13851,6 +13917,7 @@ static const struct genl_ops nl80211_ops[] = {
 #endif
 	{
 		.cmd = NL80211_CMD_SET_REKEY_OFFLOAD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_rekey_data,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13859,6 +13926,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_MGMT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tdls_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13866,6 +13934,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_OPER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tdls_oper,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13873,6 +13942,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_UNEXPECTED_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_register_unexpected_frame,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13880,6 +13950,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_PROBE_CLIENT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_probe_client,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13887,6 +13958,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_REGISTER_BEACONS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_register_beacons,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -13894,6 +13966,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_NOACK_MAP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_noack_map,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13901,6 +13974,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_START_P2P_DEVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_start_p2p_device,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV |
@@ -13908,6 +13982,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_STOP_P2P_DEVICE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_stop_p2p_device,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13915,6 +13990,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_START_NAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_start_nan,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV |
@@ -13922,6 +13998,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_STOP_NAN,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_stop_nan,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13929,6 +14006,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_ADD_NAN_FUNCTION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_nan_add_func,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13936,6 +14014,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_NAN_FUNCTION,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_nan_del_func,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13943,6 +14022,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CHANGE_NAN_CONFIG,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_nan_change_config,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13950,6 +14030,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_MCAST_RATE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_mcast_rate,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13957,6 +14038,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_MAC_ACL,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_mac_acl,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -13964,6 +14046,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_RADAR_DETECT,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_start_radar_detection,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13971,10 +14054,12 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_PROTOCOL_FEATURES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_protocol_features,
 	},
 	{
 		.cmd = NL80211_CMD_UPDATE_FT_IES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_update_ft_ies,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -13982,6 +14067,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CRIT_PROTOCOL_START,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_crit_protocol_start,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13989,6 +14075,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CRIT_PROTOCOL_STOP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_crit_protocol_stop,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -13996,12 +14083,14 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_COALESCE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_coalesce,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_SET_COALESCE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_coalesce,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
@@ -14009,6 +14098,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CHANNEL_SWITCH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_channel_switch,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14016,6 +14106,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_VENDOR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_vendor_cmd,
 		.dumpit = nl80211_vendor_cmd_dump,
 		.flags = GENL_UNS_ADMIN_PERM,
@@ -14024,6 +14115,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_QOS_MAP,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_qos_map,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14031,6 +14123,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_ADD_TX_TS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_add_tx_ts,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14038,6 +14131,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_DEL_TX_TS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_tx_ts,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14045,6 +14139,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_CHANNEL_SWITCH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tdls_channel_switch,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14052,6 +14147,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_CANCEL_CHANNEL_SWITCH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tdls_cancel_channel_switch,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14059,6 +14155,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_MULTICAST_TO_UNICAST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_multicast_to_unicast,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
@@ -14066,18 +14163,21 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_SET_PMK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_set_pmk,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_PMK,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_del_pmk,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_EXTERNAL_AUTH,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_external_auth,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14085,6 +14185,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_CONTROL_PORT_FRAME,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_control_port,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
@@ -14092,12 +14193,14 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_GET_FTM_RESPONDER_STATS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_get_ftm_responder_stats,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
 		.cmd = NL80211_CMD_PEER_MEASUREMENT_START,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_pmsr_start,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
@@ -14105,6 +14208,7 @@ static const struct genl_ops nl80211_ops[] = {
 	},
 	{
 		.cmd = NL80211_CMD_NOTIFY_RADAR,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_notify_radar_detection,
 		.flags = GENL_UNS_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-- 
2.17.2

